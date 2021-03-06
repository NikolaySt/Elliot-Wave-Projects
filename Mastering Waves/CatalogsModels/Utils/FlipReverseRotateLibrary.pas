UNIT FlipReverseRotateLibrary;

INTERFACE

USES Dialogs, Windows,  Graphics;
  // The Rotation function is only for the Scanline Method.
  // Note:  Windows NT supports a "plgblt" API call that can be used to rotate
  // images.

  FUNCTION RotateScanline90(CONST angle:  INTEGER;
                            CONST Bitmap:  TBitmap):  TBitmap;

IMPLEMENTATION

USES
  Classes,    // Rect
  SysUtils;   // Exception

CONST
  MaxPixelCount = 65536;   // or some other arbitrarily large value

TYPE
  EBitmapError = CLASS(Exception);
  TRGBArray    = ARRAY[0..MaxPixelCount-1] OF TRGBTriple;
  pRGBArray    = ^TRGBArray;

//////////////////////////////////////////////////////////////////////////////
// Rotate 24-bits/pixel Bitmap any multiple of 90 degrees.
FUNCTION RotateScanLine90(CONST angle:  INTEGER;
                          CONST Bitmap:  TBitmap):  TBitmap;

  // These four internal functions parallel the four cases in rotating a
  // bitmap using the Pixels property.  See the RotatePixels example on
  // the Image Processing page of efg's Computer Lab for an example of the
  // use of the Pixels property (which is very slow).

  // A Bitmap.Assign could be used for a simple copy.  A complete example
  // using ScanLine is included here to help explain the other three cases.


  FUNCTION Rotate90DegreesCounterClockwise:  TBitmap;
     VAR
      i     :  INTEGER;
      j     :  INTEGER;
      rowIn :  pRGBArray;
  BEGIN
    RESULT := TBitmap.Create;
    RESULT.Width  := Bitmap.Height;
    RESULT.Height := Bitmap.Width;
    RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

    // Out[j, Right - i - 1] = In[i, j]
    FOR  j := 0 TO Bitmap.Height - 1 DO
    BEGIN
      rowIn  := Bitmap.ScanLine[j];
      FOR i := 0 TO Bitmap.Width - 1 DO
        pRGBArray(RESULT.ScanLine[Bitmap.Width - i - 1])[j] := rowIn[i]
    END
  END {Rotate90DegreesCounterClockwise};


  // Could use Rotate90DegreesCounterClockwise twice to get a
  // Rotate180DegreesCounterClockwise.  Rotating 180 degrees is the same
  // as a Flip and Reverse
  FUNCTION Rotate180DegreesCounterClockwise:  TBitmap;
    VAR
      i     :  INTEGER;
      j     :  INTEGER;
      rowIn :  pRGBArray;
      rowOut:  pRGBArray;
  BEGIN
    RESULT := TBitmap.Create;
    RESULT.Width  := Bitmap.Width;
    RESULT.Height := Bitmap.Height;
    RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

    // Out[Right - i - 1, Bottom - j - 1] = In[i, j]
    FOR  j := 0 TO Bitmap.Height - 1 DO
    BEGIN
      rowIn  := Bitmap.ScanLine[j];
      rowOut := RESULT.ScanLine[Bitmap.Height - j - 1];
      FOR i := 0 TO Bitmap.Width - 1 DO
        rowOut[Bitmap.Width - i - 1] := rowIn[i]
    END

  END {Rotate180DegreesCounterClockwise};


  // Could use Rotate90DegreesCounterClockwise three times to get a
  // Rotate270DegreesCounterClockwise
  FUNCTION Rotate270DegreesCounterClockwise:  TBitmap;
    VAR
      i    :  INTEGER;
      j    :  INTEGER;
      rowIn:  pRGBArray;
  BEGIN
    RESULT := TBitmap.Create;
    RESULT.Width  := Bitmap.Height;
    RESULT.Height := Bitmap.Width;
    RESULT.PixelFormat := Bitmap.PixelFormat;    // only pf24bit for now

    // Out[Bottom - j - 1, i] = In[i, j]
    FOR  j := 0 TO Bitmap.Height - 1 DO
    BEGIN
      rowIn  := Bitmap.ScanLine[j];
      FOR i := 0 TO Bitmap.Width - 1 DO
        pRGBARray(RESULT.Scanline[i])[Bitmap.Height - j - 1] := rowIn[i]
    END
  END {Rotate270DegreesCounterClockwise};


BEGIN
  //IF   Bitmap.PixelFormat <> pf24bit
  //THEN RAISE EBitmapError.Create('Can Rotate90 only 24-bit bitmap');

  IF   (angle >= 0) AND (angle MOD 90 <> 0)
  THEN RAISE EBitmapError.Create('Rotate90:  Angle not positive multiple of 90 degrees');

  CASE (angle DIV 90) MOD 4 OF
    1:  RESULT := Rotate90DegreesCounterClockwise;  // Anticlockwise for the Brits
    2:  RESULT := Rotate180DegreesCounterClockwise;
    3:  RESULT := Rotate270DegreesCounterClockwise
    ELSE
      RESULT := NIL    // avoid compiler warning
  END;

END {RotateScanline90};

END.
