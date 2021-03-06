unit FullScreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TFormFullScreen = class(TForm)
    Image: TImage;
    procedure ImageDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure View(Source: TImage);
  end;

var
  FormFullScreen: TFormFullScreen;

implementation

{$R *.DFM}

{ TFormFullScreen }

procedure TFormFullScreen.View(Source: TImage);
begin
  Image.Picture.Assign(Source.Picture);

  if Image.Picture.Width > 30 then
    Width := Image.Picture.Width+10
  else
    Width := 150;

  if Image.Picture.Height > 30 then
    Height := Image.Picture.Height+25
  else
    Height := 150;

  if not Visible then begin
    Position := poScreenCenter;
    Top := 25;
    Left := 25;
  end;    
  Image.AutoSize := true;

  FormStyle := fsStayOnTop;
  Show;
end;

procedure TFormFullScreen.ImageDblClick(Sender: TObject);
begin
  Close;
end;

end.
