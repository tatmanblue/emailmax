object dlgResults: TdlgResults
  Left = 183
  Top = 108
  BorderStyle = bsDialog
  Caption = 'PGP Results'
  ClientHeight = 377
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 345
    Width = 508
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 9
      Width = 212
      Height = 13
      Caption = 'Copy the PGP results to your email program...'
    end
    object cmdQuick: TButton
      Left = 363
      Top = 9
      Width = 69
      Height = 22
      Caption = '&Quick'
      Default = True
      TabOrder = 0
    end
    object cmdClose: TButton
      Left = 436
      Top = 8
      Width = 69
      Height = 22
      Cancel = True
      Caption = 'Close'
      TabOrder = 1
      OnClick = cmdCloseClick
    end
  end
  object efResults: TMemo
    Left = 0
    Top = 0
    Width = 508
    Height = 345
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
