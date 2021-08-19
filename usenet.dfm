inherited wndUsenetMsg: TwndUsenetMsg
  Left = 204
  Top = 6
  Width = 647
  Height = 501
  Caption = 'Post a Usenet Message'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ctlLeftPanel: TPanel
    Top = 21
    Width = 23
    Height = 453
  end
  inherited cltClientPanel: TPanel
    Left = 23
    Top = 21
    Width = 616
    Height = 453
    inherited ctlEditPanel: TPanel
      Width = 616
      Height = 131
      Color = clActiveBorder
      inherited Label7: TLabel
        Left = 50
        Top = 8
      end
      inherited Label5: TLabel
        Left = 50
        Top = 32
      end
      inherited Label4: TLabel
        Left = 8
        Top = 82
        Width = 74
        Caption = 'Newsgroups:'
      end
      inherited lblSubj: TLabel
        Left = 34
        Top = 103
      end
      object Label1: TLabel [4]
        Left = 28
        Top = 59
        Width = 54
        Height = 13
        Caption = 'Remailer:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      inherited efDate: TEdit
        Left = 94
        Top = 9
      end
      inherited efTo: TEdit
        Left = 94
        Top = 79
        Width = 287
        BorderStyle = bsSingle
        Color = clWindow
        ParentColor = False
        TabOrder = 4
      end
      inherited efSubj: TEdit
        Left = 94
        Top = 101
        Width = 387
        BorderStyle = bsSingle
        Color = clWindow
        ParentColor = False
        TabOrder = 6
      end
      inherited cbFrom: TComboBox
        Left = 94
        Top = 32
        Color = clWindow
        ParentColor = False
      end
      object cbRemailers: TComboBox
        Left = 94
        Top = 55
        Width = 285
        Height = 21
        Hint = 'Select one of your email accounts this message should be from'
        Style = csDropDownList
        Ctl3D = False
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 3
      end
      object ckAnon: TCheckBox
        Left = 380
        Top = 31
        Width = 97
        Height = 17
        Caption = 'Anonymous Post'
        TabOrder = 2
      end
      object pbNewsGroupLookup: TButton
        Left = 386
        Top = 82
        Width = 23
        Height = 18
        Caption = '...'
        TabOrder = 5
        OnClick = pbNewsGroupLookupClick
      end
    end
    inherited efMsg: TMemo
      Top = 131
      Width = 616
      Height = 322
      BorderStyle = bsSingle
      Color = clWindow
      ParentColor = False
    end
  end
  inherited ctlTopPanel: TPanel
    Width = 639
    Height = 21
  end
end
