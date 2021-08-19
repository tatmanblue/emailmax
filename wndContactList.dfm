object wndContactList: TwndContactList
  Left = 40
  Top = 128
  Width = 454
  Height = 418
  HelpContext = 4100
  Caption = 'Contact List'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  HelpFile = 'emailmax.hlp'
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object gridSelectFrom: TStringGrid
    Left = 0
    Top = 89
    Width = 446
    Height = 261
    Align = alClient
    DefaultColWidth = 84
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    OnDblClick = gridSelectFromDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 350
    Width = 446
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object cmdNew: TButton
      Left = 13
      Top = 8
      Width = 75
      Height = 25
      Caption = '&New'
      TabOrder = 0
      OnClick = cmdNewClick
    end
    object cmdEdit: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Edit'
      TabOrder = 1
      OnClick = cmdEditClick
    end
    object cmdDelete: TButton
      Left = 178
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Delete'
      TabOrder = 2
      OnClick = cmdDeleteClick
    end
    object cmdOK: TButton
      Left = 360
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Close'
      Default = True
      ModalResult = 1
      TabOrder = 3
      Visible = False
      OnClick = cmdOKClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 446
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label3: TLabel
      Left = 13
      Top = 45
      Width = 162
      Height = 13
      Caption = 'Type in a Name or Select from List'
    end
    object Bevel1: TBevel
      Left = 5
      Top = 32
      Width = 437
      Height = 8
      Shape = bsTopLine
    end
    object Label1: TLabel
      Left = 11
      Top = 11
      Width = 139
      Height = 13
      Caption = 'Select Email &Addresses From:'
    end
    object efFind: TEdit
      Left = 14
      Top = 58
      Width = 265
      Height = 21
      TabOrder = 0
      OnEnter = efFindEnter
      OnExit = efFindExit
      OnKeyPress = efFindKeyPress
    end
    object cmdFind: TButton
      Left = 287
      Top = 58
      Width = 41
      Height = 21
      Caption = '&Find'
      TabOrder = 1
      OnClick = cmdFindClick
    end
    object cbWhich: TComboBox
      Left = 160
      Top = 7
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = cbWhichChange
      Items.Strings = (
        'Emailmax'
        'Outlook')
    end
  end
end
