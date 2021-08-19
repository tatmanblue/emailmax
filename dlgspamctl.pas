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

unit dlgspamctl;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, basesetuptab;

type
  TdlgSpamControl = class(TdlgBaseSetupTab)
    lvFilters: TListView;
    Label1: TLabel;
    cbAction: TComboBox;
    Label3: TLabel;
    cbFilterType: TComboBox;
    ckIgnoreCase: TCheckBox;
    Label4: TLabel;
    efFilterText: TEdit;
    pbSave: TButton;
    pbReset: TButton;
    pbDelete: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    cbAccounts: TComboBox;
    procedure pbSaveClick(Sender: TObject);
    procedure pbResetClick(Sender: TObject);
    procedure lvFiltersClick(Sender: TObject);
    procedure efFilterTextChange(Sender: TObject);
    procedure pbDeleteClick(Sender: TObject);
  private
    { Private declarations }
    m_nDefaultAccount : Integer;
  public
    { Public declarations }

    procedure Load; reintroduce; override;
    procedure Save; reintroduce; override;
  end;

var
  dlgSpamControl: TdlgSpamControl;

implementation

{$R *.DFM}
uses
    mdimax, displmsg, alias, eglobal, dispyn, filterobject, helpengine;

procedure TdlgSpamControl.pbSaveClick(Sender: TObject);
var
    oItem : TListItem;
    dlgConfirm : TdlgDisplayYesNo;
    results : Integer;
begin
   {Action, Account, Type, Case, Text}
   results := mrYes;

   if 0 = Length(Trim(efFilterText.Text)) then
   begin
       dlgConfirm := TdlgDisplayYesNo.Create(Self);
       CenterFormOverParent(Self, dlgConfirm);

       with dlgConfirm do
       begin
           DialogTitle := 'Confirm Save of Rule';
           NoticeText := 'Please confirm...';
           m_oDetailItems.Add('You have selected to save a rule (or filter) that ');
           m_oDetailItems.Add('has no Rule Text.  This means the rule will apply');
           m_oDetailItems.Add('to all email sent to ' + cbAccounts.Items[cbAccounts.ItemIndex] + '.');
           m_oDetailItems.Add('Do you wish to save this rule?');

           YesOptionText := 'Go ahead and save Filter.';
           NoOptionText := 'Do not save Filter. I changed my mind.';
           results := DisplayModal;
           free;
       end;
   end;

   if mrNo = results then
       exit;


    oItem := lvFilters.Items.add();
    with oItem do
    begin
        if cbAction.Items[cbAction.ItemIndex] = 'Ignore' then
           Caption := 'ignore'
        else if cbAction.Items[cbAction.ItemIndex] = 'Move to Trash Folder' then
           Caption := 'trash'
        else if cbAction.Items[cbAction.ItemIndex] = 'Delete from Server' then
           Caption := 'delete';

        if g_csAllAccountsDesc = cbAccounts.Items[cbAccounts.ItemIndex] then
           SubItems.Add(g_csAllAccounts)
        else
           SubItems.Add(cbAccounts.Items[cbAccounts.ItemIndex]);

        SubItems.add(cbFilterType.Items[cbFilterType.ItemIndex]);
        if ckIgnoreCase.Checked = TRUE then
            SubItems.add('N')
        else
            SubItems.add('Y');
            
        SubItems.add(efFilterText.Text);
    end;

end;

procedure TdlgSpamControl.pbResetClick(Sender: TObject);
begin
    cbAction.ItemIndex := 0;
    cbAccounts.ItemIndex := m_nDefaultAccount;
    cbFilterType.ItemIndex := 0;
    ckIgnoreCase.Checked := FALSE;
    efFilterText.Text := '';
end;

procedure TdlgSpamControl.lvFiltersClick(Sender: TObject);
begin
    pbDelete.Enabled := TRUE;
end;

procedure TdlgSpamControl.efFilterTextChange(Sender: TObject);
begin
    pbSave.Enabled := TRUE;
end;

procedure TdlgSpamControl.pbDeleteClick(Sender: TObject);
var
   oItem : TListItem;
   dlgConfirm : TdlgDisplayYesNo;
   results : Integer;
begin

   results := mrNo;

   if NIL = lvFilters.ItemFocused then
       exit;

   oItem := lvFilters.ItemFocused;
   dlgConfirm := TdlgDisplayYesNo.Create(Self);
   CenterFormOverParent(Self, dlgConfirm);
   with dlgConfirm do
   begin
       DialogTitle := 'Confirm Delete';
       NoticeText := 'Please confirm...';
       m_oDetailItems.Add('Confirm action to delete filter:');
       m_oDetailItems.Add('Action:' + oItem.Caption);
       m_oDetailItems.Add('on Account:' + oItem.SubItems[0]);

       YesOptionText := 'Go ahead and delete Filter.';
       NoOptionText := 'Do not delete Filter. I changed my mind.';
       results := DisplayModal;
       free;
   end;

   if results = mrYes then
       lvFilters.Items.Delete(oItem.Index);

end;

procedure TdlgSpamControl.Save;
var
   oItem : TListItem;
   oFilter : TFilterItem;
   itemCount : Integer;
begin
   if Not Assigned(g_oEmailFilters) then
       raise Exception.Create('g_oEmailFilters not assigned in TdlgSpamControl.Save.');

   g_oEmailFilters.Clear;
   oFilter := TFilterItem.Create;

   if Not Assigned(oFilter) then
       raise Exception.Create('oFilter not assigned in TdlgSpamControl.Save.');


   for itemCount := 0 to (lvFilters.Items.Count - 1) do
   begin
       oItem := lvFilters.Items[itemCount];

       oFilter.SetActionTypeFromText(oItem.Caption);
       oFilter.Account := oItem.SubItems[0];
       oFilter.SetFilterTypeFromText(oItem.SubItems[1]);
       if UpperCase(Trim(oItem.SubItems[2])) = 'N' then
           oFilter.IgnoreCase := false
       else
           oFilter.IgnoreCase := true;
       oFilter.FilterText := oItem.SubItems[3];

       g_oEmailFilters.AddFromFilterObject(oFilter);
   end;

   g_oEmailFilters.SaveToFile(g_oDirectories.ProgramDataPath + 'filters.txt');

end;

procedure TdlgSpamControl.Load;
var
    bIsDefault : Boolean;
    nCount, nAddIndex : Integer;
    oDialog : TdlgDisplayMessage;
    oItem : TListItem;
    oFilter : TFilterItem;
    itemCount : Integer;
begin
   // load all the current filters
   // load all of the receiving accounts
   HelpId := KEY_SPAMINATOR;

   bIsDefault := FALSE;
   nAddIndex := -1;

   cbAccounts.Items.Add(g_csAllAccountsDesc);
   
   for nCount := 1 to g_oEmailAddr.Count do
   begin
       g_oEmailAddr.ActiveIndex := nCount - 1;
       if g_oEmailAddr.GetUseageType = g_cnUsageRecv then
       begin
           if bIsDefault = FALSE then
           begin
               bIsDefault := g_oEmailAddr.IsDefault;
               nAddIndex := cbAccounts.Items.Add(g_oEmailAddr.GetEmailAddress);
           end
           else
               cbAccounts.Items.Add(g_oEmailAddr.GetEmailAddress);
       end;
   end;

   if cbAccounts.Items.Count = 0 then
   begin
       oDialog := TdlgDisplayMessage.Create(Self);
       with oDialog do
       begin
           DialogTitle := 'Emailmax needs setup information';
           NoticeText := 'Information missing';
           m_oDetailItems.Add('No email address information for receiving email');
           m_oDetailItems.Add('has been set up.  This information is needed');
           m_oDetailItems.Add('before spaminator rules can be created.');
           Display;
           free;
       end;
       Close;
   end;

   if cbAccounts.Items.Count = 1 then
       cbAccounts.ItemIndex := 0;

   pbResetClick(Self);
   if bIsDefault then
   begin
       cbAccounts.ItemIndex := nAddIndex;
   end;
   m_nDefaultAccount := nAddIndex;


   for itemCount := 0 to (g_oEmailFilters.Count - 1) do
   begin
       g_oEmailFilters.ActiveIndex := itemCount;
       oFilter := g_oEmailFilters.SelectedItem;

       oItem := lvFilters.Items.Add();

       oItem.Caption := oFilter.GetActionTypeAsText();
       oItem.SubItems.Add(oFilter.Account);
       oItem.SubItems.Add(oFilter.GetFilterTypeAsText());
       if oFilter.IgnoreCase = true then
           oItem.SubItems.Add('Y')
       else
           oItem.SubItems.Add('N');

       oItem.SubItems.Add(oFilter.FilterText);
   end;


end;

end.
