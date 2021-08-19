object dlgAddNewsGroup: TdlgAddNewsGroup
  Left = 165
  Top = 171
  BorderStyle = bsDialog
  Caption = 'Newsgroup additions'
  ClientHeight = 105
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 10
    Width = 205
    Height = 13
    Caption = 'Add the name of thew newsgroup you want'
  end
  object pbOK: TButton
    Left = 100
    Top = 71
    Width = 75
    Height = 25
    Hint = 'Close the window, accepting your changes'
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object pbCancel: TButton
    Left = 180
    Top = 71
    Width = 75
    Height = 25
    Hint = 'Close the window, losing any changes made'
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object efNewsGroup: TEdit
    Left = 14
    Top = 30
    Width = 252
    Height = 21
    Hint = 'eg: joe@camel.com'
    TabOrder = 0
    OnChange = efNewsGroupChange
  end
end
