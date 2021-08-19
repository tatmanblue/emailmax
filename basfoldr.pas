// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit basfoldr;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, syncobjs;

type
   EFolderException = class(Exception)
   end;

type
   TBaseFolder = class(TStringList)

   protected
       m_nFolderId,
       m_nMinIndex,
       m_nMaxIndex,
       m_nActiveIndex : Integer;

       m_sFileName,
       m_sName,
       m_sDescription,
       m_sIconName : String;

       m_CriticalSection : TCriticalSection;

       // helper functions for parsing information in a row that is part of the folder
       function GetElement(sData : String; nElement : Integer) : string;
       procedure SetActiveIndex(newIndex : Integer); virtual;

   public
       constructor Create;
       destructor Destroy; override;
       procedure IsIndexValid;
       procedure DeleteMsg; virtual;
       procedure AddMsg(sData : string); virtual;
       procedure AddRowToList(sData : String);

       procedure FlushToFile; virtual;

   published
       // helper propertues for parsing information in a row that is part of the folder
       property ActiveIndex : Integer read m_nActiveIndex write SetActiveIndex default -1;
       property Description : String read m_sDescription write m_sDescription;
       property Id : Integer read m_nFolderId write m_nFolderId default -1;
       property MinIndex : Integer read m_nMinIndex write m_nMinIndex default 1;
       property MaxIndex : Integer read m_nMaxIndex write m_nMaxIndex default 1;
       property Name : String read m_sName write m_sName;
   end;


implementation

uses
   eglobal;

constructor TBaseFolder.Create;
begin
   inherited Create;
   m_CriticalSection := TCriticalSection.Create;
   m_nActiveIndex := -1;
end;

destructor TBaseFolder.Destroy;
begin
   try
      if 0 < Length(Trim(m_sFileName)) then
          SaveToFile(m_sFileName);
          
   except
      on error : Exception  do
      begin
         // hmmm...sometimes the exception might mean something
         if Assigned(g_oLogFile) then
            g_oLogFile.Write('Exception in TBaseFolder.Destroy: "' + error.Message + '"');

      end;
   end;
   
   if Assigned(m_CriticalSection) then
      m_CriticalSection.Free;

   inherited;
end;


procedure TBaseFolder.FlushToFile;
begin
   if Not Assigned(m_CriticalSection) then
      raise EFolderException.Create('m_CriticalSection was not assigned in TBaseFolder.FlushToFile');

   m_CriticalSection.Enter;
   
   if 0 = Length(Trim(m_sFileName)) then
      raise EFolderException.Create('No file name was not assigned in TBaseFolder.FlushToFile');
        

   if 0 = Length(Trim(m_sFileName)) then
      raise EFolderException.Create('No file name was not assigned in TBaseFolder.FlushToFile');

   if Assigned(g_oLogFile) then
       g_oLogFile.Write('Flushing "' + m_sName + '"');

   try
       SaveToFile(m_sFileName);
   except
       m_CriticalSection.Leave;
       raise;
   end;

   m_CriticalSection.Leave;
end;


procedure TBaseFolder.SetActiveIndex(newIndex : Integer);
begin
   m_nActiveIndex := newIndex;
end;

function TBaseFolder.GetElement(sData : String; nElement : Integer) : string;
var
   nPos, nCount : Integer;
   sElement : String;
begin
   if (nElement < MinIndex) or (nElement > MaxIndex) then
       raise EFolderException.Create('Element Index out of bounds');

   sElement := sData;
   for nCount := 1 to nElement do
   begin
       nPos := Pos(g_ccharDelimiter, sElement);

       if (nPos = 0) and (nElement < MaxIndex) then
           raise EFolderException.Create('Element #' + IntToStr(nElement) +
                                         ' not found in string:' + Chr(13) +
                                         Chr(10) + '"' + sData + '"');

       if nElement > nCount then
       begin
           sElement := Copy(sElement, nPos + 1, length(sElement));
       end;
   end;

   if nElement < MaxIndex then
   begin
       nPos := Pos(g_ccharDelimiter, sElement);
       GetElement := trim(Copy(sElement, 0, nPos - 1));
   end
   else
       GetElement := trim(sElement);
end;

procedure TBaseFolder.IsIndexValid;
begin
   if m_nActiveIndex = -1 then
       raise EFolderException.Create('Invalid array index #' + IntToStr(m_nActiveIndex));

   if m_nActiveIndex >= Count then
       raise EFolderException.Create('Index exceeds items in list #' + IntToStr(m_nActiveIndex));
end;

procedure TBaseFolder.DeleteMsg;
begin
   try
      m_CriticalSection.Enter;
      IsIndexValid;
      Delete(m_nActiveIndex);
   except
      on oError : Exception do
      begin
         if Assigned(g_oLogFile) then
            g_oLogFile.Write('Exception in TBaseFolder.DeleteMsg: ' + oError.Message);
      end;
   end;
   
   m_CriticalSection.Leave;

end;

// for "backwards compaitibility" hahaha
procedure TBaseFolder.AddMsg(sData : string);
begin
   AddRowToList(sData);
end;

// for "backwards compaitibility" hahaha
procedure TBaseFolder.AddRowToList(sData : String);
begin
   Add(sData);
end;

end.
