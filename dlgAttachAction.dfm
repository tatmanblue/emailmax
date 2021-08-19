object dlgAttachmentAction: TdlgAttachmentAction
  Left = 337
  Top = 61
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Attachment Notice'
  ClientHeight = 237
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 6
    Width = 271
    Height = 13
    Caption = 'Please indicate what you want to do with this attachment:'
  end
  object ctlWarning: TImage
    Left = 5
    Top = 179
    Width = 35
    Height = 33
    Hint = 
      'You have chosen to open an attachment.  This could compromise th' +
      'e integrity of your computer.'
    Picture.Data = {
      055449636F6E0000010002002020100000000000E80200002600000010101000
      00000000280100000E0300002800000020000000400000000100040000000000
      8002000000000000000000000000000000000000000000000000800000800000
      0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
      00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000077777777000
      0000000000000000007777777777777700000000000000000771111111177777
      7000000000000007111999999991117777700000000000719999999999999917
      7777000000000119999999999999999117777000000019999999999999999999
      9177700000019999999999999999999999177700000199999999999999999999
      99177770001999999F9999999999F9999991777001999999FFF99999999FFF99
      999917700199999FFFFF999999FFFFF99999177701999999FFFFF9999FFFFF99
      99991777199999999FFFFF99FFFFF999999991771999999999FFFFFFFFFF9999
      9999917719999999999FFFFFFFF9999999999177199999999999FFFFFF999999
      99999177199999999999FFFFFF9999999999917719999999999FFFFFFFF99999
      999991771999999999FFFFFFFFFF999999999170199999999FFFFF99FFFFF999
      9999917001999999FFFFF9999FFFFF99999917700199999FFFFF999999FFFFF9
      9999170001999999FFF99999999FFF9999991000001999999F9999999999F999
      9991700000019999999999999999999999170000000199999999999999999999
      9910000000001999999999999999999991000000000001199999999999999991
      1000000000000001999999999999991000000000000000001119999999911100
      0000000000000000000111111110000000000000FFF807FFFFC000FFFF80007F
      FE00001FFC00000FF8000007F0000007E0000003E0000001C000000180000001
      8000000080000000000000000000000000000000000000000000000000000000
      0000000100000001800000018000000380000007C0000007E000000FE000001F
      F000003FF800007FFE0001FFFF0003FFFFE01FFF280000001000000020000000
      0100040000000000C00000000000000000000000000000000000000000000000
      00008000008000000080800080000000800080008080000080808000C0C0C000
      0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000777
      7777000000001111111777000011999999911770019999999999917001999999
      999991771999FF999FF999171999FFF9FFF9991719999FFFFF999917199999FF
      F999991719999FFFFF9999171999FFF9FFF999171999FF999FF9991001999999
      99999100019999999999910000119999999110000000111111100000F80F0000
      F0030000C0010000800100008000000000000000000000000000000000000000
      0000000000000000000100008003000080030000C0070000F01F0000}
    Transparent = True
    Visible = False
  end
  object txtWarning: TLabel
    Left = 47
    Top = 182
    Width = 255
    Height = 13
    Hint = 
      'You have chosen to open an attachment.  This could compromise th' +
      'e integrity of your computer.'
    AutoSize = False
    Caption = 'You have chosen a potentially unsafe action!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object txtFile: TLabel
    Left = 6
    Top = 22
    Width = 8
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = [fsUnderline]
    ParentFont = False
  end
  object rbActions: TRadioGroup
    Left = 5
    Top = 47
    Width = 303
    Height = 129
    Caption = 'rbActions'
    ItemIndex = 1
    Items.Strings = (
      'Open the attachment'
      'Save attachment '
      'Delete attachment'
      'Other')
    TabOrder = 2
    OnClick = rbActionsClick
  end
  object pbOK: TButton
    Left = 148
    Top = 209
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = pbOKClick
  end
  object pbCancel: TButton
    Left = 231
    Top = 210
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = pbCancelClick
  end
  object efOtherCommand: TEdit
    Left = 69
    Top = 145
    Width = 215
    Height = 21
    Color = clInactiveCaptionText
    Enabled = False
    TabOrder = 3
  end
  object ctlWarningTimer: TTimer
    Interval = 1250
    OnTimer = ctlWarningTimerTimer
    Left = 75
    Top = 205
  end
  object ctlSaveAs: TSaveDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofEnableSizing]
    Title = 'Select where you want to save file'
    Left = 7
    Top = 21
  end
end
