unit ViewCharts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, TeeShape, Series, ArrowCha, TeEngine, ExtCtrls,
  TeeProcs, Chart;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    Chart1: TChart;
    Series1: TFastLineSeries;
    Series2: TArrowSeries;
    Series3: TChartShape;
    Series4: TChartShape;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure ToolButton6Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ToolButton6Click(Sender: TObject);
var
  wave_a, wave_b, wave_c: double;
  ratio1, ratio2: double;
begin
    Chart1.BottomAxis.Maximum := 20;
    Chart1.BottomAxis.Minimum := 0;

    Chart1.LeftAxis.Maximum := 1.3650;
    Chart1.LeftAxis.Minimum := 1.3400;

    Series1.AddXY(1, 1.3620);
    Series1.AddXY(2, 1.3516);


    Series1.AddXY(3, 1.3564);
    Series1.AddXY(4, 1.3518);

    Series1.AddXY(5, 1.3561);
    Series1.AddXY(6, 1.3462);


    wave_a := Abs(1.3620 - 1.3516);
    wave_b := Abs(1.3516 - 1.3561);
    wave_c := Abs(1.3561 - 1.3462);

    ratio1 := wave_b/wave_a;
    ratio2 := wave_c/wave_a;


    Series2.AddArrow(1, 1.3620, 8, 1.3620, '', clRed);
    Series2.AddArrow(1, 1.3516, 8, 1.3516, '', clRed);
    Series2.AddArrow(7.5, 1.3620, 7.5, 1.3516, '', clRed);

//    Series2.AddArrow(5, 1.3561, 8, 1.3561, '', clGreen);

    Series3.X0 := 5;
    Series3.X1 := 8;
    Series3.Y0 := 1.3561;
    Series3.Y1 := 1.3561;
    Series3.Pen.Color := clGreen;
    Series3.Text.Clear;
    Series3.Text.Add('');
    Series3.Text.Add(FormatFloat('#0.#0%', ratio1*100));

    Series4.X0 := 6;
    Series4.X1 := 8;
    Series4.Y0 := 1.3462;
    Series4.Y1 := 1.3462;
    Series4.Pen.Color := clGreen;
    Series4.Text.Clear;
    Series4.Text.Add('');
    Series4.Text.Add(FormatFloat('#0.#0%', ratio2*100));

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var XDelta,YDelta,
    XRange,YRange:Double;
begin

  { initialize some temporary variables... }
  XDelta:=0;
  YDelta:=0;
  With Series1.GetHorizAxis do XRange:=Maximum-Minimum;
  With Series1.GetVertAxis  do YRange:=Maximum-Minimum;
  { handle keyboard !!! }
  if ssShift in Shift then
  begin
    Case key of
      VK_LEFT,VK_UP    : Chart1.ZoomPercent( 110 );
      VK_RIGHT,VK_DOWN : Chart1.ZoomPercent( 90 );
    end;
    exit;
  end
  else
  Case key of
    VK_LEFT  : XDelta:=-XRange/100;
    VK_RIGHT : XDelta:= XRange/100;
    VK_UP    : YDelta:= YRange/100;
    VK_DOWN  : YDelta:=-YRange/100;
    vk_Next  : YDelta:=-YRange/10;
    vk_Prior : YDelta:= YRange/10;
    VK_SPACE : Begin Chart1.UndoZoom; Exit; End;  { <-- reset scrolling }
  end;
  { apply scrolling !!! }
  With Chart1 do
  Begin
    LeftAxis.Scroll(YDelta,false);
    RightAxis.Scroll(YDelta,false);
    BottomAxis.Scroll(XDelta,false);
    TopAxis.Scroll(XDelta,false);
    //SetFocus;
  End;


end;

end.
