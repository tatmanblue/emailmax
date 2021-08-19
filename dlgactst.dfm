object dlgEmailAcctSetup: TdlgEmailAcctSetup
  Left = 236
  Top = 104
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Setup an Account to Receive Email'
  ClientHeight = 322
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object txtGeneralInfo: TLabel
    Left = 10
    Top = 5
    Width = 66
    Height = 13
    Caption = 'txtGeneralInfo'
  end
  object ctlBottom: TPanel
    Left = 0
    Top = 280
    Width = 362
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pbOK: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Close the window, accepting your changes'
      Caption = 'OK'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = pbOKClick
    end
    object pbCancel: TButton
      Left = 271
      Top = 8
      Width = 75
      Height = 25
      Hint = 'Close the window, losing any changes made'
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = pbCancelClick
    end
  end
  object ctlPages: TPageControl
    Left = 9
    Top = 23
    Width = 340
    Height = 245
    ActivePage = ctlDefaultPage
    TabOrder = 1
    object ctlDefaultPage: TTabSheet
      Caption = '&Setup'
      object Label1: TLabel
        Left = 26
        Top = 16
        Width = 66
        Height = 13
        Caption = 'Email Address'
      end
      object ctlImage: TImage
        Left = 285
        Top = 14
        Width = 32
        Height = 32
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010002002020100000000000E80200002600000010101000
          00000000280100000E0300002800000020000000400000000100040000000000
          8002000000000000000000000000000000000000000000000000800000800000
          0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
          00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000FFFFFFFFFFFFF
          0000000000000000000888888887676F0000000000000000000000000000066F
          0000000000000000FFFFFFFFFFFF076F0000000000000000FFFFFFF0000F066F
          0000000000000000FFF7FFF0990F08FF0000000000000000F7F7FFF0F90F08FF
          0000000008777770F7F7F7F0000F08FF077777700FB8B8B0F7F7F7FFFFFF08FF
          07B8B87008800000F7F7F7FFFFFF08FF00000B700FB007708787878888880788
          070008700880F070888888888888078800070B700FB0FF000000000000000000
          007808700880FFFF3F3F3F3F3F3F3F3F37870B700FB0FFF3F3F3F3F3F3F3F3F3
          F3780870088B0F3F3F3F3F3F3F3F3F3F3F308B700FB8B0000000000000000000
          0008B870088B8B8B8B8B8B8B8B8B8B8B8B8B8B700F8F8F8F8F8F8F8F8F8F8F8F
          8F8F8F8000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFC0007FFFC0007FFFC0007FFE00007FFE00007FFE00007FFE00007F00000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000
          0100040000000000C00000000000000000000000000000000000000000000000
          00008000008000000080800080000000800080008080000080808000C0C0C000
          0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
          00000000000000000000000000000000FF6F0000000000000006000000000FFF
          9F0F000000000F7F990F000008F80F7FFF0F08F00F0708788808008008800000
          000008F00F0F3F3F3F3F308008F8F8F8F8F8F8F0000000000000000000000000
          00000000000000000000000000000000000000000000000000000000FFFF0000
          FE070000FE070000F0070000F007000000000000000000000000000000000000
          000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000}
        Transparent = True
      end
      object efAddress: TEdit
        Left = 26
        Top = 33
        Width = 189
        Height = 21
        Hint = 'eg: joe@camel.com'
        TabOrder = 0
        OnChange = OnAddressChange
      end
      object ckDefault: TCheckBox
        Left = 26
        Top = 75
        Width = 133
        Height = 19
        Caption = '&Default Account'
        TabOrder = 1
        Visible = False
        OnClick = OnDataChange
      end
    end
    object ctlAdvancedPage: TTabSheet
      Caption = '&Advanced'
      ImageIndex = 1
      object txtPopOrSmtp: TLabel
        Left = 33
        Top = 27
        Width = 97
        Height = 13
        Caption = 'Server/SMTP Name'
      end
      object txtUser: TLabel
        Left = 33
        Top = 76
        Width = 107
        Height = 13
        Caption = 'User/Authentication Id'
      end
      object txtPassword: TLabel
        Left = 33
        Top = 123
        Width = 46
        Height = 13
        Caption = 'Password'
      end
      object Image1: TImage
        Left = 285
        Top = 14
        Width = 32
        Height = 32
        AutoSize = True
        Picture.Data = {
          055449636F6E0000010002002020100000000000E80200002600000010101000
          00000000280100000E0300002800000020000000400000000100040000000000
          8002000000000000000000000000000000000000000000000000800000800000
          0080800080000000800080008080000080808000C0C0C0000000FF0000FF0000
          00FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000FFFFFFFFFFFFF
          0000000000000000000888888887676F0000000000000000000000000000066F
          0000000000000000FFFFFFFFFFFF076F0000000000000000FFFFFFF0000F066F
          0000000000000000FFF7FFF0990F08FF0000000000000000F7F7FFF0F90F08FF
          0000000008777770F7F7F7F0000F08FF077777700FB8B8B0F7F7F7FFFFFF08FF
          07B8B87008800000F7F7F7FFFFFF08FF00000B700FB007708787878888880788
          070008700880F070888888888888078800070B700FB0FF000000000000000000
          007808700880FFFF3F3F3F3F3F3F3F3F37870B700FB0FFF3F3F3F3F3F3F3F3F3
          F3780870088B0F3F3F3F3F3F3F3F3F3F3F308B700FB8B0000000000000000000
          0008B870088B8B8B8B8B8B8B8B8B8B8B8B8B8B700F8F8F8F8F8F8F8F8F8F8F8F
          8F8F8F8000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFC0007FFFC0007FFFC0007FFE00007FFE00007FFE00007FFE00007F00000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF280000001000000020000000
          0100040000000000C00000000000000000000000000000000000000000000000
          00008000008000000080800080000000800080008080000080808000C0C0C000
          0000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000
          00000000000000000000000000000000FF6F0000000000000006000000000FFF
          9F0F000000000F7F990F000008F80F7FFF0F08F00F0708788808008008800000
          000008F00F0F3F3F3F3F308008F8F8F8F8F8F8F0000000000000000000000000
          00000000000000000000000000000000000000000000000000000000FFFF0000
          FE070000FE070000F0070000F007000000000000000000000000000000000000
          000000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000}
        Transparent = True
      end
      object efServer: TEdit
        Left = 33
        Top = 45
        Width = 186
        Height = 21
        Hint = 'eg: camel.com or smtp.camel.com'
        TabOrder = 0
        OnChange = OnDataChange
      end
      object efUserId: TEdit
        Left = 33
        Top = 94
        Width = 186
        Height = 21
        Hint = 'eg: camel.com or smtp.camel.com'
        TabOrder = 1
        OnChange = OnDataChange
        OnKeyPress = OnUserIdKeyPress
      end
      object efPassword: TEdit
        Left = 33
        Top = 143
        Width = 186
        Height = 21
        Hint = 'eg: camel.com or smtp.camel.com'
        PasswordChar = '*'
        TabOrder = 2
        OnChange = OnDataChange
      end
    end
  end
end