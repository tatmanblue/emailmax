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
unit dlgNewsgroups;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  basesetuptab, ComCtrls, StdCtrls, ExtCtrls, eglobal;

type
  TdlgNewsgroupsTab = class(TdlgBaseSetupTab)
    Label9: TLabel;
    rbNewsServer: TRadioButton;
    rbMailToNews: TRadioButton;
    Panel3: TPanel;
    Label10: TLabel;
    pbAddRemailer: TButton;
    pbRemoveRemailer: TButton;
    ctlRemailer: TListView;
    cmdEditNews: TButton;
    procedure pbRemoveRemailerClick(Sender: TObject);
    procedure pbAddRemailerClick(Sender: TObject);
    procedure ctlRemailerDblClick(Sender: TObject);
    procedure cmdEditNewsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Load; reintroduce; override;
    procedure Save; reintroduce; override;

  end;


implementation

{$R *.DFM}
uses
   alias, addreml, eregistry, news;

procedure TdlgNewsgroupsTab.Load;
var
   nCount, nIndex, nUsage : Integer;
   oItem : TListItem;
   oAlias : TEmailAddress;
begin

   if Not Assigned(g_oEmailAddr) then
       raise Exception.Create('g_oEmailAddr not assigned in TdlgNewsgroupsTab.Load.');

   oAlias := TEmailAddress.Create();
   if Not Assigned(oAlias) then
       raise Exception.Create('oAlias not assigned in TdlgNewsgroupsTab.Load.');

   try
       ctlRemailer.Items.Clear;

       for nCount := 1 to g_oEmailAddr.Count do
       begin
           g_oEmailAddr.GetEmailObject(nCount - 1, oAlias);
           if Not Assigned(oAlias) then
               raise Exception.Create('oAlias not assigned in TdlgNewsgroupsTab.Load.');

           nUsage := oAlias.UsageType;

           case nUsage of
               g_cnUsageSend: continue;
               g_cnUsageRecv: continue;
               g_cnUsageUsenet: oItem := ctlRemailer.Items.Add;
               else
               begin
                   oItem := NIL;
                   raise Exception.Create('System.txt may be corrupt.  Aborting load of email address information.');
               end;
           end;
           if Assigned(oItem) then
           begin
              with oItem do
              begin
                  Caption := oAlias.Address;
                  SubItems.Add(oAlias.Server);
                  nIndex := oAlias.IndexId;
                  SubItems.Add(IntToStr(nIndex));

                  if (nUsage = g_cnUsageSend) or
                     (nUsage = g_cnUsageUsenet) then
                      if oAlias.IsDefault then
                          SubItems.Add('yes')
                      else
                          SubItems.Add(' ');
              end;
           end;
       end;
   except
   end;

   if Assigned(oAlias) then
       oAlias.Free;

   if ctlRemailer.Items.Count > 0 then
       pbRemoveRemailer.Enabled := TRUE
   else
       pbRemoveRemailer.Enabled := FALSE;

end;

procedure TdlgNewsgroupsTab.Save;
begin
   if Not Assigned(g_oRegistry) then
       raise Exception.Create('g_oRegistry not assigned in TdlgNewsgroupsTab.Save;.');

   if TRUE = rbNewsServer.Checked then
      g_oRegistry.PostNewsViaNewsServer := rtfOn
   else
      g_oRegistry.PostNewsViaNewsServer := rtfOff;

end;

procedure TdlgNewsgroupsTab.pbRemoveRemailerClick(Sender: TObject);
var
   nIndex : Integer;
   oItem : TListItem;
begin
   if NIL = ctlRemailer.ItemFocused then
   begin
       MessageDlg('You need to select an address from the Remailer List.', mtInformation, [mbOK], 0);
       Exit;
   end;

   oItem := ctlRemailer.ItemFocused;

   if mrNo = MessageDlg('Are you sure you want to delete "' + oItem.Caption + '"?', mtConfirmation	, [mbYes, mbNo], 0) then
       Exit;

   nIndex := StrToInt(oItem.SubItems[1]);
   g_oEmailAddr.Delete(nIndex);
   nIndex := oItem.Index;
   ctlRemailer.Items.Delete(nIndex);

   if 0 = ctlRemailer.Items.Count then
       pbRemoveRemailer.Enabled := FALSE;

end;

procedure TdlgNewsgroupsTab.pbAddRemailerClick(Sender: TObject);
var
   oItem : TListItem;
   dlgAddRemailer : TdlgAddRemailer;
   nIndex : Integer;
begin

   // TODO: 08.11.02 use Email Objects
   dlgAddRemailer := TdlgAddRemailer.Create(Self);
   CenterFormOverParent(Application.MainForm, dlgAddRemailer);

   with dlgAddRemailer do
   begin
       if ctlRemailer.Items.Count = 0 then
           ckDefault.Checked := TRUE;

       if ShowModal = mrOK then
       begin
           if ckDefault.Checked then
               g_oEmailAddr.ResetAllDefaults(g_cnUsageUsenet);

           oItem := ctlRemailer.Items.Add;
           oItem.Caption := dlgAddRemailer.efSendAddress.Text;
           oItem.SubItems.Add(dlgAddRemailer.efSendServer.Text);
           nIndex := g_oEmailAddr.AddEmailAddr(dlgAddRemailer.efSendAddress.Text, dlgAddRemailer.efSendServer.Text, '<NA>', '<NA>', g_cnServerSMTP, g_cnUsageUsenet, TRUE, ckDefault.Checked, FALSE);
           oItem.SubItems.Add(IntToStr(nIndex));
           if ckDefault.Checked then
               oItem.SubItems.Add('Yes')
           else
               oItem.SubItems.Add(' ');

           pbRemoveRemailer.Enabled := TRUE;
       end;
       free;
   end;

   ctlRemailer.SetFocus;
end;

procedure TdlgNewsgroupsTab.ctlRemailerDblClick(Sender: TObject);
begin
   if ctlRemailer.Items.Count > 0 then
       pbRemoveRemailerClick(Sender)
   else
       pbAddRemailerClick(Sender);
end;

procedure TdlgNewsgroupsTab.cmdEditNewsClick(Sender: TObject);
var
   dlgNews : TdlgNewsgroup;
   sSelection : String;
begin
   dlgNews := TdlgNewsgroup.Create(Self);

   if Not Assigned(dlgNews) then
       raise Exception.Create('dlgNews not assigned in TdlgNewsgroupsTab.cmdEditNewsClick.');

   CenterFormOverParent(Application.MainForm, dlgNews);
   dlgNews.txtPosts.Text := '<none>';
   dlgNews.Caption := 'Editing Newsgroups';
   dlgNews.NewsWndState := nsEditor;       
   dlgNews.ShowModal;
   dlgNews.Free;
   
end;

end.
