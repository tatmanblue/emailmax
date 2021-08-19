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
unit dlgSelectAttach;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, registry, ExtCtrls, eglobal;

type
  TdlgSelectAttachments = class(TForm)
    pbOK: TButton;
    pbCancel: TButton;
    lbItems: TListBox;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure pbOKClick(Sender: TObject);
    procedure pbCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_nFolderId,
    m_nMsgIndex : Integer;
  public
    { Public declarations }
  published
     property Folder : Integer write m_nFolderId;
     property MsgIndex : Integer write m_nMsgIndex;
  end;


implementation

{$R *.DFM}

uses
   basfoldr, folder, email, alias, foldlist, eregistry, helpengine;


procedure TdlgSelectAttachments.FormShow(Sender: TObject);
var
   oMsg : TBaseEmail;
   nCount : Integer;
   oAttachList : TStringList;
begin
   oMsg := TBaseEmail.Create;
   if Not Assigned(oMsg) then
       raise Exception.Create('unable to create attachment choices dialog because TBaseEmail.Create failed');

   g_oFolders[m_nFolderId].ActiveIndex := m_nMsgIndex;
   g_oFolders[m_nFolderId].GetAsEmailObject(oMsg);

   oAttachList := TStringList.Create;
   if Not Assigned(oAttachList) then
       raise Exception.Create('unable to create attachment choices dialog because TStringList.Create failed');

   oAttachList.LoadFromFile(oMsg.AttachmentListFileName);
   for nCount := 0 to oAttachList.Count - 1 do
   begin
      lbItems.Items.Add(ExtractFileName(oAttachList.Strings[nCount]));
   end;

   oAttachList.Free();
   oMsg.Free();

end;

procedure TdlgSelectAttachments.pbOKClick(Sender: TObject);
begin
   ModalResult := mrOK;
end;

procedure TdlgSelectAttachments.pbCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

end.
