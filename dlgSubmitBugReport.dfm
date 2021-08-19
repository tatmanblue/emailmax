object dlgSubmitBug: TdlgSubmitBug
  Left = 92
  Top = 103
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Submit Bug Report'
  ClientHeight = 439
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 306
    Height = 26
    Caption = 
      'The purpose of the screen is to submit a bug to microObjects inc' +
      '.  Please remember:  '
    WordWrap = True
  end
  object Label2: TLabel
    Left = 113
    Top = 21
    Width = 235
    Height = 13
    Caption = 'The more infomation you give, the better.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 54
    Width = 53
    Height = 13
    Caption = 'Your Email:'
  end
  object Label4: TLabel
    Left = 16
    Top = 79
    Width = 26
    Height = 13
    Caption = 'Date:'
  end
  object txtDate: TLabel
    Left = 91
    Top = 79
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 16
    Top = 105
    Width = 16
    Height = 13
    Caption = 'To:'
  end
  object txtTo: TLabel
    Left = 93
    Top = 101
    Width = 116
    Height = 13
    Caption = 'mattr@microobjects.com'
  end
  object Label7: TLabel
    Left = 16
    Top = 130
    Width = 60
    Height = 13
    Caption = 'Report Area:'
  end
  object Label8: TLabel
    Left = 16
    Top = 155
    Width = 62
    Height = 13
    Caption = 'Report Type:'
  end
  object Label9: TLabel
    Left = 16
    Top = 189
    Width = 35
    Height = 13
    Caption = 'Details:'
  end
  object cbYourEmail: TComboBox
    Left = 91
    Top = 51
    Width = 230
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object cbProblem: TComboBox
    Left = 91
    Top = 123
    Width = 230
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    Items.Strings = (
      'Composing Mail'
      'Encryption'
      'Help'
      'Installation'
      'Main Application'
      'News Composer'
      'News Reader'
      'Other'
      'Reading Mail'
      'Remailers'
      'Retrieving Mail'
      'Send Mail'
      'Setup'
      'Spaminator')
  end
  object cbType: TComboBox
    Left = 91
    Top = 155
    Width = 230
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
    Items.Strings = (
      'Bug'
      'Other'
      'Suggestion')
  end
  object efDetails: TMemo
    Left = 15
    Top = 205
    Width = 360
    Height = 199
    Lines.Strings = (
      '')
    TabOrder = 3
  end
  object pbSend: TButton
    Left = 213
    Top = 409
    Width = 75
    Height = 25
    Caption = '&Send'
    TabOrder = 4
    OnClick = pbSendClick
  end
  object pbCancel: TButton
    Left = 301
    Top = 409
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = pbCancelClick
  end
end
