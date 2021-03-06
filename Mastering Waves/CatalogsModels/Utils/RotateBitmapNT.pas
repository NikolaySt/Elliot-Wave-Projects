unit RotateBitmapNT;

interface

uses Windows, graphics;

type
  TRotateValue = (rv0, rvR90, rvR180, rvR270, rvL90, rvL180, rvL270);

procedure RotateBitmap(ASource: TBitmap; ADest: TBitmap; ADirection: TRotateValue);  

implementation

procedure RotateBitmap(ASource: TBitmap; ADest: TBitmap; ADirection: TRotateValue);
var
  LPoints: array[0..2] of TPoint;
  LDest: TBitmap;
begin 
  if (ADirection = rv0) and (ASource = ADest) then
    Exit
  else 
  begin 
    LDest := TBitmap.Create;
    if ADirection in [rv0, rvL180, rvR180] then 
    begin 
      LDest.Width := ASource.Width;
      LDest.Height := ASource.Height; 
    end else begin 
      LDest.Width := ASource.Height; 
      LDest.Height := ASource.Width; 
    end; 
    if ADirection = rv0 then 
    begin 
      BitBlt(LDest.Canvas.Handle, 0, 0, ASource.Width, ASource.Height, ASource.Canvas.Handle, 0, 0, SRCCOPY); 
    end else begin 
      if (ADirection = rvL90) or (ADirection = rvR270) then 
      begin 
        LPoints[0].X := 0; 
        LPoints[0].Y := ASource.Width; 

        LPoints[1].X := 0; 
        LPoints[1].Y := 0; 

        LPoints[2].X := ASource.Height; 
        LPoints[2].Y := ASource.Width; 
      end; 
      if (ADirection = rvR90) or (ADirection = rvL270) then 
      begin 
        LPoints[0].X := ASource.Height; 
        LPoints[0].Y := 0; 

        LPoints[1].X := ASource.Height; 
        LPoints[1].Y := ASource.Width; 

        LPoints[2].X := 0; 
        LPoints[2].Y := 0; 
      end; 
      if (ADirection = rvR180) or (ADirection = rvL180) then 
      begin 
        LPoints[0].X := ASource.Width - 1; 
        LPoints[0].Y := ASource.Height - 1; 

        LPoints[1].X := -1; 
        LPoints[1].Y := ASource.Height - 1; 

        LPoints[2].X := ASource.Width - 1; 
        LPoints[2].Y := -1; 
      end; 
      PlgBlt(LDest.Canvas.Handle, LPoints, ASource.Canvas.Handle, 0, 0, ASource.Width, ASource.Height, 0, 0, 0); 
    end; 
    ADest.Assign(LDest); 
    LDest.Free; 
  end;
end;  

end.
 