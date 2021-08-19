object dlgContactListWnd: TdlgContactListWnd
  Left = 40
  Top = 128
  HelpContext = 4100
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select Email Address'
  ClientHeight = 391
  ClientWidth = 496
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
    Left = 11
    Top = 11
    Width = 139
    Height = 13
    Caption = 'Select Email &Addresses From:'
  end
  object Bevel1: TBevel
    Left = 5
    Top = 32
    Width = 487
    Height = 8
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 281
    Top = 63
    Width = 96
    Height = 13
    Caption = 'Message &Recipients'
  end
  object Label3: TLabel
    Left = 13
    Top = 46
    Width = 162
    Height = 13
    Caption = 'Type in a Name or Select from List'
  end
  object cbWhich: TComboBox
    Left = 160
    Top = 7
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbWhichChange
    Items.Strings = (
      'Emailmax'
      'Outlook')
  end
  object cmdCancel: TButton
    Left = 412
    Top = 358
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 13
  end
  object cmdOK: TButton
    Left = 335
    Top = 358
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 12
  end
  object gridSelectFrom: TStringGrid
    Left = 11
    Top = 94
    Width = 209
    Height = 251
    DefaultColWidth = 50
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 3
    OnDblClick = gridSelectFromDblClick
  end
  object lbTo: TListBox
    Left = 279
    Top = 79
    Width = 206
    Height = 85
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = lbToDblClick
  end
  object lbCC: TListBox
    Left = 279
    Top = 168
    Width = 206
    Height = 85
    ItemHeight = 13
    TabOrder = 7
    OnDblClick = lbCCDblClick
  end
  object lbBcc: TListBox
    Left = 279
    Top = 259
    Width = 206
    Height = 85
    ItemHeight = 13
    TabOrder = 9
    OnDblClick = lbBccDblClick
  end
  object efFind: TEdit
    Left = 14
    Top = 69
    Width = 158
    Height = 21
    TabOrder = 1
    OnEnter = efFindEnter
    OnExit = efFindExit
    OnKeyPress = efFindKeyPress
  end
  object cmdFind: TButton
    Left = 177
    Top = 69
    Width = 41
    Height = 21
    Caption = '&Find'
    TabOrder = 2
    OnClick = cmdFindClick
  end
  object cmdTo: TButton
    Left = 228
    Top = 106
    Width = 47
    Height = 25
    Caption = '&To --->'
    TabOrder = 4
    OnClick = cmdToClick
  end
  object cmdCC: TButton
    Left = 228
    Top = 191
    Width = 47
    Height = 25
    Caption = '&Cc --->'
    TabOrder = 6
    OnClick = cmdCCClick
  end
  object cmdBcc: TButton
    Left = 228
    Top = 282
    Width = 47
    Height = 25
    Caption = '&Bcc --->'
    TabOrder = 8
    OnClick = cmdBccClick
  end
  object cmdNew: TButton
    Left = 13
    Top = 353
    Width = 75
    Height = 25
    Caption = '&New Contact'
    TabOrder = 10
    OnClick = cmdNewClick
  end
  object cmdProperties: TButton
    Left = 99
    Top = 353
    Width = 75
    Height = 25
    Caption = '&Properties'
    TabOrder = 11
    OnClick = cmdPropertiesClick
  end
end
