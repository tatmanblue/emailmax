object dlgSpamControl: TdlgSpamControl
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Spam Control and Filters'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pbOK: TButton
    Left = 151
    Top = 182
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object pbCancel: TButton
    Left = 231
    Top = 181
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
end
