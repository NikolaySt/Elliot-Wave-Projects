unit EditTreeFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFormEdit = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    EditText: string;
    function ShowModalEdit(Atext: string = ''; ACaption: string = '' ): integer;
  end;

var
  FormEdit: TFormEdit;

implementation

{$R *.DFM}


procedure TFormEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EditText := Edit1.text;
end;

function TFormEdit.ShowModalEdit(Atext: string = ''; ACaption: string = ''): integer;
begin
  Edit1.text := Atext;
  if ACaption = '' then Caption := 'Елемент'
  else Caption := ACaption;
  result := ShowModal;
end;

procedure TFormEdit.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

end.
