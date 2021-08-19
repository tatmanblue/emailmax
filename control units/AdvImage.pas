{******************************************************************************
 TadvImage : use methode loadImage(filename : String)
             or property imagename := filename

 This is a BETA version... feel free to contribute!

 This software is Freeware.

      By Janick Fortin
      Send modifications,Bugs and comments
      fortin01@gel.ulaval.ca


-Legal Notice------------------------------------------------------------------

 TadvImage and TAdvOpenPictureDlg for Delphi 3 based on :

 GifImage      mboler@flash.net
                Mark Boler

 TJpegImage     Copyright (C) 1991-1996, Thomas G. Lane.
                All Rights Reserved except as specified below.

 Others         Some code are Copyright of Borland Internationnal



 Before using the GIF and JPEG format in any commercial application
 be sure you know the legal issues for this format!


 History :

 24 Dec 97 : release of 0.87B (TadvImage and TAdvOpenPictureDlg)
 13 jan 98 : release of 0.93B (TadvImage) GDI bug corrected
******************************************************************************}

unit AdvImage;

interface

uses
  Windows,SysUtils,forms, Classes, Graphics, Controls,ExtCtrls,jpeg,
  dsgnintf,MPGifImg;

type
   TImageType = (itBmp,itGif,itJpeg,itUnknown);

    TAboutAdvImage = class(TPropertyEditor)
    public
      function GetAttributes: TPropertyAttributes; override;
      procedure Edit; override;
      function GetValue: string; override;
    end;

  TAdvImage = class(TpaintBox)
  private
    FFileSize            : Integer;
    FImageType           : TImageType;
    FGifAnimate          : Boolean;
    FStretchRatio        : Boolean;
    FCenterView          : Boolean;
    Fchecked             : Boolean;
    FShowEmptyLabel      : Boolean;
    FPixelFormat         : TJPEGPixelFormat;
    FScale               : TJPEGScale;
    FGrayscale           : Boolean;
    FPerformance         : TJPEGPerformance;
    FProgressiveDisplay  : Boolean;
    FSmoothing           : Boolean;
    FProgressiveEncoding : Boolean;
    FCompressionQuality  : TJPEGQualityRange;
    FFrame3D             : Boolean;
    FAbout               : TAboutAdvImage;
    FCaptionBottom       : TCaption;
    FPicture             : TPicture;
    FImageName           : String;
    FCheckColor          : TColor;
    FSpeed               : Integer;
    FEmptyLabel          : TCaption;
    FBevelWidth          : Integer;
    FDrawRect            : TRect;
    
    procedure SetShowEmptyLabel(value: Boolean);
    procedure SetProgressiveEncoding(value: Boolean);
    procedure SetSmoothing(value: Boolean);
    procedure SetPixelFormat(value: TJPEGPixelFormat);
    procedure SetScale(value: TJPEGScale);
    procedure SetGrayscale(value: Boolean);
    procedure SetPerformance(value: TJPEGPerformance);
    procedure PictureChanged(Sender: TObject);
    procedure SetCenterView(value : Boolean);
    procedure SetStretchRatio(value : Boolean);
    procedure SetGifAnimate(value : Boolean);
    procedure PaintCheck;
    procedure SetFrame3D(value : Boolean);
    procedure SetPicture(Value: TPicture);
    procedure setImageName(value : String);
    procedure SetCheckColor(value : TColor);
    procedure SetSpeed(Value : Integer);
    procedure SetBevelWidth(Value : Integer);
    procedure SetEmptyLabel(value : TCaption);

  protected 
    procedure Paint; override;
    procedure SetCaptionBottom(Value : TCaption);

  public
    property Picture : TPicture
     read FPicture write SetPicture;

    property FileSize : Integer
     read FFileSize;

    constructor Create(aOwner: TComponent); override;
    destructor  destroy; override;
    procedure   Clear;
    procedure   loadImage(Filename : String);
    procedure   SetChecked(Value : Boolean);
    procedure   SaveAsBitmap(const filename : String);
    procedure   SaveAsJpeg(const filename : String);
    procedure   Resize(Area : TRect);
    procedure   ConvertToJpeg;
    procedure   ConvertToBmp;
    function    GetimageType : TImageType;
  published
  
    {read only} 
    property ImageType: TImageType
      read GetimageType;

    property ImageName: String
      read FImageName write setImageName;

    property BevelWidth: Integer
      read FBevelWidth write setBevelWidth;

    property GIFAnimate: Boolean
      read FGifAnimate write SetGifAnimate;

    property ShowFrame3D: Boolean
      read FFrame3D write SetFrame3D;

    property StretchRatio: Boolean
      read FStretchRatio write SetStretchRatio;

    property CenterView: Boolean
      read FCenterView write SetCenterView;

    property ShowEmptyLabel: Boolean
      read FShowEmptyLabel write SetShowEmptyLabel;

    {Jpeg}
    property JPEGPixelFormat: TJPEGPixelFormat
      read FPixelFormat write SetPixelFormat;

    property JPEGScale: TJPEGScale
      read FScale write SetScale;

    property JPEGGrayscale: Boolean
      read FGrayscale write SetGrayscale;

    property JPEGPerformance: TJPEGPerformance
      read FPerformance write SetPerformance;

    property JPEGSmoothing: Boolean
      read FSmoothing write SetSmoothing;

    property JPEGProgressiveEncoding : Boolean
      read FProgressiveEncoding write SetProgressiveEncoding;

    property JPEGCompressionQuality : TJPEGQualityRange
      read FCompressionQuality write FCompressionQuality;

    property JPEGProgressiveDisplay : Boolean
      read FProgressiveDisplay write FProgressiveDisplay;

    property About: TAboutAdvImage
      read FAbout write FAbout;

    property Caption  : TCaption
      read FCaptionBottom write SetCaptionBottom Stored true;

    property Font;

    property Checked  : Boolean
      read FChecked write SetChecked;

    property CheckColor  : TColor
     read FCheckColor write SetCheckColor;

    property GifAnimateSpeed : Integer
     read FSpeed write SetSpeed;

    Property EmptyLabel : TCaption
     read FEmptyLabel write SetEmptyLabel;

  end;

procedure Register;   

function GetStretchRatio(CtrlWidth,CtrlHeight,PictureWidth,PictureHeight : Integer) : TRect;
function GetCenterView(CtrlRec,PictureRect : TRect) : TRect;
function GetfileSize(filename : string) : integer;

implementation

function GetfileSize(filename : string) : integer;
var
 f: file of Byte;
begin
 {getting file size}
 if not FileExists(Filename) then
  begin
   Result := 0;
   exit;
  end;

 try
  AssignFile(f, filename);
 except
  Result := 0;
  Exit;
 end;

 Reset(f);
 Result := FileSize(f);
 CloseFile(F);
end;         

function GetStretchRatio(CtrlWidth,CtrlHeight,PictureWidth,PictureHeight : Integer) : TRect;
begin
 Result := rect(0,0,CtrlWidth,CtrlHeight);
  
 if (PictureHeight > CtrlHeight) and (PictureWidth > CtrlWidth) then
    begin
     Result.Bottom := trunc(PictureHeight * (CtrlWidth / PictureWidth));
     if Result.Bottom > CtrlHeight then
      begin
       Result.right := trunc(Result.right * (CtrlHeight / Result.Bottom));
       Result.Bottom := CtrlHeight;
      end;
    end else if PictureHeight > CtrlHeight
              then Result.right := trunc(PictureWidth * (CtrlHeight / PictureHeight))
              else if PictureWidth > CtrlWidth
                    then Result.Bottom := trunc(PictureHeight * (CtrlWidth / PictureWidth))
                    else Result := Rect(0,0,PictureWidth,PictureHeight);                                       
end;

function GetCenterView(CtrlRec,PictureRect : TRect) : TRect;
var
 L_R : Integer;
begin
 L_R := PictureRect.Left;
 PictureRect.Left   := CtrlRec.left + ((CtrlRec.right-CtrlRec.left)div 2) - ((PictureRect.right - PictureRect.left) div 2);
 PictureRect.Right := PictureRect.Left - L_R + PictureRect.Right;
 L_R := PictureRect.Top;
 PictureRect.Top    := CtrlRec.top + ((CtrlRec.bottom-CtrlRec.top)div 2) - ((PictureRect.bottom - PictureRect.top) div 2);
 PictureRect.bottom := PictureRect.Top - L_R + PictureRect.bottom;
  
 Result := PictureRect;
end;



procedure TAboutAdvImage.Edit;
begin
 Application.MessageBox('by janick Fortin : fortin01@gel.ulaval.ca '+#10#13+
   'This component is FreeWare','TAdvImage version 0.93B',MB_ICONASTERISK);
end;

function TAboutAdvImage.GetValue: string;
begin
 Result := 'About TAvImage';
end;

function TAboutAdvImage.GetAttributes: TPropertyAttributes;
begin
 Result := [paMultiSelect, paDialog, paReadOnly];
end;

constructor TAdvImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := '';
  FPicture := Tpicture.Create;
  FPicture.OnChange := PictureChanged;
  FimageName := '';
  FcheckColor := clred;
  FSpeed := 10;
  FBevelWidth := 1;
  FEmptylabel := 'Empty';
end;

destructor TAdvImage.destroy;
begin
 FPicture.Free;
 inherited destroy;
end;


function TAdvImage.GetImageType : TImageType;
begin
 if (FPicture.Graphic is TGIFImage)
  then Result := itGif
  else if (FPicture.Graphic is TJpegImage)
        then Result := itJpeg
        else if (FPicture.Graphic is TBitmap)
              then Result := itBmp
              else Result := itunknown;
end;

procedure TAdvImage.SaveAsBitmap(const filename : String);
var
 Bitmap:  TBitmap;
begin
 Bitmap := TBitmap.Create;
 try
  Bitmap.Assign(TJPEGImage(FPicture.Graphic));
  Bitmap.SaveToFile(filename);
 finally
  Bitmap.Free
 end;

end;

procedure TAdvImage.SaveAsJpeg(const filename : String);
var
 jpeg:  TJPEGImage;
begin
 jpeg := TJPEGImage.Create;
 try    
  jpeg.Assign(FPicture.Graphic);
  jpeg.SaveToFile(filename);
 finally
  jpeg.Free
 end;

end;

procedure TAdvImage.SetPicture(Value: TPicture);
begin
 FPicture.assign(value);
 if not FPicture.bitmap.Empty
  then FPicture.bitmap.Dormant;

 paint;
end;

procedure TAdvImage.Setimagename(Value: String);
begin
 if Value <> FimageName then
  begin
   FimageName := Value;
   if (FimageName <> '') and FileExists(FimageName)
    then loadimage(value)
    else Clear;
  end;
end;

procedure TAdvImage.PictureChanged(Sender: TObject);
begin
 if (FPicture.Width > 0) and (FPicture.Height > 0) and
    (((FPicture.Graphic is TGIFImage) and FGifAnimate) or ((FPicture.Graphic is TJPEGImage)and FProgressiveDisplay))
  then Paint;
end;

procedure TAdvImage.SetGifAnimate(Value : Boolean);
begin
 if Value <> FGifAnimate then
  begin
   if (FPicture.Graphic <> nil) and (FPicture.Graphic is TGIFImage)
    then TGIFImage(FPicture.Graphic).Animating:= Value;

   FGifAnimate := Value;
  end;
end;


procedure TAdvImage.SetSpeed(Value : Integer);
begin
 if Value <> FSpeed then
  begin
   if (FPicture.Graphic <> nil) and (FPicture.Graphic is TGIFImage)
    then TGIFImage(FPicture.Graphic).Interval:= Value;

   FSpeed := Value;
  end;
end;

procedure TAdvImage.SetFrame3D(value : Boolean);
begin
 if Value <> FFrame3D then
  begin
   FFrame3D := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetBevelWidth(value : Integer);
begin
 if Value <> FBevelWidth then
  begin
   FBevelWidth := Value;
   Invalidate;
  end;
end;     

procedure TAdvImage.SetCheckColor(value : TColor);
begin
 if Value <> FcheckColor then
  begin
   FcheckColor := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetCaptionBottom(Value : TCaption);
begin
 if Value <> FCaptionBottom then
  begin
   if (FCaptionBottom <> '') and (Value <> '')
    then PaintCheck
    else invalidate;

   FCaptionBottom := Value;
  end;
end;

procedure TAdvImage.SetEmptyLabel(Value : TCaption);
begin
 if Value <> FEmptyLabel then
  begin
   FEmptyLabel := Value;
   invalidate;   
  end;
end;

procedure TAdvImage.SetCenterView(value : Boolean);
begin
 if Value <> FCenterView then
  begin
   FCenterView := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetStretchRatio(value : Boolean);
begin
 if Value <> FStretchRatio then
  begin
   FStretchRatio := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.Clear;
begin
 FPicture.bitmap := nil;
 FDrawRect := rect(0,0,0,0);
 Fimagename := '';
 paintcheck;
end;

procedure TAdvImage.SetProgressiveEncoding(value: Boolean);
begin
 if Value <> FProgressiveEncoding then
  begin
   FProgressiveEncoding := Value;
   Invalidate;
  end;
end;


procedure TAdvImage.SetSmoothing(value: Boolean);
begin
 if Value <> FSmoothing then
  begin
   FSmoothing := Value;
   Invalidate;
  end;
end;


procedure TAdvImage.SetShowEmptyLabel(value: Boolean);
begin
 if Value <> FShowEmptyLabel then
  begin
   FShowEmptyLabel := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetPixelFormat(value : TJPEGPixelFormat);
begin
 if Value <> FPixelFormat then
  begin
   FPixelFormat := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetPerformance(value : TJPEGPerformance);
begin
 if Value <> FPerformance then
  begin
   FPerformance := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetGrayscale(value : Boolean);
begin
 if Value <> FGrayscale then
  begin
   FGrayscale := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.SetChecked(value : Boolean);
begin
 if Value <> FChecked then
  begin
   FChecked := Value;
   PaintCheck;    
  end;
end;

procedure TAdvImage.SetScale(value : TJPEGScale);
begin
 if Value <> FScale then
  begin
   FScale := Value;
   Invalidate;
  end;
end;

procedure TAdvImage.LoadImage(Filename : String);
var
 ValidPicture: Boolean;
begin 
 ValidPicture := FileExists(Filename) and
                 (GetFileAttributes(PChar(Filename)) <> $FFFFFFFF);   
 if ValidPicture then
  begin
   try
    FPicture.LoadFromFile(Filename);
   except
    on EInvalidGraphic do
     FPicture.Graphic := nil;
   end;

   {set jpeg options}
   if FPicture.Graphic is TJPEGImage then
    with TJPEGImage(FPicture.Graphic) do
     begin
      PixelFormat        := FPixelFormat;
      Scale              := FScale;
      Grayscale          := FGrayscale;
      Performance        := FPerformance;
      ProgressiveDisplay := FProgressiveDisplay;
     end;                                                 

   {set gif options}
   if (FPicture.Graphic <> nil) and (FPicture.Graphic is TGIFImage) then
    begin
     TGIFImage(FPicture.Graphic).Animating := FGifAnimate;
     TGIFImage(FPicture.Graphic).Interval := FSpeed;
    end;
  end else FPicture.Assign(nil);

  FFileSize := GetFileSize(Filename);
  Paint;
end;

procedure TAdvImage.Paint;
var
 CtrlRect : TRect;
 
begin
 if (csDesigning in ComponentState) and not (FFrame3D)
  then inherited Paint;

 {initialise drawrect}
 FDrawRect := ClientRect;
 CtrlRect  := ClientRect;

 if FFrame3D then
  begin
   Frame3D(Canvas,FDrawRect, clBtnHighlight, clBtnShadow, FBevelWidth);
   CtrlRect := Rect(BevelWidth,BevelWidth,Width-BevelWidth,Height-BevelWidth);
  end;

 {Draw caption on bottom}
 if FCaptionBottom <> ''
  then CtrlRect.bottom := CtrlRect.bottom - Canvas.textHeight(FCaptionBottom);
   
 if FPicture.Width = 0 then
  begin
   if FShowEmptyLabel
    then Canvas.Textout((Width- Canvas.textWidth(FEmptyLabel)) div 2,
                        (Height- Canvas.textHeight(FEmptyLabel)) div 2,FEmptyLabel);
   exit;
  end;

 {stretch ratio}
 if FStretchRatio
  then FDrawRect := GetStretchRatio(CtrlRect.Right - CtrlRect.left,CtrlRect.bottom - CtrlRect.top,
                    FPicture.width,FPicture.Height)
  else FDrawRect := Rect(0,0,FPicture.Width,FPicture.Height);

 if FFrame3D
  then FDrawRect := Rect(FDrawRect.left+FBevelWidth,FDrawRect.top+FBevelWidth,
                         FDrawRect.right+FBevelWidth,FDrawRect.bottom+FBevelWidth);

 if CenterView
  then FDrawRect := GetCenterView(CtrlRect,FDrawRect);

 if FStretchRatio
  then Canvas.StretchDraw(FDrawRect, FPicture.Graphic)
  else Canvas.Draw(FDrawRect.left,FDrawRect.top, FPicture.Graphic);

 PaintCheck;
end;

procedure TAdvImage.PaintCheck;
var
 Marge : Integer;

 Newstr : String;
 OldStr : String[255];
 I      : Integer;
begin
 if Fchecked
  then Canvas.Brush.Color := Fcheckcolor
  else Canvas.Brush.Color := Color;

 if FFrame3D
  then Marge := FBevelWidth
  else Marge := 0;

 if FPicture.Width > 0 then
  begin
   {avoid flicking when drawing large image}
   canvas.FillRect(Rect(Marge,Marge,FDrawRect.rIGHT,FDrawRect.Top));
   canvas.FillRect(Rect(FDrawRect.right,Marge,width-Marge,FDrawRect.Bottom));
   canvas.FillRect(Rect(FDrawRect.left,FDrawRect.Bottom,width-Marge,Height - Marge));
   canvas.FillRect(Rect(Marge,FDrawRect.top,FDrawRect.left,Height-Marge));
  end else canvas.FillRect(Rect(Marge,Marge,Width-Marge,Height-Marge));


 newstr := FCaptionBottom;
 if Canvas.textWidth(FCaptionBottom) > Width - 2*marge   then
  begin
   newstr := '';
   oldstr := FCaptionBottom;
   for i := 1 to length(FCaptionBottom) do
    if Canvas.textWidth(newstr) < Width - 2*marge
     then newstr := newstr + oldstr[i]
     else Break;

  end;
  
 if FCaptionBottom <> ''
  then Canvas.Textout((Width- Canvas.textWidth(newstr)) div 2,Height- Canvas.textHeight(newstr)-FBevelWidth,newstr);
end;

procedure TAdvImage.Resize(Area : TRect);
var
 img : TImage;
 Ratio : TRect;  
begin
 img := TImage.Create(self);       
 Ratio := GetStretchRatio(Area.right -Area.left,Area.bottom - Area.top,
                          FPicture.width,FPicture.Height);
 try
  img.width := Ratio.right -Ratio.left;
  img.height := Ratio.bottom - Ratio.top;
  img.canvas.stretchdraw(Ratio,FPicture.Graphic);
  Clear;
  FPicture.assign(img.picture);
 finally
  img.free;
 end;

 invalidate;
end;

procedure TAdvImage.ConvertToJpeg;
var
 JPEG : TJPEGImage;
begin
 {saving options}
 JPEG := TJPEGImage.Create;
 JPEG.ProgressiveEncoding := FProgressiveEncoding;
 JPEG.CompressionQuality  := FCompressionQuality;
 JPEG.Grayscale           := FGrayscale;
 try
  JPEG.Assign(FPicture.Bitmap);
  FPicture.Graphic := JPEG
 finally
  JPEG.Free
 end;
end;

procedure TAdvImage.ConvertToBMP;
var
 BMP : TBitmap;
begin
 BMP := TBitmap.Create;
 try
  BMP.Assign(FPicture.Bitmap);
  FPicture.Graphic := BMP
 finally
  BMP.Free
 end;
end;

procedure Register;
begin
  RegisterComponents('Alpine', [TAdvImage]);
  RegisterPropertyEditor(TypeInfo(TAboutAdvImage), TAdvImage, 'ABOUT', TAboutAdvImage); 
end;



end.
