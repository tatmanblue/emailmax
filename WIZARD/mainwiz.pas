// copyright (c) 2002  by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.
unit mainwiz;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, global, edirectory, PBPathList;

type
  TdlgWizard = class(TForm)
    ctlPane: TPanel;
    pbCancel: TButton;
    pbFinish: TButton;
    pbNext: TButton;
    pbPrev: TButton;
    ctlPane1: TImage;
    ctlPane2: TImage;
    ctlPane3: TImage;
    ctlPaths: TPBPathList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbPrevClick(Sender: TObject);
    procedure pbNextClick(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
    procedure pbFinishClick(Sender: TObject);
  protected
    m_nActiveWindow : Integer;
  private
    { Private declarations }
    procedure ResetToFirstForm;
    function SaveEmailInfo: Boolean;
  public
    { Public declarations }
    procedure UserWantsToCreateMore(var oMsg : TMessage); Message g_cmsgCREATE_MORE;
  end;

var
   dlgWizard: TdlgWizard;


implementation

uses
   registry, basepane, panesend, panerecv, paneconf;

{$R *.DFM}


procedure TdlgWizard.UserWantsToCreateMore(var oMsg : TMessage);
begin
   if oMsg.wParam = 0 then
       pbNext.Enabled := FALSE
   else
       pbNext.Enabled := TRUE;

end;

procedure TdlgWizard.FormCreate(Sender: TObject);
var
   nCount : Integer;
begin
   g_oSytemFile := TStringList.Create;
   if Not Assigned(g_oSytemFile) then
      raise Exception.Create('g_oSystemFile is not assigned in TdlgWizard.FormCreate');

   g_oDirectories := TDirectoryControl.Create(ctlPaths);
   g_oPath := g_oDirectories.ProgramDataPath;
   try
       g_oSytemFile.LoadFromFile(g_oPath + 'system.txt');
   except
       // dont care
   end;

   g_nMaxPanes := 3;
   wndPanes[0] := TwndSendEmail.Create(Self);
   wndPanes[1] := TwndReceivePane.Create(Self);
   wndPanes[2] := TwndConfirm.Create(Self);

   for nCount := 0 to g_nMaxPanes - 1 do
   begin
       wndPanes[nCount].Parent := ctlPane;
       wndPanes[nCount].Left := 1;
       wndPanes[nCount].Top := 2;
   end;

   Self.Caption := g_sApplicationTitle;

   m_nActiveWindow := g_cnFirstPane;
   wndPanes[m_nActiveWindow].Show;
   wndPanes[m_nActiveWindow].Update;

   ctlPane2.Visible := FALSE;
   ctlPane3.Visible := FALSE;
   ctlPane1.Visible := TRUE;
   ctlPane1.Update;

end;

procedure TdlgWizard.FormDestroy(Sender: TObject);
var
   nCount : Integer;
begin
   for nCount := 0 to g_nMaxPanes - 1 do
   begin
       wndPanes[nCount].Free;
   end;

   g_oDirectories.Free;
   g_oSytemFile.Free;

end;

procedure TdlgWizard.pbPrevClick(Sender: TObject);
var
   nOldPane : Integer;
begin
   if m_nActiveWindow = g_cnFirstPane then
       exit;

   pbNext.Enabled := TRUE;
   pbFinish.Enabled := FALSE;
   pbPrev.Enabled := TRUE;

   nOldPane := m_nActiveWindow;
   m_nActiveWindow := m_nActiveWindow - 1;
   wndPanes[nOldPane].Hide;
   wndPanes[nOldPane].CopyToProperties;
   wndPanes[m_nActiveWindow].UpdateFields;
   wndPanes[m_nActiveWindow].Show;
   wndPanes[m_nActiveWindow].Update;
   case m_nActiveWindow of
        0:
        begin
             ctlPane2.Visible := FALSE;
             ctlPane3.Visible := FALSE;
             ctlPane1.Visible := TRUE;
             ctlPane1.Update;
             pbPrev.Enabled := FALSE;

        end;
        1:
        begin
             ctlPane1.Visible := FALSE;
             ctlPane3.Visible := FALSE;
             ctlPane2.Visible := TRUE;
             ctlPane2.Update;
        end;
        2:
        begin
             ctlPane1.Visible := FALSE;
             ctlPane2.Visible := FALSE;
             ctlPane3.Visible := TRUE;
             ctlPane3.Update;
             pbFinish.Enabled := TRUE;
        end;
   end;
end;

procedure TdlgWizard.pbNextClick(Sender: TObject);
var
   nOldPane : Integer;
begin
   if m_nActiveWindow = (g_nMaxPanes - 1) then
   begin
       // save existing...
       // reset form to start
       try
           SaveEmailInfo;
           ResetToFirstForm;
       except
           on oException : Exception do
           begin
               MessageDlg(oException.Message + 'Try making sure the information you entered is complete and correct.', mtWarning, [mbOK], 0);
           end;
       end;
       exit;
   end;

   pbNext.Enabled := TRUE;
   pbFinish.Enabled := FALSE;
   pbPrev.Enabled := TRUE;

   nOldPane := m_nActiveWindow;
   m_nActiveWindow := m_nActiveWindow + 1;
   wndPanes[nOldPane].Hide;
   wndPanes[nOldPane].CopyToProperties;
   wndPanes[m_nActiveWindow].UpdateFields;
   wndPanes[m_nActiveWindow].Show;
   wndPanes[m_nActiveWindow].Update;
   case m_nActiveWindow of
        0:
        begin
             ctlPane2.Visible := FALSE;
             ctlPane3.Visible := FALSE;
             ctlPane1.Visible := TRUE;
             ctlPane1.Update;
             pbPrev.Enabled := FALSE;

        end;
        1:
        begin
             ctlPane1.Visible := FALSE;
             ctlPane3.Visible := FALSE;
             ctlPane2.Visible := TRUE;
             ctlPane2.Update;
        end;
        2:
        begin
             ctlPane1.Visible := FALSE;
             ctlPane2.Visible := FALSE;
             ctlPane3.Visible := TRUE;
             ctlPane3.Update;
             pbFinish.Enabled := TRUE;
        end;
   end;
end;

procedure TdlgWizard.pbCancelClick(Sender: TObject);
begin
   if g_bInitialInstall then
   begin
       MessageDlg('To use the Setup Wizard later on, select "File | Setup Wizard" from the menu in Emailmax.', mtInformation, [mbOK], 0);
   end;

   ModalResult := mrCancel;
end;

procedure TdlgWizard.pbFinishClick(Sender: TObject);
begin
   try
       SaveEmailInfo;
       ModalResult := mrOK
   except
       on oException : Exception do
       begin
           MessageDlg(oException.Message + 'Try making sure the information you entered is complete and correct.', mtWarning, [mbOK], 0);
       end;
   end;

end;

procedure TdlgWizard.ResetToFirstForm;
var
   nCount : Integer;
begin
   for nCount := 0 to g_nMaxPanes - 1 do
   begin
       wndPanes[nCount].ResetSelf;
   end;

   m_nActiveWindow := g_cnFirstPane;
   wndPanes[m_nActiveWindow].Show;
   wndPanes[m_nActiveWindow].Update;

   ctlPane2.Visible := FALSE;
   ctlPane3.Visible := FALSE;
   ctlPane1.Visible := TRUE;
   ctlPane1.Update;
   pbFinish.Enabled := FALSE;
   pbNext.Enabled := TRUE;
   pbPrev.Enabled := FALSE;

end;

function TdlgWizard.SaveEmailInfo: Boolean;
var
   nCount : Integer;
   sOutput : String;
begin
   SaveEmailInfo := FALSE;
   for nCount := 0 to g_nMaxPanes - 1 do
   begin
       wndPanes[nCount].Validate;
       sOutput := wndPanes[nCount].GetEmailString;
       if Length(Trim(sOutput)) > 0 then
           g_oSytemFile.Add(sOutput);
   end;
   if g_oSytemFile.Count > 0 then
       g_oSytemFile.SaveToFile(g_oPath + 'system.txt');

   SaveEmailInfo := TRUE;
end;

end.
