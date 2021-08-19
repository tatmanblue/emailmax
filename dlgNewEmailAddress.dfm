object NewEmailAddress: TNewEmailAddress
  Left = 136
  Top = 141
  HelpContext = 4101
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'New Email Address'
  ClientHeight = 292
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 12
    Top = 7
    Width = 325
    Height = 13
    Caption = 
      'Please enter the information you wish for another address book e' +
      'ntry:'
  end
  object cmdOK: TButton
    Left = 217
    Top = 257
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 294
    Top = 257
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object ctlPages: TPageControl
    Left = 7
    Top = 28
    Width = 352
    Height = 218
    HelpContext = 4101
    ActivePage = pageAdditional
    TabOrder = 0
    object pageGeneral: TTabSheet
      HelpContext = 4101
      Caption = '&General'
      object Label1: TLabel
        Left = 17
        Top = 29
        Width = 28
        Height = 13
        Caption = 'Name'
      end
      object Label3: TLabel
        Left = 17
        Top = 53
        Width = 53
        Height = 13
        Caption = 'Nick Name'
      end
      object Label4: TLabel
        Left = 16
        Top = 96
        Width = 25
        Height = 13
        Caption = 'Email'
      end
      object Label7: TLabel
        Left = 16
        Top = 123
        Width = 31
        Height = 13
        Caption = 'Phone'
      end
      object efFullName: TEdit
        Left = 76
        Top = 22
        Width = 208
        Height = 21
        TabOrder = 0
        OnChange = efFullNameChange
        OnExit = efFullNameExit
      end
      object efNick: TEdit
        Left = 76
        Top = 47
        Width = 208
        Height = 21
        TabOrder = 1
      end
      object efEmail1: TEdit
        Left = 76
        Top = 90
        Width = 208
        Height = 21
        TabOrder = 2
      end
      object efPhone1: TEdit
        Left = 76
        Top = 117
        Width = 208
        Height = 21
        TabOrder = 3
      end
    end
    object pageAddress: TTabSheet
      HelpContext = 4102
      Caption = '&Address'
      ImageIndex = 1
      object Label11: TLabel
        Left = 6
        Top = 31
        Width = 29
        Height = 13
        Caption = 'Line 1'
      end
      object Label12: TLabel
        Left = 6
        Top = 56
        Width = 29
        Height = 13
        Caption = 'Line 2'
      end
      object Label13: TLabel
        Left = 6
        Top = 81
        Width = 29
        Height = 13
        Caption = 'Line 3'
      end
      object Label14: TLabel
        Left = 6
        Top = 107
        Width = 17
        Height = 13
        Caption = 'City'
      end
      object Label15: TLabel
        Left = 6
        Top = 134
        Width = 25
        Height = 13
        Caption = 'State'
      end
      object Label16: TLabel
        Left = 169
        Top = 133
        Width = 49
        Height = 13
        Caption = 'Zip/Postal'
      end
      object Label17: TLabel
        Left = 7
        Top = 161
        Width = 36
        Height = 13
        Caption = 'Country'
      end
      object efAddress1: TEdit
        Left = 42
        Top = 26
        Width = 286
        Height = 21
        TabOrder = 0
      end
      object efAddress2: TEdit
        Left = 42
        Top = 51
        Width = 286
        Height = 21
        TabOrder = 1
      end
      object efAddress3: TEdit
        Left = 42
        Top = 76
        Width = 286
        Height = 21
        TabOrder = 2
      end
      object efCity: TEdit
        Left = 42
        Top = 102
        Width = 286
        Height = 21
        TabOrder = 3
      end
      object efState: TEdit
        Left = 42
        Top = 129
        Width = 121
        Height = 21
        TabOrder = 4
      end
      object efZip: TEdit
        Left = 223
        Top = 130
        Width = 106
        Height = 21
        TabOrder = 5
      end
      object efCountry: TEdit
        Left = 50
        Top = 157
        Width = 175
        Height = 21
        TabOrder = 6
      end
    end
    object pageAdditional: TTabSheet
      HelpContext = 4103
      Caption = 'More &Info'
      ImageIndex = 2
      object Label5: TLabel
        Left = 12
        Top = 124
        Width = 41
        Height = 13
        Caption = 'Email #2'
      end
      object Label2: TLabel
        Left = 12
        Top = 149
        Width = 41
        Height = 13
        Caption = 'Email #3'
      end
      object Label8: TLabel
        Left = 12
        Top = 64
        Width = 47
        Height = 13
        Caption = 'Phone #2'
      end
      object Label9: TLabel
        Left = 12
        Top = 90
        Width = 47
        Height = 13
        Caption = 'Phone #3'
      end
      object Label10: TLabel
        Left = 13
        Top = 16
        Width = 28
        Height = 13
        Caption = 'Notes'
      end
      object efEmail2: TEdit
        Left = 71
        Top = 119
        Width = 252
        Height = 21
        TabOrder = 3
      end
      object efEmail3: TEdit
        Left = 71
        Top = 144
        Width = 252
        Height = 21
        TabOrder = 4
      end
      object efPhone2: TEdit
        Left = 72
        Top = 58
        Width = 208
        Height = 21
        TabOrder = 1
      end
      object efPhone3: TEdit
        Left = 72
        Top = 84
        Width = 208
        Height = 21
        TabOrder = 2
      end
      object efNotes: TEdit
        Left = 71
        Top = 10
        Width = 255
        Height = 21
        TabOrder = 0
      end
    end
  end
  object cmdEdit: TButton
    Left = 7
    Top = 257
    Width = 75
    Height = 25
    Caption = '&Edit'
    TabOrder = 3
    Visible = False
    OnClick = cmdEditClick
  end
end
