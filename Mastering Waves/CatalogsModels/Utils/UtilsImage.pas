unit UtilsImage;

interface

uses db, extctrls, classes, graphics;


procedure LoadImageFromStream(Stream: TStream; Image: TImage);
procedure LoadPictureFromStream(Stream: TStream; Picture: TPicture);
procedure ClearImage(Image: TImage);
procedure ZoomImage(Image: TImage; Factor: double);

procedure RotateImage(Picture: TPicture);

implementation

uses dbtables, Dialogs, GIFImg, jpeg, MessagesConst, FlipReverseRotateLibrary, RotateBitmap, RotateBitmapNT;

function SetGifImage(MS: TStream; Picture: TPicture): boolean; forward;
function SetBitmapImage(MS: TStream; Picture: TPicture): boolean; forward;
function SetJPEGImage(MS: TStream; Picture: TPicture): boolean; forward;


procedure ClearImage(Image: TImage);
var
  bitmap: TBitmap;
begin
  //clear bitmap

  bitmap := TBitmap.Create;
  try
    Image.Picture.Assign(bitmap);
  finally
    bitmap.free;

    Image.AutoSize := true;
    Image.Picture.Bitmap.FreeImage;
    Image.Picture.Bitmap.Dormant;
    Image.Refresh;
  end;
end;

procedure ZoomImage(Image: TImage; Factor: double);
begin
  Image.AutoSize := false;
  Image.Stretch := true;
  
  {
  Image.Height := Image.Picture.Height - Round(Image.Picture.Height*Factor);
  Image.Width := Image.Picture.Width - Round(Image.Picture.Width*Factor);
  }
  
end;

procedure LoadImageFromStream(Stream: TStream; Image: TImage);
begin
  if Stream.Size > 0 then begin

    if not SetGifImage(Stream, Image.Picture) then
      if not SetJPEGImage(Stream, Image.Picture) then
        if not SetBitmapImage(Stream, Image.Picture) then begin
          MessageDlg(const_mess_err_load_image, mtError, [mbOK], 0);
          ClearImage(Image);
        end;
  end
  else begin
    ClearImage(image);
  end;
end;

procedure LoadPictureFromStream(Stream: TStream; Picture: TPicture);
begin
  if Stream.Size > 0 then begin

    if not SetGifImage(Stream, Picture) then
      if not SetJPEGImage(Stream, Picture) then
        if not SetBitmapImage(Stream, Picture) then
          MessageDlg(const_mess_err_load_image, mtError, [mbOK], 0);
  end;
end;

function SetGifImage(MS: TStream; Picture: TPicture): boolean;
var
  gif: TGIFImage;
begin
  gif := TGIFImage.Create;
  try
    try
      MS.Position := 0;
      gif.LoadFromStream(MS);
      Picture.Assign(gif.bitmap);
      result := true;
    except
      result := false;
    end;
  finally
    gif.Free;
  end;
end;

function SetBitmapImage(MS: TStream; Picture: TPicture): boolean;
var
  bitmap: TBitmap;
begin
  bitmap := TBitmap.Create;
  try
    try
      MS.Position := 0;
      bitmap.LoadFromStream(MS);
      Picture.Assign(bitmap);
      result := true;
    except
      result := false;
    end;
  finally
    bitmap.Free;
  end;
end;

function SetJPEGImage(MS: TStream; Picture: TPicture): boolean;
var
  jpg: TJPEGImage;
begin
  jpg := TJPEGImage.Create;
  try
    try
      MS.Position := 0;
      jpg.LoadFromStream(MS);
      Picture.Assign(jpg);
      result := true;
    except
      result := false;
    end;
  finally
    jpg.Free;
  end;
end;

procedure RotateImage(Picture: TPicture);
var
  sourceBMP, RotateBMP: TBitmap;
  //str: TStretchBitmap;
begin
  sourceBMP := TBitmap.Create;
  try
    sourceBMP.Width  := Picture.Width;
    sourceBMP.Height := Picture.Height;
    sourceBMP.PixelFormat := pf24Bit;
    sourceBMP.Canvas.Draw(0,0, Picture.Graphic);

    RotateBMP := RotateScanline90(90, sourceBMP);
    {
    RotateBMP := TBitmap.Create;

    str := TStretchBitmap.Create;
    str.SourceBitmap := sourceBMP;
    str.TargetBitmap := RotateBMP;
    RotateBMP.PixelFormat := pf24Bit;
    str.RotateIt(90);
    }
    //Picture.Assign(RotateBMP);

//    RotateBMP := TBitmap.Create;
//    RotateBMP.PixelFormat := pf24Bit;
//    RotateBitmapNT.RotateBitmap(sourceBMP, RotateBMP, rvR270);

    Picture.Assign(RotateBMP);
//    Picture.Bitmap.Canvas.Draw(0,0, RotateBMP);
  finally
    sourceBMP.Free;
    if Assigned(RotateBMP) then RotateBMP.Free;
  end;

end;

end.
