object Form1: TForm1
  Left = 230
  Top = 110
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'PBPathList Demo'
  ClientHeight = 299
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 62
    Top = 3
    Width = 298
    Height = 13
    Caption = 'Pick a Pathname to show the path on this computer:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 146
    Width = 405
    Height = 2
  end
  object Label1: TLabel
    Left = 20
    Top = 159
    Width = 382
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Type a path above, pick the action and press '#39'Perform'#39#13#10'(A shell' +
      'name path is like: %SYSTEM%\MyFolders\MySubFolder):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object TotalLabel: TLabel
    Left = 251
    Top = 88
    Width = 84
    Height = 13
    AutoSize = False
    Caption = '(Count: )'
  end
  object ComboBox1: TComboBox
    Left = 116
    Top = 20
    Width = 189
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object Edit1: TEdit
    Left = 8
    Top = 54
    Width = 405
    Height = 21
    TabOrder = 1
  end
  object RadioGroup1: TRadioGroup
    Left = 82
    Top = 186
    Width = 257
    Height = 51
    Columns = 2
    Ctl3D = True
    Items.Strings = (
      'DisplayPath'
      'FullPath'
      'BuildShellName'
      'ReplaceShellName')
    ParentCtl3D = False
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 8
    Top = 244
    Width = 405
    Height = 21
    TabOrder = 3
  end
  object Perform: TButton
    Left = 173
    Top = 271
    Width = 75
    Height = 25
    Caption = 'Perform'
    TabOrder = 4
    OnClick = PerformClick
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 106
    Width = 405
    Height = 30
    Caption = 'PathCase:'
    Columns = 4
    Items.Strings = (
      'pcDontCare'
      'pcLower'
      'pcUpper'
      'pcUpperName')
    TabOrder = 5
    OnClick = RadioGroup2Click
  end
  object SimulateNotfound: TCheckBox
    Left = 85
    Top = 86
    Width = 133
    Height = 17
    Caption = 'SimulateNotfound'
    TabOrder = 6
    OnClick = SimulateNotfoundClick
  end
  object PBPathList1: TPBPathList
    Left = 391
    Top = 269
  end
end
