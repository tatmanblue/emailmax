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

unit usenet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, AdvImage, KDECap, basepost, email;

type
  TwndUsenetMsg = class(TwndBasePost)
    Label1: TLabel;
    cbRemailers: TComboBox;
    ckAnon: TCheckBox;
    pbNewsGroupLookup: TButton;
    procedure FormCreate(Sender: TObject);
    procedure pbNewsGroupLookupClick(Sender: TObject);
  protected
    procedure SavePostChildProc(oMsg : TBaseEmail); override;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SavePost; override;
  end;

var
  wndUsenetMsg: TwndUsenetMsg;

implementation

uses
   displmsg, news, mdimax, alias, folder, wndFolder, eglobal,
   savemsg, addreml;
{$R *.DFM}

procedure TwndUsenetMsg.SavePostChildProc(oMsg : TBaseEmail);
begin
end;

procedure TwndUsenetMsg.SavePost;
var
   oMsg : TOutboundEmail;
begin
   // TODO...can this be rewritten to take advantage of
   // SavePostChildProc implementation?
   oMsg := TOutboundEmail.Create;
   with oMsg do
   begin
       SendTo := cbRemailers.Text;
       if ckAnon.Checked = TRUE then
           From := cbRemailers.Text
       else
           From := cbFrom.Text;
       Date := efDate.Text;
       Subject := efSubj.Text;
       IsValid := TRUE;
       GenerateFileName;
   end;

   // got to add some lines in the body of the text
   if ckAnon.Checked = TRUE then
       efMsg.Lines.Insert(0, 'Anon-Post-To: ' + efTo.Text)
   else
       efMsg.Lines.Insert(0, 'Post-To: ' + efTo.Text);

   efMsg.Lines.Insert(1, 'Subject: ' + efSubj.Text);
   efMsg.Lines.Insert(2, '  ');

   efMsg.Lines.SaveToFile(oMsg.MsgTextFileName);
   g_oFolders[g_cnToSendFolder].AddMsg(oMsg.OutputHeaderAsString);
   m_bChanged := FALSE;
   Close;
end;

procedure TwndUsenetMsg.FormCreate(Sender: TObject);
var
   oDialog : TdlgAddRemailer;
   oErrorDlg : TdlgDisplayMessage;
   nColor, nCount : Integer;
begin
   inherited;
   // 15461355
   nColor := RGB(235,235,235);
   ctlEditPanel.Color := nColor;
   ctlTopPanel.Color := nColor;

   efDate.Text := DateTimeToStr(Now);
   try
       for nCount := 1 to g_oEmailAddr.Count do
       begin
           g_oEmailAddr.ActiveIndex := nCount - 1;
           if g_oEmailAddr.GetUseageType = g_cnUsageUsenet then
           begin
               cbRemailers.Items.Add(g_oEmailAddr.GetEmailAddress);
           end;
       end;
   except
       on oError : Exception do
           oError.free;
   end;
   
   if cbRemailers.Items.Count = 0 then
   begin
        // g_oEmailAddr.AddEmailAddr(dlgAddRemailer.efSendAddress.Text, dlgAddRemailer.efSendServer.Text, '<NA>', g_cnServerSMTP, g_cnUsageUsenet, TRUE);
        oDialog := TdlgAddRemailer.Create(Self);
        if oDialog.ShowModal = mrOK then
        begin
            g_oEmailAddr.AddEmailAddr(oDialog.efSendAddress.Text, oDialog.efSendServer.Text, '<NA>', '<NA>', g_cnServerSMTP, g_cnUsageUsenet, TRUE, FALSE, FALSE);
            oDialog.free;
            try
                for nCount := 1 to g_oEmailAddr.Count do
                begin
                   g_oEmailAddr.ActiveIndex := nCount - 1;
                   if g_oEmailAddr.GetUseageType = g_cnUsageUsenet then
                   begin
                       cbRemailers.Items.Add(g_oEmailAddr.GetEmailAddress);
                   end;
                end;
            except
            on oError : Exception do
               oError.free;
            end;

        end
        else
        begin
             oDialog.Free;
             oErrorDlg := TdlgDisplayMessage.Create(Self);
             with oErrorDlg do
             begin
                  DialogTitle := 'Emailmax needs setup information';
                  NoticeText := 'Information missing';
                  m_oDetailItems.Add('No remailer address information to post usenet');
                  m_oDetailItems.Add('messages through has been set up.  Please enter');
                  m_oDetailItems.Add('the setup (from the File menu) window and add');
                  m_oDetailItems.Add('entries in the Newsgroups tab');
                  Display;
                  free;
             end;
             Close;
        end;
   end;
end;

procedure TwndUsenetMsg.pbNewsGroupLookupClick(Sender: TObject);
var
   dlgNews : TdlgNewsgroup;
   sSelection : String;
begin
   dlgNews := TdlgNewsgroup.Create(Self);
   wndMaxMain.CenterFormOverSelf(dlgNews);
   if length(Trim(efTo.Text)) > 0 then
       dlgNews.txtPosts.Text := efTo.Text
   else
       dlgNews.txtPosts.Text := '<none>';
       
   sSelection := dlgNews.GetAGroup;
   dlgNews.Free;
   if Length(Trim(sSelection)) > 0 then
       if Length(Trim(efTo.Text)) > 0 then
           efTo.Text := efTo.Text + ',' + sSelection
       else
           efTo.Text := sSelection;

end;

end.
