object dlgSelectDecrypt: TdlgSelectDecrypt
  Left = 89
  Top = 79
  BorderStyle = bsDialog
  Caption = 'Select Decryption Method.'
  ClientHeight = 180
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object txtDirections: TLabel
    Left = 8
    Top = 6
    Width = 291
    Height = 34
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'You have selected to decrypt a message.  Please select the appro' +
      'priate type of decryption.'
    WordWrap = True
  end
  object OKBtn: TButton
    Left = 52
    Top = 143
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 132
    Top = 143
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object HelpBtn: TButton
    Left = 212
    Top = 143
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
    OnClick = HelpBtnClick
  end
  object rbPGP: TRadioButton
    Left = 102
    Top = 48
    Width = 113
    Height = 17
    Caption = '&PGP'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TabStop = True
    OnClick = rbPGPClick
  end
  object rbCeasar: TRadioButton
    Left = 102
    Top = 88
    Width = 113
    Height = 17
    Caption = '&Ceasar'
    TabOrder = 4
    OnClick = rbCeasarClick
  end
  object rbBeal: TRadioButton
    Left = 102
    Top = 108
    Width = 113
    Height = 17
    Caption = '&Beal'
    Enabled = False
    TabOrder = 5
    Visible = False
    OnClick = rbBealClick
  end
  object rbMD5: TRadioButton
    Left = 102
    Top = 68
    Width = 113
    Height = 17
    Caption = '&MD5'
    TabOrder = 6
    OnClick = rbMD5Click
  end
end
