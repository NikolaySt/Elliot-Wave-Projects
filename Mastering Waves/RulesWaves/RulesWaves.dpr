library RulesWaves;

uses
  SysUtils,
  Classes,
  Windows,
  Messages,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  main in 'main.pas' {DTConfig: TAppletModule},
  REMain in 'REMain.pas' {MainForm},
  Reabout in 'REABOUT.PAS' {AboutBox};

{$R *.RES}



function ViewTestRules(rule: integer; condition: pchar; categoria: integer;
  symbol: pchar; period: pchar): integer; stdcall;
begin
  DTConfig.Activations(rule, condition[0], categoria, string(symbol), string(period));
  result := 0;
end;

function DataTransfer(arr: pointer; size: integer): integer; stdcall;
var
  temp: array of double;
  i: integer;
begin
  save := '';
  asm
   // int 03h
  end;
  temp := arr;
  asm
   // int 03h
  end;
  
  SetLength(arr_temp, size);
  for i := 0 to size-1 do
  begin
    arr_temp[i] := temp[i];
    save := save + ', ' + FloatToStr(temp[i]);
  end;
  result := Round(arr_temp[0]);
end;

exports
  ViewTestRules,
  DataTransfer;

begin
  Application.Initialize;
  Application.CreateForm(TDTConfig, DTConfig);
  Application.Run;
end.