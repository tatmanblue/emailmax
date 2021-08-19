inherited wndInbound: TwndInbound
  Left = 101
  Top = 40
  Hint = 'Shows all messages received'
  Caption = 'In -- mail received from your internet accounts'
  Menu = mnInbound
  PixelsPerInch = 96
  TextHeight = 13
  inherited ctlSplitter: TSplitter
    Top = 229
  end
  inherited pnlPreview: TPanel
    Top = 236
  end
  inherited pnlTop: TPanel
    Height = 229
    inherited ctlTop: TPanel
      Height = 41
      object txtAction: TLabel
        Left = 17
        Top = 7
        Width = 27
        Height = 13
        Caption = 'Task:'
      end
      object txtSending: TLabel
        Left = 47
        Top = 7
        Width = 462
        Height = 13
        AutoSize = False
      end
      object pbNow: TButton
        Left = 307
        Top = 0
        Width = 75
        Height = 25
        Caption = '&Check Mail'
        TabOrder = 0
        Visible = False
        OnClick = pbNowClick
      end
    end
    inherited ctlMessages: TListView
      Top = 41
      Height = 188
      Hint = 'List of messages received'
      PopupMenu = mnPopup
    end
  end
  inherited ctlIcons: TImageList
    Left = 542
    Top = 147
  end
  inherited ctlListViewIcons: TImageList
    Left = 513
    Top = 141
  end
  object ctlPop: TNMPOP3
    Port = 110
    TimeOut = 15000
    ReportLevel = 0
    OnInvalidHost = ctlPopInvalidHost
    OnStatus = ctlPopStatus
    OnConnectionFailed = ctlPopConnectionFailed
    OnConnectionRequired = ctlPopConnectionRequired
    Parse = False
    DeleteOnRead = False
    OnAuthenticationNeeded = ctlPopAuthenticationNeeded
    OnAuthenticationFailed = ctlPopAuthenticationFailed
    Left = 478
    Top = 144
  end
  object mnInbound: TMainMenu
    AutoMerge = True
    Left = 371
    Top = 60
    object mnReceived: TMenuItem
      Caption = '&In'
      GroupIndex = 23
      object mnReceivedCheckMail: TMenuItem
        Caption = '&Check Mail'
        ShortCut = 16459
        OnClick = mnReceivedCheckMailClick
      end
      object mnReceivedStopMail: TMenuItem
        Caption = '&Stop Receiving Mail'
        Enabled = False
        OnClick = mnReceivedStopMailClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnReceivedOpen: TMenuItem
        Caption = '&Open'
        OnClick = mnReceivedOpenClick
      end
      object mnReceivedDelete: TMenuItem
        Caption = '&Delete'
        OnClick = mnReceivedDeleteClick
      end
      object N1: TMenuItem
        Caption = '-'
        Enabled = False
      end
      object mnReceivedMoveTo: TMenuItem
        Caption = '&Move To...'
        OnClick = OnMoveMessage
      end
    end
  end
  object mnPopup: TPopupMenu
    Left = 280
    Top = 102
    object mnPopupOpen: TMenuItem
      Caption = '&Open'
      OnClick = mnReceivedOpenClick
    end
    object mnPopDelete: TMenuItem
      Caption = '&Delete'
      OnClick = mnReceivedDeleteClick
    end
    object mnPopMoveTo: TMenuItem
      Caption = '&Move To...'
      OnClick = OnMoveMessage
    end
    object mnPopupPrint: TMenuItem
      Caption = '&Print'
      OnClick = mnPopupPrintClick
    end
    object mnPopupPreview: TMenuItem
      Caption = 'Pre&view'
      OnClick = mnPopupPreviewClick
    end
  end
end
