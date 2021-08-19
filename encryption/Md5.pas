{$R-} {$A-} {$Q-}
{$ifndef COMMANDLINE}     // Overrides the following defaults
{$define REGISTERED}   		// NOTREGISTERED, FREEWARE, REGISTERED
{$define COMPONENT}       // OBJECT, COMPONENT
{$endif}

{$WARNINGS OFF}

unit MD5;

interface

uses Windows, Classes, SysUtils, Dialogs;

{*******************************************************************************
* Type      : TDigest                                                          *
********************************************************************************
* Purpose   : Defines the interface definition of the Message Digest           *
*******************************************************************************}
type TDigest = array[0..15] of Byte;

{*******************************************************************************
* Type      : TState                                                           *
********************************************************************************
* Purpose   : Holds the internal state of MD5                                  *
*******************************************************************************}
{$ifdef VER120}
type TState  = array[0..3] of Cardinal;
{$else}
type TState  = array[0..3] of Integer;
{$endif}

type
  TMD5_CTX = record
     state: TState;
     {$ifdef VER120}
     count: array[0..1] of Cardinal;     // number of bits, modulo 2^64 (lsb first)
     {$else}
     count: array[0..1] of integer;     // number of bits, modulo 2^64 (lsb first)
     {$endif}
     Buffer: array[0..63] of Byte;      // input buffer
  end;

{*******************************************************************************
* Type      : TMD5                                                             *
********************************************************************************
* Purpose   : Defines the component (in component mode) or object              *
*******************************************************************************}
{$ifdef COMPONENT}
type TMD5 = class(TComponent)
{$else}
type TMD5 = class(TObject)
{$endif}
  private
     FContext:    TMD5_CTX;
     FDigest:     TDigest;

     {$ifndef REGISTERED}
     procedure    NagRegister;
     {$endif}
     procedure    Update(const input: array of Byte; const InputLen: Cardinal);
     procedure    Transform(var block: array of Byte);
     {$ifdef VER120}
     procedure    Encode(var Output: array of Byte; Input: array of Cardinal; const Length: integer);
     procedure    Decode(var Output: array of Cardinal; Input: array of Byte; const Length: integer);
     procedure    FF(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
     procedure    GG(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
     procedure    HH(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
     procedure    II(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
     {$else}
     procedure    Encode(var Output: array of Byte; Input: array of integer; const Length: integer);
     procedure    Decode(var Output: array of integer; Input: array of Byte; const Length: integer);
     procedure    FF(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
     procedure    GG(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
     procedure    HH(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
     procedure    II(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
     {$endif}
  public
     procedure    Init;
     procedure    HashByte  (const ByteToHash: Byte);
     procedure    HashString(const StringToHash: String);
     procedure    HashFile  (const FileName: String);
     procedure    HashStream(const Stream: TStream);
     function     Finish: TDigest;
     function     GetHashString: string;
     function     GetHashDigest: TDigest;
     function     GetVersion: string;
     procedure    Burn;
  end;

{$ifdef COMPONENT}
procedure Register;
{$endif}

implementation

const
     RELVER = '1.11b';

{$ifdef COMPONENT}
{*******************************************************************************
* Procedure : Register                                                         *
********************************************************************************
* Purpose   : Declares the component to the Delhpi IDE (in component mode only)*
********************************************************************************
* Paramters : 'Crypto' : the name of the Tab under which the component should  *
*             appear                                                           *
*             'TMD5' The name of the component in the tab. Must match the      *
*             declared type name                                               *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure Register;
begin
     RegisterComponents('Crypto', [TMD5]);
end; {Register}
{$endif}

{*******************************************************************************
* Procedure : Init                                                             *
********************************************************************************
* Purpose   : Reloads the internal state variables with the inital vector      *
********************************************************************************
* Paramters :None                                                              *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.Init;
begin
     // if the component has not been registered, remind the user occasionally
     // that he should do this and set the property so that we can see this

     {$ifndef REGISTERED}
     NagRegister;
     {$endif}

     // MD5 initialization. Begins an MD5 operation, writing a new context. */
     Fcontext.count[0] := 0;
     Fcontext.count[1] := 0;

     // Load magic initialization constants.
     Fcontext.state[0] := $67452301;
     Fcontext.state[1] := $efcdab89;
     Fcontext.state[2] := $98badcfe;
     Fcontext.state[3] := $10325476;
end; {TMD5.Init}

{*******************************************************************************
* Procedure : HashString                                                       *
********************************************************************************
* Purpose   : Hashes the characters of a Delphi string                         *
********************************************************************************
* Paramters : StringToHash: The string to be added to the hash                 *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.HashString(const StringToHash: String);
const
     MAX_BUFFER = 2048;
var
     Buffer: array[0..MAX_BUFFER-1] of Byte;
     Index: integer;
begin
     // initialise the position counters
     FillChar(Buffer, Sizeof(Buffer), 0);
     Index := 0;

     // do the bulk of the string
     while Length(StringToHash) - Index > MAX_BUFFER do
     begin
          Move(StringToHash[Index], Buffer, MAX_BUFFER);
          Update(Buffer[0], MAX_BUFFER);
     end;

     // do the trailing bytes
     FillChar(Buffer, Sizeof(Buffer), 0);
     Move(StringToHash[Index+1], Buffer, Length(StringToHash)-Index);
     Update(Buffer, Length(StringToHash)-Index);
end; {TMD5.HashString}

{*******************************************************************************
* Procedure : HashByte                                                         *
********************************************************************************
* Purpose   : Hashes a single byte                                             *
********************************************************************************
* Paramters : BateToHash: The string to be added to the hash                   *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.HashByte(const ByteToHash: Byte);
begin
     Update(ByteToHash, 1);
end; {TMD5.HashByte}

{*******************************************************************************
* Procedure : HashFile                                                         *
********************************************************************************
* Purpose   : Adds the contents of a given file to the hash                    *
********************************************************************************
* Paramters : Filename - the file to be added to the hash                      *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.HashFile(const FileName: String);
const
     MAX_BUFFER = 2048;
var
     filestream: TFileStream;
     Buffer: array[0..MAX_BUFFER-1] of Byte;
     BytesRead: Integer;
     Continue: Boolean;
begin
     // continue tells us if there are more blocks to read
     Continue := False;

     // initialise the buffer
     FillChar(Buffer, Sizeof(Buffer), 0);

     // open the stream
     filestream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
     try
          // read up to the buffer length into the buffer from the stream
          BytesRead := filestream.Read(Buffer, MAX_BUFFER);

          // if there are more bytes remaining, then note that we have more to do
          if BytesRead > 0 then Continue := True;
          while (Continue) do
          begin
               // break out of the loop if we have processed everything
               if BytesRead < MAX_BUFFER then
               begin
                    Continue := False;
               end;

               // add the bytes to the hash
               Update(Buffer, BytesRead);

               // perform the next read
               BytesRead := filestream.Read(Buffer, MAX_BUFFER);
          end;
     finally
          // free the filestream
          filestream.Free;
     end;
end; {TMD5.HashFile}

{*******************************************************************************
* Procedure : HashStream                                                       *
********************************************************************************
* Purpose   : Adds the contents of a stream to the hash                        *
********************************************************************************
* Paramters : Stream - the stream to be added to the hash                      *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.HashStream(const Stream: TStream);
const
     MAX_BUFFER = 2048;
var
     Buffer: array[0..MAX_BUFFER-1] of Byte;
     BytesRead: Integer;
     Continue: Boolean;
begin
     // continue tells us if there are more blocks to read
     Continue := False;

     // initialise the buffer
     FillChar(Buffer, Sizeof(Buffer), 0);

     try
          // read up to the buffer length into the buffer from the stream
          BytesRead := Stream.Read(Buffer, MAX_BUFFER);

          // if there are more bytes remaining, then note that we have more to do
          if BytesRead > 0 then Continue := True;
          while (Continue) do
          begin
               // break out of the loop if we have processed everything
               if BytesRead < MAX_BUFFER then
               begin
                    Continue := False;
               end;

               // add the bytes to the hash
               Update(Buffer, BytesRead);

               // perform the next read
               BytesRead := Stream.Read(Buffer, MAX_BUFFER);
          end;
     except
          raise Exception.Create('Invalid Stream Object');
     end;
end; {TMD5.HashStream}

{*******************************************************************************
* Procedure : Finish                                                           *
********************************************************************************
* Purpose   : Finalises the hash and burns the context                         *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : Digest of the message                                            *
*******************************************************************************}
function TMD5.Finish: TDigest;
var
     bits: array[0..7] of Byte;
     index: integer;
     padLen: integer;
     padding: array[0..63] of Byte;
     temp: array[0..15] of Byte;
begin
     // Save number of bits
     Encode (bits, Fcontext.count, 8);

     // Pad out to 56 mod 64.
     index := ((Fcontext.count[0] shr 3) and $3f);

     if index < 56 then
     begin
          padLen := (56-index);
     end
     else
     begin
          padLen := (120-index);
     end;

     FillChar(Padding, SizeOf(Padding), #0);
     Padding[0] := $80;

     Update (Padding, PadLen);

     FillChar(Padding, SizeOf(Padding), #0);
     Move(Bits, Padding, 8);
     Update (Padding, 8);

     // Store state in digest
     Encode (temp, Fcontext.state, 16);

     Move(Temp, FDigest, 16);

     // return the result
     Result := FDigest;

     // Zeroize sensitive information.
     FillChar(Fcontext, sizeof(Fcontext), #0);
end; {TMD5.Finish}

{*******************************************************************************
* Procedure : GetHashString                                                    *
********************************************************************************
* Purpose   : Returns the hash as a string after it has been created with      *
*             'Finish'                                                         *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : String - the hash expressed as a hex string                      *
*******************************************************************************}
function TMD5.GetHashString: String;
var
     i: Byte;
begin
     Result := '';
     for i := 0 to 15 do
     begin
          Result := Result + IntToHex(Ord(FDigest[i]),2);
     end;
end; {TMD5.GetHashString}

{*******************************************************************************
* Procedure : GetHashDigest                                                    *
********************************************************************************
* Purpose   : Returns the hash as a digest after it has been created with      *
*             'Finish'                                                         *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : Digest - the hash expressed as an object 'TDigest'               *
*******************************************************************************}
function TMD5.GetHashDigest: TDigest;
begin
     Result := FDigest;
end; {TMD5.GetHashDigest}

{*******************************************************************************
* Procedure : GetVersion                                                       *
********************************************************************************
* Purpose   : Returns the internal version number of the component             *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : String - the version number expressed as a string                *
*******************************************************************************}
function TMD5.GetVersion;
begin
     // return the version string
     Result := RELVER;

     {$ifdef REGISTERED}
     Result := Result + ' Registered';
     {$endif}
     {$ifdef NOTREGISTERED}
     Result := Result + ' Unregistered';
     {$endif}
     {$ifdef FREEWARE}
     Result := Result + ' Freeware';
     {$endif}
end; {TMD5.GetVersion}

{*******************************************************************************
* Procedure : Burn                                                             *
********************************************************************************
* Purpose   : Clears the internal state of the component                       *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.Burn;
begin
     // clear the internal state
     Init;
end; {TMD5.Burn}

{*******************************************************************************
* Procedure : Update                                                           *
********************************************************************************
* Purpose   : Adds bytes to the internal hash                                  *
********************************************************************************
* Paramters : Input - the bytes to be added to the hash                        *
*             InputLen - the length of the buffer which is to be added         *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.Update(const input: Array of Byte; const InputLen: Cardinal);
var
     index: integer;
     partLen: Cardinal;
     i: Cardinal;
begin
     // Compute number of bytes mod 64
     index := ((Fcontext.count[0] shr 3) and $3F);

     // Update number of bits
     Fcontext.count[0] := Fcontext.count[0] + (inputLen shl 3);
     if Fcontext.count[0] < (inputLen shl 3) then
          Inc(Fcontext.count[1]);
     Fcontext.count[1] := Fcontext.count[1] + (inputLen shr 29);

     partLen := 64 - index;

     // Transform as many times as necessary, each time
     // adding a block of up to 64 bytes
     if (inputLen >= partLen) then
     begin
          move(input, Fcontext.Buffer[index], partLen);
          Transform (Fcontext.Buffer);

          i := partLen;
          while (i + 63) < inputLen do
          begin
               move(input[i], Fcontext.Buffer, 64);
               Transform (Fcontext.Buffer);
               Inc(i,64);
          end;
          index := 0;
     end
     else
     begin
          i := 0;
     end;

     // Buffer remaining input
     move(input[i], Fcontext.Buffer[index], inputLen-i);
end; {TMD5.Update}

{*******************************************************************************
* Procedure : Transform                                                        *
********************************************************************************
* Purpose   : MD5 basic transformation                                         *
********************************************************************************
* Paramters : Block - array to be transformed                                  *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.Transform(var Block: array of Byte);
var
     {$ifdef VER120}
     a: Cardinal;
     b: Cardinal;
     c: Cardinal;
     d: Cardinal;
     x: array[0..15] of Cardinal;
     {$else}
     a: integer;
     b: integer;
     c: integer;
     d: integer;
     x: array[0..15] of integer;
     {$endif}
begin
     a := Fcontext.state[0];
     b := Fcontext.state[1];
     c := Fcontext.state[2];
     d := Fcontext.state[3];

     Decode (x, block, 64);

     // Round 1
     FF (a, b, c, d, x[ 0], 7,  $d76aa478);
     FF (d, a, b, c, x[ 1], 12, $e8c7b756);
     FF (c, d, a, b, x[ 2], 17, $242070db);
     FF (b, c, d, a, x[ 3], 22, $c1bdceee);
     FF (a, b, c, d, x[ 4], 7,  $f57c0faf);
     FF (d, a, b, c, x[ 5], 12, $4787c62a);
     FF (c, d, a, b, x[ 6], 17, $a8304613);
     FF (b, c, d, a, x[ 7], 22, $fd469501);
     FF (a, b, c, d, x[ 8], 7,  $698098d8);
     FF (d, a, b, c, x[ 9], 12, $8b44f7af);
     FF (c, d, a, b, x[10], 17, $ffff5bb1);
     FF (b, c, d, a, x[11], 22, $895cd7be);
     FF (a, b, c, d, x[12], 7,  $6b901122);
     FF (d, a, b, c, x[13], 12, $fd987193);
     FF (c, d, a, b, x[14], 17, $a679438e);
     FF (b, c, d, a, x[15], 22, $49b40821);

     // Round 2
     GG (a, b, c, d, x[ 1], 5,  $f61e2562);
     GG (d, a, b, c, x[ 6], 9,  $c040b340);
     GG (c, d, a, b, x[11], 14, $265e5a51);
     GG (b, c, d, a, x[ 0], 20, $e9b6c7aa);
     GG (a, b, c, d, x[ 5], 5,  $d62f105d);
     GG (d, a, b, c, x[10], 9,  $2441453);
     GG (c, d, a, b, x[15], 14, $d8a1e681);
     GG (b, c, d, a, x[ 4], 20, $e7d3fbc8);
     GG (a, b, c, d, x[ 9], 5,  $21e1cde6);
     GG (d, a, b, c, x[14], 9,  $c33707d6);
     GG (c, d, a, b, x[ 3], 14, $f4d50d87);
     GG (b, c, d, a, x[ 8], 20, $455a14ed);
     GG (a, b, c, d, x[13], 5,  $a9e3e905);
     GG (d, a, b, c, x[ 2], 9,  $fcefa3f8);
     GG (c, d, a, b, x[ 7], 14, $676f02d9);
     GG (b, c, d, a, x[12], 20, $8d2a4c8a);

     // Round 3
     HH (a, b, c, d, x[ 5], 4,  $fffa3942);
     HH (d, a, b, c, x[ 8], 11, $8771f681);
     HH (c, d, a, b, x[11], 16, $6d9d6122);
     HH (b, c, d, a, x[14], 23, $fde5380c);
     HH (a, b, c, d, x[ 1], 4,  $a4beea44);
     HH (d, a, b, c, x[ 4], 11, $4bdecfa9);
     HH (c, d, a, b, x[ 7], 16, $f6bb4b60);
     HH (b, c, d, a, x[10], 23, $bebfbc70);
     HH (a, b, c, d, x[13], 4,  $289b7ec6);
     HH (d, a, b, c, x[ 0], 11, $eaa127fa);
     HH (c, d, a, b, x[ 3], 16, $d4ef3085);
     HH (b, c, d, a, x[ 6], 23, $04881d05);
     HH (a, b, c, d, x[ 9], 4,  $d9d4d039);
     HH (d, a, b, c, x[12], 11, $e6db99e5);
     HH (c, d, a, b, x[15], 16, $1fa27cf8);
     HH (b, c, d, a, x[ 2], 23, $c4ac5665);

     // Round 4
     II (a, b, c, d, x[ 0], 6,  $f4292244);
     II (d, a, b, c, x[ 7], 10, $432aff97);
     II (c, d, a, b, x[14], 15, $ab9423a7);
     II (b, c, d, a, x[ 5], 21, $fc93a039);
     II (a, b, c, d, x[12], 6,  $655b59c3);
     II (d, a, b, c, x[ 3], 10, $8f0ccc92);
     II (c, d, a, b, x[10], 15, $ffeff47d);
     II (b, c, d, a, x[ 1], 21, $85845dd1);
     II (a, b, c, d, x[ 8], 6,  $6fa87e4f);
     II (d, a, b, c, x[15], 10, $fe2ce6e0);
     II (c, d, a, b, x[ 6], 15, $a3014314);
     II (b, c, d, a, x[13], 21, $4e0811a1);
     II (a, b, c, d, x[ 4], 6,  $f7537e82);
     II (d, a, b, c, x[11], 10, $bd3af235);
     II (c, d, a, b, x[ 2], 15, $2ad7d2bb);
     II (b, c, d, a, x[ 9], 21, $eb86d391);

     Inc(Fcontext.state[0],a);
     Inc(Fcontext.state[1],b);
     Inc(Fcontext.state[2],c);
     Inc(Fcontext.state[3],d);

     // Zeroize sensitive information.
     fillchar (x, sizeof (x), #0);
end; {MD5.Transform}

{*******************************************************************************
* Procedure : Encode                                                           *
********************************************************************************
* Purpose   : Turns 32Bit words into Bytes taking care of endianness           *
********************************************************************************
* Paramters : Input - Array of 32bit words to be encoded                       *
*             Length - the number of 32bit words to be encoded (multiple of 4) *
********************************************************************************
* Returns   : Output - the words encoded as bytes                              *
*******************************************************************************}
{$ifdef VER120}
procedure TMD5.Encode(var Output: array of Byte; Input: array of Cardinal; const Length: integer);
{$else}
procedure TMD5.Encode(var Output: array of Byte; Input: array of integer; const Length: integer);
{$endif}
var
     i: integer;
     j: integer;
begin
     i := 0;
     j := 0;

     while (j < Length) do
     begin
          output[j]   := (input[i] and $ff);
          output[j+1] := ((input[i] shr 8)  and $ff);
          output[j+2] := ((input[i] shr 16) and $ff);
          output[j+3] := ((input[i] shr 24) and $ff);
          Inc(i);
          Inc(j,4);
     end;
end; {TMD5.Encode}

{*******************************************************************************
* Procedure : Decode                                                           *
********************************************************************************
* Purpose   : Turns Bytes into 32bit words taking care of endianness           *
********************************************************************************
* Paramters : Input - Array of bytes to be decoded                             *
*             Length - the number of bates to be decoded                       *
********************************************************************************
* Returns   : Output - the bytes encoded as words                              *
*******************************************************************************}
{$ifdef VER120}
procedure TMD5.Decode(var Output: array of Cardinal; Input: array of Byte; const Length: integer);
{$else}
procedure TMD5.Decode(var Output: array of integer; Input: array of Byte; const Length: integer);
{$endif}
var
     i: integer;
     j: integer;
begin
     i := 0;
     j := 0;

     while (j < Length) do
     begin
         Output[i] := (Input[j]) or ((input[j+1]) shl 8) or
                       ((input[j+2]) shl 16) or ((input[j+3]) shl 24);
          Inc(i);
          Inc(j,4);
     end;
end; {TMD5.Decode}

{*******************************************************************************
* Procedure : FF                                                               *
********************************************************************************
* Purpose   : Nonlinear round function for round one                           *
*             F(x, y, z) := (((x) & (y)) | ((~x) & (z)))                       *
********************************************************************************
* Paramters : a,b,c,d - state variables in MD5 context                         *
*             x - element of the message                                       *
*             s - the rotation                                                 *
*             ac - constant                                                    *
********************************************************************************
* Returns   : None - changes performed in a                                    *
*******************************************************************************}
{$ifdef VER120}
procedure TMD5.FF(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
{$else}
procedure TMD5.FF(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
{$endif}
begin
     // (a) += F ((b), (c), (d)) + (x) + (ac)
     a := a + ((b and c) or ((not b) and d)) + x + ac;

     // (a) = ROTATE_LEFT ((a), (s))
     a := (a shl s) or (a shr (32-s));
     a := a + b;
end; {TMD5.FF}

{*******************************************************************************
* Procedure : GG                                                               *
********************************************************************************
* Purpose   : Nonlinear round function for round two                           *
*             G(x, y, z) := (((x) & (z)) | ((y) & (~z)))                       *
********************************************************************************
* Paramters : a,b,c,d - state variables in MD5 context                         *
*             x - element of the message                                       *
*             s - the rotation                                                 *
*             ac - constant                                                    *
********************************************************************************
* Returns   : None - changes performed in a                                    *
*******************************************************************************}
{$ifdef VER120}
procedure TMD5.GG(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
{$else}
procedure TMD5.GG(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
{$endif}
begin
     //  (a) += G ((b), (c), (d)) + (x) + (UINT4)(ac); \
     a := a + ((b and d) or (c and (not d))) + x + ac;
     a := (a shl s) or (a shr (32-s));
     a := a + b;
end; {TMD5.GG}

{*******************************************************************************
* Procedure : HH                                                               *
********************************************************************************
* Purpose   : Nonlinear round function for round three                         *
*             H(x, y, z) := ((x) ^ (y) ^ (z))                                  *
********************************************************************************
* Paramters : a,b,c,d - state variables in MD5 context                         *
*             x - element of the message                                       *
*             s - the rotation                                                 *
*             ac - constant                                                    *
********************************************************************************
* Returns   : None - changes performed in a                                    *
*******************************************************************************}
{$ifdef VER120}
procedure TMD5.HH(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
{$else}
procedure TMD5.HH(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
{$endif}
begin
     //(a) += H ((b), (c), (d)) + (x) + (UINT4)(ac); \
     a := a + (b xor c xor d) + x + ac;
     a := (a shl s) or (a shr (32-s));
     a := a + b;
end; {TMD5.HH}

{*******************************************************************************
* Procedure : II                                                               *
********************************************************************************
* Purpose   : Nonlinear round function for round four                          *
*             I(x, y, z) := ((y) ^ ((x) | (~z)))                               *
********************************************************************************
* Paramters : a,b,c,d - state variables in MD5 context                         *
*             x - element of the message                                       *
*             s - the rotation                                                 *
*             ac - constant                                                    *
********************************************************************************
* Returns   : None - changes performed in a                                    *
*******************************************************************************}
{$ifdef VER120}
procedure TMD5.II(var a:Cardinal; const b:Cardinal; const c:Cardinal; const d: Cardinal; const x:Cardinal; const s:Cardinal; const ac:Cardinal);
{$else}
procedure TMD5.II(var a:integer; const b:integer; const c:integer; const d: integer; const x:integer; const s:integer; const ac:integer);
{$endif}
begin
     // (a) += I ((b), (c), (d)) + (x) + (UINT4)(ac)
     a := a + (c xor (b or (not d))) + x + ac;
     a := (a shl s) or (a shr (32-s));
     a := a + b;
end; {TMD5.II}

{$ifndef REGISTERED}
{*******************************************************************************
* Procedure : NagRegister                                                      *
********************************************************************************
* Purpose   : Prompts the user to register TMD5 - can be disabled by setting   *
*             the define 'REGISTERED'                                          *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TMD5.NagRegister;
begin
     Randomize;
     if Random(100) >= 95 then
     begin
          {$ifdef NOTREGISTERED}
          // show the reminder 5% of the time
          ShowMessage('You have not yet registered MD5. Contact <register@crypto-central.com> to do so and remove this message.');
          {$endif}
          {$ifdef FREEWARE}
          // show the advert message 1% of the time
          if Random(6) = 1 then
          begin
               ShowMessage('The MD5 hash used in this application has been brought to you by TSM Inc. Visit our web site at http://www.crypto-central.com for more information.');
          end; {if Random(6)}
          {$endif}
     end; {if}
end; {TMD5.NagRegister}
{$endif}

end.

