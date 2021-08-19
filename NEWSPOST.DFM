object wndNewsPost: TwndNewsPost
  Left = 201
  Top = 108
  Width = 619
  Height = 466
  Caption = 'Post a Usenet message...'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Menu = mnNotepadMenu
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object ctlBkground: TImage
    Left = 0
    Top = 0
    Width = 611
    Height = 420
    Align = alClient
  end
  object efTo: TEdit
    Left = 121
    Top = 120
    Width = 414
    Height = 18
    BorderStyle = bsNone
    ParentColor = True
    TabOrder = 0
  end
  object efDate: TEdit
    Left = 121
    Top = 69
    Width = 150
    Height = 18
    BorderStyle = bsNone
    ParentColor = True
    ReadOnly = True
    TabOrder = 1
  end
  object mnNotepadMenu: TMainMenu
    AutoMerge = True
    Left = 118
    Top = 9
    object mnNotepad: TMenuItem
      Caption = '&Usenet'
      GroupIndex = 1
      object mnNotepadSend: TMenuItem
        Caption = '&Send'
        GroupIndex = 1
      end
      object N1: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object mnNotepadClose: TMenuItem
        Caption = '&Close'
        GroupIndex = 1
      end
      object mnNotepadSaveClose: TMenuItem
        Caption = 'Save && &Close'
        GroupIndex = 1
      end
    end
  end
end
