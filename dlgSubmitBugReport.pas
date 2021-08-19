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
unit dlgSubmitBugReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TdlgSubmitBug = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbYourEmail: TComboBox;
    Label4: TLabel;
    txtDate: TLabel;
    Label5: TLabel;
    txtTo: TLabel;
    Label7: TLabel;
    cbProblem: TComboBox;
    cbType: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    efDetails: TMemo;
    pbSend: TButton;
    pbCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure pbSendClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveBugReportAndClose();
  public
    { Public declarations }
  end;

var
  dlgSubmitBug: TdlgSubmitBug;

implementation

{$R *.DFM}
uses
   mdimax, displmsg, alias, eglobal, savemsg, email, helpengine;


procedure TdlgSubmitBug.FormCreate(Sender: TObject);
var
   nCount,
   nAddIndex : Integer;
   bIsDefault : Boolean;
begin
//
//
//  1) load "send" email addresses, selecting default
//  2) set date

   bIsDefault := FALSE;
   nAddIndex := -1;

   for nCount := 1 to g_oEmailAddr.Count do
   begin
       g_oEmailAddr.ActiveIndex := nCount - 1;
       if g_oEmailAddr.GetUseageType = g_cnUsageSend then
       begin
           if bIsDefault = FALSE then
           begin
               nAddIndex := cbYourEmail.Items.Add(g_oEmailAddr.GetEmailAddress);
               bIsDefault := g_oEmailAddr.IsDefault;
           end
           else
               cbYourEmail.Items.Add(g_oEmailAddr.GetEmailAddress);
       end;
   end;

   if bIsDefault then
   begin
       cbYourEmail.ItemIndex := nAddIndex;
   end
   else if cbYourEmail.Items.Count = 1 then
       cbYourEmail.ItemIndex := 0;

   cbProblem.ItemIndex := 3;
   cbType.ItemIndex := 0;
   txtDate.Caption := DateToStr(Now);
   HelpContext := KEY_BUG_REPORT;
   HelpFile := g_csHelpFile;
end;

procedure TdlgSubmitBug.pbCancelClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TdlgSubmitBug.pbSendClick(Sender: TObject);
begin
   SaveBugReportAndClose();
   Close;
end;

procedure TdlgSubmitBug.SaveBugReportAndClose();
var
   sSourceFileName : String;
   oMsg : TOutboundEmail;
   oSaveMsg : TSaveMsg;
   bCreatedFile : Boolean;
begin

   oMsg := Nil;
   bCreatedFile := FALSE;

   oMsg := TOutboundEmail.Create;
   with oMsg do
   begin
       SendTo := txtTo.Caption;
       From := cbYourEmail.Text;
       Date := txtDate.Caption;
       Subject := 'BUG RERORT: ' + cbProblem.Text + ' ' + cbType.Text;
       if Length(Trim(sSourceFileName)) = 0 then
       begin
          GenerateFileName;
          sSourceFileName := MsgTextFileName;
          bCreatedFile := TRUE;
       end;
   end;
   
   efDetails.Lines.Insert(0, ' ');
   efDetails.Lines.Insert(0, 'Emailmax Wizard Version: ' + GetEmailmaxWizardVerInfo());
   efDetails.Lines.Insert(0, ' ');
   efDetails.Lines.Insert(0, 'Emailmax Version: ' + GetVerInfo());

   oSaveMsg := TSaveMsg(efDetails.Lines);
   oSaveMsg.SaveToFile(sSourceFileName);
   if TRUE = bCreatedFile then
       g_oFolders[g_cnToSendFolder].AddMsg(oMsg.OutputHeaderAsString);

   oMsg.Free;

   MessageDlg('Your Bug Submit information has been saved as an email in your out folder.   Please select send mail to send this message to microObjects development staff.', mtInformation, [mbOK], 0);
end;

end.
