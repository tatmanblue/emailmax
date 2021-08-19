unit dlgNewEmailAddress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, addressbook;

type
  TNewEmailAddress = class(TForm)
    cmdOK: TButton;
    cmdCancel: TButton;
    Label6: TLabel;
    ctlPages: TPageControl;
    pageGeneral: TTabSheet;
    Label1: TLabel;
    efFullName: TEdit;
    Label3: TLabel;
    efNick: TEdit;
    Label4: TLabel;
    efEmail1: TEdit;
    pageAddress: TTabSheet;
    pageAdditional: TTabSheet;
    Label5: TLabel;
    efEmail2: TEdit;
    Label2: TLabel;
    efEmail3: TEdit;
    Label7: TLabel;
    efPhone1: TEdit;
    Label8: TLabel;
    efPhone2: TEdit;
    Label9: TLabel;
    efPhone3: TEdit;
    Label10: TLabel;
    efNotes: TEdit;
    Label11: TLabel;
    efAddress1: TEdit;
    Label12: TLabel;
    efAddress2: TEdit;
    Label13: TLabel;
    efAddress3: TEdit;
    Label14: TLabel;
    efCity: TEdit;
    Label15: TLabel;
    efState: TEdit;
    Label16: TLabel;
    efZip: TEdit;
    Label17: TLabel;
    efCountry: TEdit;
    cmdEdit: TButton;
    procedure cmdOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure efFullNameExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure efFullNameChange(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
  private
    { Private declarations }
    m_oEntry : TAddressBookEntry;

    m_bFullNameChanged,
    m_bReadChanged,
    m_bReadOnly : Boolean;

    procedure ValidateEmailAddress(sText : String);
    procedure FormatName();
    procedure ToogleReadOnlyState(fState : Boolean);

    function GetFirstName(): String;
    function GetLastName(): String;


  public
    { Public declarations }
    function DoModal(): Integer;

  published
     property Entry : TAddressBookEntry read m_oEntry write m_oEntry;
     property ReadOnly : Boolean read m_bReadOnly write m_bReadOnly default FALSE;
     property ReadOnlyChangedToEdit : Boolean read m_bReadChanged write m_bReadChanged default FALSE; 
  end;

implementation

{$R *.DFM}

procedure TNewEmailAddress.ToogleReadOnlyState(fState : Boolean);
begin
   efFullName.ReadOnly := fState;
   efNick.ReadOnly := fState;
   efEmail1.ReadOnly := fState;
   efEmail2.ReadOnly := fState;
   efEmail3.ReadOnly := fState;
   efPhone1.ReadOnly := fState;
   efPhone2.ReadOnly := fState;
   efPhone3.ReadOnly := fState;
   efAddress1.ReadOnly := fState;
   efAddress2.ReadOnly := fState;
   efAddress3.ReadOnly := fState;
   efCity.ReadOnly := fState;
   efState.ReadOnly := fState;
   efCountry.ReadOnly := fState;
   efZip.ReadOnly := fState;
   efNotes.ReadOnly := fState;

end;

function TNewEmailAddress.GetFirstName() : String;
var
   sText : String;
   nPos : Integer;
begin
   sText := Trim(efFullName.Text);
   nPos := Pos(',', sText);
   if 0 < nPos then
      GetFirstName := Copy(sText, nPos + 1, Length(sText))
   else
      GetFirstName := sText;
end;

function TNewEmailAddress.GetLastName() : String;
var
   sText : String;
   nPos : Integer;
begin
   sText := Trim(efFullName.Text);
   nPos := Pos(',', sText);
   if 0 < nPos then
      GetLastName := Copy(sText, 0, nPos - 1)
   else
      GetLastName := '';

end;

procedure TNewEmailAddress.FormatName;
var
   sText : String;
   nPos : Integer;
begin
   if FALSE = m_bFullNameChanged then
       exit;

   sText := Trim(efFullName.Text);

   // only format if its not in LastName, FirstName format
   // assumption is that the , is the clue to that format
   if 0 < Pos(',', sText) then
       exit;

   nPos := Pos(' ', sText);
   if 0 < nPos then
   begin
       efFullName.Text := Copy(sText, nPos + 1, Length(sText)) + ', ' + Copy(sText, 0, nPos);
   end;

end;

procedure TNewEmailAddress.ValidateEmailAddress(sText : String);
begin
   if 0 = Length(Trim(sText)) then
      exit;

   if 0 = Pos('@', sText) then
      raise Exception.Create('Not valid email address');

   if 0 = Pos('.', sText) then
      raise Exception.Create('Not valid email address');

end;

function TNewEmailAddress.DoModal: Integer;
begin
   with m_oEntry do
   begin
       efFullName.Text := FullName;
       efNick.Text := NickName;
       efEmail1.Text := Email[0];
       efEmail2.Text := Email[1];
       efEmail3.Text := Email[2];
       efPhone1.Text := Phone[0];
       efPhone2.Text := Phone[1];
       efPhone3.Text := Phone[2];
       efAddress1.Text := Address[0];
       efAddress2.Text := Address[1];
       efAddress3.Text := Address[2];
       efCity.Text := City;
       efState.Text := State;
       efCountry.Text := Country;
       efZip.Text := Zip;
       efNotes.Text := Notes;
   end;

   if TRUE = ReadOnly then
   begin
       ToogleReadOnlyState(TRUE);
       cmdOk.Visible := FALSE;
       cmdCancel.Caption := 'Close';
       cmdEdit.Visible := TRUE;
   end;

   m_bFullNameChanged := FALSE;
   DoModal := Self.ShowModal();
end;

procedure TNewEmailAddress.cmdOKClick(Sender: TObject);
begin
   // TODO 08.09.02 use emailmax notification dialog
   // and create help ids for the messages.
   if 0 = Length(Trim(efFullName.Text)) then
   begin
      ModalResult := mrNone;
      MessageDlg('Name is required.  Please enter a name for your address book entry.', mtError, [mbOK], 0);
      ctlPages.ActivePageIndex := 0;
      efFullName.SetFocus;
      Exit;
   end;

   if 0 = Length(Trim(efEmail1.Text)) then
   begin
      ModalResult := mrNone;
      MessageDlg('Email #1 is required.  Please enter a valid email address.', mtError, [mbOK], 0);
      ctlPages.ActivePageIndex := 0;
      efEmail1.SetFocus;
      Exit;
   end;

   try
      ValidateEmailAddress(efEmail1.Text);
   except
      ModalResult := mrNone;
      MessageDlg('Email #1 is not in a valid format. Please re-enter.', mtError, [mbOK], 0);
      ctlPages.ActivePageIndex := 0;
      efEmail1.SetFocus;
      Exit;
   end;

   try
      ValidateEmailAddress(efEmail2.Text);
   except
      ModalResult := mrNone;
      MessageDlg('Email #2 is not in a valid format. Please re-enter.', mtError, [mbOK], 0);
      ctlPages.ActivePageIndex := 2;
      efEmail2.SetFocus;
      Exit;
   end;

   try
      ValidateEmailAddress(efEmail3.Text);
   except
      ModalResult := mrNone;
      MessageDlg('Email #3 is not in a valid format. Please re-enter.', mtError, [mbOK], 0);
      ctlPages.ActivePageIndex := 2;
      efEmail3.SetFocus;
      Exit;
   end;

   // get the info into m_oentry

   if FALSE = ReadOnly Then
   begin
      with m_oEntry do
      begin
          FirstName := GetFirstName();
          LastName := GetLastName();
          NickName := Trim(efNick.Text);
          Email[0] := Trim(efEmail1.Text);
          Email[1] := Trim(efEmail2.Text);
          Email[2] := Trim(efEmail3.Text);
          Phone[0] := Trim(efPhone1.Text);
          Phone[1] := Trim(efPhone2.Text);
          Phone[2] := Trim(efPhone3.Text);
          Address[0] := Trim(efAddress1.Text);
          Address[1] := Trim(efAddress2.Text);
          Address[2] := Trim(efAddress3.Text);
          City := Trim(efCity.Text);
          State := Trim(efState.Text);
          Country := Trim(efCountry.Text);
          Zip := Trim(efZip.Text);
          Notes := Trim(efNotes.Text);
      end;
   end;
   
end;

procedure TNewEmailAddress.FormCreate(Sender: TObject);
begin
   ctlPages.ActivePageIndex := 0;
   m_oEntry := TAddressBookEntry.Create;
   if Not Assigned(m_oEntry) then
      raise Exception.Create('m_oEntry not assigned in TNewEmailAddress.FormCreate');

   m_bFullNameChanged := FALSE;      
end;

procedure TNewEmailAddress.efFullNameExit(Sender: TObject);
begin
    FormatName();
end;

procedure TNewEmailAddress.FormDestroy(Sender: TObject);
begin
    if Assigned(m_oEntry) then
       m_oEntry.Free;
end;

procedure TNewEmailAddress.efFullNameChange(Sender: TObject);
begin
   if FALSE = ReadOnly then
       m_bFullNameChanged := TRUE;
end;

procedure TNewEmailAddress.cmdEditClick(Sender: TObject);
begin
   ToogleReadOnlyState(FALSE);
   cmdOk.Visible := TRUE;
   cmdCancel.Caption := 'Cancel';
   cmdEdit.Visible := FALSE;
   ReadOnly := FALSE;
   ReadOnlyChangedToEdit := TRUE;
end;

end.
