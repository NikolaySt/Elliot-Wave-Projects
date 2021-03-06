program CreateDBRules;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Arhiv in 'Arhiv.pas' {DlgArhiv},
  ArhivPr in 'Arhivpr.pas' {DlgArhivProgres};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDlgArhiv, DlgArhiv);
  Application.CreateForm(TDlgArhivProgres, DlgArhivProgres);
  Application.Run;
end.
