unit ArhivPr;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Gauges, ExtCtrls;

type
  TDlgArhivProgres = class(TForm)
    GProgress: TGauge;
    LblFileName: TLabel;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgArhivProgres: TDlgArhivProgres;

implementation

{$R *.DFM}

procedure TDlgArhivProgres.FormShow(Sender: TObject);
begin
	GProgress.Progress := 0;
  LblFileName.Caption := '';
end;

end.
