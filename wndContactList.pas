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
unit wndContactList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, eglobal, addressbook;

type
  TwndContactList = class(TForm)
    gridSelectFrom: TStringGrid;
    Panel1: TPanel;
    cmdNew: TButton;
    cmdEdit: TButton;
    cmdDelete: TButton;
    cmdOK: TButton;
    Panel2: TPanel;
    efFind: TEdit;
    cmdFind: TButton;
    Label3: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    cbWhich: TComboBox;
    procedure cbWhichChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdNewClick(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
    procedure cmdFindClick(Sender: TObject);
    procedure efFindKeyPress(Sender: TObject; var Key: Char);
    procedure gridSelectFromDblClick(Sender: TObject);
    procedure efFindEnter(Sender: TObject);
    procedure efFindExit(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmdDeleteClick(Sender: TObject);

  private
    { Private declarations }
    m_bRowsAdded : Boolean;

    m_oLastListBoxUsed : TListBox;

  protected
     function GetListBoxEntriesAsString(oList : TListBox) : String;
     procedure SetListBoxEntriesFromString(oList : TListBox; sEntries : String);
     procedure RemoveEntryFromList(oList : TListBox);

     procedure LoadGridWithContacts;
     procedure AddUpdateRow(nRow : Integer; oEntry : TAddressBookEntry);

     procedure FindNameFromEdit;
     procedure AppendEmailEntryToList(oEntry : TAddressBookEntry);

     procedure CopyEmailToFieldFromList(oList : TListBox);

  public
    { Public declarations }
  published
  end;

var
   wndContacts : TwndContactList;


implementation

uses
    dispyn, dlgNewEmailAddress, mdimax, folder, helpengine;

{$R *.DFM}

procedure TwndContactList.LoadGridWithContacts;
var
  oEntry : TAddressBookEntry;
  nCount : Integer;
begin
    oEntry := NIL;
    m_bRowsAdded := FALSE;
    gridSelectFrom.RowCount := 2;
    gridSelectFrom.Cells[0, 0] := 'Name';
    gridSelectFrom.Cells[1, 0] := 'Email Address';
    gridSelectFrom.Cells[2, 0] := 'Email Address';
    gridSelectFrom.Cells[3, 0] := 'Nick Name';
    gridSelectFrom.Cells[4, 0] := 'Notes';

    if Not Assigned(g_oAddressBook) then
       raise Exception.create('g_oAddressBook not assigned in TwndContactList.FormCreate');

    if 0 = g_oAddressBook.Count then
    begin
       gridSelectFrom.Cells[0, 1] := '';
       gridSelectFrom.Cells[1, 1] := '';
       gridSelectFrom.Cells[2, 1] := '';
       gridSelectFrom.Cells[3, 1] := '';
       gridSelectFrom.Cells[4, 1] := '';
    end
    else
    begin
       // add each address book item to the list
       for nCount := 0 to g_oAddressBook.Count - 1 do
       begin
           // Get Entry will create it if its not assigned
           g_oAddressBook.GetEntry(nCount, oEntry);
           if Not Assigned(oEntry) then
              raise Exception.Create('Error in loading addressbook in TwndContactList.FormCreate');

           AppendEmailEntryToList(oEntry);

       end;
    end;

    if Assigned(oEntry) then
       oEntry.Free();
end;

procedure TwndContactList.AddUpdateRow(nRow : Integer; oEntry : TAddressBookEntry);
begin
   if Not Assigned(oEntry) then
       raise Exception.Create('oEntry not assigned in TwndContactList.AddUpdateRow.');

   gridSelectFrom.Cells[0, nRow] := oEntry.FullName;
   gridSelectFrom.Cells[1, nRow] := oEntry.Email[0];
   gridSelectFrom.Cells[2, nRow] := oEntry.Email[1];
   gridSelectFrom.Cells[3, nRow] := oEntry.NickName;
   gridSelectFrom.Cells[4, nRow] := oEntry.Notes;

end;

procedure TwndContactList.RemoveEntryFromList(oList : TListBox);
begin
   if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TwndContactList.CopyEmailToFieldFromLisTt');

   if -1 < oList.ItemIndex then
   begin
       oList.Items.Delete(oList.ItemIndex);
   end;
end;

function TwndContactList.GetListBoxEntriesAsString(oList : TListBox) : String;
var
   sText : String;
   nCount : Integer;
begin
    if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TwndContactList.CopyEmailToFieldFromLisTt');

   for nCount := 0 to oList.Items.Count - 1 do
   begin
      if 0 < Length(Trim(sText)) then
         sText := sText + '; ';

      sText := sText + oList.Items[nCount];
   end;

   GetListBoxEntriesAsString := sText;
end;

procedure TwndContactList.SetListBoxEntriesFromString(oList : TListBox; sEntries : String);
var
   nPos : Integer;
   sText : String;
begin
   if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TwndContactList.CopyEmailToFieldFromLisTt');

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

procedure TwndContactList.CopyEmailToFieldFromList(oList : TListBox);
var
   oEntry : TAddressBookEntry;
   nRow : Integer;
begin
    oEntry := NIL;

    if Not Assigned(oList) then
       raise Exception.Create('oList is not assigned  in TwndContactList.CopyEmailToFieldFromLisTt');

   if Not Assigned(g_oAddressBook) then
      raise Exception.Create('g_oAddressBook not assigned in TwndContactList.CopyEmailToFieldFromLisTt');

    m_oLastListBoxUsed := oList;

    nRow := gridSelectFrom.Row - 1;
    if 0 <= nRow then
    begin
        if nRow >= g_oAddressBook.Count then
           raise Exception.Create('There are more items in the address book selection than in the address book object in TwndContactList.CopyEmailToFieldFromLisTt');

        g_oAddressBook.GetEntry(nRow, oEntry);
        if Not Assigned(oEntry) then
           raise Exception.Create('oEntry is not assigned in TwndContactList.CopyEmailToFieldFromLisTt');

        oList.Items.Add(oEntry.Email[0]);
        oEntry.Free();
    end;
end;

procedure TwndContactList.AppendEmailEntryToList(oEntry : TAddressBookEntry);
var
   nCount : Integer;
begin
   if Not Assigned(oEntry) then
      raise Exception.Create('oEntry not assigned in TwndContactList.AppendEmailEntryToList');

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

   AddUpdateRow(nCount - 1, oEntry);

end;

procedure TwndContactList.FindNameFromEdit;
var
   oEntry : TAddressBookEntry;
   nIndex : Integer;
begin
   oEntry := NIL;

   nIndex := g_oAddressBook.FindEntryFromString(Trim(efFind.Text), oEntry);
   if -1 < nIndex then
   begin
       if Not Assigned(oEntry) then
           raise Exception.Create('oEntry not assigned in TwndContactList.FindNameFromEdit');

       gridSelectFrom.Row := nIndex + 1;
       oEntry.Free;
   end
   else
       MessageDlg('Your search did not find a match.  Please reenter search information.', mtInformation, [mbOK], 0);

end;


procedure TwndContactList.cbWhichChange(Sender: TObject);
begin
   // TODO 1.12.02 temporary
   if 0 < cbWhich.ItemIndex then
   begin
       MessageDlg('Only Emailmax address books are supported at this time.  If you think this is in error, please download the latest Emailmax install and reinstall Emailmax.', mtInformation, [mbOK], 0);
       cbWhich.ItemIndex := 0;
   end;
end;

procedure TwndContactList.FormCreate(Sender: TObject);
begin
   m_oLastListBoxUsed := NIL;
   cbWhich.ItemIndex := 0;
   HelpContext := KEY_ADDRESS_BOOK_MDI;

   LoadGridWithContacts;
end;

procedure TwndContactList.cmdNewClick(Sender: TObject);
var
   oDlg : TNewEmailAddress;
begin
   if Not Assigned(g_oAddressBook) then
      raise Exception.Create('g_oAddressBook not assigned in TwndContactList.cmdNewClick');
      
   oDlg := TNewEmailAddress.Create(Self);
   if Not Assigned(oDlg) then
      raise Exception.Create('oDlg not assigned in TwndContactList.cmdNewClick');

   CenterFormOverParent(Application.MainForm, oDlg);
   if mrOk = oDlg.DoModal() then
   begin

      g_oAddressBook.AddEntry(oDlg.Entry);
      AppendEmailEntryToList(oDlg.Entry);

   end;

   oDlg.Free();
end;

procedure TwndContactList.cmdEditClick(Sender: TObject);
var
   nRow : Integer;
   oDlg : TNewEmailAddress;
   oEntry : TAddressBookEntry;
begin
   nRow := gridSelectFrom.Row - 1;
   if 0 > nRow then
      exit;

   if Not Assigned(g_oAddressBook) then
      raise Exception.Create('g_oAddressBook not assigned in TwndContactList.cmdPropertiesClick');

   if nRow >= g_oAddressBook.Count then
      raise Exception.Create('There are more items in the address book selection than in the address book object in TwndContactList.CopyEmailToFieldFromLisTt');

   oDlg := TNewEmailAddress.Create(Self);
   if Not Assigned(oDlg) then
      raise Exception.Create('oDlg not assigned in TwndContactList.cmdPropertiesClick');

   CenterFormOverParent(Application.MainForm, oDlg);

   oEntry := oDlg.Entry;
   g_oAddressBook.GetEntry(nRow, oEntry);

   if Not Assigned(oDlg.Entry) then
      raise Exception.Create('oDlg.Entry not assigned in TwndContactList.cmdPropertiesClick');

   oDlg.ReadOnly := FALSE;
   if mrOK = oDlg.DoModal() then
   begin
       g_oAddressBook.UpdateEntry(oEntry);
       AddUpdateRow(nRow + 1, oEntry);
   end;

   oDlg.Free();

end;

procedure TwndContactList.cmdFindClick(Sender: TObject);
begin
    FindNameFromEdit();
end;

procedure TwndContactList.efFindKeyPress(Sender: TObject;
  var Key: Char);
begin
   if Chr(13) = Key then
   begin
       FindNameFromEdit();
       Key := Chr(0);
   end;

end;

procedure TwndContactList.gridSelectFromDblClick(Sender: TObject);
begin
{}
end;

procedure TwndContactList.efFindEnter(Sender: TObject);
begin
   cmdFind.Default := TRUE;
   cmdOK.Caption := '&OK';
   cmdOK.Default := FALSE;
end;

procedure TwndContactList.efFindExit(Sender: TObject);
begin
   cmdFind.Default := FALSE;
   cmdOK.Caption := 'OK';
   cmdOK.Default := TRUE;
end;

procedure TwndContactList.cmdOKClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TwndContactList.FormDestroy(Sender: TObject);
begin

   if Assigned(wndMaxMain) then
   begin
      wndMaxMain.ChildWndLostFocus(wfContacts);
      PostMessage(wndMaxMain.Handle, WM_HANDLE_MDICHILD_CLOSES, WPARAM(wfContacts), 0);
   end;

end;

procedure TwndContactList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   CanClose := TRUE;
end;

procedure TwndContactList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TwndContactList.cmdDeleteClick(Sender: TObject);
var
   nRow : Integer;
   oEntry : TAddressBookEntry;
   dlgConfirm : TdlgDisplayYesNo;
begin
   nRow := gridSelectFrom.Row - 1;
   if 0 > nRow then
      exit;

   oEntry := NIL;

   if Not Assigned(g_oAddressBook) then
       raise Exception.Create('g_oAddressBook not assigned in TwndContactList.cmdDeleteClick.');

   g_oAddressBook.GetEntry(nRow, oEntry);

   if Not Assigned(oEntry) then
       raise Exception.Create('oEntry not assigned in TwndContactList.cmdDeleteClick.');

   dlgConfirm := TdlgDisplayYesNo.Create(Self);

   if Not Assigned(dlgConfirm) then
       raise Exception.Create('dlgConfirm not assigned in TwndContactList.cmdDeleteClick.');

   with dlgConfirm do
   begin
       HelpContext := KEY_ADDRESS_BOOK_EDIT_CONFIRM;
       DialogTitle := 'Confirm Action';
       NoticeText := 'Please confirm...';
       m_oDetailItems.Add('Do you really wish to delete the address book for');
       m_oDetailItems.Add(oEntry.FullName + '?');
       YesOptionText := 'Delete the contact.';
       NoOptionText := 'Do not do delete. I changed my mind.';
       if mrYes = DisplayModal then
       begin
           g_oAddressBook.DeleteEntry(nRow);
           Self.LoadGridWithContacts();
       end;

       free;
   end;

end;

end.
