unit Hash;

interface

function HashString(const S: string): string;


implementation


uses
  SysUtils,
  MD5;

function HashString(const S: string): string;
var
	Hasher: TMD5;
begin
	Hasher := TMD5.Create(nil);
	try
		Hasher.Init;
		Hasher.HashString(S);
		Hasher.Finish;
		Result := Hasher.GetHashString;
	finally
		Hasher.Free;
	end;
end; // HashString

end.
