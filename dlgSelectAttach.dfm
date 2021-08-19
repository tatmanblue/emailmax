object dlgSelectAttachments: TdlgSelectAttachments
  Left = 237
  Top = 131
  BorderStyle = bsDialog
  Caption = 'Select Attachments'
  ClientHeight = 246
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 19
    Width = 57
    Height = 13
    Caption = 'Select Files:'
  end
  object pbOK: TButton
    Left = 49
    Top = 210
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = pbOKClick
  end
  object pbCancel: TButton
    Left = 132
    Top = 211
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = pbCancelClick
  end
  object lbItems: TListBox
    Left = 5
    Top = 34
    Width = 199
    Height = 167
    Hint = 'Attachments available'
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 2
  end
end
