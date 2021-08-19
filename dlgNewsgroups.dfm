inherited dlgNewsgroupsTab: TdlgNewsgroupsTab
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 14
    Top = 22
    Width = 130
    Height = 13
    Caption = 'Send usenet messages via:'
  end
  object rbNewsServer: TRadioButton
    Left = 156
    Top = 22
    Width = 97
    Height = 17
    Caption = 'News Server'
    Enabled = False
    TabOrder = 0
  end
  object rbMailToNews: TRadioButton
    Left = 261
    Top = 22
    Width = 133
    Height = 17
    Caption = 'Mail to News Remailer'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object Panel3: TPanel
    Left = 9
    Top = 52
    Width = 400
    Height = 173
    Alignment = taLeftJustify
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label10: TLabel
      Left = 8
      Top = 5
      Width = 110
      Height = 13
      Caption = 'Mail to News Remailers'
    end
    object pbAddRemailer: TButton
      Left = 312
      Top = 106
      Width = 75
      Height = 17
      Caption = '&Add'
      TabOrder = 0
      OnClick = pbAddRemailerClick
    end
    object pbRemoveRemailer: TButton
      Left = 312
      Top = 126
      Width = 75
      Height = 17
      Caption = '&Remove'
      Enabled = False
      TabOrder = 1
      OnClick = pbRemoveRemailerClick
    end
    object ctlRemailer: TListView
      Left = 7
      Top = 27
      Width = 295
      Height = 139
      Columns = <
        item
          Caption = 'Remailer Address'
          Width = 150
        end
        item
          Caption = 'SMTP'
          Width = 85
        end
        item
          Caption = 'Index'
          Width = 0
        end
        item
          Caption = 'Default'
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 2
      ViewStyle = vsReport
      OnDblClick = ctlRemailerDblClick
    end
  end
  object cmdEditNews: TButton
    Left = 10
    Top = 232
    Width = 92
    Height = 25
    Caption = '&Edit Newsgroups'
    TabOrder = 3
    OnClick = cmdEditNewsClick
  end
end
