program ArdCatalogs;

uses
  LocalProgramMem,
  Forms,
  Models in 'Modules\Models.pas' {ModelsForm},
  ViewImages in 'Modules\ViewImages.pas' {ViewImagesFrame: TFrame},
  About in 'Modules\About.pas' {FormAbout},
  DataBase in 'Modules\DataBase.pas' {DBModuls: TDataModule},
  EditTreeFrm in 'Modules\EditTreeFrm.pas' {FormEdit},
  FullScreen in 'Modules\FullScreen.pas' {FormFullScreen},
  TextEditor in 'Modules\TextEditor.pas' {EditorFrame: TFrame},
  TreeModels in 'Modules\TreeModels.pas' {TreeModelsFrame: TFrame},
  Arhiv in 'Modules\Arhiv.pas' {DlgArhiv},
  Arhivpr in 'Modules\Arhivpr.pas' {DlgArhivProgres},
  Utils in 'Utils\Utils.pas',
  UtilsTree in 'Utils\UtilsTree.pas',
  FlipReverseRotateLibrary in 'Utils\FlipReverseRotateLibrary.pas',
  MessagesConst in 'Utils\MessagesConst.pas',
  RotateBitmap in 'Utils\RotateBitmap.pas',
  UtilsDB in 'Utils\UtilsDB.pas',
  UtilsImage in 'Utils\UtilsImage.pas',
  ProgramConst in 'Utils\ProgramConst.pas',
  RotateBitmapNT in 'Utils\RotateBitmapNT.pas';

{$R *.RES}

begin
  Application.Initialize;
  if not RunProgramGlobalVar('Ariadna_Katalog_v1.0_2008') then
    try
      Application.Title := 'Ариадна - Каталог 1.0';
      Application.CreateForm(TDBModuls, DBModuls);
  Application.CreateForm(TModelsForm, ModelsForm);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormEdit, FormEdit);
  Application.CreateForm(TFormFullScreen, FormFullScreen);
  Application.CreateForm(TDlgArhiv, DlgArhiv);
  Application.CreateForm(TDlgArhivProgres, DlgArhivProgres);
  Application.Run;
    finally
      ExitProgramGrobalVar;
    end
  else
    ExitProgramGrobalVar;
end.


