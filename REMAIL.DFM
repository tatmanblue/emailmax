object frmRemail: TfrmRemail
  Left = 307
  Top = 19
  BorderStyle = bsSingle
  Caption = 'Remail'
  ClientHeight = 378
  ClientWidth = 458
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = mnRemailMain
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = OnMainCreate
  OnDestroy = OnMainDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 64
    Height = 16
    AutoSize = False
    Caption = 'Remailer'
  end
  object Label2: TLabel
    Left = 10
    Top = 37
    Width = 64
    Height = 16
    AutoSize = False
    Caption = 'Nym'
  end
  object Label3: TLabel
    Left = 10
    Top = 62
    Width = 49
    Height = 16
    AutoSize = False
    Caption = 'From'
  end
  object Label4: TLabel
    Left = 10
    Top = 89
    Width = 35
    Height = 16
    AutoSize = False
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 10
    Top = 111
    Width = 40
    Height = 16
    AutoSize = False
    Caption = 'Subject'
  end
  object Label6: TLabel
    Left = 333
    Top = 14
    Width = 97
    Height = 12
    AutoSize = False
    Caption = 'like: remailer@replay.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 333
    Top = 40
    Width = 97
    Height = 12
    AutoSize = False
    Caption = 'like: remailer@replay.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 333
    Top = 68
    Width = 97
    Height = 12
    AutoSize = False
    Caption = 'like: MyNymName'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 333
    Top = 91
    Width = 97
    Height = 12
    AutoSize = False
    Caption = 'like: remailer@replay.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 363
    Top = 158
    Width = 79
    Height = 13
    AutoSize = False
    Caption = 'Like: rec.invest.misc'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 10
    Top = 183
    Width = 50
    Height = 16
    AutoSize = False
    Caption = 'Message'
  end
  object efTo: TEdit
    Left = 73
    Top = 85
    Width = 250
    Height = 21
    TabOrder = 3
  end
  object efSubj: TEdit
    Left = 73
    Top = 111
    Width = 250
    Height = 21
    TabOrder = 4
  end
  object ckNews: TCheckBox
    Left = 42
    Top = 135
    Width = 187
    Height = 17
    Caption = 'Newsgroups'
    TabOrder = 5
    OnClick = OnNewsGroupsClick
  end
  object efNewsgroup: TEdit
    Left = 73
    Top = 152
    Width = 250
    Height = 21
    Color = clBtnFace
    Enabled = False
    TabOrder = 6
  end
  object cmdSave: TButton
    Left = 312
    Top = 351
    Width = 69
    Height = 22
    Caption = '&Save'
    TabOrder = 9
    OnClick = cmdSaveClick
  end
  object cmdClose: TButton
    Left = 386
    Top = 351
    Width = 69
    Height = 22
    Cancel = True
    Caption = 'Close'
    TabOrder = 10
    OnClick = cmdCloseClick
  end
  object efMsg: TMemo
    Left = 9
    Top = 202
    Width = 446
    Height = 143
    TabOrder = 8
  end
  object pbLookupGroups: TButton
    Left = 329
    Top = 151
    Width = 23
    Height = 23
    Caption = '...'
    Enabled = False
    TabOrder = 7
    OnClick = pbLookupGroupsClick
  end
  object cbRemailer: TComboBox
    Left = 74
    Top = 9
    Width = 250
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object cbNym: TComboBox
    Left = 74
    Top = 36
    Width = 250
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object cbFrom: TComboBox
    Left = 74
    Top = 61
    Width = 250
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object cmdReset: TButton
    Left = 10
    Top = 350
    Width = 69
    Height = 22
    Caption = '&Reset'
    TabOrder = 11
    OnClick = cmdSaveClick
  end
  object mnRemailMain: TMainMenu
    AutoMerge = True
    Left = 386
    Top = 111
    object mnFile: TMenuItem
      Caption = '&File'
      object mnFileSave: TMenuItem
        Caption = '&Save'
        OnClick = mnFileSaveClick
      end
      object mnFileReset: TMenuItem
        Caption = '&Reset'
      end
      object mnFileClose: TMenuItem
        Caption = '&Close'
        OnClick = mnFileCloseClick
      end
    end
  end
  object ctlCaption: TMarsCaption
    ActiveBeginColor = clNavy
    ActiveEndColor = clBlue
    ActiveFontColor = clWhite
    InactiveBeginColor = clGray
    InactiveEndColor = clSilver
    InactiveFontColor = clSilver
    ApplicationNameFont.Charset = DEFAULT_CHARSET
    ApplicationNameFont.Color = clWindowText
    ApplicationNameFont.Height = -11
    ApplicationNameFont.Name = 'MS Sans Serif'
    ApplicationNameFont.Style = [fsBold]
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'MS Sans Serif'
    CaptionFont.Style = []
    NumColors = 64
    AutoSize = False
    Left = 164
    Top = 112
  end
end
