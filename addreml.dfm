object dlgAddRemailer: TdlgAddRemailer
  Left = 221
  Top = 137
  BorderStyle = bsDialog
  Caption = 'Add a Remailer'
  ClientHeight = 209
  ClientWidth = 234
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
    Left = 13
    Top = 10
    Width = 180
    Height = 13
    Caption = 'Remailers work just like sending email.'
  end
  object Label2: TLabel
    Left = 25
    Top = 41
    Width = 73
    Height = 13
    Caption = 'Remail Address'
  end
  object Label3: TLabel
    Left = 25
    Top = 87
    Width = 97
    Height = 13
    Caption = 'Server/SMTP Name'
  end
  object pbOK: TButton
    Left = 72
    Top = 174
    Width = 75
    Height = 25
    Hint = 'Close the window, accepting your changes'
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object pbCancel: TButton
    Left = 148
    Top = 174
    Width = 75
    Height = 25
    Hint = 'Close the window, losing any changes made'
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object efSendAddress: TEdit
    Left = 25
    Top = 58
    Width = 191
    Height = 21
    Hint = 'eg: joe@camel.com'
    TabOrder = 0
    OnChange = OnSendAddressChange
  end
  object efSendServer: TEdit
    Left = 25
    Top = 105
    Width = 191
    Height = 21
    Hint = 'eg: camel.com or smtp.camel.com'
    TabOrder = 1
    OnChange = OnDataChange
  end
  object ckDefault: TCheckBox
    Left = 26
    Top = 140
    Width = 144
    Height = 15
    Caption = '&Default Remailer'
    TabOrder = 4
  end
end
