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
unit wndPrintPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Qrctrls, eglobal, folder, email;

type
  TPreviewPrintError = (ppNoFolderId, ppNoMessageId, ppNotSupported, ppUnknown);
  EPrintPreviewException = class(Exception)
  private
      m_eErrorId : TPreviewPrintError;
  public
      constructor Create(sError : String; eErrorId : TPreviewPrintError);
  published
      property ErrorId : TPreviewPrintError read m_eErrorId write m_eErrorId default ppUnknown;
  end;

type
  TwndPrintOrPreview = class(TForm)
    ctlQuickReport: TQuickRep;
    ctlDetail: TQRBand;
    ctlPage: TQRBand;
    ctlPageHeader: TQRBand;
    ctlTitle: TQRBand;
    efPageHeader: TQRLabel;
    efTitle: TQRLabel;
    efBody: TQRLabel;
    QRLabel1: TQRLabel;
    QRSysData1: TQRSysData;
    ctlTitleSep: TShape;
    procedure efBodyPrint(sender: TObject; var Value: String);
    procedure efTitlePrint(sender: TObject; var Value: String);
    procedure efPageHeaderPrint(sender: TObject; var Value: String);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_nFolderId,
    m_nMsgIndex : Integer;

    m_sMsgId : String;

    // TODO 082001...use this instead of m_nFolderId, m_nMsgIndex;
    m_oEmail : TBaseEmail;

  public

    { Public declarations }
    procedure Preview; overload; virtual;
    procedure Preview(nFolderId, nMsgId : Integer); overload;
    procedure Preview(nFolderId : Integer; sMsgId : String); overload;
    procedure Print(bAndIncludeSetup : boolean); overload; virtual;
    procedure Print(bAndIncludeSetup : boolean; nFolderId, nMsgId : Integer); overload;
    procedure Print(bAndIncludeSetup : boolean; nFolderId : Integer; sMsgId : String); overload;
    procedure Setup;

    procedure Reset;
  published
    property FolderId : Integer read m_nFolderId write m_nFolderId DEFAULT -1;
    property MessageId : String read m_sMsgId write m_sMsgId;
    property MessageIndex : Integer read m_nMsgIndex write m_nMsgIndex DEFAULT -1;
  end;

var
  wndPrintOrPreview: TwndPrintOrPreview;

implementation


{$R *.DFM}

uses
   helpengine;
   
{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
constructor EPrintPreviewException.Create(sError : String; eErrorId : TPreviewPrintError);
begin
   inherited Create(sError);
   m_eErrorId := eErrorId;
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Setup;
begin
   ctlQuickReport.PrinterSetup;
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Print(bAndIncludeSetup : boolean);
begin
   self.Hide;

   if ('' = m_sMsgId) AND
      (-1 = m_nMsgIndex) then
   begin
       raise EPrintPreviewException.Create('Missing Message Id Parameter', ppNoMessageId);
   end;

   if (-1 = m_nFolderId) then
   begin
       raise EPrintPreviewException.Create('Missing Folder Id Parameter', ppNoFolderId);
   end;

   if '' <> m_sMsgId then
   begin
       // TODO...this is temporary
       raise EPrintPreviewException.Create('Message Time stamp Id not supported', ppNotSupported);
   end;

   if true = bAndIncludeSetup then
       Setup;

   ctlQuickReport.Print;
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Print(bAndIncludeSetup : boolean; nFolderId : Integer; sMsgId : String);
begin
   Reset;
   m_nFolderId := nFolderId;
   m_sMsgId := sMsgId;
   Print(bAndIncludeSetup);
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Print(bAndIncludeSetup : boolean; nFolderId, nMsgId : Integer);
begin
   Reset;
   m_nFolderId := nFolderId;
   m_nMsgIndex := nMsgId;
   Print(bAndIncludeSetup);
end;


{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Preview;
begin
   self.Hide;

   if ('' = m_sMsgId) AND
      (-1 = m_nMsgIndex) then
   begin
       raise EPrintPreviewException.Create('Missing Message Id Parameter', ppNoMessageId);
   end;

   if (-1 = m_nFolderId) then
   begin
       raise EPrintPreviewException.Create('Missing Folder Id Parameter', ppNoFolderId);
   end;

   if '' <> m_sMsgId then
   begin
       // TODO...this is temporary
       raise EPrintPreviewException.Create('Message Time stamp Id not supported', ppNotSupported);
   end;

   g_oFolders[m_nFolderId].ActiveIndex := m_nMsgIndex;
   Self.Caption := 'Previewing message "' + Trim(g_oFolders[m_nFolderId].GetSubject) + '"';

   ctlQuickReport.ReportTitle := Self.Caption; 
   ctlQuickReport.Preview;
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Preview(nFolderId : Integer; sMsgId : String);
begin
   Reset;
   m_nFolderId := nFolderId;
   m_sMsgId := sMsgId;
   Preview;
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Preview(nFolderId, nMsgId : Integer);
begin
   Reset;
   m_nFolderId := nFolderId;
   m_nMsgIndex := nMsgId;
   Preview;
end;

{ ------------------------------------------------------------------------------------

------------------------------------------------------------------------------------}
procedure TwndPrintOrPreview.Reset;
begin
   m_sMsgId := '';
   m_nMsgIndex := -1;
   m_nFolderId := -1;
end;

procedure TwndPrintOrPreview.efBodyPrint(sender: TObject;
  var Value: String);
var
   oStrings : TStringList;
   sFileName : String;
begin
//
   g_oFolders[m_nFolderId].ActiveIndex := m_nMsgIndex;
   oStrings := TStringList.Create;
   sFileName := g_oDirectories.ProgramDataPath + g_oFolders[m_nFolderId].GetFileName;
   oStrings.LoadFromFile(g_oFolders[m_nFolderId].GetFileName);
   Value := oStrings.Text;
   oStrings.Free;
end;

procedure TwndPrintOrPreview.efTitlePrint(sender: TObject;
  var Value: String);
begin
//
   g_oFolders[m_nFolderId].ActiveIndex := m_nMsgIndex;

   Value := 'To: ' +  g_oFolders[m_nFolderId].GetAccount + g_csCRLF;
   if 0 < Length(Trim(g_oFolders[m_nFolderId].GetCC)) then
       Value := Value + 'CC: ' + g_oFolders[m_nFolderId].GetCC  + g_csCRLF;

   Value := Value + 'Date: ' + g_oFolders[m_nFolderId].GetDate + g_csCRLF
          + 'Subject: ' + g_oFolders[m_nFolderId].GetSubject;

end;

procedure TwndPrintOrPreview.efPageHeaderPrint(sender: TObject;
  var Value: String);
begin
//
   g_oFolders[m_nFolderId].ActiveIndex := m_nMsgIndex;

   Value := 'Message From: '
          +  g_oFolders[m_nFolderId].GetFrom;
end;

procedure TwndPrintOrPreview.FormCreate(Sender: TObject);
begin
   Reset;
   HelpContext := KEY_PRINTING_SETUP;
   HelpFile := g_csHelpFile;
end;

end.
