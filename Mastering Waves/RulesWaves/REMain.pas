unit REMain;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, FormExt, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ComCtrls, ClipBrd,
  ToolWin, ActnList, ImgList, TeEngine, Series, TeeProcs, Chart, TeeShape,
  ArrowCha, GoldZip;

type
  TMainForm = class(TFormExt)
    StatusBar: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabControl2: TTabControl;
    Editor: TRichEdit;
    TabSheet3: TTabSheet;
    TabControl4: TTabControl;
    EditorMethod: TRichEdit;
    procedure TabControl2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Series2GetMarkText(Sender: TChartSeries; ValueIndex: Integer;
      var MarkText: String);
    procedure PageControl1Change(Sender: TObject);
    procedure TabControl4Change(Sender: TObject);
  private
    procedure PerformStreamOpen(var MS: TMemoryStream);
  public
    procedure OpenStreamRules(var MS: TMemoryStream; Window: String; Rule: string);
    procedure ShowAbout;
  end;



var
  MainForm: TMainForm;

  save: string;
  arr_temp: array of double;

implementation

uses REAbout, RichEdit, ShellAPI, main;

type
  TInfoRules = class(TObject)
  private
    Rule: string;
    MS: TMemoryStream;
  public
    constructor Create(var AMS: TMemoryStream; ARule: string);
  end;

{$R *.DFM}


constructor TInfoRules.Create(var AMS: TMemoryStream; ARule: string);
begin
  inherited Create();
  MS := AMS;
  Rule := ARule;
end;

{ Event Handlers }

procedure TMainForm.PerformStreamOpen(var MS: TMemoryStream);
begin
  Editor.DefAttributes.Size := 10;
  MS.Position := 0;

  Editor.Lines.LoadFromStream(MS);
  //Editor.SetFocus;
  Editor.Modified := False;
  Editor.ReadOnly := True;

  Editor.DefAttributes.Size := 10;
end;



procedure TMainForm.TabControl2Change(Sender: TObject);
var
  index: integer;
  AMS: TMemoryStream;
begin
  index := TabControl2.TabIndex;
  with (TabControl2.Tabs.Objects[index] as TInfoRules) do begin
    AMS := MS;
    StatusBar.Panels[1].Text := Rule;
  end;

  PerformStreamOpen(AMS);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  count, i: integer;
  obj: TObject;
begin
  count := TabControl2.Tabs.Count;
  for i := 0 to count - 1 do begin
    obj := TabControl2.Tabs.Objects[i];
    obj.free;
  end;
end;

procedure TMainForm.Series2GetMarkText(Sender: TChartSeries;
  ValueIndex: Integer; var MarkText: String);
begin
  MarkText := 'niki';
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
var
  MS: TMemoryStream;
begin
  if PageControl1.ActivePage.PageIndex = 1 then
  begin
    EditorMethod.DefAttributes.Size := 12;


    DTConfig.FindStream('test_models.rtf', MS);
    MS.Position := 0;
    EditorMethod.Lines.LoadFromStream(MS);
    EditorMethod.DefAttributes.Size := 12;
    EditorMethod.Modified := False;
    EditorMethod.ReadOnly := True;

  end;    
end;

procedure TMainForm.TabControl4Change(Sender: TObject);
var
  index: integer;
  MS: TMemoryStream;
begin
  index := TabControl4.TabIndex;
  if index = 0 then
    DTConfig.FindStream('test_models.rtf', MS)
  else
    DTConfig.FindStream('method_group.rtf', MS);

    MS.Position := 0;
    EditorMethod.DefAttributes.Size := 12;
    EditorMethod.Lines.LoadFromStream(MS);
    EditorMethod.DefAttributes.Size := 12;
    EditorMethod.Modified := False;
    EditorMethod.ReadOnly := True;
end;

procedure TMainForm.ShowAbout;
begin
  with TAboutBox.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TMainForm.OpenStreamRules(var MS: TMemoryStream; Window, Rule: string);
var
  index: integer;
begin
  index := TabControl2.Tabs.IndexOf(Window);

  if index = -1 then begin
    TabControl2.Tabs.AddObject(Window, TInfoRules.Create(MS, Rule));
    PerformStreamOpen(MS);
    TabControl2.TabIndex := TabControl2.Tabs.Count - 1;
  end
  else begin
    if (Rule <> (TabControl2.Tabs.Objects[index] as TInfoRules).Rule) then begin
      (TabControl2.Tabs.Objects[index] as TInfoRules).MS := MS;
      (TabControl2.Tabs.Objects[index] as TInfoRules).Rule := Rule;
      TabControl2.TabIndex := index;
      PerformStreamOpen(MS);
    end;
    if index <> TabControl2.TabIndex then begin
      TabControl2.TabIndex := index;
      PerformStreamOpen(MS);
    end;      
  end;
  StatusBar.Panels[1].Text := Rule;
end;


end.
