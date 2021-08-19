object wndBasePost: TwndBasePost
  Left = 247
  Top = 106
  Width = 652
  Height = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object ctlLeftPanel: TPanel
    Left = 0
    Top = 20
    Width = 26
    Height = 350
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
  end
  object cltClientPanel: TPanel
    Left = 26
    Top = 20
    Width = 618
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object ctlEditPanel: TPanel
      Left = 0
      Top = 0
      Width = 618
      Height = 105
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label7: TLabel
        Left = 7
        Top = 9
        Width = 32
        Height = 13
        Caption = 'Date:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label5: TLabel
        Left = 7
        Top = 34
        Width = 32
        Height = 13
        Caption = 'From:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label4: TLabel
        Left = 6
        Top = 58
        Width = 20
        Height = 13
        Caption = 'To:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblSubj: TLabel
        Left = 7
        Top = 79
        Width = 48
        Height = 13
        Caption = 'Subject:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object efDate: TEdit
        Left = 66
        Top = 8
        Width = 150
        Height = 18
        Hint = 'Date of email'
        TabStop = False
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object efTo: TEdit
        Left = 66
        Top = 59
        Width = 414
        Height = 18
        Hint = 'To whom you wish to send your message'
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        TabOrder = 2
        OnChange = efSubjChange
      end
      object efSubj: TEdit
        Left = 66
        Top = 74
        Width = 414
        Height = 21
        Hint = 'What is the message about?'
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        TabOrder = 3
        OnChange = efSubjChange
      end
      object cbFrom: TComboBox
        Left = 66
        Top = 30
        Width = 285
        Height = 21
        Hint = 'Select one of your email accounts this message should be from'
        Style = csDropDownList
        Ctl3D = False
        ItemHeight = 13
        ParentColor = True
        ParentCtl3D = False
        TabOrder = 1
      end
    end
    object efMsg: TMemo
      Left = 0
      Top = 105
      Width = 618
      Height = 245
      Hint = 'Email message body'
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 1
      WantTabs = True
      OnChange = efSubjChange
      OnKeyDown = efMsgKeyDown
    end
  end
  object ctlTopPanel: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
end
