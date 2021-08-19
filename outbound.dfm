inherited wndOutbound: TwndOutbound
  Left = 40
  Top = 73
  Height = 412
  Caption = 'Out -- email to send'
  Menu = mnOutbound
  PopupMenu = mnOutPopUp
  PixelsPerInch = 96
  TextHeight = 13
  inherited ctlSplitter: TSplitter
    Top = 259
  end
  object pbNow: TButton [1]
    Left = 373
    Top = 28
    Width = 75
    Height = 25
    Caption = '&Send Now'
    TabOrder = 2
    OnClick = pbNowClick
  end
  inherited pnlPreview: TPanel
    Top = 266
    Height = 100
    inherited ctrlPreviewBody: TMemo
      Height = 59
    end
  end
  inherited pnlTop: TPanel
    Height = 259
    inherited ctlTop: TPanel
      Height = 42
      object txtAction: TLabel
        Left = 17
        Top = 7
        Width = 24
        Height = 13
        Caption = 'Task'
      end
      object efSending: TEdit
        Left = 92
        Top = 6
        Width = 406
        Height = 17
        TabStop = False
        BorderStyle = bsNone
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = 'Idle'
      end
      object pbSend: TButton
        Left = 325
        Top = 2
        Width = 91
        Height = 25
        Caption = '&Send Mail'
        TabOrder = 1
        Visible = False
        OnClick = pbNowClick
      end
    end
    inherited ctlMessages: TListView
      Top = 42
      Height = 217
      Columns = <
        item
          Caption = 'To'
        end
        item
          Caption = 'Subject'
          Width = 250
        end
        item
          Caption = 'Account'
          Width = 75
        end>
    end
  end
  object ctlStartup: TTimer
    Enabled = False
    OnTimer = ctlStartupTimer
    Left = 140
    Top = 310
  end
  object mnOutbound: TMainMenu
    AutoMerge = True
    Left = 341
    Top = 44
    object mnOutboundMenu: TMenuItem
      Caption = '&Out'
      GroupIndex = 18
      object mnOutSendNow: TMenuItem
        Caption = '&Send Mail'
        ShortCut = 16461
        OnClick = mnOutSendNowClick
      end
      object mnOutStopSendingMail: TMenuItem
        Caption = 'Sto&p Sending Mail'
        Enabled = False
        OnClick = mnOutStopSendingMailClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnOutEdit: TMenuItem
        Caption = '&Open'
        OnClick = mnOutEditClick
      end
      object mnOutDelete: TMenuItem
        Caption = '&Delete'
        OnClick = mnOutDeleteClick
      end
      object mnOutMove: TMenuItem
        Caption = '&Move To...'
        OnClick = OnMessageMove
      end
    end
  end
  object ctlSMTP: TNMSMTP
    Port = 25
    TimeOut = 35000
    ReportLevel = 0
    OnInvalidHost = ctlSMTPInvalidHost
    OnConnectionFailed = ctlSMTPConnectionFailed
    PostMessage.LocalProgram = 'Emailmax 2K'
    FinalHeader.Strings = (
      'X-Copyright -- copyright (c) 1998 by microObjects inc.'
      'X-Website -- www.microobjects.com')
    EncodeType = uuMime
    ClearParams = True
    SubType = mtPlain
    Charset = 'us-ascii'
    OnRecipientNotFound = ctlSMTPRecipientNotFound
    OnSuccess = ctlSMTPSuccess
    OnFailure = ctlSMTPFailure
    OnAuthenticationFailed = ctlSMTPAuthenticationFailed
    Left = 279
    Top = 24
  end
  object mnOutPopUp: TPopupMenu
    Left = 292
    Top = 130
    object mnPopSendNow: TMenuItem
      Caption = '&Send Mail'
      ShortCut = 16461
      OnClick = pbNowClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnPopOpen: TMenuItem
      Caption = '&Open'
      OnClick = mnOutEditClick
    end
    object mnPopPrint: TMenuItem
      Caption = '&Print'
      OnClick = mnPopPrintClick
    end
    object mnPopPreview: TMenuItem
      Caption = 'Pre&view'
      OnClick = mnPopPreviewClick
    end
    object mnPopMove: TMenuItem
      Caption = '&Move To...'
      OnClick = OnMessageMove
    end
    object mnPopDelete: TMenuItem
      Caption = '&Delete'
      OnClick = mnOutDeleteClick
    end
  end
end
