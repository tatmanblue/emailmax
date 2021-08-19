object wndNewMail: TwndNewMail
  Left = 4
  Top = 108
  BorderIcons = []
  BorderStyle = bsToolWindow
  BorderWidth = 3
  ClientHeight = 165
  ClientWidth = 167
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object ctlImage: TAdvImage
    Left = 0
    Top = 0
    Width = 160
    Height = 145
    Color = clWhite
    ParentColor = False
    ImageName = 'c:\program files\emailmax2k\newmail.jpg'
    BevelWidth = 1
    GIFAnimate = False
    ShowFrame3D = False
    StretchRatio = True
    CenterView = False
    ShowEmptyLabel = False
    JPEGPixelFormat = jf24Bit
    JPEGScale = jsFullSize
    JPEGGrayscale = False
    JPEGPerformance = jpBestQuality
    JPEGSmoothing = True
    JPEGProgressiveEncoding = False
    JPEGCompressionQuality = 0
    JPEGProgressiveDisplay = False
    Checked = False
    CheckColor = clRed
    GifAnimateSpeed = 10
    EmptyLabel = 'Empty'
  end
  object lblClose: TLabel
    Left = 69
    Top = 146
    Width = 91
    Height = 13
    Cursor = crHandPoint
    Caption = 'Close This Window'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    OnClick = lblCloseClick
  end
  object Label1: TLabel
    Left = 80
    Top = 23
    Width = 72
    Height = 60
    Caption = 'New Mail Has Arrived'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object ctrlTimer: TTimer
    Interval = 20
    OnTimer = ctrlTimerTimer
    Left = 4
    Top = 150
  end
end
