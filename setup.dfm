object dlgSetup: TdlgSetup
  Left = 93
  Top = 100
  BorderStyle = bsDialog
  Caption = 'Emailmax 2000 Setup'
  ClientHeight = 335
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 301
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object ctlPages: TPageControl
      Left = 5
      Top = 5
      Width = 431
      Height = 291
      ActivePage = ctlSpam
      Align = alClient
      HotTrack = True
      TabOrder = 0
      OnChange = ctlPagesChange
      object ctlSendingMail: TTabSheet
        Hint = 'Sets up '#39'how to send email'#39
        Caption = '&Sending Mail'
        object Label2: TLabel
          Left = 10
          Top = 21
          Width = 251
          Height = 13
          Caption = 'With these accounts, you will be able to SEND email:'
        end
        object pbSendNew: TButton
          Left = 7
          Top = 240
          Width = 60
          Height = 17
          Hint = 'Create a new entry'
          Caption = '&New'
          TabOrder = 0
          OnClick = pbSendNewClick
        end
        object pbSendEdit: TButton
          Left = 73
          Top = 240
          Width = 60
          Height = 17
          Hint = 'Edit the selected entry (from above)'
          Caption = '&Edit'
          TabOrder = 1
          OnClick = pbSendEditClick
        end
        object pbSendDelete: TButton
          Left = 137
          Top = 240
          Width = 60
          Height = 17
          Hint = 'Delete the selected entry (from above)'
          Caption = '&Delete'
          TabOrder = 2
          OnClick = pbSendDeleteClick
        end
        object ctlSend: TListView
          Left = 7
          Top = 41
          Width = 383
          Height = 194
          Hint = 'Email addresses'
          Columns = <
            item
              Caption = 'Email Address'
              Width = 175
            end
            item
              Caption = 'SMTP Name'
              Width = 150
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
          TabOrder = 3
          ViewStyle = vsReport
          OnDblClick = ctlSendDblClick
        end
        object pbSendUp: TButton
          Left = 392
          Top = 107
          Width = 27
          Height = 25
          Caption = '&Up'
          TabOrder = 4
          OnClick = pbSendUpClick
        end
        object pbSendDown: TButton
          Left = 392
          Top = 133
          Width = 27
          Height = 25
          Caption = '&Dn'
          TabOrder = 5
          OnClick = pbSendDownClick
        end
      end
      object ctlRecvMail: TTabSheet
        Hint = 'Sets up '#39'How to receive email'#39
        Caption = '&Receiving Mail'
        object Label1: TLabel
          Left = 10
          Top = 21
          Width = 267
          Height = 13
          Caption = 'With these accounts, you will be able to RECEIVE email:'
        end
        object pbRecvNew: TButton
          Left = 7
          Top = 240
          Width = 60
          Height = 17
          Hint = 'Create a new entry'
          Caption = '&New'
          TabOrder = 0
          OnClick = pbRecvNewClick
        end
        object pbRecvEdit: TButton
          Left = 73
          Top = 240
          Width = 60
          Height = 17
          Hint = 'Edit the selected entry (from above)'
          Caption = '&Edit'
          TabOrder = 1
          OnClick = pbRecvEditClick
        end
        object pbRecvDelete: TButton
          Left = 137
          Top = 240
          Width = 60
          Height = 17
          Hint = 'Delete the selected entry (from above)'
          Caption = '&Delete'
          TabOrder = 2
          OnClick = pbRecvDeleteClick
        end
        object ctlRecv: TListView
          Left = 7
          Top = 41
          Width = 384
          Height = 194
          Columns = <
            item
              Caption = 'Email Address'
              Width = 200
            end
            item
              Caption = 'POP Name'
              Width = 175
            end
            item
              Caption = 'Index'
              Width = 0
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 3
          ViewStyle = vsReport
          OnDblClick = ctlRecvDblClick
        end
        object pbRecvUp: TButton
          Left = 392
          Top = 107
          Width = 27
          Height = 25
          Caption = '&Up'
          TabOrder = 4
          OnClick = pbRecvUpClick
        end
        object pbRecvDown: TButton
          Left = 392
          Top = 133
          Width = 27
          Height = 25
          Caption = '&Dn'
          TabOrder = 5
          OnClick = pbRecvDownClick
        end
      end
      object ctlSpam: TTabSheet
        Hint = 'Define custom folders/baskets'
        Caption = 'Spa&minator'
        OnShow = ctlSpamShow
        object pnlSpam: TPanel
          Left = 0
          Top = 0
          Width = 423
          Height = 263
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
      object ctlPrefs: TTabSheet
        Hint = 'Determine your perferences'
        Caption = '&Preferences'
        object lblEvery: TLabel
          Left = 56
          Top = 196
          Width = 27
          Height = 13
          Caption = 'Every'
          Enabled = False
        end
        object lblMinutes: TLabel
          Left = 145
          Top = 197
          Width = 39
          Height = 13
          Caption = 'minutes.'
          Enabled = False
        end
        object ckTooltips: TCheckBox
          Left = 18
          Top = 28
          Width = 115
          Height = 16
          Caption = 'Show &Tool Tips'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
        end
        object ckEmptyTrashOnExit: TCheckBox
          Left = 18
          Top = 150
          Width = 373
          Height = 12
          Caption = '&Automatically empty Trash Basket on program exit'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object ckMaximize: TCheckBox
          Left = 18
          Top = 124
          Width = 373
          Height = 15
          Caption = 'Ma&ximize each window when opened'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object ckShowFolders: TCheckBox
          Left = 18
          Top = 53
          Width = 373
          Height = 15
          Caption = '&Show the Toolbar'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object ckQuickBar: TCheckBox
          Left = 18
          Top = 79
          Width = 373
          Height = 15
          Caption = 'Show the &Quickbar'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object rbAttachments: TRadioGroup
          Left = 257
          Top = 7
          Width = 144
          Height = 65
          Caption = 'Attachment Encoding'
          ItemIndex = 0
          Items.Strings = (
            'M&ime'
            '&UUEncode/Decode')
          TabOrder = 5
        end
        object ckAutoCheckEmail: TCheckBox
          Left = 18
          Top = 175
          Width = 154
          Height = 17
          Caption = 'Automatically &Check Email '
          TabOrder = 6
          OnClick = ckAutoCheckEmailClick
        end
        object pbMinSpinner: TUpDown
          Left = 127
          Top = 193
          Width = 12
          Height = 21
          Associate = efCheckMailMins
          Enabled = False
          Min = 0
          Position = 0
          TabOrder = 7
          Wrap = False
        end
        object efCheckMailMins: TEdit
          Left = 87
          Top = 193
          Width = 40
          Height = 21
          Enabled = False
          TabOrder = 8
          Text = '0'
        end
        object ckShowPreview: TCheckBox
          Left = 18
          Top = 101
          Width = 373
          Height = 15
          Caption = 'Show the &Preview Pane'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
      end
      object ctlSecurity: TTabSheet
        Caption = 'Se&curity'
        ImageIndex = 6
        object txtPassword: TLabel
          Left = 13
          Top = 50
          Width = 46
          Height = 13
          Caption = 'Password'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object txtConfirm: TLabel
          Left = 189
          Top = 50
          Width = 35
          Height = 13
          Caption = 'Confirm'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object ckRequireSysPass: TCheckBox
          Left = 17
          Top = 18
          Width = 146
          Height = 17
          Caption = '&Require System Password'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ckRequireSysPassClick
        end
        object efPassword: TEdit
          Left = 67
          Top = 46
          Width = 107
          Height = 21
          Enabled = False
          PasswordChar = '*'
          TabOrder = 1
        end
        object efConfirm: TEdit
          Left = 243
          Top = 46
          Width = 107
          Height = 21
          Enabled = False
          PasswordChar = '*'
          TabOrder = 2
        end
        object ckOnStartup: TCheckBox
          Left = 60
          Top = 77
          Width = 97
          Height = 17
          Caption = 'On &Start Up'
          Enabled = False
          TabOrder = 3
        end
        object ckOnSend: TCheckBox
          Left = 151
          Top = 77
          Width = 97
          Height = 17
          Caption = 'On Send &Mail'
          Enabled = False
          TabOrder = 4
        end
        object ckOnCheck: TCheckBox
          Left = 242
          Top = 77
          Width = 97
          Height = 17
          Caption = 'On &Check Mail'
          Enabled = False
          TabOrder = 5
        end
      end
      object ctlEncrypt: TTabSheet
        Hint = 'Sets up Encryption'
        Caption = '&Encryption'
        object Label12: TLabel
          Left = 18
          Top = 26
          Width = 156
          Height = 13
          Caption = 'Working Directory for Encryption:'
        end
        object efWorkingPath: TEdit
          Left = 194
          Top = 21
          Width = 173
          Height = 21
          Hint = 'A directory for tempory files (eg: c:\temp\)'
          TabOrder = 0
        end
        object GroupBox2: TGroupBox
          Left = 14
          Top = 54
          Width = 386
          Height = 73
          Caption = 'PGP'
          TabOrder = 1
          object Label11: TLabel
            Left = 10
            Top = 21
            Width = 136
            Height = 13
            Caption = 'Path to the PGP Executable:'
          end
          object Label13: TLabel
            Left = 11
            Top = 46
            Width = 97
            Height = 13
            Caption = 'Default Signature Id:'
          end
          object efPGPPath: TEdit
            Left = 182
            Top = 14
            Width = 172
            Height = 21
            Hint = 'Directory PGP.EXE is installed'
            TabOrder = 0
          end
          object efPGPSigId: TEdit
            Left = 182
            Top = 40
            Width = 172
            Height = 21
            Hint = 'default PGP Id for signing messages'
            TabOrder = 1
          end
          object pbPgpBrowse: TButton
            Left = 356
            Top = 13
            Width = 22
            Height = 22
            Caption = '...'
            TabOrder = 2
            OnClick = pbPgpBrowseClick
          end
        end
        object GroupBox3: TGroupBox
          Left = 14
          Top = 134
          Width = 386
          Height = 66
          Caption = 'Ceasar'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object Label14: TLabel
            Left = 11
            Top = 19
            Width = 88
            Height = 13
            Caption = 'Default Key Value:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object efCeaserDefault: TEdit
            Tag = 64
            Left = 182
            Top = 16
            Width = 66
            Height = 21
            Hint = 'A default letter for Caesar encryption'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 0
            Text = 'A'
          end
          object ctlCeaserChg: TUpDown
            Left = 248
            Top = 17
            Width = 13
            Height = 19
            Min = 32
            Max = 126
            Position = 64
            TabOrder = 1
            Wrap = False
            OnClick = ctlCeaserChgClick
          end
          object ckCaesarIncludeNum: TCheckBox
            Left = 11
            Top = 40
            Width = 278
            Height = 17
            Caption = 'Include Numbers 0 - 9 in Ceasar Sequence'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Visible = False
          end
        end
        object GroupBox4: TGroupBox
          Left = 14
          Top = 202
          Width = 386
          Height = 51
          Caption = 'Beal'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Visible = False
          object Label15: TLabel
            Left = 11
            Top = 23
            Width = 126
            Height = 13
            Caption = 'Default Source Document:'
            Enabled = False
          end
          object efBealDefault: TEdit
            Left = 179
            Top = 18
            Width = 172
            Height = 21
            Hint = 'Default file to use for Beal codes'
            Enabled = False
            TabOrder = 0
          end
        end
        object pbBrowse: TButton
          Left = 369
          Top = 20
          Width = 22
          Height = 22
          Caption = '...'
          TabOrder = 4
          OnClick = pbBrowseClick
        end
      end
      object ctlNewsgroups: TTabSheet
        Caption = '&Newsgroups'
        OnShow = ctlNewsgroupsShow
        object pnlNewsgroups: TPanel
          Left = 0
          Top = 0
          Width = 423
          Height = 263
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 301
    Width = 441
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 187
      Top = 2
      Width = 75
      Height = 25
      Hint = 'Close the window, accepting your changes'
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TButton
      Left = 267
      Top = 2
      Width = 75
      Height = 25
      Hint = 'Close the window, losing any changes made'
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TButton
      Left = 347
      Top = 2
      Width = 75
      Height = 25
      Hint = 'Open help for this window'
      Caption = '&Help'
      TabOrder = 2
      OnClick = HelpBtnClick
    end
  end
  object ctlDirTree: TOpenDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofNoValidate, ofPathMustExist, ofEnableSizing]
    Left = 59
    Top = 296
  end
end
