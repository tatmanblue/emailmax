// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and hold harmless
// microObjects inc and its employees and owners
// from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit dlgContactList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, eglobal, addressbook;

type
  TdlgContactListWnd = class(TForm)
    Label1: TLabel;
    cbWhich: TComboBox;
    Bevel1: TBevel;
    cmdCancel: TButton;
    cmdOK: TButton;
    gridSelectFrom: TStringGrid;
    lbTo: TListBox;
    lbCC: TListBox;
    lbBcc: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    efFind: TEdit;
    cmdFind: TButton;
    cmdTo: TButton;
    cmdCC: TButton;
    cmdBcc: TButton;
    cmdNew: TButton;
    cmdProperties: TButton;
    procedure cbWhichChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdNewClick(Sender: TObject);
    procedure cmdPropertiesClick(Sender: TObject);
    procedure cmdFindClick(Sender: TObject);
    procedure cmdToClick(Sender: TObject);
    procedure cmdCCClick(Sender: TObject);
    procedure cmdBccClick(Sender: TObject);
    procedure efFindKeyPress(Sender: TObject; var Key: Char);
    procedure gridSelectFromDblClick(Sender: TObject);
    procedure lbToDblClick(Sender: TObject);
    procedure lbCCDblClick(Sender: TObject);
    procedure lbBccDblClick(Sender: TObject);
    procedure efFindEnter(Sender: TObject);
    procedure efFindExit(Sender: TObject);
  private
    { Private declarations }
    m_bRowsAdded : Boolean;

    m_oLastListBoxUsed : TListBox;

  protected
     function GetListBoxEntriesAsString(oList : TListBox) : String;
     procedure SetListBoxEntriesFromString(oList : TListBox; sEntries : String);
     procedure RemoveEntryFromList(oList : TListBox);

     function GetTo() : String;
     function GetCC() : String;
     function GetBCC() : String;

     procedure SetTo(sTo : String);
     procedure SetCC(sCC : String);
     procedure SetBCC(sBCC : String);

     procedure FindNameFromEdit;
     procedure AppendEmailEntryToList(oEntry : TAddressBookEntry);

     procedure CopyEmailToFieldFromList(oList : TListBox);

  public
    { Public declarations }
  published
     property ToField : String read GetTo write SetTo;
     property CCField : String read GetCC write SetCC;
     property BCCField : String read GetBCC write SetBCC;
  end;

implementation

uses
    dlgNewEmailAddress;

{$R *.DFM}

procedure TdlgAddEmailAddress.RemoveEntryFromList(oList : TListBox);
begin
   if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

   if -1 < oList.ItemIndex then
   begin
       oList.Items.Delete(oList.ItemIndex);
   end;
end;

function TdlgAddEmailAddress.GetListBoxEntriesAsString(oList : TListBox) : String;
var
   sText : String;
   nCount : Integer;
begin
    if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

   for nCount := 0 to oList.Items.Count - 1 do
   begin
      if 0 < Length(Trim(sText)) then
         sText := sText + '; ';

      sText := sText + oList.Items[nCount];
   end;

   GetListBoxEntriesAsString := sText;
end;

procedure TdlgAddEmailAddress.SetListBoxEntriesFromString(oList : TListBox; sEntries : String);
var
   nPos : Integer;
   sText : String;
begin
   if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

   if 0 = Length(Trim(sEntries)) then
      exit;

   sText := sEntries;
   repeat
      nPos := Pos(',', sText);
      if 0 = nPos then
         nPos := Pos(';', sText);

      if 0 = nPos then
      begin
         oList.Items.Add(sText);
         sText := '';
      end
      else
      begin
         oList.Items.Add(Trim(Copy(sText, 0, nPos - 1)));
         sText := Copy(sText, nPos + 1, Length(sText));
      end;

   until 0 = Length(sText);

end;

procedure TdlgAddEmailAddress.CopyEmailToFieldFromList(oList : TListBox);
var
   oEntry : TAddressBookEntry;
   nRow : Integer;
begin
    oEntry := NIL;

    if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

   if Not Assigned(g_oAddressBook) then
      raise Exception.Create('g_oAddressBook not assigned in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

    m_oLastListBoxUsed := oList;

    nRow := gridSelectFrom.Row - 1;
    if 0 <= nRow then
    begin
        if nRow >= g_oAddressBook.Count then
           raise Exception.Create('There are more items in the address book selection than in the address book object in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

        g_oAddressBook.GetEntry(nRow, oEntry);
        if Not Assigned(oEntry) then
           raise Exception.Create('oEntry is not assigned in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

        oList.Items.Add(oEntry.Email[0]);
        oEntry.Free();
    end;
end;

procedure TdlgAddEmailAddress.AppendEmailEntryToList(oEntry : TAddressBookEntry);
var
   nCount : Integer;
begin
   if Not Assigned(oEntry) then
      raise Exception.Create('oEntry not assigned in TdlgAddEmailAddress.AppendEmailEntryToList');

   nCount := gridSelectFrom.RowCount;

   // heres more fucking pain the ass crap from borland
   // in order to have a fixed row (column headers) there
   // has to be more than 1 row in the grid...how fucking
   // stupid...cant the only row be the fixed row.....
   if TRUE = m_bRowsAdded then
   begin
      Inc(nCount);
      gridSelectFrom.RowCount := nCount;
   end;

   m_bRowsAdded := TRUE;

   gridSelectFrom.Cells[0, nCount - 1] := oEntry.FullName;
   gridSelectFrom.Cells[1, nCount - 1] := oEntry.Email[0];
   gridSelectFrom.Cells[2, nCount - 1] := oEntry.Email[1];
   gridSelectFrom.Cells[3, nCount - 1] := oEntry.NickName;
   gridSelectFrom.Cells[4, nCount - 1] := oEntry.Notes;

end;

procedure TdlgAddEmailAddress.FindNameFromEdit;
var
   oEntry : TAddressBookEntry;
   nIndex : Integer;
begin
   oEntry := NIL;

   nIndex := g_oAddressBook.FindEntryFromString(Trim(efFind.Text), oEntry);
   if -1 < nIndex then
   begin
       if Not Assigned(oEntry) then
           raise Exception.Create('oEntry not assigned in TdlgAddEmailAddress.FindNameFromEdit');

       gridSelectFrom.Row := nIndex + 1;
       oEntry.Free;
   end
   else
       MessageDlg('Your search did not find a match.  Please reenter search information.', mtInformation, [mbOK], 0);

end;

function TdlgAddEmailAddress.GetTo() : String;
begin
   GetTo := GetListBoxEntriesAsString(lbTo);
end;

function TdlgAddEmailAddress.GetCC() : String;
begin
   GetCC := GetListBoxEntriesAsString(lbCC);
end;

function TdlgAddEmailAddress.GetBCC() : String;
begin
   GetBCC := GetListBoxEntriesAsString(lbBCC);
end;

procedure TdlgAddEmailAddress.SetTo(sTo : String);
begin
   SetListBoxEntriesFromString(lbTo, sTo);
end;

procedure TdlgAddEmailAddress.SetCC(sCC : String);
begin
   SetListBoxEntriesFromString(lbBCC, sCC);

end;

procedure TdlgAddEmailAddress.SetBCC(sBCC : String);
begin
   SetListBoxEntriesFromString(lbBCC, sBCC);
end;

procedure TdlgAddEmailAddress.cbWhichChange(Sender: TObject);
begin
   // TODO 1.12.02 temporary
   if 0 < cbWhich.ItemIndex then
   begin
       MessageDlg('Only Emailmax address books are supported at this time.  If you think this is in error, please download the latest Emailmax install and reinstall Emailmax.', mtInformation, [mbOK], 0);
       cbWhich.ItemIndex := 0;
   end;
end;

procedure TdlgAddEmailAddress.FormCreate(Sender: TObject);
var
  oEntry : TAddressBookEntry;
  nCount : Integer;
begin
    m_oLastListBoxUsed := NIL;
    cbWhich.ItemIndex := 0;

    gridSelectFrom.Cells[0, 0] := 'Name';
    gridSelectFrom.Cells[1, 0] := 'Email Address';
    gridSelectFrom.Cells[2, 0] := 'Email Address';
    gridSelectFrom.Cells[3, 0] := 'Nick Name';
    gridSelectFrom.Cells[4, 0] := 'Notes';

    oEntry := NIL;
    m_bRowsAdded := FALSE;

    if Not Assigned(g_oAddressBook) then
       raise Exception.create('g_oAddressBook not assigned in TdlgAddEmailAddress.FormCreate');

    // add each address book item to the list
    for nCount := 0 to g_oAddressBook.Count - 1 do
    begin
        // Get Entry will create it if its not assigned
        g_oAddressBook.GetEntry(nCount, oEntry);
        if Not Assigned(oEntry) then
           raise Exception.Create('Error in loading addressbook in TdlgAddEmailAddress.FormCreate');

        AppendEmailEntryToList(oEntry);

    end;

    if Assigned(oEntry) then
       oEntry.Free();

end;

procedure TdlgAddEmailAddress.cmdNewClick(Sender: TObject);
var
   oDlg : TNewEmailAddress;
begin
   oDlg := TNewEmailAddress.Create(Self);
   if Not Assigned(oDlg) then
      raise Exception.Create('oDlg not assigned in TdlgAddEmailAddress.cmdNewClick');

   if Not Assigned(g_oAddressBook) then
      raise Exception.Create('g_oAddressBook not assigned in TdlgAddEmailAddress.cmdNewClick');

   CenterFormOverParent(Self, oDlg);
   if mrOk = oDlg.DoModal() then
   begin

      g_oAddressBook.AddEntry(oDlg.Entry);
      AppendEmailEntryToList(oDlg.Entry);

   end;

   oDlg.Free();
end;

procedure TdlgAddEmailAddress.cmdPropertiesClick(Sender: TObject);
var
   nRow : Integer;
   oDlg : TNewEmailAddress;
   oEntry : TAddressBookEntry;
begin
   nRow := gridSelectFrom.Row - 1;
   if 0 = nRow then
      exit;

   if Not Assigned(g_oAddressBook) then
      raise Exception.Create('g_oAddressBook not assigned in TdlgAddEmailAddress.cmdPropertiesClick');

   if nRow >= g_oAddressBook.Count then
      raise Exception.Create('There are more items in the address book selection than in the address book object in TdlgAddEmailAddress.CopyEmailToFieldFromLisTt');

   oDlg := TNewEmailAddress.Create(Self);
   if Not Assigned(oDlg) then
      raise Exception.Create('oDlg not assigned in TdlgAddEmailAddress.cmdPropertiesClick');

   CenterFormOverParent(Self, oDlg);

   oEntry := oDlg.Entry;
   g_oAddressBook.GetEntry(nRow, oEntry);

   if Not Assigned(oDlg.Entry) then
      raise Exception.Create('oDlg.Entry not assigned in TdlgAddEmailAddress.cmdPropertiesClick');

   oDlg.ReadOnly := TRUE;
   if mrOK = oDlg.DoModal() then
   begin
       if TRUE = oDlg.ReadOnlyChangedToEdit then
       begin
           g_oAddressBook.UpdateEntry(oEntry);
       end;
   end;


   oDlg.Free();

end;

procedure TdlgAddEmailAddress.cmdFindClick(Sender: TObject);
begin
    FindNameFromEdit();
end;

procedure TdlgAddEmailAddress.cmdToClick(Sender: TObject);
begin
   CopyEmailToFieldFromList(lbTo);
end;

procedure TdlgAddEmailAddress.cmdCCClick(Sender: TObject);
begin
   CopyEmailToFieldFromList(lbCC);
end;

procedure TdlgAddEmailAddress.cmdBccClick(Sender: TObject);
begin
   CopyEmailToFieldFromList(lbBCC);
end;

procedure TdlgAddEmailAddress.efFindKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Chr(13) = Key then
   begin
       FindNameFromEdit();
       Key := Chr(0);
   end;

end;

procedure TdlgAddEmailAddress.gridSelectFromDblClick(Sender: TObject);
begin
   if Not Assigned(m_oLastListBoxUsed) then
       m_oLastListBoxUsed := lbTo;

   CopyEmailToFieldFromList(m_oLastListBoxUsed);
end;

procedure TdlgAddEmailAddress.lbToDblClick(Sender: TObject);
begin
   RemoveEntryFromList(lbTo);
end;

procedure TdlgAddEmailAddress.lbCCDblClick(Sender: TObject);
begin
   RemoveEntryFromList(lbCC);
end;

procedure TdlgAddEmailAddress.lbBccDblClick(Sender: TObject);
begin
   RemoveEntryFromList(lbBCC);
end;

procedure TdlgAddEmailAddress.efFindEnter(Sender: TObject);
begin
   cmdFind.Default := TRUE;
   cmdOK.Caption := '&OK';
   cmdOK.Default := FALSE;
end;

procedure TdlgAddEmailAddress.efFindExit(Sender: TObject);
begin
   cmdFind.Default := FALSE;
   cmdOK.Caption := 'OK';
   cmdOK.Default := TRUE;
end;

end.
