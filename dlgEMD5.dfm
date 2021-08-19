object dlgMD5Handler: TdlgMD5Handler
  Left = 272
  Top = 209
  BorderStyle = bsDialog
  Caption = ' with MD5'
  ClientHeight = 137
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object txtWho: TLabel
    Left = 17
    Top = 66
    Width = 62
    Height = 13
    Caption = 'Pass Phrase:'
  end
  object txtType: TLabel
    Left = 17
    Top = 14
    Width = 242
    Height = 29
    AutoSize = False
    Caption = 
      'ion requires a pass phrase known by all parties associated with ' +
      'this message.'
    WordWrap = True
  end
  object OKBtn: TButton
    Left = 27
    Top = 108
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelBtn: TButton
    Left = 107
    Top = 108
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object HelpBtn: TButton
    Left = 187
    Top = 108
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
    OnClick = HelpBtnClick
  end
  object efEncryptPhase: TEdit
    Left = 89
    Top = 61
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
end
