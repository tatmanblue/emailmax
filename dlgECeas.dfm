object dlgEncryptCeaser: TdlgEncryptCeaser
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Ceaser Encryption'
  ClientHeight = 142
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object txtNote: TLabel
    Left = 10
    Top = 11
    Width = 253
    Height = 17
    AutoSize = False
    Caption = 'Pick the key character to begin the encryption with:'
  end
  object Label2: TLabel
    Left = 66
    Top = 48
    Width = 46
    Height = 13
    Caption = 'Character'
  end
  object OKBtn: TButton
    Left = 49
    Top = 108
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 129
    Top = 108
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object HelpBtn: TButton
    Left = 209
    Top = 108
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object efChar: TEdit
    Tag = 64
    Left = 124
    Top = 45
    Width = 66
    Height = 21
    Hint = 'A default letter for Caesar encryption'
    ReadOnly = True
    TabOrder = 3
    Text = 'A'
  end
  object ctlCeaserChg: TUpDown
    Left = 190
    Top = 46
    Width = 13
    Height = 19
    Min = 32
    Max = 126
    Position = 64
    TabOrder = 4
    Wrap = False
    OnClick = ctlCeaserChgClick
  end
end
