unit Models;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ImgList, ExtCtrls, jpeg, Menus, ToolWin, Db, DBTables,
  Grids, DBGrids, DBCtrls, DataBase, ExtDlgs, TreeModels, ViewImages,
  TextEditor, FileCtrl, GoldZip, RichEditURL;

type
  TNotifySavePosition = procedure(Position: integer) of object;

  TModelsForm = class(TForm)
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    MenuFail: TMenuItem;
    MenuArchives: TMenuItem;
    MenuExit: TMenuItem;
    MenuSoftware: TMenuItem;
    MenuAbout: TMenuItem;
    Panel1: TPanel;
    MainPage: TPageControl;
    TabSheet2: TTabSheet;
    Splitter2: TSplitter;
    TabSheet3: TTabSheet;
    DBGrid3: TDBGrid;
    Splitter3: TSplitter;
    TreeModelsFrame: TTreeModelsFrame;
    StandardImageFrame: TViewImagesFrame;
    RealImageFrame: TViewImagesFrame;
    EditorFrame: TEditorFrame;
    procedure FormCreate(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuArchivesClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure Splitter2Moved(Sender: TObject);
    procedure FormExtCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FOnSavePosition: TNotifySavePosition;
    FOnEditorModified: TNotifyEditorModified;
    FOnEditorSave: TNotifyEvent;
  public
    procedure ChangeView(Position: integer);
  published
    property OnSavePosition: TNotifySavePosition read FOnSavePosition write FOnSavePosition;
    property OnEditorModified: TNotifyEditorModified read FOnEditorModified write FOnEditorModified;
    property OnEditorSave: TNotifyEvent read FOnEditorSave write FOnEditorSave;    
  end;

var
  ModelsForm: TModelsForm;


function CreateMainForm: boolean;

implementation

{$R *.DFM}

uses About, {PrintNode,} Arhiv, Utils, ProgramConst, MessagesConst;

function CreateMainForm: boolean;
begin
  result := ModelsForm <> nil;
end;

procedure TModelsForm.FormCreate(Sender: TObject);
begin
  DBModuls.OnChangeView := ChangeView;
  OnSavePosition := DBModuls.SaveView;

  //RealImageFrame
  RealImageFrame.CreateFrame();
  RealImageFrame.OnDeleteImage := DBModuls.DeleteRealImage;
  RealImageFrame.OnSelectImage := DBModuls.SelectRealImage;
//  RealImageFrame.OnClearImage := DBModuls.ClearRealImage;
  RealImageFrame.OnEditImage := DBModuls.EditRealImage;
  RealImageFrame.OnAddImage := DBModuls.AddRealImage;

  DBModuls.OnChangeRealImage := RealImageFrame.ChangeImage;
  DBModuls.OnRecalcRealImage := RealImageFrame.RecalcImage;
  DBModuls.OnClearRealFrameImage := RealImageFrame.ClearFrameImage;
  //----------------------------------------------------------------------------

  //StandardImageFrame
  StandardImageFrame.CreateFrame();
  StandardImageFrame.OnDeleteImage := DBModuls.DeleteStdImage;
  StandardImageFrame.OnSelectImage := DBModuls.SelectStdImage;
//  StandardImageFrame.OnClearImage := DBModuls.ClearStdImage;
  StandardImageFrame.OnEditImage := DBModuls.EditStdImage;
  StandardImageFrame.OnAddImage := DBModuls.AddStdImage;

  DBModuls.OnChangeStdImage := StandardImageFrame.ChangeImage;
  DBModuls.OnRecalcStdImage := StandardImageFrame.RecalcImage;
  DBModuls.OnClearStdFrameImage := StandardImageFrame.ClearFrameImage;
  //----------------------------------------------------------------------------

  //Editor
  EditorFrame.CreateFrame();
  EditorFrame.OnSaveEditor := DBModuls.SaveEditor;
  EditorFrame.OnGetCaption := TreeModelsFrame.CaptionNode;
  EditorFrame.OnSelectFigure := StandardImageFrame.SelectImage;

  DBModuls.OnChangeEditor := EditorFrame.ChangeEditor;
  DBModuls.OnClearFrameEditor := EditorFrame.ClearFrameEditor;

  OnEditorModified := EditorFrame.GetModified;
  OnEditorSave := EditorFrame.FileSave;
  //----------------------------------------------------------------------------  
  
  // TreeModelsFrame
  TreeModelsFrame.OnFindModel := DBModuls.FindModel;
  TreeModelsFrame.OnReadAllTree := DBModuls.ReadAllTree;
  TreeModelsFrame.OnFindTree := DBModuls.FindTree;
  TreeModelsFrame.OnAddTree := DBModuls.AddTree;
  TreeModelsFrame.OnEditNameTree := DBModuls.EditNameTree;
  TreeModelsFrame.OnDeleteTree := DBModuls.DeleteTree;
  TreeModelsFrame.OnSaveTree := DBModuls.SaveTree;
  TreeModelsFrame.OnDeleteBranch := DBModuls.DeleteBranch;
  TreeModelsFrame.OnDeleteAllBranch := DBModuls.DeleteAllBranch;

  TreeModelsFrame.OnEditorModified := EditorFrame.GetModified;
  TreeModelsFrame.OnEditorSave := EditorFrame.FileSave;

  DBModuls.OnClearFrameTree := TreeModelsFrame.ClearFrameTree;
  DBModuls.OnChangeTree := TreeModelsFrame.ChangeTree;

  TreeModelsFrame.CreateFrame();
  //----------------------------------------------------------------------------
end;

procedure TModelsForm.MenuAboutClick(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TModelsForm.FormShow(Sender: TObject);
begin
  //PrintNode
  //FrmPrint.OnReadStdImageFromDB := DBModuls.StdImageSendToPrint;
  //FrmPrint.OnReadRealImageFromDB := DBModuls.RealImageSendToPrint;
  //DBModuls.OnPrintStdImage := FrmPrint.AddImageFromDB;
  //DBModuls.OnPrintRealImage := FrmPrint.AddImageFromDB;

  EditorFrame.ClearFrameEditor(nil);
end;

procedure TModelsForm.MenuArchivesClick(Sender: TObject);
var
  dest_path, source_path: string;
  check_update: boolean;
begin
  dest_path := GetPersonalPath(Handle);
  if DirectoryExists(dest_path + '\' + const_MyDocument_Archives_folder) then
    dest_path := dest_path + '\' + const_MyDocument_Archives_folder ;

  source_path := DBModuls.DBDirectory;
  DBModuls.CloseConnection;
  check_update := false;
  try

    if DlgArhiv.Execute(dest_path, source_path+'\') = arOpenArchive then begin
      check_update := true;
    end;
  finally
    if check_update then begin
      DBModuls.DataModuleCreate(nil);
      RealImageFrame.CreateFrame();
      StandardImageFrame.CreateFrame();
      EditorFrame.CreateFrame();
      TreeModelsFrame.CreateFrame();
    end
    else begin
      DBModuls.OpenConnection();
      DBModuls.SelectModelIndex(TreeModelsFrame.ModelIndex);
      DBModuls.SelectTreeIndex(TreeModelsFrame.TreeIndex);
    end;
  end;
end;

procedure TModelsForm.MenuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TModelsForm.ChangeView(Position: integer);
begin
  if (Position > 0) and (Position < Height) then EditorFrame.height := Position;
end;

procedure TModelsForm.Splitter2Moved(Sender: TObject);
begin
  if Assigned(FOnSavePosition) then FOnSavePosition(EditorFrame.height);
end;

procedure TModelsForm.FormExtCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  modified: boolean;
  msg_result: word;
begin
  msg_result := MessageDlg(const_mess_close_application, mtConfirmation, [mbYes, mbNo], 0);
  case msg_result of
    mrYes:
        begin
          CanClose := true;
          modified := false;
          if Assigned(FOnEditorModified) then FOnEditorModified(modified);
          if modified then begin
            msg_result := MessageDlg(const_mess_modified_editor, mtConfirmation, [mbYes, mbNo, mbCancel], 0);
            case msg_result of
              mrYes: FOnEditorSave(sender);
              mrCancel: CanClose := false;
            end;
          end;
        end;
    mrNo: CanClose := false;
  end;
end;

end.


