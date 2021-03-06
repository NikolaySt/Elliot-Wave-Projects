unit Arhiv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GoldZip, StdCtrls, Gauges, ComCtrls, Menus, ExtCtrls, FileCtrl;

type
  TArchiveResult = (arOpenArchive, arNone);
  
  TDlgArhiv = class(TForm)
    BtnCreateArchiv: TButton;
    BtnOpenArchiv: TButton;
    OpenArhiv: TOpenDialog;
    SaveArhiv: TSaveDialog;
    BtnExit: TButton;
    Bevel1: TBevel;
    Image1: TImage;
    Bevel2: TBevel;
    GoldZip1: TGoldZip;
    procedure BtnCreateArchivClick(Sender: TObject);
    procedure BtnOpenArchivClick(Sender: TObject);
    procedure GoldZip1StatusAdd(Sender: TObject; Path: String;
      Progress: Integer);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FResult: TArchiveResult;
    FDBPath, FDestPath: String;
    procedure Delete(Path: String; AFilename: string);
    procedure Move(Path: String; AFilename: string);    
  protected
    Procedure DeleteFiles(Path: String);
    Procedure MoveFiles(Path: String);
  public
		function Execute(Dest, Soruce: string): TArchiveResult;
  end;

var
  DlgArhiv: TDlgArhiv;

implementation

{$R *.DFM}

Uses Utils, ArhivPr, MessagesConst, ProgramConst;

function TDlgArhiv.Execute(Dest, Soruce: String): TArchiveResult;
begin
  FResult := arNone;
  FDBPath := Soruce;
  FDestPath := Dest;
	ShowModal;
  result := FResult;
end;

procedure TDlgArhiv.BtnCreateArchivClick(Sender: TObject);
begin
  SaveArhiv.InitialDir := FDestPath;
	If SaveArhiv.Execute Then Begin
  	If FileExists(SaveArhiv.FileName) Then
	  	If MessageDlg(const_mess_OverrideFile,	mtConfirmation, [mbYES, mbNO], 0) = mrNo Then Exit;
      
  	GoldZip1.ZipFile := SaveArhiv.FileName;
    GoldZip1.FilesToProcess(FDBPath+'*.rtf');
    Try
  		DlgArhivProgres.Show;
    	GoldZip1.Add;
    Finally
    	DlgArhivProgres.Close;
      Update;
    End;
    MessageDlg(const_mess_ReadyOK, mtInformation, [mbOK], 0);
	End;
end;


procedure TDlgArhiv.BtnOpenArchivClick(Sender: TObject);
Var
	Path: String;
  A: array[0..255] Of Char;
begin
	If OpenArhiv.Execute Then
  	If MessageDlg(const_mess_ArchiveOpen,	mtConfirmation, [mbYES, mbNO], 0) = mrYES Then Begin

      GetTempPath(MAX_PATH, A);
      Path := StrPas(A) + const_temp_directory + '\';
      Try
      	Try
      		DlgArhivProgres.Show;
		  		GoldZip1.PathToExpand := Path;
  				GoldZip1.ZipFile := OpenArhiv.FileName;
					GoldZip1.Expand;
        Finally
        	DlgArhivProgres.Close;
        End;
        Application.ProcessMessages;
        DeleteFiles(FDBPath);
        MoveFiles(Path);

        MessageDlg(const_mess_ReadyOK, mtInformation, [mbOK], 0);
      Finally
        DeleteFiles(Path);
        DeleteFolder(StrPas(A) + const_temp_directory)
      End;
      FResult := arOpenArchive;
	  End;//If MessageDlg1('Информацията....
end;

procedure TDlgArhiv.GoldZip1StatusAdd(Sender: TObject; Path: String;
  Progress: Integer);
begin
	DlgArhivProgres.LblFileName.Caption := ExtractFileName(Path);
	DlgArhivProgres.GProgress.Progress := Progress;
end;

procedure TDlgArhiv.DeleteFiles(Path: String);
begin
  Delete(Path, Path+'*.rtf');
end;

procedure TDlgArhiv.MoveFiles(Path: String);
begin
  Move(Path, Path+'*.rtf');
end;

procedure TDlgArhiv.Delete(Path: String; AFilename: string);
Var
	i: Integer;
  Search: TSearchRec;
  ListFile: TStringList;
begin
  I := FindFirst(AFilename, faAnyFile, Search);
  ListFile := TStringList.Create;
  Try
  	While i = 0 Do Begin
      ListFile.Add(Path + Search.Name);
    	i := FindNext(Search);
    End;
   	For i := 0 To ListFile.Count - 1 Do
    	DeleteFile(PChar(ListFile.Strings[i]));
  Finally
  	ListFile.Free;
  	FindClose(Search)
  End;
end;

procedure TDlgArhiv.Move(Path: String; AFilename: string);
Var
	i: Integer;
  Search: TSearchRec;
  ListFile: TStringList;
begin
  I := FindFirst(AFilename, faAnyFile, Search);
  ListFile := TStringList.Create;
  Try
  	While i = 0 Do Begin
      ListFile.Add(Path + Search.Name);
    	i := FindNext(Search);
    End;
   	For i := 0 To ListFile.Count - 1 Do
    	MoveFile(
      	PChar(ListFile.Strings[i]),
      	PChar(FDBPath + ExtractFileName(ListFile.Strings[i]))
        );
  Finally
  	ListFile.Free;
  	FindClose(Search)
  End;
end;

procedure TDlgArhiv.BtnExitClick(Sender: TObject);
begin
	Close;
end;


procedure TDlgArhiv.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then  Close;
end;

end.
