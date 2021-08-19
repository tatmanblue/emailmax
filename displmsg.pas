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
//
//
//
//

unit displmsg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TDisplayMsgType = (dmtInfo, dmtError, dmtQuestion, dmtWarn, dmtShutdown);
  TdlgDisplayMessage = class(TForm)
    pbClose: TButton;
    txtNotice: TLabel;
    txtDetails: TMemo;
    ctlInfo: TImage;
    ctlWarn: TImage;
    ctlError: TImage;
    ctlQuestion: TImage;
    procedure pbCloseClick(Sender: TObject);
  private
    { Private declarations }
    m_sNoticeText, m_sDialogTitle : String;
    m_nMessageType : TDisplayMsgType;

  public
    { Public declarations }
    m_oDetailItems : TStringList;

    constructor Create(AOwner: TComponent); override;
    procedure Display;
    procedure Setup; virtual;

  published
    property MessageType : TDisplayMsgType read m_nMessageType write m_nMessageType default dmtInfo;
    property DialogTitle : String read m_sDialogTitle write m_sDialogTitle;
    property NoticeText : String read m_sNoticeText write m_sNoticeText;
  end;

implementation

uses
   mdimax, eglobal;

{$R *.DFM}

constructor TdlgDisplayMessage.Create(AOwner: TComponent);
begin
   inherited;
   m_oDetailItems := TStringList.Create;
   m_nMessageType := dmtInfo;
   m_sNoticeText := 'Not setup';
   m_sDialogTitle := 'Not setup';
end;

procedure TdlgDisplayMessage.Display;
begin
   Setup;
   ShowModal;
end;

procedure TdlgDisplayMessage.pbCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TdlgDisplayMessage.Setup;
begin
   Caption := m_sDialogTitle;
   ctlInfo.Visible := FALSE;
   ctlQuestion.Visible := FALSE;
   ctlError.Visible := FALSE;
   ctlWarn.Visible := FALSE;

   case m_nMessageType of
       dmtInfo: ctlInfo.Visible := TRUE;
       dmtError: ctlError.Visible := TRUE;
       dmtQuestion: ctlQuestion.Visible := TRUE;
       dmtWarn: ctlWarn.Visible := TRUE;
       // dmtShutdown
       else ctlInfo.Visible := TRUE;
   end;

   txtDetails.Lines := m_oDetailItems;
   txtNotice.Caption := m_sNoticeText;
   wndMaxMain.CenterFormOverSelf(Self);

end;




end.
