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
unit dlgactst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TAcctSetupType = (astSTMP, astPOP, astNewsReader, astPOPAuthentication);
  TDlgActionType = (datNew, datEdit);
  TdlgEmailAcctSetup = class(TForm)
    ctlBottom: TPanel;
    pbOK: TButton;
    pbCancel: TButton;
    ctlPages: TPageControl;
    ctlDefaultPage: TTabSheet;
    ctlAdvancedPage: TTabSheet;
    txtPopOrSmtp: TLabel;
    efServer: TEdit;
    txtUser: TLabel;
    efUserId: TEdit;
    txtPassword: TLabel;
    efPassword: TEdit;
    Label1: TLabel;
    efAddress: TEdit;
    ckDefault: TCheckBox;
    ctlImage: TImage;
    txtGeneralInfo: TLabel;
    Image1: TImage;
    procedure pbOKClick(Sender: TObject);
    procedure OnDataChange(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure OnAddressChange(Sender: TObject);
    procedure OnUserIdKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_nType : TAcctSetupType;
    m_nAction : TDlgActionType;
    m_bSave,                               // property for POP Authentication
    m_bLeaveOnServer,                      // property
    m_bDefault,                            // property
    m_bChanged,
    m_bOverrideServer,
    m_bOverrideUserId : Boolean;
    m_sAddress,                            // property
    m_sServer,                             // property
    m_sUserId,                             // property
    m_sPassword : String;                  // property

    // TODO: 06.30.02 this screen/unit is not very OO...redo

  public
    { Public declarations }
    function Display : Integer;
  published
     property DialogType : TAcctSetupType read m_nType write m_nType Default astSTMP;
     property DialogAction : TDlgActionType read m_nAction write m_nAction Default datNew;
     property Default : Boolean read m_bDefault write m_bDefault default FALSE;
     property Address : string read m_sAddress write m_sAddress;
     property LeaveOnServer : boolean read m_bLeaveOnServer write m_bLeaveOnServer default FALSE;
     property Save : boolean read m_bSave write m_bSave default FALSE;
     property Server : String read m_sServer write m_sServer;
     property UserId : String read m_sUserId write m_sUserId;
     property Password : String read m_sPassword write m_sPassword;
  end;


implementation

{$R *.DFM}

uses
   mdimax, helpengine;

function TdlgEmailAcctSetup.Display : Integer;
begin

   // TODO: 08.03.02 Have this function or class take an TEmailAddress and let is handle
   // assigment to screen fields and get from screen fields...
   // the obj could take place of the properties above
   // (as part of the TODO: 06.30.02 above

   wndMaxMain.CenterFormOverSelf(Self);

   //
   // setup data values from parent
   //
   efAddress.Text := Address;
   efServer.Text := Server;
   efUserId.Text := UserId;
   efPassword.Text := Password;

   case DialogType of
       astSTMP:
       begin
           txtGeneralInfo.Caption := 'Enter the information needed for sending an email.';
           efServer.Hint := 'eg: camel.com or smtp.camel.com';
           Self.HelpContext := KEY_SETUP_RECEIVING_DLG;
           if DialogAction = datNew then
               Self.Caption := 'Add a new email address for sending email'
           else
               Self.Caption := 'Edit email address for sending email';

           txtPoporSmtp.Caption := 'Server/SMTP Name';
           ckDefault.Caption := 'Default Account';
           ckDefault.Visible := TRUE;
           ckDefault.Checked := m_bDefault;
           // self.Height := 290;
       end;
       astPOP:
       begin
           txtGeneralInfo.Caption := 'Enter the information needed to receive email.';
           efServer.Hint := 'eg: camel.com or pop.camel.com';
           Self.HelpContext := KEY_SETUP_SENDING_DLG;
           if DialogAction = datNew then
               Self.Caption := 'Add a new email address for receiving email'
           else
               Self.Caption := 'Edit email address for receiving email';
           txtPoporSmtp.Caption := 'Server/POP3 Name';

           ckDefault.Caption := 'Leave Mail on Server';
           ckDefault.Visible := TRUE;
           ckDefault.Checked := m_bLeaveOnServer;

       end;
       astPOPAuthentication:
       begin
           ctlPages.ActivePageIndex := 1;

           txtGeneralInfo.Caption := 'This account could not be authenticated.  Please re-enter the information.';
           efServer.Hint := 'eg: camel.com or pop.camel.com';
           Self.Caption := 'This email account requires authentication';
           Self.HelpContext := KEY_ERRORS_RECEIVE_AUTH;
           txtPoporSmtp.Caption := 'Server/POP3 Name';

           ckDefault.Caption := '&Save for future';
           ckDefault.Visible := TRUE;
           ckDefault.Checked := FALSE;
           efAddress.ReadOnly := TRUE;
           efAddress.Enabled := FALSE;
           efAddress.TabStop := FALSE;
           efPassword.TabOrder := 0;
           pbOK.Enabled := TRUE;
       end;
       astNewsReader: raise Exception.Create('astNewsReader is not supported yet');
   end;

   // Setup internal variables
   m_bOverrideUserId := FALSE;
   m_bOverrideServer := FALSE;
   m_bChanged := FALSE;
   Display := ShowModal;
end;

procedure TdlgEmailAcctSetup.pbOKClick(Sender: TObject);
begin
   Address := efAddress.Text;
   Server := efServer.Text;
   UserId := efUserId.Text;
   Password := efPassword.Text;

   if astPOP = DialogType then
       LeaveOnServer := ckDefault.Checked
   else if astSTMP = DialogType then
       Self.Default := ckDefault.Checked
   else if astPOPAuthentication = DialogType then
       Save := ckDefault.Checked
   else
   begin
       Self.Default := FALSE;
       LeaveOnServer := FALSE;
   end;
end;

procedure TdlgEmailAcctSetup.OnDataChange(Sender: TObject);
begin
    // authentication
    if astPOPAuthentication = DialogType then
    begin
       pbOK.Enabled := TRUE;
       exit;
    end;

    m_bChanged := TRUE;

    if astPOP = DialogType then
    begin
        if (Length(Trim(efAddress.Text)) > 0) and
           (Length(Trim(efServer.Text)) > 0) and
           (Length(Trim(efPassword.Text)) > 0) and
           (Length(Trim(efUserId.Text)) > 0) then
           pbOK.Enabled := TRUE
        else
           pbOK.Enabled := FALSE;
    end
    else
    begin
        if (Length(Trim(efAddress.Text)) > 0) and
           (Length(Trim(efServer.Text)) > 0) then
           pbOK.Enabled := TRUE
        else
           pbOK.Enabled := FALSE;
    end;
end;

procedure TdlgEmailAcctSetup.pbCancelClick(Sender: TObject);
begin
   if TRUE = m_bChanged then
   begin
       if Application.MessageBox('You have changed information -- canceling will lose those changes.  Do you want to close?', 'Confirm Close', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = idNo then
           exit;
   end;
   
   ModalResult := mrCancel

end;

procedure TdlgEmailAcctSetup.OnAddressChange(Sender: TObject);
var
   nPos : Integer;
begin
   nPos := Pos('@', efAddress.Text);
   if 0 < nPos then
   begin
       efServer.Text := Copy(efAddress.Text, nPos + 1, Length(efAddress.Text));
       if FALSE = m_bOverrideUserId then
       begin
           efUserId.Text := Copy(efAddress.Text, 1, nPos - 1);
       end;
    end;
    OnDataChange(Sender);
end;

procedure TdlgEmailAcctSetup.OnUserIdKeyPress(Sender: TObject; var Key: Char);
begin
   m_bOverrideUserId := TRUE;
end;

procedure TdlgEmailAcctSetup.FormCreate(Sender: TObject);
begin
   ctlPages.ActivePageIndex := 0;
end;

end.
