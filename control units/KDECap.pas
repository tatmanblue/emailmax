{***************************************************************}
{* KDE Caption                                                 *}
{*-------------------------------------------------------------*}
{* Authors: Chen Ken (MarsCaption)                             *}
{*                  chenken@public1.ptt.js.cn                  *}
{*                  www.nease.net/~marspark                    *}
{*          Kenneth Paul Evans Jr (KDECaption)                 *}
{*                  kenneth.evans@base.com.br                  *}
{*                  www.geocities.com/Area51/6689              *}
{*-------------------------------------------------------------*}
{* Created:  1997.11.2                                         *}
{*-------------------------------------------------------------*}
{* Modified:                                                   *}
{*   1997.11.3  - Version 1.01                                 *}
{*      Bug fixed:                                             *}
{*      1. TextRect Calculate Error when no buttons in caption *}
{*         bar.                                                *}
{*      2. Incorrect drawing  menu icon when dialog box        *}
{*      3. Incorrect size window when minimize or maximize     *}
{*         button not avaiable                                 *}
{*   1997.11.4  - Version 1.02                                 *}
{*     Big bug fixed!                                          *}
{*      1. Destroy message not transparent                     *}
{*   1997.11.5  - Version 1.03                                 *}
{*      1. Now can draw tool windows' system buttons           *}
{*      2. Now can draw disabled minimize and maximize box     *}
{*   1997.11.28 - Version 1.04                                 *}
{*      1. Fix bug of set form's caption, this component can   *}
{*         not repaint caption                                 *}
{*   1997.11.29 - Version 1.05                                 *}
{*      1. Fix bug of MDIChild form with edit control, it can  *}
{*         not focus edit control with mouse click!            *}
{*   1997.11.30 - Version 1.06                                 *}
{*      1. Fix bug of MDIChild form with initial maximized     *}
{*         state.                                              *}
{*   1999.01.31 - Renamed to KDECap                            *}
{*      1. Add hability to use bitmaps for active and inactive *}
{*         states.                                             *}
{*                                                             *}
{***************************************************************}

unit KDECap;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Buttons,
  Math;

type
  TKDECaptionSystemButtonKind = (sbClose, sbMinimize, sbMaximize, sbHelp, sbPin);

  TKDECaptionSystemButton = class(TSpeedButton)
  private
    FParentForm: TForm;
    FDown: Boolean;
    FDragging: Boolean;
    FKind: TKDECaptionSystemButtonKind;
    FDLeft, FDTop, FDWidth, FDHeight: Integer;
    FHBitmap1, FHBitmap2: Integer;
    
    procedure SetKind(Value: TKDECaptionSystemButtonKind);
    procedure SetDLeft(Value: Integer);
    procedure SetDTop(Value: Integer);
    procedure SetDWidth(Value: Integer);
    procedure SetDHeight(Value: Integer);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                        X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                      X, Y: Integer); override;

    procedure SystemButtonClick(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Draw(DC: HDC);

    property Kind: TKDECaptionSystemButtonKind read FKind write SetKind;
    property DLeft: Integer read FDLeft write SetDLeft;
    property DTop: Integer read FDTop write SetDTop;
    property DWidth: Integer read FDWidth write SetDWidth;
    property DHeight: Integer read FDHeight write SetDHeight;
    end;

  TKDECaption = class(TComponent)
  private
    FOldStyle: LongInt;
    FParentIcons: TBorderIcons;
    FParentForm: TForm;
    FParentHandle: THandle;
    FOldWindowProc: TFarProc;
    FNewWindowProc: Pointer;
{$IFNDEF VER90} {$IFNDEF VER93}
    FOldFormWindowProc: TWndMethod;         { 1997.11.28  Version 1.04 }
{$ENDIF} {$ENDIF}
    FActiveBeginColor, FActiveEndColor: TColor;
    FInactiveBeginColor, FInactiveEndColor: TColor;
    FActiveFontColor, FInactiveFontColor: TColor;
    FApplicationName: String;
{$IFNDEF VER90} {$IFNDEF VER93}
    FCaption: String;   { 1997.11.28  Version 1.04 }
{$ENDIF} {$ENDIF}
    FApplicationNameFont: TFont;
    FCaptionFont: TFont;
    FAutoSize: Boolean;

    FNumColors: Integer;

    FCloseButton, FMinimizeButton,
    FMaximizeButton, FHelpButton, FPinButton: TKDECaptionSystemButton;

    FCaptionRect, FMenuIconRect, FSystemButtonsRect, FTextRect: TRect;
    FParentBorderStyle: TFormBorderStyle;
    FSystemButtons: TBorderIcons;
    FBorderHeight, FBorderWidth, FCaptionHeight: Integer;

    FRButtonCaptionDown: Boolean;
    FLButtonMenuDownTick: DWORD;
    FLButtonIconicCaptionDown: Boolean;
    FIconicWindowMove: Boolean;
    FLButtonIconicCaptionDownPos: TPoint;
    FLButtonIconicCaptionDownRect: TRect;
    FLastPos: TPoint;

    FActiveBitmap: TBitmap;
    FInactiveBitmap: TBitmap;
    FUseBitmaps: boolean;

    FPinButtonVisible: boolean;

    procedure WMNCActivate(var Msg: TWMNCActivate);
    procedure WMActivate(var Msg: TWMActivate);
    procedure WMNCMouseMessages(var Msg: TMessage);
    procedure WMNCPaint(var Msg: TMessage);
    procedure WMDestroy(var Msg: TMessage);
    procedure WMCommand(var Msg: TMessage);
    procedure WMLButtonUp(var Msg: TWMLButtonUp);
    procedure WMMouseMove(var Msg: TWMMouseMove);
    procedure CallOldWindowProc(var Msg: TMessage);
    procedure MarsCaptionWindowProc(var Msg: TMessage);
    procedure MarsGetMenu(var M: HMenu);

    function WindowIsActive: Boolean;
    procedure PaintBackGround(DC: HDC; Active: Boolean);
    procedure PaintMenuIcon(DC: HDC);
    procedure PaintTitle(DC: HDC; Active: Boolean);
    procedure Paint(Active: Boolean);


    procedure SetActiveBeginColor(Value: TColor);
    procedure SetActiveEndColor(Value: TColor);
    procedure SetInactiveBeginColor(Value: TColor);
    procedure SetInactiveEndColor(Value: TColor);
    procedure SetActiveFontColor(Value: TColor);
    procedure SetInactiveFontColor(Value: TColor);
    procedure SetApplicationName(Value: String);
    procedure SetApplicationNameFont(Value: TFont);
    procedure SetCaptionFont(Value: TFont);
    procedure SetAutoSize(Value: Boolean);
    procedure SetNumColors(Value: Integer);

    { 1997.11.28  Version 1.04}
{$IFNDEF VER90} {$IFNDEF VER93}
    procedure MarsCaptionFormWindowProc(var Message: TMessage);
{$ENDIF} {$ENDIF}
    { Begin 1997.11.30  Version 1.06}
    procedure RestoreSysmenuStyle;
    procedure DeleteSysmenuStyle;
    { End 1997.11.30  Version 1.06}

    procedure CalculateCaption;

    procedure SetActiveBitmap(Value: TBitmap);
    procedure SetInactiveBitmap(Value: TBitmap);
  protected
    procedure HookWindowProc;
    procedure UnHookWindowProc;
    procedure Loaded; override;

    property OldWindowProc: TFarProc read FOldWindowProc;
    property NewWindowProc: Pointer read FNewWindowProc;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Repaint;

  published
    property ActiveBeginColor: TColor read FActiveBeginColor write SetActiveBeginColor;
    property ActiveEndColor: TColor read FActiveEndColor write SetActiveEndColor;
    property ActiveFontColor: TColor read FActiveFontColor write SetActiveFontColor;
    property InactiveBeginColor: TColor read FInactiveBeginColor write SetInactiveBeginColor;
    property InactiveEndColor: TColor read FInactiveEndColor write SetInactiveEndColor;
    property InactiveFontColor: TColor read FInactiveFontColor write SetInactiveFontColor;
    property ApplicationName: String read FApplicationName write SetApplicationName;
    property ApplicationNameFont: TFont read FApplicationNameFont write SetApplicationNameFont;
    property CaptionFont: TFont read FCaptionFont write SetCaptionFont;
    property NumColors: Integer read FNumColors write SetNumColors;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;

    property ActiveBitmap: TBitmap read FActiveBitmap write SetActiveBitmap;
    property InactiveBitmap: TBitmap read FInactiveBitmap write SetInactiveBitmap;
    property UseBitmaps: boolean read FUseBitmaps write FUseBitmaps;

    property PinButton: boolean read FPinButtonVisible write FPinButtonVisible default false; 
  end;

procedure Register;

implementation

{$R kdecapbt.res}

constructor TKDECaptionSystemButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParentForm := TKDECaption(AOwner).FParentForm;
  FKind := sbClose;
  FDragging := False;
  Visible := False;
  Left := 0;
  Top := 0;
  Width := 0;
  Height := 0;
  OnClick := SystemButtonClick;
end;

procedure TKDECaptionSystemButton.SetKind(Value: TKDECaptionSystemButtonKind);
begin
  if FKind <> Value then
    begin
    FKind := Value;
    Paint;
    end;
end;

procedure TKDECaptionSystemButton.SetDLeft(Value: Integer);
begin
  if FDLeft <> Value then
    begin
    FDLeft := Value;
    end;
end;

procedure TKDECaptionSystemButton.SetDTop(Value: Integer);
begin
  if FDTop <> Value then
    begin
    FDTop := Value;
    end;
end;

procedure TKDECaptionSystemButton.SetDWidth(Value: Integer);
begin
  if FDWidth <> Value then
    begin
    FDWidth := Value;
    end;
end;

procedure TKDECaptionSystemButton.SetDHeight(Value: Integer);
begin
  if FDHeight <> Value then
    begin
    FDHeight := Value;
    end;
end;

procedure TKDECaptionSystemButton.Draw(DC: HDC);
var
  Flags, ButtonType, HBitmap: UINT;

		procedure DrawTransparentBitmapRect(DC: HDC; Bitmap: Integer; xStart, yStart,
		  Width, Height: Integer; Rect: TRect; TransparentColor: TColorRef);
		var
		{$IFDEF WIN32}
		  BM: Windows.TBitmap;
		{$ELSE}
		  BM: WinTypes.TBitmap;
		{$ENDIF}
		  cColor: TColorRef;
		  bmAndBack, bmAndObject, bmAndMem, bmSave: Integer;
		  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: Integer;
		  hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave: HDC;
		  ptSize, ptRealSize, ptBitSize, ptOrigin: TPoint;
		begin
		  hdcTemp := CreateCompatibleDC(DC);
		  SelectObject(hdcTemp, Bitmap);      { Select the bitmap    }
		  GetObject(Bitmap, SizeOf(BM), @BM);
		  ptRealSize.x := Min(Rect.Right - Rect.Left, BM.bmWidth - Rect.Left);
		  ptRealSize.y := Min(Rect.Bottom - Rect.Top, BM.bmHeight - Rect.Top);
		  DPtoLP(hdcTemp, ptRealSize, 1);
		  ptOrigin.x := Rect.Left;
		  ptOrigin.y := Rect.Top;
		  DPtoLP(hdcTemp, ptOrigin, 1);       { Convert from device  }
		                                      { to logical points    }
		  ptBitSize.x := BM.bmWidth;          { Get width of bitmap  }
		  ptBitSize.y := BM.bmHeight;         { Get height of bitmap }
		  DPtoLP(hdcTemp, ptBitSize, 1);
		  if (ptRealSize.x = 0) or (ptRealSize.y = 0) then begin
		    ptSize := ptBitSize;
		    ptRealSize := ptSize;
		  end
		  else ptSize := ptRealSize;
		  if (Width = 0) or (Height = 0) then begin
		    Width := ptSize.x;
		    Height := ptSize.y;
		  end;

		  { Create some DCs to hold temporary data }
		  hdcBack   := CreateCompatibleDC(DC);
		  hdcObject := CreateCompatibleDC(DC);
		  hdcMem    := CreateCompatibleDC(DC);
		  hdcSave   := CreateCompatibleDC(DC);
		  { Create a bitmap for each DC. DCs are required for a number of }
		  { GDI functions                                                 }
		  { Monochrome DC }
		  bmAndBack   := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
		  bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
		  bmAndMem    := CreateCompatibleBitmap(DC, Max(ptSize.x, Width), Max(ptSize.y, Height));
		  bmSave      := CreateCompatibleBitmap(DC, ptBitSize.x, ptBitSize.y);
		  { Each DC must select a bitmap object to store pixel data }
		  bmBackOld   := SelectObject(hdcBack, bmAndBack);
		  bmObjectOld := SelectObject(hdcObject, bmAndObject);
		  bmMemOld    := SelectObject(hdcMem, bmAndMem);
		  bmSaveOld   := SelectObject(hdcSave, bmSave);
		  { Set proper mapping mode }
		  SetMapMode(hdcTemp, GetMapMode(DC));

		  { Save the bitmap sent here, because it will be overwritten }
		  BitBlt(hdcSave, 0, 0, ptBitSize.x, ptBitSize.y, hdcTemp, 0, 0, SRCCOPY);
		  { Set the background color of the source DC to the color,         }
		  { contained in the parts of the bitmap that should be transparent }
		  cColor := SetBkColor(hdcTemp, TransparentColor);
		  { Create the object mask for the bitmap by performing a BitBlt()  }
		  { from the source bitmap to a monochrome bitmap                   }
		  BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, ptOrigin.x, ptOrigin.y,
		    SRCCOPY);
		  { Set the background color of the source DC back to the original  }
		  { color                                                           }
		  SetBkColor(hdcTemp, cColor);
		  { Create the inverse of the object mask }
		  BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0,
		    NOTSRCCOPY);
		  { Copy the background of the main DC to the destination }
		  BitBlt(hdcMem, 0, 0, Width, Height, DC, xStart, yStart,
		    SRCCOPY);
		  { Mask out the places where the bitmap will be placed }
		  StretchBlt(hdcMem, 0, 0, Width, Height, hdcObject, 0, 0,
		    ptSize.x, ptSize.y, SRCAND);
		  {BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);}
		  { Mask out the transparent colored pixels on the bitmap }
		  BitBlt(hdcTemp, ptOrigin.x, ptOrigin.y, ptSize.x, ptSize.y, hdcBack, 0, 0,
		    SRCAND);
		  { XOR the bitmap with the background on the destination DC }
		  StretchBlt(hdcMem, 0, 0, Width, Height, hdcTemp, ptOrigin.x, ptOrigin.y,
		    ptSize.x, ptSize.y, SRCPAINT);
		  {BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, ptOrigin.x, ptOrigin.y,
		    SRCPAINT);}
		  { Copy the destination to the screen }
		  BitBlt(DC, xStart, yStart, Max(ptRealSize.x, Width), Max(ptRealSize.y, Height),
		    hdcMem, 0, 0, SRCCOPY);
		  { Place the original bitmap back into the bitmap sent here }
		  BitBlt(hdcTemp, 0, 0, ptBitSize.x, ptBitSize.y, hdcSave, 0, 0, SRCCOPY);

		  { Delete the memory bitmaps }
		  DeleteObject(SelectObject(hdcBack, bmBackOld));
		  DeleteObject(SelectObject(hdcObject, bmObjectOld));
		  DeleteObject(SelectObject(hdcMem, bmMemOld));
		  DeleteObject(SelectObject(hdcSave, bmSaveOld));
		  { Delete the memory DCs }
		  DeleteDC(hdcMem);
		  DeleteDC(hdcBack);
		  DeleteDC(hdcObject);
		  DeleteDC(hdcSave);
		  DeleteDC(hdcTemp);
		end;


begin
  HBitmap:= 0;
  ButtonType:= 0;
  Flags := 0;
  case FKind of
    sbClose:    begin
                  ButtonType:= DFC_CAPTION;
                  Flags := DFCS_CAPTIONCLOSE;
                end;

    sbHelp:     begin
                  ButtonType:= DFC_CAPTION;
                  Flags := DFCS_CAPTIONHELP;
                end;

    sbMinimize: begin
                  ButtonType:= DFC_CAPTION;
                  if IsIconic(FParentForm.Handle) then
                     Flags := DFCS_CAPTIONRESTORE
                  else
                     Flags := DFCS_CAPTIONMIN;
                end;

    sbMaximize: begin
                  ButtonType:= DFC_CAPTION;
                  if IsZoomed(FParentForm.Handle) then
                     Flags := DFCS_CAPTIONRESTORE
                  else
                     Flags := DFCS_CAPTIONMAX;
                end;

    sbPin:      begin
                  ButtonType:= DFC_BUTTON;
                  Flags:= DFCS_BUTTONPUSH;
                  if FParentForm.Handle = GetTopWindow(0) then
                     HBitmap:= FHBitmap2
                  else
                     HBitmap:= FHBitmap1;
                end;

    end;
  if FDown then Flags := Flags or DFCS_PUSHED;
  if not Enabled then Flags := Flags or DFCS_INACTIVE;  { 1997.11.5  1.03}

  DrawFrameControl(DC, Rect(FDLeft, FDTop, FDLeft + FDWidth, FDTop + FDHeight),
                   ButtonType, Flags);

  case FKind of
    sbPin:      begin
                  DrawTransparentBitmapRect(
                                            DC,
                                            HBitmap,
                                            FDLeft,
                                            FDTop,
                                            0,
                                            0,
                                            Bounds(0, 0, 12, 12),
                                            ColorToRGB(clOlive)
                                            );
                end;
  end;
end;

procedure TKDECaptionSystemButton.Paint;
var
  DC: HDC;
begin
  DC := GetWindowDC(FParentForm.Handle);
  try
    Draw(DC);
  finally
    ReleaseDC(FParentForm.Handle, DC);
    end;
end;

procedure TKDECaptionSystemButton.MouseDown(Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and Enabled then
    begin
    FDown := True;
    FDragging := True;
    Paint;
    end;
end;

procedure TKDECaptionSystemButton.MouseMove(Shift: TShiftState;
          X, Y: Integer);
var
  P: TPoint;
  R: TRect;
  NewDown: Boolean;
begin
  if FDragging then
    begin
    GetWindowRect(FParentForm.Handle, R);
    GetCursorPos(P);
    P.X := P.X - R.Left;
    P.Y := P.Y - R.Top;
    if PtInRect(Rect(DLeft, DTop - 2,
                     DLeft + DWidth, DTop + DHeight + 2), P) or
      ((FKind = sbClose) and
       PtInRect(Rect(DLeft, DTop - 2,
                     DLeft + DWidth + 2, DTop + DHeight + 2), P)) then
      NewDown := True
    else
      NewDown := False;
    if FDown <>  NewDown then
      begin
      FDown := NewDown;
      Paint;
      end;
    end;
end;

procedure TKDECaptionSystemButton.MouseUp(Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  P: TPoint;
begin
  if FDragging and (Button = mbLeft) then
    begin
    GetWindowRect(FParentForm.Handle, R);
    GetCursorPos(P);
    FDown := False;
    FDragging := False;
    Paint;
    P.X := P.X - R.Left;
    P.Y := P.Y - R.Top;
    if PtInRect(Rect(DLeft, DTop - 2,
                     DLeft + DWidth, DTop + DHeight + 2), P) or
      ((FKind = sbClose) and
       PtInRect(Rect(DLeft, DTop - 2,
                     DLeft + DWidth + 2, DTop + DHeight + 2), P)) then
      Click;
    end;
end;

procedure TKDECaptionSystemButton.SystemButtonClick(Sender: TObject);
var
  P: TPoint;
  Pos: LongInt;
  Placement: TWindowPlacement;
begin
  GetCursorPos(P);
  Pos := LongInt(PointToSmallPoint(P));
  case FKind of
    sbClose:      SendMessage(FParentForm.Handle, WM_SYSCOMMAND,
                              SC_CLOSE, Pos);
    sbMinimize:   if IsIconic(FParentForm.Handle) then
                    SendMessage(FParentForm.Handle, WM_SYSCOMMAND,
                                SC_RESTORE, Pos)
                  else
                    SendMessage(FParentForm.Handle, WM_SYSCOMMAND,
                                SC_MINIMIZE, Pos);
    sbMaximize:   if IsZoomed (FParentForm.Handle) then
                    SendMessage(FParentForm.Handle, WM_SYSCOMMAND,
                                SC_RESTORE, Pos)
                  else
                    begin
                    if IsIconic(FParentForm.Handle) then
                      begin
                      Placement.Length := SizeOf(Placement);
                      GetWindowPlacement(FParentForm.Handle, @Placement);
                      end
                    else
                      Placement.Length := 12345678;
                    SendMessage(FParentForm.Handle, WM_SYSCOMMAND,
                                SC_MAXIMIZE, Pos);
                    if Placement.Length <> 12345678 then
                      begin
                      Placement.ShowCmd := SW_SHOWNA;
                      SetWindowPlacement(FParentForm.Handle, @Placement);
                      end;
                    end;
    sbHelp:       SendMessage(FParentForm.Handle, WM_SYSCOMMAND,
                              SC_CONTEXTHELP, Pos);
    sbPin:        begin
                    if FParentForm.Handle = GetTopWindow(0) then
                       SetWindowPos(
                                    FParentForm.Handle,
                                    HWND_NOTOPMOST,
                                    FParentForm.Left,
                                    FParentForm.top,
                                    FParentForm.width,
                                    FParentForm.height,
                                    SWP_NOACTIVATE Or SWP_SHOWWINDOW
                                    )
                    else
                       SetWindowPos(
                                    FParentForm.Handle,
                                    HWND_TOPMOST,
                                    FParentForm.Left,
                                    FParentForm.top,
                                    FParentForm.width,
                                    FParentForm.height,
                                    SWP_NOACTIVATE Or SWP_SHOWWINDOW
                                    );
                    Paint;
                  end;
    end;
end;

constructor TKDECaption.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AOwner is TForm then
    begin
    FParentForm := TForm(AOwner);

    FParentIcons := FParentForm.BorderIcons;
    FParentHandle := FParentForm.Handle;

    FCloseButton := TKDECaptionSystemButton.Create(Self);
    FCloseButton.Parent := FParentForm;
    FCloseButton.FHBitmap1:= 0;
    FCloseButton.FHBitmap2:= 0;

    FMinimizeButton := TKDECaptionSystemButton.Create(Self);
    FMinimizeButton.Kind := sbMinimize;
    FMinimizeButton.Parent := FParentForm;
    FMinimizeButton.FHBitmap1:= 0;
    FMinimizeButton.FHBitmap2:= 0;

    FMaximizeButton := TKDECaptionSystemButton.Create(Self);
    FMaximizeButton.Kind := sbMaximize;
    FMaximizeButton.Parent := FParentForm;
    FMaximizeButton.FHBitmap1:= 0;
    FMaximizeButton.FHBitmap2:= 0;

    FHelpButton := TKDECaptionSystemButton.Create(Self);
    FHelpButton.Kind := sbHelp;
    FHelpButton.Parent := FParentForm;
    FHelpButton.FHBitmap1:= 0;
    FHelpButton.FHBitmap2:= 0;
    
    FPinButton:= TKDECaptionSystemButton.Create(Self);
    FPinButton.Kind:= sbPin;
    FPinButton.Parent:= FParentForm;
    FPinButton.FHBitmap1:= LoadBitmap(hInstance,'KC_Pin1');
    FPinButton.FHBitmap2:= LoadBitmap(hInstance,'KC_Pin2');

    HookWindowProc;

    FActiveBeginColor := clNavy;
    FActiveEndColor := clBlue;
    FActiveFontColor := clWhite;
    FInactiveBeginColor := clGray;
    FInactiveEndColor := clSilver;
    FInactiveFontColor := clSilver;
    FNumColors := 64;
    FAutoSize := False;
    FApplicationName := '';
{$IFNDEF VER90} {$IFNDEF VER93}
    { Begin 1997.11.28   1.04}
    FCaption := FParentForm.Caption;
    { End 1997.11.28  1.04 }
{$ENDIF} {$ENDIF}
    FCaptionFont := TFont.Create;
    FApplicationNameFont := TFont.Create;
    FCaptionFont.Assign(FParentForm.Font);
    FCaptionFont.Style := [];
    FApplicationNameFont.Assign(FParentForm.Font);
    FApplicationnameFont.Style := [fsBold];

{ Delete WS_Caption Style from parent form's Style }
    FOldStyle := GetWindowLong(FParentHandle, GWL_STYLE);
    if not (csDesigning in ComponentState) then
      SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle and not (WS_SYSMENU));
    CalculateCaption;

    Paint(WindowIsActive);

{$IFNDEF VER90} {$IFNDEF VER93}
    { Begin 1997.11.28  Ver 1.04 }
    FOldFormWindowProc := FParentForm.WindowProc;
    FParentForm.WindowProc := MarsCaptionFormWindowProc;
    { End 1997.11.28  Ver 1.04 }
{$ENDIF} {$ENDIF}

    FRButtonCaptionDown := False;
    FLButtonMenuDownTick := 0;
    FActiveBitmap:= TBitmap.Create;
    FInactiveBitmap:= TBitmap.Create;
    end
  else
    raise Exception.Create('The KDECaption''s owner must be a Form!');

end;

destructor TKDECaption.Destroy;
begin
  UnHookWindowProc;

{$IFNDEF VER90} {$IFNDEF VER93}
  { 1997.11.28  Ver 1.04 }
  FParentForm.WindowProc := FOldFormWindowProc;
{$ENDIF} {$ENDIF}

  SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle);

  FApplicationNameFont.Free;
  FCaptionFont.Free;

  SetWindowPos(FParentHandle, 0, 0, 0, 0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or
               SWP_NOSIZE or SWP_NOZORDER or SWP_NOMOVE);
  FActiveBitmap.Destroy;
  FInactiveBitmap.Destroy;
  inherited Destroy;
end;


procedure TKDECaption.CalculateCaption;
var
  WindowRect: TRect;

  procedure GetBorderStyle;
  begin
    FParentBorderStyle := FParentForm.BorderStyle;
    if csDesigning in ComponentState then FParentBorderStyle := bsSizeable;
  end;

  procedure GetBorderSize;
  begin
    FBorderHeight := 0;
    FBorderWidth := 0;
    if IsIconic(FParentHandle) then
      begin
      FBorderHeight := GetSystemMetrics(SM_CXFIXEDFRAME);
      FBorderWidth := GetSystemMetrics(SM_CYFIXEDFRAME);
      end
    else
      case FParentBorderStyle of
        bsSingle,
        bsDialog,
        bsToolWindow:   begin
                        FBorderHeight := GetSystemMetrics(SM_CXFIXEDFRAME);
                        FBorderWidth := GetSystemMetrics(SM_CYFIXEDFRAME);
                        end;
        bsSizeToolWin,
        bsSizeable:     begin
                        FBorderHeight := GetSystemMetrics(SM_CXSIZEFRAME);
                        FBorderWidth := GetSystemMetrics(SM_CYSIZEFRAME);
                        end;
        end;
  end;

  procedure GetCaptionHeight;
  begin
    case FParentBorderStyle of
      bsSizeToolWin,
      bsToolWindow:   FCaptionHeight := GetSystemMetrics(SM_CYSMCAPTION);
      bsSingle,
      bsDialog,
      bsSizeable:     FCaptionHeight := GetSystemMetrics(SM_CYCAPTION);
    end;
    Dec(FCaptionHeight);
  end;

  procedure GetCaptionRect;
  begin
    FCaptionRect := WindowRect;
    OffsetRect(FCaptionRect,
               -FCaptionRect.Left + FBorderWidth,
               -FCaptionRect.Top + FBorderHeight);
    FCaptionRect.Right := FCaptionRect.Right - FBorderWidth * 2;
    FCaptionRect.Bottom := FCaptionRect.Top + FCaptionHeight;
  end;

  procedure GetSystemButtons;
  begin
    FSystemButtons := [];
    if (FParentBorderStyle = bsNone) or
       not (biSystemMenu in FParentIcons) then Exit;
    if FParentBorderStyle in [bsSizeToolWin, bsToolWindow] then
      begin
      FSystemButtons := [biSystemMenu];
      Exit;
      end;
    FSystemButtons := FParentIcons;
    case FParentBorderStyle of
      bsDialog:    FSystemButtons := FSystemButtons - [biMinimize, biMaximize];
      bsSingle,
      bsSizeable:  FSystemButtons := FSystemButtons - [biHelp];
      end;
    { 1997.11.5   1.03}
    if (biMinimize in FSystemButtons) or (biMaximize in FSystemButtons) then
      begin
      FSystemButtons := FSystemButtons + [biMinimize, biMaximize];
      end;
  end;

  procedure GetMenuIconRect;
  begin
{    FMenuIconRect := Rect(0, 0, 0, 0);    (* 1.00 *) }
    FMenuIconRect := Rect(FCaptionRect.Left, FCaptionRect.Top,
                     FCaptionRect.Left, FCaptionRect.Bottom);  { 1997.11.3 1.01 }
    if (FParentBorderStyle in [bsNone, bsToolWindow, bsSizeToolWin,
       bsDialog { 1997.11.3  1.01 }]) or
       not (biSystemMenu in FSystemButtons) then
      Exit;
    FMenuIconRect := Rect(FCaptionRect.Left, FCaptionRect.Top,
                          FCaptionRect.Left + 2 + GetSystemMetrics(SM_CXSIZE) - 2,
                          FCaptionRect.Bottom);
  end;

  procedure GetSystemButtonsRect;
  var
    TotalIconsWidth, IconNumber: Integer;
  begin
{    FSystemButtonsRect := Rect(0, 0, 0, 0);   (* 1997.11.2 *) }
    FSystemButtonsRect := Rect(FCaptionRect.Right, FCaptionRect.Top + 2,
           FCaptionRect.Right, FCaptionRect.Bottom - 2);  { 1997.11.3 }
    if not (biSystemMenu in FSystemButtons) then Exit;
    if FParentBorderStyle in [bsSizeToolWin, bsToolWindow] then
      TotalIconsWidth := GetSystemMetrics(SM_CXSMSIZE)
    else
      begin
      IconNumber := 1;
      if biMinimize in FSystemButtons then Inc(IconNumber);
      if biMaximize in FSystemButtons then Inc(IconNumber);
      if biHelp in FSystemButtons then Inc(IconNumber);
      { begin 1999.02.01 }
      if self.FPinButtonVisible then inc(IconNumber);
      { end 1999.02.01 }

      TotalIconsWidth := (GetSystemMetrics(SM_CXSIZE) - 2) * IconNumber;
      end;
    FSystemButtonsRect := Rect(FCaptionRect.Right - TotalIconsWidth - 2,
                               FCaptionRect.Top + 2,
                               FCaptionRect.Right,
                               FCaptionRect.Bottom - 2);
  end;

  procedure GetTextRect;
  begin
    FTextRect := Rect(FMenuIconRect.Right + 2,
                      FCaptionRect.Top + 2,
                      FSystemButtonsRect.Left - 2,
                      FCaptionRect.Bottom - 2);
  end;

  procedure RealignSystemButtons;
  var
    R: TRect;
    W, H: Integer;
  begin
    if not (biSystemMenu in FSystemButtons) then
      begin
      FCloseButton.Visible := False;
      FMaximizeButton.Visible := False;
      FMinimizeButton.Visible := False;
      FHelpButton.Visible := False;
      { begin 1999.02.01 }
      FPinButton.Visible:= false;
      { end 1999.02.01 }
      Exit;
      end;
    if FParentBorderStyle in [bsSizeToolWin, bsToolWindow] then
      begin  { 1997.11.5   1.03 }
      FCloseButton.Visible := True;
      FCloseButton.DLeft := FSystemButtonsRect.Left + 2;
      FCloseButton.DTop := FSystemButtonsRect.Top;
      FCloseButton.DWidth := FSystemButtonsRect.Right - FSystemButtonsRect.Left - 4;
      FCloseButton.DHeight := FSystemButtonsRect.Bottom - FSystemButtonsRect.Top;
      end
    else
      begin
      R := FSystemButtonsRect;
      H := GetSystemMetrics(SM_CYSIZE) - 4;
      W := GetSystemMetrics(SM_CXSIZE) - 2;
      FCloseButton.DWidth := W;
      FCloseButton.DHeight := H;
      FCloseButton.DTop := R.Top;
      FCloseButton.DLeft := R.Right - W - 2;
      FCloseButton.Visible := True;
      R.Right := FCloseButton.DLeft - 2;

      if biMaximize in FSystemButtons then
        begin
        FMaximizeButton.DWidth := W;
        FMaximizeButton.DHeight := H;
        FMaximizeButton.DTop := R.Top;
        FMaximizeButton.DLeft := R.Right - W;
        FMaximizeButton.Visible := True;
        R.Right := FMaximizeButton.DLeft;
        {  1997.11.5  1.03 }
        if not (biMaximize in FParentIcons) then FMaximizeButton.Enabled := False;
        end
      else
        FMaximizeButton.Visible := False;
      if biMinimize in FSystemButtons then
        begin
        FMinimizeButton.DWidth := W;
        FMinimizeButton.DHeight := H;
        FMinimizeButton.DTop := R.Top;
        FMinimizeButton.DLeft := R.Right - W;
        FMinimizeButton.Visible := True;
        R.Right := FMinimizeButton.DLeft;
        {  1997.11.5  1.03 }
        if not (biMinimize in FParentIcons) then FMinimizeButton.Enabled := False;
        end
      else
        FMinimizeButton.Visible := False;
      if biHelp in FSystemButtons then
        begin
        FHelpButton.DWidth := W;
        FHelpButton.DHeight := H;
        FHelpButton.DTop := R.Top;
        FHelpButton.DLeft := R.Right - W;
        FHelpButton.Visible := True;
        end
      else
        FHelpButton.Visible := False;
      { begin 1999.02.01 }
      if FPinButtonVisible then
        begin
        FPinButton.DWidth := W;
        FPinButton.DHeight := H;
        FPinButton.DTop := R.Top;
        FPinButton.DLeft := R.Right - W;
        FPinButton.Visible := True;
        R.Right := FPinButton.DLeft;
        end
      else
        FPinButton.Visible := False;
      end;
      { end 1999.02.01 }
  end;

begin
  GetWindowRect(FParentHandle, WindowRect);
  GetBorderStyle;
  GetBorderSize;
  GetCaptionHeight;
  GetCaptionRect;
  GetSystemButtons;
  GetMenuIconRect;
  GetSystemButtonsRect;
  GetTextRect;
  ReAlignSystemButtons;
end;


procedure TKDECaption.HookWindowProc;
begin
  FOldWindowProc := TFarProc(GetWindowLong(FParentHandle, GWL_WNDPROC));
  FNewWindowProc := MakeObjectInstance(MarsCaptionWindowProc);
  SetWindowLong(FParentHandle, GWL_WNDPROC, LongInt(FNewWindowProc));
end;

procedure TKDECaption.UnHookWindowProc;
begin
  SetWindowLong(FParentHandle, GWL_WNDPROC, LongInt(FOldWindowProc));
  FreeObjectInstance(FNewWindowProc);
end;

procedure TKDECaption.CallOldWindowProc(var Msg: TMessage);
begin
  Msg.Result := CallWindowProc(FOldWindowProc, FParentHandle,
                Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TKDECaption.WMNCPaint(var Msg: TMessage);
var
  DC: HDC;
  WR : TRect;
  MyRgn : HRgn;
begin
  Paint(WindowIsActive);
  DC := GetWindowDC(FParentHandle);
  GetWindowRect(FParentHandle, WR);
  MyRgn := CreateRectRgnIndirect(WR);
  try
    if SelectClipRgn(DC, Msg.wParam) = ERROR then SelectClipRgn(DC, MyRgn);
    OffsetClipRgn(DC, -WR.Left, -WR.Top);
    ExcludeClipRect(DC, FCaptionRect.Left, FCaptionRect.Top,
                        FCaptionRect.Right, FCaptionRect.Bottom);
    OffsetClipRgn(DC, WR.Left, WR.Top);
    GetClipRgn(DC, MyRgn);
    Msg.wParam := MyRgn;
    CallOldWindowProc(Msg);
  finally
    DeleteObject(MyRgn);
    ReleaseDC(FParentHandle, DC);
  end;

end;

procedure TKDECaption.WMNCActivate(var Msg: TWMNCActivate);
begin
  { 1997.11.29  Version 1.05 }
  if Msg.Active then CallOldWindowProc(TMessage(Msg));
  Paint(Msg.Active);
  Msg.Result := 1;
end;

procedure TKDECaption.WMActivate(var Msg: TWMACTIVATE);
begin
  if Msg.Active = WA_INACTIVE then
    Paint(False)
  else
    Paint(True);
  CallOldWindowProc(TMessage(Msg));
end;

procedure TKDECaption.MarsGetMenu(var M: HMenu);
begin
  M := GetSystemMenu(FParentHandle, False);
  EnableMenuItem(M, SC_RESTORE, MF_BYCOMMAND or MF_ENABLED);
  EnableMenuItem(M, SC_MOVE, MF_BYCOMMAND or MF_ENABLED);
  EnableMenuItem(M, SC_SIZE, MF_BYCOMMAND or MF_ENABLED);
  EnableMenuItem(M, SC_MAXIMIZE, MF_BYCOMMAND or MF_ENABLED);
  EnableMenuItem(M, SC_MINIMIZE, MF_BYCOMMAND or MF_ENABLED);
  SetMenuDefaultItem(M, SC_CLOSE, 0);
  if IsZoomed(FParentHandle) or IsIconic(FParentHandle) then
    begin
    if IsIconic(FParentHandle) or (FParentForm.FormStyle <> fsMDIChild) then
      SetMenuDefaultItem(M, SC_RESTORE, 0);
    EnableMenuItem(M, SC_SIZE, MF_BYCOMMAND or MF_GRAYED);
    EnableMenuItem(M, SC_MOVE, MF_BYCOMMAND or MF_GRAYED);
    if IsZoomed(FParentHandle) then
      EnableMenuItem(M, SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED)
    else
      EnableMenuItem(M, SC_MINIMIZE, MF_BYCOMMAND or MF_GRAYED);
    end
  else
    begin
    SetMenuDefaultItem(M, SC_CLOSE, 0);
    EnableMenuItem(M, SC_RESTORE, MF_BYCOMMAND or MF_GRAYED);
    end;
  { 1997.11.3  1.01 }
{  if not (biMaximize in FSystemButtons) then}
  { 1997.11.5  1.03 }
  if not (biMaximize in FSystemButtons) or not FMaximizeButton.Enabled then
    EnableMenuItem(M, SC_MAXIMIZE, MF_BYCOMMAND or MF_GRAYED);
  { 1997.11.3  1.01 }
{  if not (biMinimize in FSystemButtons) then}
  { 1997.11.5  1.03 }
  if not (biMinimize in FSystemButtons) or not FMinimizeButton.Enabled then
    EnableMenuItem(M, SC_MINIMIZE, MF_BYCOMMAND or MF_GRAYED);
end;

procedure TKDECaption.WMNCMouseMessages(var Msg: TMessage);
var
  P: TPoint;
  R: TRect;
  CurSystemButton: TKDECaptionSystemButton;
  WorkFinish: Boolean;
  M: HMenu;

  procedure SystemButtonInPoint;
  begin
    CurSystemButton := nil;
    if FCloseButton.Visible and
       PtInRect(Rect(FCloseButton.DLeft, FCloseButton.DTop - 2,
                     FCloseButton.DLeft + FCloseButton.DWidth + 2,
                     FCloseButton.DTop + FCloseButton.DHeight + 2), P) then
      CurSystemButton := FCloseButton
    else if FMaximizeButton.Visible and
      PtInRect(Rect(FMaximizeButton.DLeft, FMaximizeButton.DTop - 2,
                    FMaximizeButton.DLeft + FMaximizeButton.DWidth,
                    FMaximizeButton.DTop + FMaximizeButton.DHeight + 2), P) then
      CurSystemButton := FMaximizeButton
    else if FMinimizeButton.Visible and
      PtInRect(Rect(FMinimizeButton.DLeft, FMinimizeButton.DTop - 2,
                    FMinimizeButton.DLeft + FMinimizeButton.DWidth,
                    FMinimizeButton.DTop + FMinimizeButton.DHeight + 2), P) then
      CurSystemButton := FMinimizeButton
    else if FHelpButton.Visible and
      PtInRect(Rect(FHelpButton.DLeft, FHelpButton.DTop - 2,
                    FHelpButton.DLeft + FHelpButton.DWidth,
                    FHelpButton.DTop + FHelpButton.DHeight + 2), P) then
      CurSystemButton := FHelpButton;
    { begin 1999.02.01 }
    if FPinButton.Visible and
       PtInRect(Rect(FPinButton.DLeft, FPinButton.DTop - 2,
                     FPinButton.DLeft + FPinButton.DWidth + 2,
                     FPinButton.DTop + FPinButton.DHeight + 2), P) then
      CurSystemButton := FPinButton;
    { end 1999.02.01 }
  end;

  procedure WMNCLButtonDown;
  var
    TempMsg: TMSG;
    TPMParams: TTPMParams;
    P1: TPoint;
  begin
    if (PtInRect(FMenuIconRect, P)) and not IsIconic(FParentHandle) then
      begin
      MarsGetMenu(M);
      FLButtonMenuDownTick := GetTickCount;
      TPMParams.cbSize := SizeOf(TPMParams);
      TPMParams.rcExclude := Rect(R.Left + FBorderWidth, R.Top + FBorderHeight,
                                  R.Left + FBorderWidth + 1, R.Top + FBorderHeight + FCaptionHeight);
      TrackPopupMenuEx(M, TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_VERTICAL,
                     R.Left + FBorderWidth, R.Top + FBorderHeight + FCaptionHeight,
                     FParentHandle, @TPMParams);
      { Eat a message }
      PeekMessage(TempMsg, FParentHandle, WM_NCLButtonDown, WM_NCLButtonDown, PM_NoREMOVE);
      P1 := SmallPointToPoint(TSmallPoint(TempMsg.lParam));
      GetWindowRect(FParentHandle, R);
      P1.X := P1.X - R.Left;
      P1.Y := P1.Y - R.Top;
      if PtInRect(FMenuIconRect, P1) then
        PeekMessage(TempMsg, FParentHandle, WM_NCLButtonDown, WM_NCLButtonDown, PM_REMOVE);
      WorkFinish := True;
      end
    else
      begin
      if IsZoomed(FParentHandle) then
        Msg.WParam := HTNOWHERE;
      end;
  end;

  procedure WMNCLButtonUp;
  var
    DoubleClickTime: UINT;
  begin
    if FLButtonMenuDownTick <> 0 then
      begin
      DoubleClickTime := GetDoubleClickTime;
      if GetTickCount - FLButtonMenuDownTick <= DoubleClickTime then
        SendMessage(FParentHandle, WM_SYSCOMMAND, SC_CLOSE, 0);
      FLButtonMenuDownTick := 0;
      WorkFinish := True;
      end;
  end;

  procedure WMNCLButtonDblClk;
  begin
    if PtInRect(FTextRect, P) then
      begin
{      if biMaximize in FSystemButtons then   }{ 1997.11.3  1.01 }
      if (biMaximize in FSystemButtons) and (FMaximizeButton.Enabled) then  { 1997.11.5  1.03 }
        if IsZoomed(FParentHandle) then
          SendMessage(FParentHandle, WM_SYSCOMMAND, SC_RESTORE, 0)
        else
          SendMessage(FParentHandle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
      WorkFinish := True;
      end;
  end;

  procedure WMNCRButtonDown;
  begin
    if (P.X < FSystemButtonsRect.Left) and
       (FParentForm.FormStyle <> fsMDIChild) then
      begin
      FRButtonCaptionDown := True;
      WorkFinish := True;
      end;
  end;

  procedure WMNCRButtonUp;
  var
    P: TPoint;
  begin
    if FRButtonCaptionDown then
      begin
      MarsGetMenu(M);
      GetCursorPos(P);
      TrackPopupMenu(M, TPM_LEFTALIGN or TPM_LEFTBUTTON,
                     P.X, P.Y, 0, FParentHandle, nil);
      FRButtonCaptionDown := False;
      WorkFinish := True;
      end;
  end;

  procedure IconicLButtonDown;
  begin
    SetCapture(FParentHandle);
    FLButtonIconicCaptionDown := True;
    FLButtonIconicCaptionDownPos := P;
    FLButtonIconicCaptionDownRect := R;
    FLButtonMenuDownTick := GetTickCount;
  end;

begin
  WorkFinish := False;
  if (Msg.wParam = HTCAPTION) then
    begin
    if (Msg.Msg = WM_NCLButtonDown) or (Msg.Msg = WM_NCRBUTTONDOWN) or
       (Msg.Msg = WM_NCMButtonDown) then
      FParentForm.BringToFront;
    P := SmallPointToPoint(TSmallPoint(Msg.lParam));
    GetWindowRect(FParentHandle, R);
    P.X := P.X - R.Left;
    P.Y := P.Y - R.Top;
    SystemButtonInPoint;
    if CurSystemButton <> nil then
      begin
      if Msg.Msg = WM_NCRButtonUp then FRButtonCaptionDown := False;
      P.X := P.X - CurSystemButton.DLeft;
      P.Y := P.Y - CurSystemButton.DTop;
      CurSystemButton.Perform(Msg.Msg + $160, 0, LongInt(PointToSmallPoint(P)));
      Exit;
      end;
    if IsIconic(FParentHandle) then
      begin
      case Msg.Msg of
        WM_NCLButtonDown:  IconicLButtonDown;
        end;
      Exit;
      end;
    case Msg.Msg of
      WM_NCLButtonDown:    WMNCLButtonDown;
      WM_NCLButtonUp:      WMNCLButtonUp;
      WM_NCRButtonDown:    WMNCRButtonDown;
      WM_NCRButtonUp:      WMNCRButtonUp;
      WM_NCLButtonDblClk:  WMNCLButtonDblClk;
      end;
    end;
  if not WorkFinish then CallOldWindowProc(Msg);
end;

procedure TKDECaption.WMDestroy(var Msg: TMessage);
begin
  FCloseButton.Free;
  FMinimizeButton.Free;
  FMaximizeButton.Free;
  FHelpButton.Free;
  FPinButton.Free;

  CallOldWindowProc(Msg);   { 1997.11.4  1.02 }
end;

procedure TKDECaption.WMCommand(var Msg: TMessage);
var
  P, Pt: TPoint;
  lParam: LongInt;
  R: TRect;
  WHandle: HWnd;
begin
  GetCursorPos(P);
  lParam := LongInt(PointToSmallPoint(P));
  if not (FParentForm.FormStyle = fsMDIForm) or
    (FParentForm.ActiveMDIChild = nil) or
    (FParentForm.ActiveMDIChild.WindowState = wsNormal) then
    WHandle := FParentHandle
  else
    begin
    GetWindowRect(FParentHandle, R);
    Pt.X := P.X - R.Left;
    Pt.Y := P.Y - R.Top;
    if PtInRect(FCaptionRect, Pt) then
      WHandle := FParentHandle
    else
      WHandle := FParentForm.ActiveMDIChild.Handle;
    end;
  case Msg.wParam of
    SC_RESTORE:   SendMessage(WHandle, WM_SYSCOMMAND, SC_RESTORE, lParam);
    SC_MOVE:      SendMessage(WHandle, WM_SYSCOMMAND, SC_MOVE, lParam);
    SC_SIZE:      SendMessage(WHandle, WM_SYSCOMMAND, SC_SIZE, lParam);
    SC_MINIMIZE:  SendMessage(WHandle, WM_SYSCOMMAND, SC_MINIMIZE, lParam);
    SC_MAXIMIZE:  SendMessage(WHandle, WM_SYSCOMMAND, SC_MAXIMIZE, lParam);
    SC_CLOSE:     SendMessage(WHandle, WM_SYSCOMMAND, SC_CLOSE, lParam);
    else          CallOldWindowProc(Msg);
    end;
end;

var
  MouseDblClk: Boolean;
  HookMouse: HHOOK;

procedure MouseHook(nCode: Integer; wParam: WParam; lParam: PMouseHookStruct); stdcall;
begin
  if (wParam = WM_LButtonDBlClk) then
    MouseDblClk := True;
  CallNextHookEx(HookMouse, nCode, wParam, LongInt(lParam));
end;

procedure TKDECaption.WMLButtonUp(var Msg: TWMLButtonUp);
var
  P: TPoint;
  R: TRect;
  M: HMenu;
  TPMParams: TTPMParams;
  TempMsg:TMsg;
  Placement: TWindowPlacement;
begin
  if FIconicWindowMove then
    begin
    Placement.Length := SizeOf(Placement);
    GetWindowPlacement(FParentHandle, @Placement);
    Placement.Flags := WPF_SetMinPosition;
    GetWindowRect(FParentHandle, R);
    P.X := R.Left;
    P.Y := R.Top;
    Windows.ScreenToClient(GetParent(FParentHandle), P);
    Placement.ptMinPosition := P;
    SetWindowPlacement(FParentHandle, @Placement);
    FIconicWindowMove := False;
    ReleaseCapture;
    end;
  if FLButtonIconicCaptionDown then
    begin
    GetCursorPos(P);
    GetWindowRect(FParentHandle, R);
    P.X := P.X - R.Left;
    P.Y := P.Y - R.Top;
    MarsGetMenu(M);
    TPMParams.cbSize := SizeOf(TPMParams);
    TPMParams.rcExclude := Rect(R.Left, R.Top, R.Right, R.Bottom);
    HookMouse := SetWindowsHookEx(WH_MOUSE, @MouseHook, HInstance, GetWindowThreadProcessId(FParentHandle, nil));
    MouseDblClk := False;
    TrackPopupMenuEx(M, TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_VERTICAL,
                     R.Left, R.Top + FBorderHeight* 2 + FCaptionHeight,
                     FParentHandle, @TPMParams);
    UnHookWindowsHookEx(HookMouse);
    if (MouseDblClk) then SendMessage(FParentHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
    FLButtonIconicCaptionDown := False;
    PeekMessage(TempMsg, FParentHandle, WM_NCLButtonDown, WM_NCLButtonDown, PM_REMOVE);
    Exit;
    end;
  CallOldWindowProc(TMessage(Msg));
end;

procedure TKDECaption.WMMouseMove(var Msg: TWMMouseMove);
var
  P: TPoint;
  R: TRect;
begin
  if FLButtonIconicCaptionDown then
    begin
    if (Msg.XPos <> FLButtonIconicCaptionDownPos.X) or
       (Msg.YPos <> FLButtonIconicCaptionDownPos.Y) then
      begin
      FIconicWindowMove := True;
      FLButtonIconicCaptionDown := False;
      FLastPos.X := FLButtonIconicCaptionDownPos.X;
      FLastPos.Y := FLButtonIconicCaptionDownPos.Y;
      Windows.ClientToScreen(FParentHandle, FLastPos);
      end;
    end;
  if (FIconicWindowMove) then
    begin
    P := SmallPointToPoint(Msg.Pos);
    Windows.ClientToScreen(FParentHandle, P);
    if (FLastPos.X <> P.X) or (FLastPos.Y <> P.Y) then
      begin
      GetWindowRect(FParentHandle, R);
      OffsetRect(R, P.X - FLastPos.X, P.Y - FLastPos.Y);
      FLastPos.X := P.X;
      FLastPos.Y := P.Y;
      P.X := R.Left;
      P.Y := R.Top;
      Windows.ScreenToClient(GetParent(FParentHandle), P);
      SetWindowPos(FParentHandle, 0, P.X, P.Y,
         0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER );
      end;
    end;
  CallOldWindowProc(TMessage(Msg));
end;

procedure TKDECaption.MarsCaptionWindowProc(var Msg: TMessage);
var
  {Placement: TWindowPlacement;}  { 1997.11.30  Version 1.06 }
  NeedResetMDIChild: Boolean;
begin
  case Msg.Msg of
    WM_DESTROY:     WMDestroy(Msg);
    WM_NCPAINT:     WMNCPaint(Msg);
    WM_NCACTIVATE:  WMNCActivate(TWMNCActivate(Msg));
    WM_ACTIVATE:    WMActivate(TWMActivate(Msg));
    WM_LButtonUp:   WMLButtonUp(TWMLButtonUp(Msg));
    WM_MouseMove:   WMMouseMove(TWMMouseMove(Msg));
    WM_NCMouseMove..
    WM_NCMButtonDblClk:
                    WMNCMouseMessages(Msg);
    WM_RButtonUp:   begin
                    FRButtonCaptionDown := False;
                    CallOldWindowProc(Msg);
                    end;
    WM_COMMAND:     WMCommand(Msg);
    WM_SYSCOMMAND:  begin
                    if (Msg.wParam = SC_MAXIMIZE) and (FParentForm.FormStyle = fsMDIChild) then
                      begin
                      { Begin 1997.11.30  Version 1.06 }
                      RestoreSysmenuStyle;
                      (*if not (csDesigning in ComponentState) then
                        SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle);
                      SetWindowPos(FParentHandle, 0, 0, 0, 0, 0,
                                   SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);*)
                      { End 1997.11.30  Version 1.06 }
                      end;
                    if (Msg.wParam = SC_RESTORE) and (FParentForm.FormStyle = fsMDIChild) and
                       IsIconic(FParentHandle) then
                      begin
                      { Begin 1997.11.30  Version 1.06 }
                      RestoreSysmenuStyle;
                      (*Placement.Length := SizeOf(Placement);
                      GetWindowPlacement(FParentHandle, @Placement);
                      if ((Placement.Flags and WPF_RESTORETOMAXIMIZED) <> 0) and
                         (not (csDesigning in ComponentState)) then
                        SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle or WS_MINIMIZE);
                      SetWindowPos(FParentHandle, 0, 0, 0, 0, 0,
                                   SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);*)
                      { End 1997.11.30  Version 1.06 }
                      end;
                    if (Msg.wParam = SC_MINIMIZE) and (IsZoomed(FParentHandle)) and
                       (FParentForm.FormStyle = fsMDIChild) then
                      NeedResetMDIChild := True
                    else
                      NeedResetMDIChild := False;
                    CallOldWindowProc(Msg);
                    if NeedResetMDIChild then
                      begin
                      { Begin 1997.11.30  Version 1.06}
                      DeleteSysmenuStyle;
                      (*Placement.Length := SizeOf(Placement);
                      GetWindowPlacement(FParentHandle, @Placement);
                      if not (csDesigning in ComponentState) then
                        SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle and not WS_SYSMENU);
                      SetWindowPlacement(FParentHandle, @Placement);*)
                      { End 1997.11.30  Version 1.06 }
                      end;
                    if (Msg.wParam = SC_RESTORE) and
                       (FParentForm.FormStyle = fsMDIChild) and
                       (not IsZoomed(FParentHandle)) then
                      begin
                      { Begin 1997.11.30 Version 1.06 }
                      DeleteSysmenuStyle;
                      (*if not (csDesigning in ComponentState) then
                        SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle and not WS_SYSMENU);
                      SetWindowPos(FParentHandle, 0, 0, 0, 0, 0,
                                   SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);*)
                      { End 1997.11.30  Version 1.06 }
                      end;
                    end;
{$IFNDEF VER90} {$IFNDEF VER93}
    { Begin 1997.11.28  Version 1.04 }
    WM_SETTEXT:     begin
                    FCaption := TWMSetText(Msg).Text;
                    Repaint;
                    Msg.Result := 1;
                    end;
    WM_GetTextLength:
                    begin
                    Msg.Result := Length(FCaption);
                    end;
    WM_GetText:     begin
                    StrLCopy(TWMGetText(Msg).Text, PChar(FCaption),
                             TWMGetText(Msg).TextMax);
                    if Length(FCaption) <= TWMGetText(Msg).TextMax then
                      Msg.Result := Length(FCaption)
                    else
                      Msg.Result := TWMGetText(Msg).TextMax;
                    end;
(*    CM_TEXTChanged: begin
                    CallOldWindowProc(Msg);
                    RePaint;
                    end;*)
    { End 1997.11.28  Version 1.04 }
{$ENDIF} {$ENDIF}
    else            CallOldWindowProc(Msg);
    end;
end;

{$IFNDEF VER90} {$IFNDEF VER93}
{Begin 1997.11.28  Version 1.04}
procedure TKDECaption.MarsCaptionFormWindowProc(var Message: TMessage);
begin
  if FParentForm.FormStyle = fsMDIForm then
    begin
    FOldFormWindowProc(Message);
    if Message.Msg = WM_SETTEXT then Repaint;
    end
  else
    begin
    case Message.Msg of
      WM_SETTEXT,
      WM_GetTextLength,
      WM_GetText:      MarsCaptionWindowProc(Message);
      else             FOldFormWindowProc(Message);
      end;
    end;
end;
{End 1997.11.28 Version 1.04}
{$ENDIF} {$ENDIF}

function TKDECaption.WindowIsActive: Boolean;
begin
  Result := (FParentHandle = GetActiveWindow);
  If (FParentForm.FormStyle = fsMDIChild)
    then if Application <> nil
    then if Application.Mainform <> nil
    then if FParentForm = Application.Mainform.ActiveMDIChild
    then if Application.Mainform.HandleAllocated
    then if Application.Mainform.Handle = GetActiveWindow
      then Result := True;
end;

procedure TKDECaption.PaintBackGround(DC: HDC; Active: Boolean);
var
  BeginRGBValue: array[0..2] of Byte;
  RGBDifference: array[0..2] of integer;
  Band: TRect;
  I, ypos, xpos: Integer;
  R, G, B: Byte;
  Brush, OldBrush: HBrush;
  Background: TRect;
  BeginColor, EndColor: TColor;
  bmp: TBitmap;
begin
  Background := FCaptionRect;

  if (FUseBitmaps) and (not FActiveBitmap.Empty) and (not FInactiveBitmap.Empty) then begin
    { UseBitmaps = true }
      if Active then
         bmp:= FActiveBitmap
      else
         bmp:= FInactiveBitmap;

      ypos:= background.Top;
      while background.Bottom > ypos do begin
        xpos:= background.Left;
        while background.Right > xpos do begin
          bitblt(
                 DC,
                 xpos,
                 ypos,
                 bmp.Width,
                 bmp.Height,
                 bmp.Canvas.Handle,
                 0,
                 0,
                 SRCCOPY
                 );
          inc(xpos,bmp.Width);
        end;
        bitblt(
               DC,
               xpos,
               ypos,
               bmp.Width,
               bmp.Height,
               bmp.Canvas.Handle,
               0,
               0,
               SRCCOPY
               );
        inc(ypos,bmp.Height)
      end;
  end else begin
  if Active then
    begin
    BeginColor := FActiveBeginColor;
    EndColor := FActiveEndColor;
    end
  else
    begin
    BeginColor := FInactiveBeginColor;
    EndColor := FInactiveEndColor;
    end;
  BeginRGBValue[0] := GetRValue(ColorToRGB(BeginColor));
  BeginRGBValue[1] := GetGValue(ColorToRGB(BeginColor));
  BeginRGBValue[2] := GetBValue(ColorToRGB(BeginColor));
  RGBDifference[0] := GetRValue(ColorToRGB(EndColor)) - BeginRGBValue[0];
  RGBDifference[1] := GetGValue(ColorToRGB(EndColor)) - BeginRGBValue[1];
  RGBDifference[2] := GetBValue(ColorToRGB(EndColor)) - BeginRGBValue[2];

  Band.Top := Background.Top;
  Band.Bottom := Background.Bottom;

  for I := 0 to FNumColors - 1 do
    begin
    Band.Left  := Background.Left + MulDiv(I, Background.Right - Background.Left, FNumColors);
    Band.Right := Background.Left + MulDiv(I + 1, Background.Right - Background.Left, FNumColors);
    if FNumColors > 1 then
      begin
      R := BeginRGBValue[0] + MulDiv (I, RGBDifference[0], FNumColors - 1);
      G := BeginRGBValue[1] + MulDiv (I, RGBDifference[1], FNumColors - 1);
      B := BeginRGBValue[2] + MulDiv (I, RGBDifference[2], FNumColors - 1);
      end
    else
      begin
      R := BeginRGBValue[0];
      G := BeginRGBValue[1];
      B := BeginRGBValue[2];
      end;

    Brush := CreateSolidBrush(RGB(R, G, B));
    OldBrush := SelectObject(DC, Brush);
    try
      PatBlt(DC, Band.Left, Band.Top, Band.Right - Band.Left,
             Band.Bottom - Band.Top, PATCOPY);
    finally
      SelectObject(DC, OldBrush);
      DeleteObject(Brush);
      end;
    end; { End for }
    end;
end;

procedure TKDECaption.PaintMenuIcon(DC: HDC);
var
  R: TRect;
  Icon, NewIcon: HIcon;
  NeedRelease: Boolean;
begin
  R := Rect(FMenuIconRect.Left + 2, FMenuIconRect.Top + 1,
            FMenuIconRect.Right, FMenuIconRect.Bottom - 1);
  NeedRelease := False;
  Icon := FParentForm.Icon.Handle;
  if Icon = 0 then Icon := Application.Icon.Handle;
  if Icon = 0 then
    begin
    Icon := LoadIcon(0, IDI_APPLICATION);
    NeedRelease := True;
    end;
  if Icon <> 0 then
    begin
    NewIcon := CopyImage(Icon, IMAGE_ICON,
                     R.Right - R.Left, R.Bottom - R.Top, $4000);
    DrawIconEx(DC, R.Left, R.Top, NewIcon, 0, 0,
               0, 0, DI_NORMAL);
    DestroyIcon(NewIcon);
    end;
  if NeedRelease then DestroyIcon(Icon);
end;

procedure TKDECaption.PaintTitle(DC: HDC; Active: Boolean);
var
  R, RTemp: TRect;
  TempFont: TFont;
  OldBkMode: Integer;
  OldFont: HFont;
  Color: TColor;
  OldColor: TColorREF;
begin
  if Active then Color := FActiveFontColor else Color := FInactiveFontColor;
  OldColor := SetTextColor(DC, ColorToRGB(Color));
  try
    TempFont := TFont.Create;
    try
      OldBkMode := SetBkMode(DC, TRANSPARENT);
      try
        R := FTextRect;
        RTemp := R;
        RTemp.Right := R.Left;
        if FApplicationName <> '' then
          begin
          TempFont.Assign(FApplicationNameFont);
          if FAutoSize then TempFont.Height := -(R.Bottom - R.Top - 5);

          if Active then  TempFont.Color := FActiveFontColor
          else TempFont.Color := FInactiveFontColor;
          OldFont := SelectObject(DC, TempFont.Handle);
          try
            DrawText(DC, PChar(FApplicationName), -1, RTemp,
                     DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_CALCRECT);
            DrawText(DC, PChar(FApplicationName), -1, R,
                     DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
          finally
            SelectObject(DC, OldFont);
            end;
          end;
        R.Left := RTemp.Right;
        TempFont.Assign(FCaptionFont);
        if FAutoSize then TempFont.Height := -(R.Bottom - R.Top - 5);
        if Active then TempFont.Color := FActiveFontColor
        else TempFont.Color := FInactiveFontColor;
        OldFont := SelectObject(DC, TempFont.Handle);
        try
          DrawText(DC, PChar(FParentForm.Caption), -1, R,
                   DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
        finally
          SelectObject(DC, OldFont);
          end;
      finally
        SetBkMode(DC, OldBkMode);
        end;
    finally
      TempFont.Free;
      end;
  finally
    SetTextColor(DC, OldColor);
    end;
end;

procedure TKDECaption.Paint(Active: Boolean);
var
  DC, CompDC: HDC;
  Bitmap, OldBitmap: HBitmap;
begin
  CalculateCaption;
  DC := GetWindowDC(FParentHandle);
  if DC = 0 then Exit;
  CompDC := CreateCompatibleDC(DC);
  if CompDC = 0 then
    begin
    ReleaseDC(FParentHandle, DC);
    Exit;
    end;
  Bitmap := CreateCompatibleBitmap(DC, FCaptionRect.Right,
                                   FCaptionRect.Bottom);
  if Bitmap = 0 then
    begin
    ReleaseDC(FParentHandle, DC);
    DeleteDC(CompDC);
    Exit;
    end;
  OldBitmap := SelectObject(CompDC, Bitmap);
  try
    PaintBackGround(CompDC, Active);
    PaintMenuIcon(CompDC);
    PaintTitle(CompDC, Active);
    if FCloseButton.Visible then FCloseButton.Draw(CompDC);
    if FMaximizeButton.Visible then FMaximizeButton.Draw(CompDC);
    if FMinimizeButton.Visible then FMinimizeButton.Draw(CompDC);
    if FHelpButton.Visible then FHelpButton.Draw(CompDC);
    if FPinButton.Visible then FPinButton.Draw(CompDC);
    BitBlt(DC, FCaptionRect.Left, FCaptionRect.Top,
               FCaptionRect.Right - FCaptionRect.Left,
               FCaptionRect.Bottom - FCaptionRect.Top,
           CompDC, FCaptionRect.Left, FCaptionRect.Top, SRCCOPY);
  finally
    SelectObject(CompDC, OldBitmap);
    DeleteObject(Bitmap);
    DeleteDC(CompDC);
    ReleaseDC(FParentHandle, DC);
    end;
end;

procedure TKDECaption.Repaint;
begin
  SetWindowPos(FParentHandle, 0, 0, 0, 0, 0,
               SWP_DRAWFRAME or SWP_NOACTIVATE or SWP_NOZORDER or
               SWP_NOMOVE or SWP_NOSIZE or SWP_FRAMECHANGED);
end;

procedure TKDECaption.SetActiveBeginColor(Value: TColor);
begin
  if Value <> FActiveBeginColor then
    begin
    FActiveBeginColor := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetActiveEndColor(Value: TColor);
begin
  if Value <> FActiveEndColor then
    begin
    FActiveEndColor := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetActiveFontColor(Value: TColor);
begin
  if Value <> FActiveFontColor then
    begin
    FActiveFontColor := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetInactiveBeginColor(Value: TColor);
begin
  if Value <> FInactiveBeginColor then
    begin
    FInactiveBeginColor := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetInactiveEndColor(Value: TColor);
begin
  if Value <> FInactiveEndColor then
    begin
    FInactiveEndColor := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetInactiveFontColor(Value: TColor);
begin
  if Value <> FInactiveFontColor then
    begin
    FInactiveFontColor := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetApplicationName(Value: String);
begin
  if Value <> FApplicationName then
    begin
    FApplicationName := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetApplicationNameFont(Value: TFont);
begin
  FApplicationNameFont.Assign(Value);
  Repaint;
end;

procedure TKDECaption.SetCaptionFont(Value: TFont);
begin
  FCaptionFont.Assign(Value);
  Repaint;
end;

procedure TKDECaption.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
    begin
    FAutoSize := Value;
    Repaint;
    end;
end;

procedure TKDECaption.SetNumColors(Value: Integer);
begin
  if Value <> FNumColors then
    begin
    FNumColors := Value;
    Repaint;
    end;
end;

procedure TKDECaption.Loaded;
var
  Form: TForm;
  I: Integer;
  NeedRepaintMDIForm: Integer;
begin
  inherited Loaded;

  if FParentForm.FormStyle = fsMDIChild then
    begin
    NeedRepaintMDIForm := 0;
    Form :=nil;
    for I := 0 to Screen.FormCount - 1 do
      begin
      if Screen.Forms[I].FormStyle = fsMDIForm then
        begin
        Form := Screen.Forms[I];
        Inc(NeedRepaintMDIForm);
        end;
      if (Screen.Forms[I].FormStyle = fsMDIChild) and
         (Screen.Forms[I].WindowState = wsMaximized) then
        Inc(NeedRepaintMDIForm);
      end;
    if (NeedRepaintMDIForm >= 2) and (Form <> nil) then
      PostMessage(Form.Handle, WM_NCPAINT, 0, 0);
    PostMessage(FParentHandle, WM_NCPAINT, 0, 0);
    end;
end;

{ Begin 1997.11.30  Version 1.06 }
procedure TKDECaption.RestoreSysmenuStyle;
var
  Placement: TWindowPlacement;
begin
  Placement.Length := SizeOf(Placement);
  GetWindowPlacement(FParentHandle, @Placement);
  if not (csDesigning in ComponentState) then
    SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle);
  SetWindowPlacement(FParentHandle, @Placement);
end;

procedure TKDECaption.DeleteSysmenuStyle;
var
  Placement: TWindowPlacement;
begin
  Placement.Length := SizeOf(Placement);
  GetWindowPlacement(FParentHandle, @Placement);
  if not (csDesigning in ComponentState) then
    SetWindowLong(FParentHandle, GWL_STYLE, FOldStyle and not WS_SYSMENU);
  SetWindowPlacement(FParentHandle, @Placement);
end;
{ End Version 1.06 }

procedure TKDECaption.SetActiveBitmap(Value: TBitmap);
begin
FActiveBitmap.Assign(Value);
end;

procedure TKDECaption.SetInactiveBitmap(Value: TBitmap);
begin
FInactiveBitmap.Assign(Value);
end;

procedure Register;
begin
  RegisterComponents('Add-Ins', [TKDECaption]);
end;

end.

