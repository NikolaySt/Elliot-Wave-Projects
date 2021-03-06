unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtDlgs, ExtCtrls, dbtables, ComCtrls, Db, Grids, DBGrids,
  DBCtrls, QuickRpt, Qrctrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses gifimage, Unit2;

procedure TForm1.Button1Click(Sender: TObject);
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    with Form2 do begin
      Table1Info.SaveToStream(MS);
      MS.Position := 0;
      QRRichText3.Lines.LoadFromStream(MS);

      MS.Clear;
      Table2Charts.SaveToStream(MS);
      MS.Position := 0;
      QRImage1.Picture.Bitmap.LoadFromStream(MS);


      MS.Position := 0;
      Image1.Picture.Bitmap.LoadFromStream(MS);

      QuickRep1.Preview;
    end;

  finally
    MS.Free;
  end;
end;

end.
