// copyright (c) 2001 by microObjects inc.
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

unit wndsock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, AdvImage, StdCtrls, Menus;

type
  TMailProperties = class(TObject)
  protected
      m_sAccount : String;
      m_nCurrent, m_nMax : Integer;

      m_dtLastAccess : TDateTime;

  published
      property AccountName : String read m_sAccount write m_sAccount;
      property CurrentItem : Integer read m_nCurrent write m_nCurrent;
      property LastDateTime : TDateTime read m_dtLastAccess write m_dtLastAccess;
      property MaxItems : Integer read m_nMax write m_nMax;

  end;

type
  TwndWinSockActivity = class(TForm)
    ctlImagePanel: TPanel;
    ctlImage: TAdvImage;
    ctlControl: TTimer;
    ctlReceivePanel: TPanel;
    ctlSendPanel: TPanel;
    pbHide: TButton;
    mnWinSockMenu: TPopupMenu;
    mnSockUndock: TMenuItem;
    Hide1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ctlControlTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure pbHideClick(Sender: TObject);
    procedure mnSockUndockClick(Sender: TObject);
    procedure mnWinSockMenuPopup(Sender: TObject);
  private
    { Private declarations }
    m_nImageCount : Integer;
    m_bRemainVisible,
    m_bReceiving,
    m_bSending : Boolean;
    m_oSendMail : TMailProperties;
    m_oReceiveMail : TMailProperties;
    procedure SetSendMailProperties(oMail : TMailProperties);
    procedure SetReceiveMailProperties(oMail : TMailProperties);
    procedure SetSendingMail(bSending : Boolean);
    procedure SetReceivingMail(bReceiving : Boolean);

  protected

  public
    { Public declarations }
    procedure ShowSelf(bHow : Boolean);
  published
       property SendingEmail : Boolean read m_bSending write SetSendingMail default FALSE;
       property SendMailProperties : TMailProperties read m_oSendMail write SetSendMailProperties;
       property RemainVisible : boolean read m_bRemainVisible write m_bRemainVisible default FALSE;
       property ReceivingEmail : Boolean read m_bReceiving write SetReceivingMail default FALSE;
       property ReceiveMailProperties : TMailProperties read m_oReceiveMail write SetReceiveMailProperties;
  end;

var
  g_wndWinSock: TwndWinSockActivity;

implementation

{$R *.DFM}
uses
   eglobal, mdimax;

procedure TwndWinSockActivity.FormCreate(Sender: TObject);
begin
   Self.Caption := 'Send/Receive Email...';
   m_bReceiving := FALSE;
   m_bSending := FALSE;
   ctlImage.ImageName := g_oDirectories.ProgramPath + 'world16.jpg';
   m_nImageCount := 0;
   m_oSendMail := TMailProperties.Create;
   m_oReceiveMail := TMailProperties.Create;

end;

// CHG 1.11.02
procedure TwndWinSockActivity.FormDestroy(Sender: TObject);
begin
   if Assigned(m_oSendMail) then
      m_oSendMail.free;
   if Assigned(m_oReceiveMail) then
      m_oReceiveMail.free;
end;

procedure TwndWinSockActivity.ctlControlTimer(Sender: TObject);
var
  imageCountStr, imageFileName : String;
begin
   if (m_bReceiving = TRUE) or
      (m_bSending = TRUE) then
   begin
       if FALSE = m_bRemainVisible then
           exit;

       m_nImageCount := m_nImageCount + 1;
       imageCountStr := Trim(IntToStr(m_nImageCount));
       if 1 = Length(imageCountStr) then
          imageCountStr := '0' + imageCountStr;

       imageFileName := g_oDirectories.ProgramPath + 'world' + imageCountStr + '.jpg';
       if FALSE = FileExists(imageFileName) then
       begin
           m_nImageCount := 1;
           imageCountStr := Trim(IntToStr(m_nImageCount));
           if 1 = Length(imageCountStr) then
               imageCountStr := '0' + imageCountStr;
       end;
       
       ctlImage.ImageName := imageFileName;
   end
   else
   begin
       ctlControl.Enabled := FALSE;
       if Self.Visible = TRUE then
       begin
           ctlReceivePanel.Caption := '< not currently receiving mail >';
           ctlSendPanel.Caption := '< not currently sending mail >';
           if TRUE = m_bRemainVisible then
               exit;

           TwndMaxMain(Application.MainForm).mnViewShowProgressClick(Sender);
       end;
   end;
       
end;

procedure TwndWinSockActivity.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   pbHideClick(Sender);
   Action := caNone;
end;

procedure TwndWinSockActivity.ShowSelf(bHow : Boolean);
begin
   Self.Visible := bHow;
   ctlControl.Enabled := bHow;
   try
       Application.MainForm.SetFocus;
   except
       on oError : Exception do
   end;
end;

procedure TwndWinSockActivity.SetSendMailProperties(oMail : TMailProperties);
begin
   if Not Assigned(oMail) then
      raise Exception.Create('oMail not assigned in TwndWinSockActivity.SetSendMailProperties');      

   m_oSendMail := oMail;
   ctlSendPanel.Caption := 'Sending mail to <' + oMail.AccountName + '>';

   if TRUE = Self.Visible then
       if FALSE = ctlControl.Enabled then
           ctlControl.Enabled := TRUE;

end;

procedure TwndWinSockActivity.SetReceiveMailProperties(oMail : TMailProperties);
var
   sMsg : String;
begin
   if Not Assigned(oMail) then
      raise Exception.Create('oMail not assigned in TwndWinSockActivity.SetReceiveMailProperties');      

   m_oReceiveMail := oMail;
   sMsg := 'Checking mail for <'  + oMail.AccountName + '> ';
   if oMail.MaxItems > 0 then
   begin
       sMsg := sMsg + '(' + Trim(IntToStr(oMail.CurrentItem));
       sMsg := sMsg + ' of ' + Trim(IntToStr(oMail.MaxItems)) + ')';
   end;
   ctlReceivePanel.Caption := sMsg;

   if TRUE = Self.Visible then
       if FALSE = ctlControl.Enabled then
           ctlControl.Enabled := TRUE;

end;

procedure TwndWinSockActivity.SetSendingMail(bSending : Boolean);
begin
    m_bSending := bSending;
    if m_bSending = FALSE then
    begin
       ctlSendPanel.Caption := '< done > ';
       m_oSendMail.AccountName := '';
       m_oSendMail.CurrentItem := 0;
       m_oSendMail.MaxItems := 0;
    end;
end;

procedure TwndWinSockActivity.SetReceivingMail(bReceiving : Boolean);
begin
    m_bReceiving := bReceiving;
    if m_bReceiving = FALSE then
    begin
       ctlReceivePanel.Caption := '< last checked on ' + FormatDateTime('m/d/yy h:nn a/p', m_oReceiveMail.LastDateTime) + ' > ';
       m_oReceiveMail.AccountName := '';
       m_oReceiveMail.CurrentItem := 0;
       m_oReceiveMail.MaxItems := 0;
    end;
end;

procedure TwndWinSockActivity.pbHideClick(Sender: TObject);
begin
   TwndMaxMain(Application.MainForm).mnViewShowProgressClick(Sender);
end;

procedure TwndWinSockActivity.mnSockUndockClick(Sender: TObject);
begin
   if TRUE = Self.DockSite then
       Self.DockSite := FALSE;

   Update;
end;

procedure TwndWinSockActivity.mnWinSockMenuPopup(Sender: TObject);
begin
   mnSockUndock.Visible := Self.DockSite;
end;

end.
