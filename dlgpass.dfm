object dlgPassword: TdlgPassword
  Left = 250
  Top = 105
  Width = 350
  Height = 152
  Caption = 'Enter Password'
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
  object txtLogon: TLabel
    Left = 18
    Top = 10
    Width = 126
    Height = 13
    Caption = 'Emailmax 2K Security:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 18
    Top = 68
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object txtAction: TLabel
    Left = 18
    Top = 28
    Width = 3
    Height = 13
  end
  object txtAttempts: TLabel
    Left = 18
    Top = 98
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 18
    Top = 43
    Width = 297
    Height = 13
    Caption = 'Emailmax requires you to enter a password in order to continue:'
  end
  object efPassword: TEdit
    Left = 79
    Top = 62
    Width = 238
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnChange = efPasswordChange
  end
  object pbOK: TButton
    Left = 162
    Top = 93
    Width = 75
    Height = 25
    Hint = 'Close the window, accepting your changes'
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = pbOKClick
  end
  object pbCancel: TButton
    Left = 242
    Top = 93
    Width = 75
    Height = 25
    Hint = 'Close the window, losing any changes made'
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
