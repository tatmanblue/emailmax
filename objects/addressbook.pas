// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify amd
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit addressbook;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, syncobjs, basfoldr, email, wndFolder;


type
   EAddressBookExeception = class(Exception)
   end;
{
   CHG 1.14.02

   The addressbook contains a list of information related to contacts in terms of
   sending and receiving emails.

   format is g_ccharDelimiter delimited as follows

   06.13.02  changed...
   firstname | lastname | nickname | emailaddress1 | emailaddress2 | emailaddress3 | address1 | address2 | address3 | city | state | country | zip | notes


}
const g_cnMinAddressBookArrayIndex = 0;
const g_cnMaxAddressBookArrayIndex = 2;

type
   TAddressBookEntry = class(TObject)
   protected
      m_nIndex : Integer;
      m_sFirstName,
      m_sLastName,
      m_sNickName,
      m_sCity,
      m_sState,
      m_sCountry,
      m_sZip,
      m_sNotes : String;
      m_sEmail : array [0..2] of String;
      m_sPhone : array [0..2] of String;
      m_sAddress : array [0..2] of String;

      function GetAsString() : String; virtual;
      function GetFirstName() : String;
      function GetLastName() : String;
      function GetNickName() : String;
      function GetFullName() : String;
      function GetEmailAddress(nIndex : Integer) : String;
      function GetPhone(nIndex : Integer) : String;
      function GetAddress(nIndex : Integer) : String;
      procedure SetFirstName(sName : String);
      procedure SetLastName(sName : String);
      procedure SetNickName(sName : String);
      procedure SetEmailAddress(nIndex : Integer; sEmail : String);
      procedure SetPhone(nIndex : Integer; sPhone : String);
      procedure SetAddress(nIndex : Integer; sAddress : String);

   public

      // function AsString() : String;
      property Email[nIndex : Integer] : String read GetEmailAddress write SetEmailAddress;
      property Phone[nIndex : Integer] : String read GetPhone write SetPhone;
      property Address[nIndex : Integer] : String read GetAddress write SetAddress;


   published
      property FirstName : String read GetFirstName write SetFirstName;
      property LastName : String read GetLastName write SetLastName;
      property NickName : String read GetNickName write SetNickName;
      property City : String read m_sCity write m_sCity;
      property State : String read m_sState write m_sState;
      property Zip : String read m_sZip write m_sZip;
      property Country : String read m_sCountry write m_sCountry;
      property Notes : String read m_sNotes write m_sNotes;
      property AsString : String read GetAsString;
      property FullName : String read GetFullName;
      property Index : Integer read m_nIndex write m_nIndex;

   end;

type
   TAddressBook  = class(TBaseFolder)
   protected

   public
       constructor Create;
       constructor CreateFromFile(sFileName : String);
       destructor Destroy; override;

       function FindEntryFromString(sText : String; var oAddrEntry : TAddressBookEntry) : Integer;
       procedure GetEntry(nIndex : Integer; var oAddrEntry : TAddressBookEntry);
       procedure DeleteEntry(nIndex : Integer);
       procedure AddEntry(oAddrEntry : TAddressBookEntry);
       procedure UpdateEntry(oAddrEntry : TAddressBookEntry);


   published
   end;

implementation

uses
   alias, eglobal;


{
===============================================================
   TAddressBookEntry Class implementation
===============================================================
}

function TAddressBookEntry.GetFullName() : String;
begin
   if (0 < Length(Trim(m_sLastName))) AND
      (0 < Length(Trim(m_sFirstName))) then
   begin
      GetFullName := m_sLastName + ', ' + m_sFirstName;
   end
   else
      GetFullName := m_sFirstName + m_sLastName;
end;

function TAddressBookEntry.GetPhone(nIndex : Integer) : String;
begin
   if g_cnMinAddressBookArrayIndex > nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   if g_cnMaxAddressBookArrayIndex < nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   GetPhone := m_sPhone[nIndex];
end;

function TAddressBookEntry.GetAddress(nIndex : Integer) : String;
begin
   if g_cnMinAddressBookArrayIndex > nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   if g_cnMaxAddressBookArrayIndex < nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   GetAddress := m_sAddress[nIndex];
end;

function TAddressBookEntry.GetFirstName() : String;
begin
    GetFirstName := m_sFirstName
end;

function TAddressBookEntry.GetLastName() : String;
begin
    GetLastName := m_sLastName;
end;

function TAddressBookEntry.GetNickName() : String;
begin
    GetNickName := m_sNickName;
end;

function TAddressBookEntry.GetEmailAddress(nIndex : Integer) : String;
begin
   if g_cnMinAddressBookArrayIndex > nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   if g_cnMaxAddressBookArrayIndex < nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   GetEmailAddress := m_sEmail[nIndex];
end;

procedure TAddressBookEntry.SetFirstName(sName : String);
begin
     m_sFirstName := sName;
end;

procedure TAddressBookEntry.SetLastName(sName : String);
begin
     m_sLastName := sName;
end;

procedure TAddressBookEntry.SetNickName(sName : String);
begin
    m_sNickName := sName;
end;

procedure TAddressBookEntry.SetEmailAddress(nIndex : Integer; sEmail : String);
begin
   if 0 > nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   if 2 < nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   m_sEmail[nIndex] := sEmail;
end;

procedure TAddressBookEntry.SetPhone(nIndex : Integer; sPhone : String);
begin
   if g_cnMinAddressBookArrayIndex > nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   if g_cnMaxAddressBookArrayIndex < nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   m_sPhone[nIndex] := sPhone;
end;

procedure TAddressBookEntry.SetAddress(nIndex : Integer; sAddress : String);
begin
   if g_cnMinAddressBookArrayIndex > nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   if g_cnMaxAddressBookArrayIndex < nIndex then
      raise EAddressBookExeception.Create('Incorrect nIndex value passed to TAddressBookEntry.GetEmailAddress');

   m_sAddress[nIndex] := sAddress;
end;

function TAddressBookEntry.GetAsString() : String;
begin
   GetAsString := m_sFirstname + ' ' + g_ccharDelimiter + ' '      // 1
                 + m_sLastname  + ' ' + g_ccharDelimiter + ' '      // 2
                 + m_sNickname  + ' ' + g_ccharDelimiter + ' '      // 3
                 + m_sEmail[0]  + ' ' + g_ccharDelimiter + ' '      // 4
                 + m_sEmail[1]  + ' ' + g_ccharDelimiter + ' '      // 5
                 + m_sEmail[2]  + ' ' + g_ccharDelimiter + ' '      // 6
                 + m_sPhone[0]  + ' ' + g_ccharDelimiter + ' '      // 7
                 + m_sPhone[1]  + ' ' + g_ccharDelimiter + ' '      // 8
                 + m_sPhone[2]  + ' ' + g_ccharDelimiter + ' '      // 9
                 + m_sAddress[0]  + ' ' + g_ccharDelimiter + ' '    //10
                 + m_sAddress[1]  + ' ' + g_ccharDelimiter + ' '    //11
                 + m_sAddress[2]  + ' ' + g_ccharDelimiter + ' '    //12
                 + m_sCity  + ' ' + g_ccharDelimiter + ' '          //13
                 + m_sState  + ' ' + g_ccharDelimiter + ' '         //14
                 + m_sCountry  + ' ' + g_ccharDelimiter + ' '       //15
                 + m_sZip  + ' ' + g_ccharDelimiter + ' '           //16
                 + m_sNotes  + ' ' + g_ccharDelimiter + ' '         //17
                 + ' ' ;

end;

{
===============================================================
   TAddressBook Class implementation
===============================================================
}
constructor TAddressBook.Create;
begin
   inherited;

   MinIndex := g_cnMINADDRFIELDS;
   MaxIndex := g_cnMAXADDRFIELDS;
   m_CriticalSection := TCriticalSection.Create;
   Name := 'AddressBook';
   Description := 'List of email addresses';
end;

constructor TAddressBook.CreateFromFile(sFileName : String);
begin
   inherited Create;
   MinIndex := g_cnMINADDRFIELDS;
   MaxIndex := g_cnMAXADDRFIELDS;
   m_sFileName := sFileName;
   m_CriticalSection := TCriticalSection.Create;
   Name := 'AddressBook';
   Description := 'List of email addresses';
   try
       LoadFromFile(m_sFileName);
   except
       // do not care
   end;
end;

destructor TAddressBook.Destroy;
begin
   inherited;
end;

function TAddressBook.FindEntryFromString(sText : String; var oAddrEntry : TAddressBookEntry) : Integer;
var
   nCount : Integer;
   fRet : Boolean;
begin
   m_CriticalSection.Enter;
   fRet := FALSE;

   try
       for nCount := 0 to Count - 1 do
       begin
           if 0 < Pos(sText, Strings[nCount]) then
           begin
               m_CriticalSection.Leave;
               GetEntry(nCount, oAddrEntry);
               oAddrEntry.Index := nCount;
               fRet := TRUE;
               break;
           end;
       end;

   except
         m_CriticalSection.Leave;
         raise;
   end;

   // this needs reworking...crappy way to handle nothing found
   if FALSE = fRet then
   begin
       m_CriticalSection.Leave;
       nCount := -1;
   end;

   FindEntryFromString := nCount;
end;

procedure TAddressBook.GetEntry(nIndex : Integer; var oAddrEntry : TAddressBookEntry);
var
   sText : String;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.FindMessage');

   m_CriticalSection.Enter;

   try
      ActiveIndex := nIndex;
      IsIndexValid;

      if NOT Assigned(oAddrEntry) then
         oAddrEntry := TAddressBookEntry.Create;

      if NOT Assigned(oAddrEntry) then
         raise Exception.Create('oAddrEntry not assigned in TAddressBook.GetEntry');

      sText := Strings[nIndex];

      oAddrEntry.Index := nIndex;
      with oAddrEntry do
      begin
         FirstName := GetElement(sText, g_cnFirstNameField);
         LastName := GetElement(sText, g_cnLastNameField);
         NickName := GetElement(sText, g_cnNickNameId);
         Email[0] :=  GetElement(sText, g_cnEmail1Field);
         Email[1] :=  GetElement(sText, g_cnEmail2Field);
         Email[2] :=  GetElement(sText, g_cnEmail3Field);
         Phone[0] := GetElement(sText, g_cnPhone1Field);
         Phone[1] := GetElement(sText, g_cnPhone2Field);
         Phone[2] := GetElement(sText, g_cnPhone3Field);
         Address[0] := GetElement(sText, g_cnAddress1Field);
         Address[1] := GetElement(sText, g_cnAddress2Field);
         Address[2] := GetElement(sText, g_cnAddress3Field);
         City := GetElement(sText, g_cnCityField);
         State := GetElement(sText, g_cnStateField);
         Country := GetElement(sText, g_cnCountryField);
         Zip := GetElement(sText, g_cnZipField);
         Notes := GetElement(sText, g_cnNotesField);

      end;
   except
       m_CriticalSection.Leave;
       raise;
   end;

   m_CriticalSection.Leave;

end;

procedure TAddressBook.DeleteEntry(nIndex : Integer);
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.FindMessage');

   m_CriticalSection.Enter;

   try
      ActiveIndex := nIndex;
      IsIndexValid;

      Delete(m_nActiveIndex);

   except
      m_CriticalSection.Leave;
      raise;
   end;

   m_CriticalSection.Leave;
end;

procedure TAddressBook.UpdateEntry(oAddrEntry : TAddressBookEntry);
var
   sString : String;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.FindMessage');

   m_CriticalSection.Enter;

   try
      ActiveIndex := oAddrEntry.Index;
      IsIndexValid;

      inherited Delete(oAddrEntry.Index);
      sString := oAddrEntry.AsString;      Inherited Insert(oAddrEntry.Index, sString);
      
   except
      m_CriticalSection.Leave;
      raise;
   end;

   m_CriticalSection.Leave;
end;

procedure TAddressBook.AddEntry(oAddrEntry : TAddressBookEntry);
var
   sString : String;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TFolder.FindMessage');

   m_CriticalSection.Enter;

   try
      sString := oAddrEntry.AsString;
      Inherited Add(sString);
   except
      m_CriticalSection.Leave;
      raise;
   end;

   m_CriticalSection.Leave;
end;


end.
