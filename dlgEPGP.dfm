object dlgPgpEncrypt: TdlgPgpEncrypt
  Left = 71
  Top = 154
  BorderStyle = bsDialog
  Caption = 'Preparing to Encrypt a message with PGP'
  ClientHeight = 140
  ClientWidth = 301
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
  object txtWho: TLabel
    Left = 17
    Top = 22
    Width = 55
    Height = 13
    Caption = 'Encrypt To:'
  end
  object Label2: TLabel
    Left = 17
    Top = 50
    Width = 51
    Height = 13
    Caption = 'Signed By:'
  end
  object ctlImage: TImage
    Left = 186
    Top = 4
    Width = 105
    Height = 105
    AutoSize = True
    Transparent = True
    Visible = False
  end
  object OKBtn: TButton
    Left = 49
    Top = 108
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
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
    TabOrder = 3
  end
  object HelpBtn: TButton
    Left = 209
    Top = 108
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 4
    OnClick = HelpBtnClick
  end
  object efEncryptTo: TEdit
    Left = 89
    Top = 17
    Width = 169
    Height = 21
    TabOrder = 0
  end
  object efSignedBy: TEdit
    Left = 90
    Top = 45
    Width = 169
    Height = 21
    TabOrder = 1
  end
end
