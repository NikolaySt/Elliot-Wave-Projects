unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, 
  CtlPanel, GoldZip;

type
  TDTConfig = class(TAppletModule)
    GoldZip1: TGoldZip;
    procedure DTConfigActivate(Sender: TObject; Data: Integer);
    procedure GoldZip1ExpandStream(Sender: TObject; Stream: TStream;
      AName: String);
    procedure AppletModuleCreate(Sender: TObject);
    procedure AppletModuleDestroy(Sender: TObject);
  private
    ListData: TStringList;
    procedure FreeList;
  protected
    function CalcName(const rule, symbol, period: string): string;
  public
    function FindStream(AName: string; var MS: TMemoryStream): boolean;
    procedure Activations(rule: integer; condition: char; categoria: integer;
      symbol: string; period: string);
  end;

var
  DTConfig: TDTConfig;

    
implementation

{$R *.DFM}

uses
  REMain;

var
  MainForm: TMainForm;

procedure TDTConfig.Activations(rule: integer; condition: char; categoria: integer;
  symbol: string; period: string);
var
  afile, text_rule: string;
  MS: TMemoryStream;
begin
  DTConfigActivate(Application, 0);

  afile := '';
  case rule of
    1:
      case condition of
        'a': afile := '1_a.rtf';
        'b': afile := '1_b.rtf';
        'c': afile := '1_c.rtf';
        'd': afile := '1_d.rtf';
      end;
    2:
      case condition of
        'a': afile := '2_a.rtf';
        'b': afile := '2_b.rtf';
        'c': afile := '2_c.rtf';
        'd': afile := '2_d.rtf';
        'e': afile := '2_e.rtf';        
      end;
    3: ;
    4:
      case condition of
        'a':
            case categoria of
              1: afile := '4_a_i.rtf';
              2: afile := '4_a_ii.rtf';
              3: afile := '4_a_iii.rtf';
            end;
        'b':
            case categoria of
              1: afile := '4_b_i.rtf';
              2: afile := '4_b_ii.rtf';
              3: afile := '4_b_iii.rtf';
            end;
        'c':
            case categoria of
              1: afile := '4_c_i.rtf';
              2: afile := '4_c_ii.rtf';
              3: afile := '4_c_iii.rtf';
            end;
        'd':
            case categoria of
              1,2: afile := '4_d_i_ii.rtf';
              3: afile := '4_d_iii.rtf';
            end;
        'e':
            case categoria of
              1,2: afile := '4_e_i_ii.rtf';
              3:   afile := '4_e_iii.rtf';
            end;
      end;
    5:
      case condition of
        'a': afile := '5_a.rtf';
        'b': afile := '5_b.rtf';
        'c': afile := '5_c.rtf';
        'd': afile := '5_d.rtf';
      end;
    6:
      case condition of
        'a': afile := '6_a.rtf';
        'b': afile := '6_b.rtf';
        'c': afile := '6_c.rtf';
        'd': afile := '6_d.rtf';
      end;
    7:
      case condition of
        'a': afile := '7_a.rtf';
        'b': afile := '7_b.rtf';
        'c': afile := '7_c.rtf';
        'd': afile := '7_d.rtf';
      end;
  end;
  text_rule := 'Ï:' + IntToStr(rule) + '-' + condition;
  if rule = 4 then
    text_rule := text_rule + '-' + IntToStr(categoria);

  MS := nil;
  if FindStream(afile, MS) then begin
    if MS <> nil then
    MainForm.OpenStreamRules(MS, CalcName(text_rule, symbol, period), text_rule);
  end;    
end;

procedure TDTConfig.DTConfigActivate(Sender: TObject; Data: Integer);
begin
  if MainForm = nil then
  begin
    MainForm := TMainForm.Create(Application);
    with MainForm do
    begin
      Visible := true;
    end;
  end
  else begin
    MainForm.Visible := true;
  end;
end;

procedure TDTConfig.FreeList;
var
  stream: TObject;
  i: integer;
begin
  for i := 0 to ListData.Count - 1 do
  begin
    stream := ListData.Objects[i];
    stream.free;
  end;
  ListData.Clear;
end;

procedure TDTConfig.GoldZip1ExpandStream(Sender: TObject; Stream: TStream;
  AName: String);
var
  MS: TMemoryStream;
begin
  Stream.Position := 0;

  MS :=  TMemoryStream.Create;
  MS.LoadFromStream(Stream);
  ListData.AddObject(AName, MS);
end;

procedure TDTConfig.AppletModuleCreate(Sender: TObject);
begin
  ListData := TStringList.Create;
  FreeList;
  
	GoldZip1.PathToExpand := '';

	GoldZip1.ZipFile := ExtractFileDir(ParamStr(0)) + '\experts\libraries\dbrules.dat';
	GoldZip1.Expand;
end;

procedure TDTConfig.AppletModuleDestroy(Sender: TObject);
begin
  FreeList;
  ListData.Free;
end;

function TDTConfig.FindStream(AName: string; var MS: TMemoryStream): boolean;
var
  Index: integer;
begin

  if ListData.Find(AName, Index) then begin
    MS := ListData.Objects[Index] as TMemoryStream;
    result := true;
  end
  else
    result := false;
end;

function TDTConfig.CalcName(const rule, symbol, period: string): string;
var
  code: integer;  
begin
  try
    code := StrToInt(period);
    case code of
      5: result := 'Hourly';
      15: result := '288 minutes';
      60: result := 'Daily';
      240: result := 'Weekly';
      1440: result := 'Monthly';
      10080: result := '2.5 months';
      43200: result := '6 months';
    else
      result := period;
    end;
  except
    result := period;
  end;
  result := symbol + ':' + result;// + ' -> ' + rule;
end;

end.
