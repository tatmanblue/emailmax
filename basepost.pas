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
unit basepost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, folder, registry, ExtCtrls, outbound, wndfolder, AdvImage, email;

type
   TPostError = (peMemoryAlloc, peToEmpty, peFromEmpty, peSubjectEmpty);
   EPostException = class(Exception)
   private
       m_nErrorType : TPostError;
   published
       property ErrorType : TPostError read m_nErrorType write m_nErrorType;
   end;

type
  TwndBasePost = class(TForm)
    ctlLeftPanel: TPanel;
    cltClientPanel: TPanel;
    ctlEditPanel: TPanel;
    Label7: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    lblSubj: TLabel;
    efDate: TEdit;
    efTo: TEdit;
    efSubj: TEdit;
    cbFrom: TComboBox;
    efMsg: TMemo;
    ctlTopPanel: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure efSubjChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure efMsgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  protected
    { Private declarations }
    m_nType : TWindowFocused;
    m_bChanged : Boolean;
    m_sSourceFileName : String;

    m_oMsg : TBaseEmail;
    
    procedure SavePostChildProc(oMsg : TBaseEmail); virtual; abstract;
    procedure SaveEmailContents(oMsg : TBaseEmail);
    
  public
    { Public declarations }
    procedure SavePost; virtual;
    procedure SaveDraft; virtual;
    function CanCloseNow: Boolean; virtual;
    procedure PrintMsg(bAllowSetupFirst : boolean); virtual;
    procedure PreviewMsg; virtual;

    function IsMessageSelected: boolean; virtual;

    // TODO..need identified for folder and post windows
    // to be derived from base class
    procedure SaveMsgAs(sFilePath : String);
    
  published
     property NotepadType : TWindowFocused read m_nType write m_nType default wfNew;

  end;

implementation

{$R *.DFM}

uses
   mdimax, displmsg, alias, eglobal, savemsg, eregistry, wndPrintPreview;


procedure TwndBasePost.FormActivate(Sender: TObject);
begin
   wndMaxMain.ChildWndReceivedFocus(m_nType);
end;

procedure TwndBasePost.FormCreate(Sender: TObject);
var
   oRegistry : TRegistry;
   nCount, nAddIndex : Integer;
   oDialog : TdlgDisplayMessage;
   bIsDefault : Boolean;
begin
   m_bChanged := FALSE;
   m_sSourceFileName := '';
   if rtfOff = g_oRegistry.Maximize then
       Self.WindowState := wsNormal
   else
       Self.WindowState := wsMaximized;

   bIsDefault := FALSE;
   nAddIndex := -1;

   for nCount := 1 to g_oEmailAddr.Count do
   begin
       g_oEmailAddr.ActiveIndex := nCount - 1;
       if g_oEmailAddr.GetUseageType = g_cnUsageSend then
       begin
           if bIsDefault = FALSE then
           begin
               nAddIndex := cbFrom.Items.Add(g_oEmailAddr.GetEmailAddress);
               bIsDefault := g_oEmailAddr.IsDefault;
           end
           else
               cbFrom.Items.Add(g_oEmailAddr.GetEmailAddress);
       end;
   end;

   // TODO 01.07.02 use post message, allow basepost to become visible,
   // then show message and close basepost
   if cbFrom.Items.Count = 0 then
   begin
       oDialog := TdlgDisplayMessage.Create(Self);
       with oDialog do
       begin
           DialogTitle := 'Emailmax needs setup information';
           NoticeText := 'Information missing';
           m_oDetailItems.Add('No email address information for sending email from');
           m_oDetailItems.Add('has been set up.  Please enter the setup (from the');
           m_oDetailItems.Add('File menu) and create entries in the Sending Mail tab.');
           Display;
           free;
       end;
       Close;
   end;

   if cbFrom.Items.Count = 1 then
       cbFrom.ItemIndex := 0;

   if bIsDefault then
   begin
       cbFrom.ItemIndex := nAddIndex;
   end;

   m_oMsg := NIL;

end;

procedure TwndBasePost.efSubjChange(Sender: TObject);
begin
   m_bChanged := TRUE;
end;

procedure TwndBasePost.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   // only query if this main application is going down.
   // the user should have already had a chance to change
   // their mind about closing emailmax in TwndMaxMain.CloseQuery
   if (TRUE = m_bChanged) and (FALSE = g_bApplicationIsShutDown) then
   begin
       if Application.MessageBox('You have unsaved work--closing now will lost that work.  Do you want to close?', 'Confirm Close', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = idNo then
       begin
           Action :=  caNone;
           exit;
       end;
   end;

   Action := caFree;
end;

function TwndBasePost.CanCloseNow: Boolean;
begin
   if m_bChanged = TRUE then
   begin
       if Application.MessageBox('You have unsaved work--closing now will lost that work.  Do you want to close?', 'Confirm Close', MB_YESNO + MB_ICONQUESTION) = idNo then
       begin
           CanCloseNow := FALSE;
           exit;
       end;
   end;

   CanCloseNow := TRUE;
end;

procedure TwndBasePost.SavePost;
var
   oMsg : TOutboundEmail;
begin
   oMsg := TOutboundEmail.Create();
   SaveEmailContents(oMsg);
   // TODO
   // oMsg.free;
end;

procedure TwndBasePost.SaveDraft;
var
   oMsg : TDraftEmail;
begin
   oMsg := TDraftEmail.Create();
   SaveEmailContents(oMsg);
   oMsg.free;
end;

procedure TwndBasePost.SaveEmailContents(oMsg : TBaseEmail);
var
   oExcept : EPostException;
   oSaveMsg : TSaveMsg;
   bCreatedFile, bCheckForErrors : Boolean;
begin

   bCreatedFile := FALSE;
   bCheckForErrors := TRUE;
   try
       if NIL = oMsg then
       begin
           oExcept := EPostException.Create('Message cannot be saved because the memory could be allocated.');
           oExcept.ErrorType := peMemoryAlloc;
           raise oExcept;
       end;

       case oMsg.MessageType of
           ecDraft: bCheckForErrors := FALSE;
       end;

       with oMsg do
       begin
           SendTo := efTo.Text;
           From := cbFrom.Text;
           Date := efDate.Text;
           Subject := efSubj.Text;
           IsValid := TRUE;
           if Length(Trim(m_sSourceFileName)) = 0 then
           begin
              GenerateFileName;
              m_sSourceFileName := oMsg.MsgTextFileName;
              bCreatedFile := TRUE;
           end;
       end;

       if (TRUE = bCheckForErrors) AND
          (0 = Length(Trim(oMsg.SendTo))) then
       begin
           oMsg.Free;
           oExcept := EPostException.Create('Message cannot be saved because the "To" selection is empty.  Please enter a recipient for this email.');
           oExcept.ErrorType := peToEmpty;
           if bCreatedFile = TRUE then
               m_sSourceFileName := '';

           raise oExcept;
       end;

       if (TRUE = bCheckForErrors) AND
          (0 = Length(Trim(oMsg.From))) then
       begin
           oMsg.Free;
           oExcept := EPostException.Create('Message cannot be saved because the "From" selection is not valid.  Please select who this message is from.');
           oExcept.ErrorType := peFromEmpty;
           if bCreatedFile = TRUE then
               m_sSourceFileName := '';
           raise oExcept;
       end;

       if (TRUE = bCheckForErrors) AND
          (0 = Length(Trim(oMsg.Subject))) then
           oMsg.Subject := 'Msg From: ' + oMsg.From;

       // give any derived classes a chance to update the message
       // object too
       SavePostChildProc(oMsg);

       oSaveMsg := TSaveMsg(efMsg.Lines);
       oSaveMsg.SaveToFile(m_sSourceFileName);
       if bCreatedFile = TRUE then
           g_oFolders[g_cnToSendFolder].AddMsg(oMsg.OutputHeaderAsString);

       oMsg.Free;
       m_bChanged := FALSE;
       Close;
   except
       on oMsgError : EPostException do
       begin
           case oMsgError.ErrorType of
               peToEmpty: efTo.SetFocus;
               peFromEmpty: cbFrom.SetFocus;
           end;
           Application.MessageBox(PChar(oMsgError.Message), 'Save Error', MB_ICONINFORMATION);
       end;
   end;
end;

procedure TwndBasePost.efMsgKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_TAB) and
      (Shift = [ssShift]) then
   begin
      Key := 0;
      efSubj.SetFocus;
   end;

   if (Key <> VK_TAB) then
       m_bChanged := TRUE;
end;

procedure TwndBasePost.PrintMsg(bAllowSetupFirst : boolean);
begin
   if Not Assigned(m_oMsg) then
       raise Exception.Create('Attempting printing with invalid information saved.');

   if FALSE = m_oMsg.IsValid then
       raise Exception.Create('The message cannot be printed until it is saved.');

   if NOT Assigned(wndPrintOrPreview) then
       wndPrintOrPreview := TwndPrintOrPreview.Create(wndMaxMain);

   with wndPrintOrPreview do
   begin
       Reset;
       FolderId := m_oMsg.FolderId;
       MessageIndex := g_oFolders[m_oMsg.FolderId].FindMessage(m_oMsg.MessageId);
       Print(bAllowSetupFirst);
   end;

end;

procedure TwndBasePost.PreviewMsg;
begin
   if Not Assigned(m_oMsg) then
       raise Exception.Create('Attempting previewing with invalid information saved.');

   if FALSE = m_oMsg.IsValid then
       raise Exception.Create('The message cannot be previewed until it is saved.');

   if NOT Assigned(wndPrintOrPreview) then
       wndPrintOrPreview := TwndPrintOrPreview.Create(wndMaxMain);

   with wndPrintOrPreview do
   begin
       Reset;
       FolderId := m_oMsg.FolderId;
       MessageIndex := g_oFolders[m_oMsg.FolderId].FindMessage(m_oMsg.MessageId);
       Preview;
   end;

end;

function TwndBasePost.IsMessageSelected: boolean;
begin
   if Not Assigned(m_oMsg) then
       IsMessageSelected := FALSE
   else
       IsMessageSelected := TRUE;
end;

procedure TwndBasePost.SaveMsgAs(sFilePath : String);
var
   dlgMsg : TdlgDisplayMessage;
begin
   if Not Assigned(m_oMsg) then
   begin
       dlgMsg := TdlgDisplayMessage.Create(Self);
       with dlgMsg do
       begin
           MessageType := dmtWarn;
           NoticeText := 'Internal Programming Error.';
           m_oDetailItems.Add('You have attempted to save a message to a text file but the program has not assigned an internal message structure to complete operation.  This is a bug.');
           m_oDetailItems.Add('');
           m_oDetailItems.Add('Please report this bug to microObjects.');

           DialogTitle := 'Internal Programming Error (basepost).';
           Display;
           free;
       end;

       exit;
   end;

   m_oMsg.SaveAs(sFilePath);
end;

procedure TwndBasePost.FormDestroy(Sender: TObject);
begin
   if Assigned(m_oMsg) then
       m_oMsg.Free();
   wndMaxMain.ChildWndLostFocus(m_nType);
end;

procedure TwndBasePost.FormDeactivate(Sender: TObject);
begin

   wndMaxMain.ChildWndLostFocus(m_nType);
end;

end.
