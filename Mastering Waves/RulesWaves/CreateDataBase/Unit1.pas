unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GoldZip, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GoldZip1: TGoldZip;
    Button2: TButton;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    RichEdit1: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure GoldZip1ExpandStream(Sender: TObject; Stream: TStream;
      AName: String);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    ListData: TStringList;
    procedure FreeList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Arhiv;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  DlgArhiv.Execute(Edit2.text, edit1.text);
end;

procedure TForm1.Button2Click(Sender: TObject);

begin
  FreeList;
	If OpenDialog1.Execute Then
      Try
      	Try
		  		GoldZip1.PathToExpand := '';
  				GoldZip1.ZipFile := OpenDialog1.FileName;
					GoldZip1.Expand;
        Finally
        End;
        //MessageDlg('OK', mtInformation, [mbOK], 0);
      Finally
      End;
	  
end;

procedure TForm1.GoldZip1ExpandStream(Sender: TObject; Stream: TStream;
  AName: String);
var
  MS: TMemoryStream;
begin
  MS :=  TMemoryStream.Create;
  Stream.Position := 0;
  MS.LoadFromStream(Stream);
  ListData.AddObject(AName, MS);
  ListBox1.Items.AddObject(AName, MS);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListData := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeList;
  ListData.Free;
end;

procedure TForm1.FreeList;
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
  ListBox1.Items.Clear;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var
  MS: TStream;
begin
  if ListBox1.Items.Count = 0 then exit;
  MS := ListBox1.Items.Objects[ListBox1.ItemIndex] as TStream;
  RichEdit1.Lines.LoadFromStream(MS);
end;

end.
