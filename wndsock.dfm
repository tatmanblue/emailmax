object wndWinSockActivity: TwndWinSockActivity
  Left = 132
  Top = 91
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  ClientHeight = 77
  ClientWidth = 363
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = mnWinSockMenu
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ctlImagePanel: TPanel
    Left = 0
    Top = 0
    Width = 74
    Height = 75
    BevelOuter = bvNone
    TabOrder = 0
    object ctlImage: TAdvImage
      Left = 1
      Top = 1
      Width = 69
      Height = 72
      BevelWidth = 0
      GIFAnimate = False
      ShowFrame3D = True
      StretchRatio = True
      CenterView = True
      ShowEmptyLabel = False
      JPEGPixelFormat = jf24Bit
      JPEGScale = jsFullSize
      JPEGGrayscale = False
      JPEGPerformance = jpBestQuality
      JPEGSmoothing = True
      JPEGProgressiveEncoding = False
      JPEGCompressionQuality = 0
      JPEGProgressiveDisplay = True
      Checked = False
      CheckColor = clRed
      GifAnimateSpeed = 10
      EmptyLabel = 'Empty'
    end
  end
  object ctlReceivePanel: TPanel
    Left = 82
    Top = 3
    Width = 279
    Height = 23
    BevelOuter = bvNone
    Caption = '< not currently receiving mail >'
    TabOrder = 1
  end
  object ctlSendPanel: TPanel
    Left = 82
    Top = 30
    Width = 279
    Height = 23
    BevelOuter = bvNone
    Caption = '< not currently sending mail >'
    TabOrder = 2
  end
  object pbHide: TButton
    Left = 277
    Top = 55
    Width = 75
    Height = 21
    Caption = '&Hide'
    TabOrder = 3
    OnClick = pbHideClick
  end
  object ctlControl: TTimer
    Interval = 750
    OnTimer = ctlControlTimer
    Left = 3
    Top = 84
  end
  object mnWinSockMenu: TPopupMenu
    OnPopup = mnWinSockMenuPopup
    Left = 319
    object mnSockUndock: TMenuItem
      Caption = '&Undock'
      Visible = False
      OnClick = mnSockUndockClick
    end
    object Hide1: TMenuItem
      Caption = '&Hide'
      OnClick = pbHideClick
    end
  end
end
