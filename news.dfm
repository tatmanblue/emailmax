object dlgNewsgroup: TdlgNewsgroup
  Left = 107
  Top = 101
  Width = 467
  Height = 311
  Caption = 'Newsgroup Lookup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = OnNewsDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbGroups: TListBox
    Left = 0
    Top = 70
    Width = 459
    Height = 177
    Align = alClient
    ExtendedSelect = False
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbGroupsClick
    OnDblClick = lbGroupsDblClick
  end
  object ctlLoadNotice: TPanel
    Left = 56
    Top = 86
    Width = 354
    Height = 148
    Caption = 'Please wait while the groups load'
    TabOrder = 1
  end
  object ctlBottom: TPanel
    Left = 0
    Top = 247
    Width = 459
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object pbAdd: TButton
      Left = 11
      Top = 5
      Width = 104
      Height = 25
      Caption = '&Add Newsgroup'
      TabOrder = 0
      OnClick = pbAddClick
    end
    object pbDelete: TButton
      Left = 118
      Top = 5
      Width = 104
      Height = 25
      Caption = '&Delete Newsgroup'
      Enabled = False
      TabOrder = 1
      OnClick = pbDeleteClick
    end
    object pbOK: TButton
      Left = 292
      Top = 5
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      Enabled = False
      TabOrder = 2
      OnClick = OnOK
    end
    object pbCancel: TButton
      Left = 372
      Top = 5
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = OnCancel
    end
  end
  object ctlTop: TPanel
    Left = 0
    Top = 0
    Width = 459
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object txtPostMsg: TLabel
      Left = 18
      Top = 6
      Width = 154
      Height = 13
      Caption = 'Groups already assigned to post:'
    end
    object Label1: TLabel
      Left = 18
      Top = 50
      Width = 71
      Height = 16
      AutoSize = False
      Caption = 'Text to Search'
    end
    object txtPosts: TEdit
      Left = 176
      Top = 4
      Width = 272
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object efFind: TEdit
      Left = 99
      Top = 46
      Width = 247
      Height = 21
      HideSelection = False
      TabOrder = 1
      OnChange = efFindChange
    end
    object pbFind: TButton
      Left = 351
      Top = 45
      Width = 46
      Height = 23
      Caption = '&Find'
      Enabled = False
      TabOrder = 2
      OnClick = OnFind
    end
    object pbNext: TButton
      Left = 402
      Top = 45
      Width = 46
      Height = 23
      Caption = '&Next'
      Enabled = False
      TabOrder = 3
      OnClick = onFindNext
    end
  end
end
