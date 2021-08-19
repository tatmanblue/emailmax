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

unit news;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, eglobal;

type
  TNewsWndState = (nsSelector, nsEditor);
  TdlgNewsgroup = class(TForm)
    lbGroups: TListBox;
    ctlLoadNotice: TPanel;
    ctlBottom: TPanel;
    pbAdd: TButton;
    pbDelete: TButton;
    pbOK: TButton;
    pbCancel: TButton;
    ctlTop: TPanel;
    txtPostMsg: TLabel;
    txtPosts: TEdit;
    Label1: TLabel;
    efFind: TEdit;
    pbFind: TButton;
    pbNext: TButton;
    procedure OnNewsDestroy(Sender: TObject);
    procedure onFindNext(Sender: TObject);
    procedure OnOK(Sender: TObject);
    procedure OnCancel(Sender: TObject);
    procedure OnFind(Sender: TObject);
    procedure pbDeleteClick(Sender: TObject);
    procedure pbAddClick(Sender: TObject);
    procedure efFindChange(Sender: TObject);
    procedure lbGroupsClick(Sender: TObject);
    procedure lbGroupsDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_sSelection : String;
    m_bChanged, m_bFirstSearch : Boolean;
    m_nWndState : TNewsWndState;

  protected


    procedure HandlePostCreation(var Msg: TMessage); Message WM_HANDLE_WNDPOSTCREATION;

  public
    { Public declarations }
    function GetAGroup: String;
    procedure SearchForText(nStartRow : Integer);
  published
    property NewsWndState : TNewsWndState read m_nWndState write m_nWndState default nsSelector;
  end;

implementation

uses
   displmsg, addnews;

{$R *.DFM}


procedure TdlgNewsgroup.HandlePostCreation(var Msg: TMessage);
var
   dlgLoad : TdlgDisplayMessage;
begin

// TODO 08.11.02 another bug in delphi...a range check error
// gets thrown on the this constant defined by delphi.
//   Screen.Cursor := Screen.Cursors[crHourGlass];
//   EmailmaxWaitCursor();

   m_bChanged := FALSE;
   m_bFirstSearch := FALSE;
   lbGroups.Visible := FALSE;
   ctlLoadNotice.Visible := TRUE;

   if nsEditor = m_nWndState then
   begin
       txtPosts.Visible := FALSE;
       txtPostMsg.Caption := 'Use this screen to add, edit and delete usenet groups from the list below.';
       txtPosts.Text := '<none>';
       Caption := 'Editing Newsgroups';
       pbOK.Visible := FALSE;
       pbCancel.Caption := '&Close';
   end;

   Self.Refresh;
   Sleep(0);

   try
       lbGroups.Items.LoadFromFile(g_oDirectories.ProgramDataPath + 'newsgroups.txt');
       lbGroups.ItemIndex := -1;
   except
       dlgLoad := TdlgDisplayMessage.Create(Self);
       with dlgLoad do
       begin
           MessageType := dmtWarn;
           DialogTitle := 'Load Newsgroups Error';
           NoticeText := 'Unable to find file.';
           m_oDetailItems.Add(g_csApplicationTitle + ' was unable to find "newsgroups.txt"');
           m_oDetailItems.Add('which is used to load the newsgroups for this list.');
           Display;
           Free;
       end;
   end;

   lbGroups.Visible := TRUE;
   ctlLoadNotice.Visible := FALSE;

//   Screen.Cursor := Screen.Cursors[crDefault];
//   EmailmaxDefaultCursor();
end;

procedure TdlgNewsgroup.OnNewsDestroy(Sender: TObject);
begin
   if m_bChanged = TRUE then
       lbGroups.Items.SaveToFile(g_oDirectories.ProgramDataPath +  'newsgroups.txt');
end;

function TdlgNewsgroup.GetAGroup: String;
begin
   ShowModal;
   GetAGroup := m_sSelection;
end;

procedure TdlgNewsgroup.SearchForText(nStartRow : Integer);
var
   nCounter : Integer;
   sStr : String;
begin
{
}
   try
       sStr := efFind.Text;
       for nCounter := nStartRow to lbGroups.Items.Count do
       begin
           if Pos(sStr, lbGroups.Items[nCounter]) > 0 then
           begin
               lbGroups.ItemIndex := nCounter;
               exit;
           end;
       end;
       if lbGroups.ItemIndex = -1 then
           if m_bFirstSearch then
               MessageDlg('No matches found.', mtInformation, [mbOK], 0)
           else
               MessageDlg('No more matches found.', mtInformation, [mbOK], 0);
   except
        if m_bFirstSearch then
           MessageDlg('No matches found.', mtInformation, [mbOK], 0)
        else
           MessageDlg('No more matches found.', mtInformation, [mbOK], 0);
   end;
end;

procedure TdlgNewsgroup.OnFind(Sender: TObject);
begin
   lbGroups.ItemIndex := -1;
   m_bFirstSearch := TRUE;
   SearchForText(0);
   pbNext.Enabled := TRUE;
   pbFind.Default := FALSE;
   pbNext.Default := TRUE;
   
end;

procedure TdlgNewsgroup.onFindNext(Sender: TObject);
begin
   m_bFirstSearch := FALSE;
   SearchForText(lbGroups.ItemIndex + 1);
end;

procedure TdlgNewsgroup.OnOK(Sender: TObject);
begin
{
}
   if lbGroups.ItemIndex > -1 then
   begin
       m_sSelection := lbGroups.Items.Strings[lbGroups.ItemIndex];
       Close;
   end;
end;

procedure TdlgNewsgroup.OnCancel(Sender: TObject);
begin
   m_sSelection := '';
   Close;
end;

procedure TdlgNewsgroup.pbDeleteClick(Sender: TObject);
begin
   if lbGroups.ItemIndex > -1 then
   begin
       if MessageDlg('Are you sure you want to delete "' + lbGroups.Items[lbGroups.ItemIndex] + '" ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       begin
           lbGroups.Items.Delete(lbGroups.ItemIndex);
           m_bChanged := TRUE;
       end;
   end
   else
       MessageDlg('Please select a newsgroup to delete.', mtInformation, [mbOK], 0);

   lbGroups.SetFocus;

end;


procedure TdlgNewsgroup.pbAddClick(Sender: TObject);
var
   dlgAdd : TdlgAddNewsGroup;
begin
   dlgAdd := TdlgAddNewsGroup.Create(Self);
   with dlgAdd do
   begin
       if ShowModal = mrOK then
       begin
           lbGroups.Items.Add(dlgAdd.efNewsGroup.Text);
           m_bChanged := TRUE;
       end;

       free;
   end;

   lbGroups.SetFocus;
end;

procedure TdlgNewsgroup.efFindChange(Sender: TObject);
begin
   if length(Trim(efFind.Text)) = 0 then
   begin
       pbFind.Enabled := FALSE;
       pbNext.Enabled := FALSE;
       pbFind.Default := FALSE;
       pbOK.Default := TRUE;
   end
   else
   begin
       pbFind.Enabled := TRUE;
       pbFind.Default := TRUE;
       pbOK.Default := FALSE;
   end;
end;

procedure TdlgNewsgroup.lbGroupsClick(Sender: TObject);
begin
     if lbGroups.ItemIndex > -1 then
     begin
        pbOK.Enabled := TRUE;
        pbDelete.Enabled := TRUE;
     end
     else
     begin
        pbOK.Enabled := FALSE;
        pbDelete.Enabled := FALSE;
     end;
end;

procedure TdlgNewsgroup.lbGroupsDblClick(Sender: TObject);
begin
//
     if lbGroups.ItemIndex > -1 then
     begin
        pbOK.Enabled := TRUE;
        pbDelete.Enabled := TRUE;
        OnOK(Sender);
     end
     else
     begin
        pbOK.Enabled := FALSE;
        pbDelete.Enabled := FALSE;
     end;

end;

procedure TdlgNewsgroup.FormCreate(Sender: TObject);
begin
   PostMessage(Self.Handle, WM_HANDLE_WNDPOSTCREATION, 0, 0);
end;

end.
