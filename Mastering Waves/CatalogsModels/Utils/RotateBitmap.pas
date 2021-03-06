unit RotateBitmap;

{
 This unit implements a class, TStretchBitmap, which can stretch (rotate
 and skew) a bitmap object. The stretch routine is very fast because it is
 completelly written in assembly language.

 Unit written by NickBoss.
}
interface

uses
  Windows, Graphics, Math, SysUtils, Dialogs, Classes;

type
  TPlaneType = (ptOrthogonal, ptStretched);

  TPlane = record
    PlaneType: TPlaneType;
    Origin,
    X_Axis,
    Y_Axis: TPoint;
  end;

  TStretchHeader = record
    SourcePlane,
    TargetPlane: TPlane;
  end;

  TRotateRec = record
    x1, y1, x2, y2, w, h,
    x1s, y1s, x2s, y2s, x3s, y3s,
    ww, hh, maxw, maxh,
    ptr1, ptr2,
    ptrscanline1, ptrscanline2: integer;
  end;

  TArray = record
    x, y, cor: integer;
  end;

  TStretchBitmap = class
  private
    R: TRotateRec;
    function StretchBitm(Bitmap, Target: TBitmap; R: TRotateRec): Boolean;
    procedure MakeArray(X1S, X2S, Y1S, Y2S, W: integer; WW_ptr, ptr: Pointer);
    procedure StretchArea(R: TRotateRec; ErrX, ErrY: integer);
    function CheckPlane(pl: TPlane): Boolean;
    procedure AdjustTargetPlaneToBitmap;
  public
    SourceBitmap,      //the bitmap that is about to be transformed
    TargetBitmap: TBitmap;    //the bitmap to save the transformed image
    ResizeTargetBitmap: Boolean;  //set if you want to resize the target bitmap
    BackgroundColor: TColor;
    StretchHeader: TStretchHeader;  //transformation vectors
    ErrorX, ErrorY: integer;    //shows point where an error occurred
    constructor Create;
    function StretchIt: Boolean;  //stretch the bitmap according to StretchHeader
    function RotateIt(RotationAngle: Single): Boolean;  //rotate bitmsp
    function SkewIt(Horizontally, Vertically: Single): Boolean;  //skew bitmap
  end;

implementation

function TStretchBitmap.StretchBitm(Bitmap, Target: TBitmap; R: TRotateRec): Boolean;
var
  i: integer;
  pptr1, pptr2: array of TArray;
  ptrscanline1, ptrscanline2: array of integer;
begin
   SetLength(ptrscanline1, bitmap.Height);
   SetLength(ptrscanline2, target.Height);
   for i := 0 to bitmap.Height - 1 do
     ptrscanline1[i] := integer(bitmap.ScanLine[i]);
   for i := 0 to target.Height - 1 do
     ptrscanline2[i] := integer(target.ScanLine[i]);
   r.maxw := target.Width;
   r.maxh := target.Height;
   r.w := (r.x2 - r.x1);
   r.h := (r.y2 - r.y1);
   SetLength(pptr1, Max(abs(r.x2s-r.x1s), abs(r.y2s-r.y1s)) + 1);
   SetLength(pptr2, Max(abs(r.x3s-r.x1s), abs(r.y3s-r.y1s)) + 1);
   r.ptr1 := integer(pptr1);
   r.ptr2 := integer(pptr2);
   r.ptrscanline1 := integer(ptrscanline1);
   r.ptrscanline2 := integer(ptrscanline2);
   MakeArray(r.x1s, r.x2s, r.y1s, r.y2s, r.w, @r.ww, pptr1);
   MakeArray(r.x1s, r.x3s, r.y1s, r.y3s, r.h, @r.hh, pptr2);
   Result := true;
   try
     StretchArea(r, integer(@ErrorX), integer(@ErrorY));
   except
     on EAccessViolation do
     begin
       beep;
       ErrorX := pptr1[ErrorX div 12].cor;
       ErrorY := pptr2[ErrorY div 12].cor;
       Result := false;
     end;
   end;
end;

procedure TStretchBitmap.MakeArray(X1S, X2S, Y1S, Y2S, W: integer; WW_ptr, ptr: Pointer);
var
  WW: integer;
  WW_int_ptr: ^integer;
  h, place_1, place_2: integer;
  adder_x, adder_y: integer;
  base, sum_add, step, ptr1: integer;
label
  label1, label2, label3, label4, label5,
  label6, label7, label8, label9;
begin
  ptr1 := integer(ptr);
  WW_int_ptr := WW_ptr;
  asm
    push   eax
    push   ebx
    push   ecx
    push   edx
    push   esi
    push   edi
    pushf

    mov    ecx,1
    mov    edx,1
    mov    eax,X2S
    sub    eax,X1S     //eax = X1S - X2S
    cmp    eax,0
    jge    label1      //if eax >= 0 then goto label1
    neg    eax         //else reverse sign so that is positive
    mov    ecx,-1      //and mark that X1S - X2S is negative
label1:
    inc    eax
    mov    ebx,Y2S
    sub    ebx,Y1S
    cmp    ebx,0
    jge    label2
    neg    ebx
    mov    edx,-1
label2:
    inc    ebx
    mov    place_1,0
    mov    place_2,4
    cmp    eax,ebx
    jge    label3
    xchg   eax,ebx
    xchg   ecx,edx
    mov    place_1,4
    mov    place_2,0
label3:
    mov    h,ebx
    shl    eax,2
    mov    WW,eax
    shl    eax,1
    add    WW,eax
    shr    eax,3
    mov    adder_x,ecx
    mov    adder_y,edx
    shr    ebx,1
    xor    esi,esi
    mov    edi,ebx
    mov    ecx,ptr1
    add    ecx,place_1
    mov    edx,ptr1
    add    edx,place_2
    mov    esi,12
label4:
    mov    ebx,adder_x
    mov    dword ptr [ecx+esi],ebx
    mov    dword ptr [edx+esi],0
    add    edi,h
    cmp    edi,eax
    jl     label5
    mov    ebx,adder_y
    mov    dword ptr [edx+esi],ebx
    sub    edi,eax
label5:
    add    esi,12
    cmp    esi,WW
    jl     label4

    mov    edi,ptr1
    add    edi,8
    dec    eax
    mov    ebx,W
    xchg   eax,ebx                    {EAX = h και EBX = w}
    cmp    ebx,eax                    {σύγκριση w και h}
    jl     label6
    inc    eax                        {EAX = h = y2 - y1 + 1}
    inc    ebx                        {EBX = w = x2 - x1 + 1}
    mov    ecx,eax                    {αν w >= h τότε}
    shr    ecx,1
    mov    base,ecx                   {base = int(h/2)}
    mov    step,0                     {step = 0}
    mov    sum_add,eax                {sum_add = h}
    jmp    label7
label6:                                 {αν w <= h τότε}
    mov    ecx,ebx
    shr    ecx,1
    mov    base,ecx                   {base = int(w/2)}
    push   eax                        {αποθήκευση της τιμής h του EAX}
    xor    edx,edx                    {ο EDX:EAX προετοιμάζεται για
διαίρεση}
    div    ebx                        {διαίρεση EDX:EAX/EBX}
    mov    step,eax                   {step = EAX = int(h/w) (το ακέραιο
μέρος της διαίρεσης)}
    mov    sum_add,edx                {sum_add = EDX = h mod w (το υπόλοιπο
της διαίρεσης)}
    pop    eax                        {ανάκτηση της τιμής h του EAX}
label7:
    xor    esi,esi                    {ESI = i = 0}
    mov    ecx,base                   {ECX = sum = base}
    mov    edx,0                      {EDX = level = 0}
    mov    eax,WW                     {EAX = limit}
label8:
    mov    dword ptr [edi+esi],edx    {η array στο offset i παίρνει την τιμή
level}
    add    ecx,sum_add                {sum = sum + sum_add}
    add    edx,step                   {level = level + step}
    cmp    ecx,ebx
    jl     label9                     {αν sum >= w τότε}
    inc    edx                        {level = level + 1}
    sub    ecx,ebx                    {sum = sum - w}
label9:
    add    esi,12                      {i = i + 4 (διότι τα περιεχόμενα της
array τοποθετούνται ανά 4 bytes}
    cmp    esi,WW
    jl     label8                       {αν i = limit τότε τέλος της
ρουτίνας}

    popf
    pop    edi
    pop    esi
    pop    edx
    pop    ecx
    pop    ebx
    pop    eax
  end;
  WW_int_ptr^ := WW;
end;

procedure TStretchBitmap.StretchArea(R: TRotateRec; ErrX, ErrY: integer);
var
  ptr_y, x_prev, y_prev, maxh4: integer;
label
  label1, label2, label3, label4, label5, label6, label7;
begin
  asm
    pushad
    pushf
    xor    ebx,ebx
    xor    ecx,ecx
    xor    edx,edx
    xor    edi,edi
    mov    eax,R.maxh      //takes the height of the target bitmap
    shl    eax,2           //multiply by 4
    mov    maxh4,eax       //maxh4 stores the height of the target bitmap x 4
label1:
    mov    y_prev,ebx      //y_prev takes the previous value of y correspondance in source bitmap
    mov    ebx,ErrY        //address of ErrY is loaded on ebx
    mov    dword ptr [ebx],edi   //index of array of y correspondances is stored in ErrY
    mov    ebx,R.ptr2      //array of y correspondances is loaded on ebx
    mov    eax,dword ptr [ebx+edi]     //eax takes the step in x axis
    mov    esi,dword ptr [ebx+edi+4]   //esi takes the step in y axis
    mov    ebx,dword ptr [ebx+edi+8]   //ebx takes the y correspondance in source bitmap
    push   edi         //push index of array of y correspondances in stack
    add    ecx,eax     //ecx is the x position in the target bitmap
    add    edx,esi     //ecx is the y position in the target bitmap
    test   eax,esi     //if steps in both axis is <> 0 then continue
    jz     label5      //else goto to label5
    push   ebx         //push y correspondance in source bitmap in stack
    push   ecx         //push x position in target bitmap in stack
    push   edx         //push y position in target bitmap in stack
    add    ecx,R.x1s   //ecx get the relative position in x axis of target bitmap
    shl    ecx,1       //ecx is doubled
    sub    ecx,eax     //step in x axis is subtrscted from ecx
                       //ecx now has the intermediate value of relative position
                       //in x axis of target bitmap, doubled so that it is an
                       //integer value
    add    edx,R.y1s {R.y1s}
    shl    edx,1
    sub    edx,esi     //the same as ecx, for the y axis of target bitmap
    add    ebx,y_prev  //add previous value of y correspondance in source bitmap to the present value
    shr    ebx,1       //divide ebx by 2, in order to find the intermediate value
    add    ebx,r.y1    //get the relative to y1 value
    shl    ebx,2       //multiply by 4, in order to get the index of the address of the line
    add    ebx,R.ptrscanline1  //ebx gets the array of the line adresses of the source bitmap
    mov    ebx,dword ptr [ebx]  //get the line address of the source bitmap
{    add    ebx,r.x1}     {8bit}
    mov    esi,r.x1       {24bit}  //esi = x1
    add    ebx,esi        {24bit}
    add    ebx,esi        {24bit}
    add    ebx,esi        {24bit}  //get the address of x1 in line array
    mov    ptr_y,ebx    //ptr_y is the address of x1 in source bitmap
    xor    ebx,ebx
    xor    esi,esi
label2:
    mov    x_prev,ebx  //x_prev takes the previous value of x correspondance in source bitmap
    mov    ebx,ErrX    //address of ErrX is loaded on ebx
    mov    dword ptr [ebx],esi  //index of array of x correspondances is stored in ErrX
    mov    ebx,R.ptr1  //array of y correspondances is loaded on ebx
    mov    eax,dword ptr[ebx+esi]  //eax takes the step in x axis
    mov    edi,dword ptr[ebx+esi+4]  //edi takes the step in y axis
    mov    ebx,dword ptr[ebx+esi+8]  //ebx takes the x correspondance in source bitmap
    add    ecx,eax
    add    ecx,eax     //ecx has the final x position of target bitmap, doubled
    add    edx,edi
    add    edx,edi     //edx has the final y position of target bitmap, doubled
    test   eax,edi     //if steps in both axis is <> 0 then continue
    jz     label4      //else goto label4
    push   ebx         //push x correspondance in source bitmap in stack
    push   ecx         //push final x position in target bitmap in stack
    push   edx         //push final y position in target bitmap in stack
    sub    edx,edi     //edx has the final intermediate y position, doubled
    shl    edx,1       //final intermediate y position, quadrupled
    cmp    edx,maxh4   //check if y position in target bitmap exceeds bitmap limits
    jge    label3      //if it exceeds then continue to next point
    sub    ecx,eax     //ecx has the final intermediate x position, doubled
    shr    ecx,1       //ecx has the final intermediate x position
    cmp    ecx,R.maxw  //check if x position in target bitmap exceeds bitmap limits
    jge    label3      //if it exceeds then continue to next point
    add    edx,R.ptrscanline2  //edx gets the array of the line adresses of the target bitmap
{    add    ecx,dword ptr [edx]}  {8bit}
    mov    edx,dword ptr [edx]    {24bit}  //get the line address of the target bitmap
    add    edx,ecx                {24bit}
    add    edx,ecx                {24bit}
    add    ecx,edx                {24bit}  //ecx = edx + 3 * ecx
    add    ebx,x_prev  //add previous value of x correspondance in source bitmap to the present value
    shr    ebx,1       //divide ebx by 2, in order to find the intermediate value
    mov    edx,ebx                {24bit}  //edx takes intermediate x position in source bitmap
    add    ebx,ebx                {24bit}  //ebx takes intermediate x position in source bitmap, doubled
    add    ebx,ptr_y   //ebx = (address of the source point) - edx

//    mov    bl,byte ptr [ebx]    //8bit
//    mov    byte ptr [ecx],bl    //8bit
    mov    al, byte ptr [ebx+edx]   //al gets the first byte of the 24bit source color
    mov    byte ptr [ecx], al       //the first byte of the 24bit source color is assigned to target bitmap
    mov    ax, word ptr [ebx+edx+1] //al gets the next 2 bytes of the 24bit source color
    mov    word ptr [ecx+1], ax     //the next 2 bytes of the 24bit source color are assigned to target bitmap
label3:
    pop    edx
    pop    ecx
    pop    ebx
label4:
    add    esi,12
    cmp    esi,R.ww
    jl     label2
    pop    edx
    pop    ecx
    pop    ebx
label5:
    push   ebx
    push   ecx
    push   edx
    add    ecx,R.x1s
    add    edx,R.y1s
    mov    edi,R.ptrscanline1
    xor    esi,esi
    add    ebx,r.y1
    shl    ebx,2
    mov    ebx,dword ptr [ebx+edi]
{    add    ebx,r.x1}       {8bit}
    mov    edi,r.x1         {24bit}
    add    ebx,edi          {24bit}
    add    ebx,edi          {24bit}
    add    ebx,edi          {24bit}
    mov    ptr_y,ebx
    mov    edi,R.ptrscanline2
label6:
    mov    ebx,ErrX
    mov    dword ptr [ebx],esi
    mov    ebx,R.ptr1
    add    ecx,dword ptr [ebx+esi]
    add    edx,dword ptr [ebx+esi+4]
    cmp    edx,R.maxh
    jge    label7
    cmp    ecx,R.maxw
    jge    label7
    mov    ebx,dword ptr [ebx+esi+8]
    mov    eax,ebx              {24bit}
    add    ebx,ebx              {24bit}
    add    ebx,ptr_y

{    mov    bl,byte ptr [ebx]}  {8bit}
    add    ebx,eax
    mov    eax,edx
    shl    eax,2
    mov    eax,dword ptr [eax+edi]
    add    eax,ecx
    add    eax,ecx             //24bit
    add    eax,ecx             //24bit
    push   ecx
    mov    cl,byte ptr [ebx] //24bit
    mov    byte ptr [eax],cl //24bit
    mov    cx,word ptr [ebx+1] //24bit
//    mov    byte ptr [eax],bl //8bit
    mov    word ptr [eax+1],cx //24bit
    pop    ecx
label7:
    add    esi,12
    cmp    esi,R.ww
    jl     label6
    pop    edx
    pop    ecx
    pop    ebx
    pop    edi
    add    edi,12
    cmp    edi,R.hh
    jl     label1
    popf
    popad
  end;
end;

function TStretchBitmap.StretchIt: Boolean;
var
  sr: TRect;
begin
  result := false;
  if SourceBitmap = nil then
  begin
    MessageDlg('No source bitmap.', mtError, [mbOk], 0);
    exit;
  end;
  if TargetBitmap = nil then
  begin
    MessageDlg('No target bitmap.', mtError, [mbOk], 0);
    exit;
  end;
  if SourceBitmap = TargetBitmap then
  begin
    MessageDlg('Source and Target bitmaps cannot be the same.', mtError, [mbOk], 0);
    exit;
  end;
  if (SourceBitmap.PixelFormat <> pf24bit) or (TargetBitmap.PixelFormat <> pf24bit) then
  begin
    MessageDlg('Both bitmaps must be 24bit.', mtError, [mbOk], 0);
    exit;
  end;
  StretchHeader.SourcePlane.PlaneType := ptOrthogonal;
  StretchHeader.TargetPlane.PlaneType := ptStretched;
  if not CheckPlane(StretchHeader.SourcePlane) then exit;
  sr := Rect(0, 0, SourceBitmap.Width, SourceBitmap.Height);
  with StretchHeader.SourcePlane do
    if not (PtInRect(sr, Origin) and PtInRect(sr, X_Axis) and PtInRect(sr, Y_Axis)) then
    begin
      MessageDlg('Source plane out of bitmap bounds.', mtError, [mbOk], 0);
      exit;
    end;
  if ResizeTargetBitmap then
  begin
    TargetBitmap.Width := 0;
    TargetBitmap.Height := 0;
  end;
  AdjustTargetPlaneToBitmap;
  R.x1 := StretchHeader.SourcePlane.Origin.x;
  R.y1 := StretchHeader.SourcePlane.Origin.y;
  R.x2 := StretchHeader.SourcePlane.X_Axis.x;
  R.y2 := StretchHeader.SourcePlane.Y_Axis.y;
  R.x1s := StretchHeader.TargetPlane.Origin.x;
  R.y1s := StretchHeader.TargetPlane.Origin.y;
  R.x2s := StretchHeader.TargetPlane.X_Axis.x;
  R.y2s := StretchHeader.TargetPlane.X_Axis.y;
  R.x3s := StretchHeader.TargetPlane.Y_Axis.x;
  R.y3s := StretchHeader.TargetPlane.Y_Axis.y;
  TargetBitmap.Canvas.Brush.Color := BackgroundColor;
  sr := Rect(0, 0, TargetBitmap.Width, TargetBitmap.Height);
  TargetBitmap.Canvas.FillRect(sr);
  Result := StretchBitm(SourceBitmap, TargetBitmap, R);
  if Result then
  begin
    ErrorX := 0;
    ErrorY := 0;
  end;
end;

function TStretchBitmap.CheckPlane(pl: TPlane): Boolean;
begin
  if pl.PlaneType = ptOrthogonal then
  begin
    if (pl.X_Axis.y <> pl.Origin.y) or (pl.Y_Axis.x <> pl.Origin.x) then
    begin
      MessageDlg('Othogonal plane not properly set.', mtError, [mbOk], 0);
      CheckPlane := false;
      exit;
    end;
  end;
  CheckPlane := true;
end;

procedure TStretchBitmap.AdjustTargetPlaneToBitmap;
var
  p4, maxp, minp, dims: TPoint;
begin
  with StretchHeader.TargetPlane do
  begin
    p4.x := X_Axis.x + Y_Axis.x - Origin.x;
    p4.y := X_Axis.y + Y_Axis.y - Origin.y;
    maxp.x := MaxIntValue([X_Axis.x, Y_Axis.x, Origin.x, p4.x]);
    maxp.y := MaxIntValue([X_Axis.y, Y_Axis.y, Origin.y, p4.y]);
    minp.x := MinIntValue([X_Axis.x, Y_Axis.x, Origin.x, p4.x]);
    minp.y := MinIntValue([X_Axis.y, Y_Axis.y, Origin.y, p4.y]);
    Origin.x := Origin.x - minp.x;
    Origin.y := Origin.y - minp.y;
    X_Axis.x := X_Axis.x - minp.x;
    X_Axis.y := X_Axis.y - minp.y;
    Y_Axis.x := Y_Axis.x - minp.x;
    Y_Axis.y := Y_Axis.y - minp.y;
    dims.x := maxp.x - minp.x + 1;
    dims.y := maxp.y - minp.y + 1;
  end;
  if ResizeTargetBitmap then
  begin
    TargetBitmap.Width := dims.x;
    TargetBitmap.Height := dims.y;
  end;
end;

constructor TStretchBitmap.Create;
begin
  StretchHeader.SourcePlane.PlaneType := ptOrthogonal;
  StretchHeader.TargetPlane.PlaneType := ptStretched;
  ResizeTargetBitmap := true;
  BackgroundColor := clWhite;
end;

function TStretchBitmap.RotateIt(RotationAngle: Single): Boolean;
var
  pnew: TPoint;
  rad, sinf, cosf: Double;
begin
  rad := - Pi * RotationAngle / 180;
  sinf := Sin(rad);
  cosf := Cos(rad);
  StretchHeader.SourcePlane.Origin := Point(0, 0);
  StretchHeader.SourcePlane.X_Axis := Point(SourceBitmap.Width - 1, 0);
  StretchHeader.SourcePlane.Y_Axis := Point(0, SourceBitmap.Height - 1);
  StretchHeader.TargetPlane.Origin := Point(0, 0);
  pnew.x := trunc((SourceBitmap.Width - 1) * cosf + 0.5);
  pnew.y := trunc((SourceBitmap.Width - 1) * sinf + 0.5);
  StretchHeader.TargetPlane.X_Axis := pnew;
  pnew.x := -trunc((SourceBitmap.Height - 1) * sinf + 0.5);
  pnew.y := trunc((SourceBitmap.Height - 1) * cosf + 0.5);
  StretchHeader.TargetPlane.Y_Axis := pnew;
  Result := StretchIt;
end;

function TStretchBitmap.SkewIt(Horizontally, Vertically: Single): Boolean;
var
  pnew: TPoint;
begin
  StretchHeader.SourcePlane.Origin := Point(0, 0);
  StretchHeader.SourcePlane.X_Axis := Point(SourceBitmap.Width - 1, 0);
  StretchHeader.SourcePlane.Y_Axis := Point(0, SourceBitmap.Height - 1);
  StretchHeader.TargetPlane.Origin := Point(0, 0);
  pnew.x := SourceBitmap.Width - 1;
  pnew.y := trunc((SourceBitmap.Height - 1) * Vertically / 100 + 0.5);
  StretchHeader.TargetPlane.X_Axis := pnew;
  pnew.x := trunc( - (SourceBitmap.Width - 1) * Horizontally / 100 + 0.5);
  pnew.y := SourceBitmap.Height - 1;
  StretchHeader.TargetPlane.Y_Axis := pnew;
  Result := StretchIt;
end;

end.
