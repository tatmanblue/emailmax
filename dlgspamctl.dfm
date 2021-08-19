object dlgSpamControl: TdlgSpamControl
  Left = 14
  Top = 69
  HelpContext = 2100
  BorderStyle = bsNone
  Caption = 'Spam Control and Filters'
  ClientHeight = 262
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 229
    Top = 9
    Width = 30
    Height = 13
    Caption = 'Action'
  end
  object Label3: TLabel
    Left = 11
    Top = 35
    Width = 49
    Height = 13
    Caption = 'Rule Type'
  end
  object Label4: TLabel
    Left = 11
    Top = 59
    Width = 46
    Height = 13
    Caption = 'Rule Text'
  end
  object Bevel1: TBevel
    Left = 9
    Top = 96
    Width = 390
    Height = 7
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 11
    Top = 11
    Width = 40
    Height = 13
    Caption = 'Account'
  end
  object lvFilters: TListView
    Left = 9
    Top = 103
    Width = 390
    Height = 137
    Columns = <
      item
        Caption = 'Action'
      end
      item
        Caption = 'Account'
        Width = 100
      end
      item
        Caption = 'Filter Type'
        Width = 65
      end
      item
        Caption = 'Case'
        Width = 40
      end
      item
        Caption = 'Filter Text'
        Width = 128
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 7
    ViewStyle = vsReport
    OnClick = lvFiltersClick
  end
  object cbAction: TComboBox
    Left = 269
    Top = 3
    Width = 125
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Ignore'
      'Move to Trash Folder'
      'Delete from Server')
  end
  object cbFilterType: TComboBox
    Left = 66
    Top = 29
    Width = 157
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'Contains'
      'Begins With'
      'Ends With')
  end
  object ckIgnoreCase: TCheckBox
    Left = 231
    Top = 32
    Width = 132
    Height = 17
    Caption = 'Ignore Case Sensetivity'
    TabOrder = 3
  end
  object efFilterText: TEdit
    Left = 66
    Top = 55
    Width = 330
    Height = 21
    TabOrder = 4
    OnChange = efFilterTextChange
  end
  object pbSave: TButton
    Left = 66
    Top = 78
    Width = 75
    Height = 17
    Caption = '&Save'
    TabOrder = 5
    OnClick = pbSaveClick
  end
  object pbReset: TButton
    Left = 142
    Top = 78
    Width = 75
    Height = 17
    Caption = '&Reset'
    TabOrder = 8
    OnClick = pbResetClick
  end
  object pbDelete: TButton
    Left = 8
    Top = 244
    Width = 75
    Height = 17
    Caption = '&Delete'
    TabOrder = 6
    OnClick = pbDeleteClick
  end
  object cbAccounts: TComboBox
    Left = 66
    Top = 4
    Width = 157
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
end
