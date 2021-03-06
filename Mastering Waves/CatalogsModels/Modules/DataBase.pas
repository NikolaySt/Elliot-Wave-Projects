unit DataBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, ComCtrls;

type
  TTypeSaveInTable = (tsEdit, tsInsert, tsAppend);

  TNotifyRecalcImage = procedure(count: integer) of object;
  TNotifyChangeStream = procedure(Stream: TStream) of object;
  TPrintImage = procedure(Stream: TStream; EndImage: boolean = false) of object;
  TNotifyChangeView = procedure(Position: integer) of object;

  TDBModuls = class(TDataModule)
    TblModels: TTable;
    DSModels: TDataSource;
    TblStdCharts: TTable;
    TblRules: TTable;
    DSRules: TDataSource;
    TblRulesSegment: TStringField;
    TblRulesRule: TStringField;
    TblRulesParagraphs: TMemoField;
    TblTree: TTable;
    DB: TDatabase;
    DBSession: TSession;
    DSTree: TDataSource;
    TblTreeID: TIntegerField;
    TblTreeInfo: TStringField;
    TblTreeTree: TBlobField;
    TblModelsID: TIntegerField;
    TblModelsInfo: TMemoField;
    TblModelsDBRules: TStringField;
    TblModelsDBStdCharts: TStringField;
    TblTreeFile: TStringField;
    TblStdChartsField: TBlobField;
    TblRealCharts: TTable;
    TblRealChartsField: TBlobField;
    TblModelsDBRealCharts: TStringField;
    TblModelsPositionEditor: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure TblModelsAfterPost(DataSet: TDataSet);
    procedure TblTreeAfterPost(DataSet: TDataSet);
    procedure TblStdChartsAfterPost(DataSet: TDataSet);
    procedure TblTreeAfterDelete(DataSet: TDataSet);
    procedure TblStdChartsAfterDelete(DataSet: TDataSet);
    procedure TblModelsAfterDelete(DataSet: TDataSet);
    procedure TblRealChartsAfterPost(DataSet: TDataSet);
    procedure TblRealChartsAfterDelete(DataSet: TDataSet);
  private
    //OnStdImage
    FOnChangeStdImage: TNotifyChangeStream;
    FOnRecalcStdImage: TNotifyRecalcImage;
    FOnClearStdFrameImage: TNotifyEvent;
    //OnRealImage
    FOnChangeRealImage: TNotifyChangeStream;
    FOnClearRealFrameImage: TNotifyEvent;
    FOnRecalcRealImage: TNotifyRecalcImage;    
    //--------------------------------------------------------------------------
    //OnEditor                                        
    FOnClearFrameEditor: TNotifyEvent;    
    FOnChangeEditor: TNotifyChangeStream;
    //--------------------------------------------------------------------------
    //OnTree
    FOnChangeTree: TNotifyChangeStream;
    FOnClearFrameTree: TNotifyEvent;
    FOnPrintStdImage: TPrintImage;
    FOnPrintRealImage: TPrintImage;
    //--------------------------------------------------------------------------

    FStdChartsAcitve, FRealChartsAcitve, FModelsAcitve, FTreeActive: boolean;
    FOnChangeView: TNotifyChangeView;

    function CreateNewModels(): integer;
    procedure EmptyTableModels;
    procedure LoadTableModels(AName: string);
    procedure DeleteTableModels(AName: string);
    function CreateTableModels(AName: string): string;    

    procedure ChangeModel(AFind: boolean = true);

    //Work With Image
    function CreateTableStdCharts(AName: string): string;
    function CreateTableRealCharts(AName: string): string;

    procedure SaveNameTableStdCharts(AName: string);
    procedure SaveNameTableRealCharts(AName: string);        

    procedure OpenDBStdCharts(aFileName: string; AFind: Boolean = true);
    procedure OpenDBRealCharts(aFileName: string; AFind: Boolean = true);

    function CountStdImage: integer;
    procedure ChangeStdImage();
    procedure ClearStdFrameImage;

    function CountRealImage: integer;
    procedure ChangeRealImage();
    procedure ClearRealFrameImage;
    //--------------------------------------------------------------------------

    //Work Editor
    procedure ChangeEditor(AFind: boolean = true);
    procedure ClearFrameEditor;
    //--------------------------------------------------------------------------

    //Work With Tree
    procedure ChangeTree();
    procedure ClearFrameTree;
    //--------------------------------------------------------------------------

    //View Models----------------------------------------------------------------
    procedure ChangeView;


    procedure SaveStreamToField(state: TTypeSaveInTable; DestField: TField; Stream: TStream);

    procedure ApplyDB;
    procedure Pack(ATable: TTable);
    function GenerationCode: string;
    function GenerationName(base: string): string;
  public
    //Work With Standard Image
    procedure SelectStdImage(Sender: TObject; index: integer);
    procedure DeleteStdImage(Sender: TObject);
    procedure ClearStdImage(Sender: TObject);
    procedure EditStdImage(Sender: TObject; AFileName: string);
    function AddStdImage(sender: TObject; AFileName: string): integer;
    //Work with Real Image
    procedure SelectRealImage(Sender: TObject; index: integer);
    procedure DeleteRealImage(Sender: TObject);
    procedure ClearRealImage(Sender: TObject);
    procedure EditRealImage(Sender: TObject; AFileName: string);
    function AddRealImage(sender: TObject; AFileName: string): integer;
    //--------------------------------------------------------------------------

    //Work With Tree
    procedure FindModel(var Code: integer);
    procedure FindTree(var Code: integer);
    procedure ReadAllTree(List: TStrings);
    procedure AddTree(index: integer; AName: string);
    procedure EditNameTree(AName: string);
    procedure DeleteTree(index: integer);
    procedure DeleteBranch(var Arr_code: array of integer; size: Integer);
    procedure DeleteAllBranch;
    procedure SaveTree(Stream: TStream);
    //--------------------------------------------------------------------------

    //Work Editor
    procedure SaveEditor(sender: TObject; Stream: TStream);
    //--------------------------------------------------------------------------
    function StdImageSendToPrint: integer;
    function RealImageSendToPrint: integer;

    //Utillyti
    function DBDirectory: string;
    procedure CloseConnection;
    procedure OpenConnection;
    procedure SelectTreeIndex(Code: integer);
    procedure SelectModelIndex(Code: integer);

    //View
    procedure SaveView(Position: integer);
  published
    //OnStdImage
    property OnChangeStdImage: TNotifyChangeStream read FOnChangeStdImage write FOnChangeStdImage;
    property OnRecalcStdImage: TNotifyRecalcImage read FOnRecalcStdImage write FOnRecalcStdImage;
    property OnClearStdFrameImage: TNotifyEvent read FOnClearStdFrameImage write FOnClearStdFrameImage;

    property OnChangeRealImage: TNotifyChangeStream read FOnChangeRealImage write FOnChangeRealImage;
    property OnRecalcRealImage: TNotifyRecalcImage read FOnRecalcRealImage write FOnRecalcRealImage;
    property OnClearRealFrameImage: TNotifyEvent read FOnClearRealFrameImage write FOnClearRealFrameImage;
    //--------------------------------------------------------------------------
    //OnEditor
    property OnChangeEditor: TNotifyChangeStream read FOnChangeEditor write FOnChangeEditor;
    property OnClearFrameEditor: TNotifyEvent read FOnClearFrameEditor write FOnClearFrameEditor;
        
    //OnTree
    property OnChangeTree: TNotifyChangeStream read FOnChangeTree write FOnChangeTree;
    property OnClearFrameTree: TNotifyEvent read FOnClearFrameTree write FOnClearFrameTree;
    //--------------------------------------------------------------------------

    //OnPrintImage
    property OnPrintStdImage: TPrintImage read FOnPrintStdImage write FOnPrintStdImage;
    property OnPrintRealImage: TPrintImage read FOnPrintRealImage write FOnPrintRealImage;

    //OnChangeModelView
    property OnChangeView: TNotifyChangeView read FOnChangeView write FOnChangeView;
  end;

var
  DBModuls: TDBModuls;

implementation

{$R *.DFM}

uses models, UtilsDB;

procedure TDBModuls.DataModuleCreate(Sender: TObject);
begin
  DB.Close;
  CheckDBAlias(DB, DBSession);
  DB.Open;
  if not TblTree.Exists then TblTree.CreateTable;
//  if not TblModels.Exists then TblModels.CreateTable;

  TblTree.Active := true;
  ClearFrameTree;
//  TblModels.Active := true;
end;

//------------------------------------------------------------------------------
// Work with Image!
//------------------------------------------------------------------------------
procedure TDBModuls.OpenDBStdCharts(aFileName: string; AFind: Boolean = true);
begin
  TblStdCharts.Close;

  if AFind then begin
    if AFileName = '' then begin
      TblStdCharts.TableName := CreateTableStdCharts(AFileName);
      SaveNameTableStdCharts(TblStdCharts.TableName);
    end
    else
      TblStdCharts.TableName := AFileName;

    if not TblStdCharts.Exists then TblStdCharts.CreateTable;
    TblStdCharts.Open;


    if Assigned(FOnRecalcStdImage) then FOnRecalcStdImage(CountStdImage);
    ChangeStdImage;
  end;    
end;

procedure TDBModuls.ChangeStdImage;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    TblStdChartsField.SaveToStream(MS);
    if Assigned(FOnChangeStdImage) then FOnChangeStdImage(MS)
  finally
    MS.Free;
  end;
end;

function TDBModuls.CountStdImage: integer;
begin
  result := TblStdCharts.RecordCount;
  if result = 0 then result := 1;
end;

procedure TDBModuls.EditStdImage(Sender: TObject; AFileName: string);
begin
  TblStdCharts.Edit;
  TblStdChartsField.LoadFromFile(aFileName);
  TblStdCharts.Post;
  ChangeStdImage;
end;

function TDBModuls.AddStdImage(sender: TObject; AFileName: string): Integer;
begin
  TblStdCharts.Append;
  TblStdChartsField.LoadFromFile(AFileName);
  TblStdCharts.Post;
  result := CountStdImage;
  ChangeStdImage;
end;

procedure TDBModuls.SelectStdImage(sender: TObject; index: integer);
var
  i: integer;
begin
  if TblStdCharts.Active then begin
    if index >= 0 then begin
      TblStdCharts.First;
      for i := 1 to index do TblStdCharts.Next;
    end
    else
      TblStdCharts.First;
    ChangeStdImage;
  end;
end;

procedure TDBModuls.ClearStdImage(sender: TObject);
begin
  TblStdCharts.Edit;
  TblStdChartsField.Clear;
  TblStdCharts.Post;
  ChangeStdImage;
end;

procedure TDBModuls.DeleteStdImage(Sender: TObject);
begin
  if TblStdCharts.Eof then exit;
  TblStdCharts.Delete;
  TblStdCharts.First;
  if Assigned(FOnRecalcStdImage) then FOnRecalcStdImage(CountStdImage);
  ChangeStdImage;
end;

procedure TDBModuls.FindModel(var Code: integer);
var
  find: boolean;
begin
  with TblModels do begin
    EditKey;
    TblModelsID.AsInteger := Code;
    find := GotoKey;
    if not find then
      find := (TblModelsID.AsInteger = Code) and (code <> 0);
  end;
  if not find then code := CreateNewModels();
  ChangeModel(true);
end;

procedure TDBModuls.SaveEditor(sender: TObject; Stream: TStream);
begin
  SaveStreamToField(tsEdit, TblModelsInfo, Stream);
end;

//------------------------------------------------------------------------------
// Work with Tree!
//------------------------------------------------------------------------------

procedure TDBModuls.FindTree(var Code: integer);
begin
  with TblTree do begin
    EditKey;
    TblTreeID.AsInteger := Code;
    GotoKey;
  end;
  ChangeTree;
  ClearFrameEditor;
  ClearStdFrameImage;
  ClearRealFrameImage;    
end;

procedure TDBModuls.SaveTree(Stream: TStream);
begin
  if Stream.Size = 0 then
  begin
    EmptyTableModels();
    ClearFrameEditor;
    ClearStdFrameImage;
    ClearRealFrameImage;
  end;    
  SaveStreamToField(tsEdit, TblTreeTree, Stream);
//  ChangeTree;
end;

procedure TDBModuls.AddTree(index: integer; AName: string);
begin
  TblTree.Append;
  TblTreeID.AsInteger := index;
  TblTreeInfo.AsString := AName;
  TblTreeFile.AsString := CreateTableModels(AName);
  TblTree.Post;

  ChangeTree;
  ClearFrameEditor;
  ClearStdFrameImage;
  ClearRealFrameImage;
end;

procedure TDBModuls.ReadAllTree(List: TStrings);
begin
  try
    if TblTree.Active then begin
        TblTree.First;
        while not TblTree.Eof do
        begin
          List.Add(TblTreeInfo.AsString);
          TblTree.Next;
        end;

    end;
  finally
    TblTree.First;
    ChangeTree;
    ClearStdFrameImage;
    ClearRealFrameImage;    
    ClearFrameEditor;
    ClearFrameTree;    
  end;

end;

procedure TDBModuls.EditNameTree(AName: string);
begin
  TblTree.Edit;
  TblTreeInfo.AsString := AName;
  TblTree.Post;
//  ChangeTree;
end;

procedure TDBModuls.DeleteTree(index: integer);
var
  save_index: integer;
begin
  save_index := TblTreeID.AsInteger;
  EmptyTableModels;
  DeleteTableModels(TblTreeFile.AsString);

  try
    TblTree.AfterPost := nil;
    TblTree.Delete;
    while not TblTree.Eof do
    begin
      if save_index < TblTreeID.AsInteger then begin
        TblTree.Edit;
        try
          TblTreeID.AsInteger := TblTreeID.AsInteger - 1;
        finally
          TblTree.Post;
        end;
      end;
      TblTree.Next;
    end;
    with TblTree do begin
      EditKey;
      TblTreeID.AsInteger := save_index;
      GotoKey;
    end;
  finally
    TblTree.AfterPost := TblTreeAfterPost;
    ApplyDB;
  end;

  ChangeTree;
  ClearFrameEditor;
  ClearStdFrameImage;
  ClearRealFrameImage;  
  ClearFrameTree;
end;

procedure TDBModuls.DeleteBranch(var Arr_code: array of integer;
  size: Integer);
var
  find: boolean;
  i, code: integer;
begin
  TblModels.AfterDelete := nil;
  try
    for i := 0 to size - 1 do begin
      code := Arr_code[i];
      with TblModels do begin
        EditKey;
        TblModelsID.AsInteger := Code;
        find := GotoKey;
        if not find then
          find := (TblModelsID.AsInteger = Code) and (code <> 0);
      end;
      if find then begin
        //Delete table Std Charts
        TblStdCharts.Close;
        TblStdCharts.TableName := TblModelsDBStdCharts.AsString;
        try
          TblStdCharts.DeleteTable;
        except;
        end;
        //----------------------------------------------------------------------
        
        //Delete table Real Charts
        TblRealCharts.Close;
        TblRealCharts.TableName := TblModelsDBRealCharts.AsString;
        try
          TblRealCharts.DeleteTable;
        except;
        end;
        //----------------------------------------------------------------------
        
        TblModels.Delete;
      end;
    end;
  finally
    TblModels.AfterDelete := TblModelsAfterDelete;
    ApplyDB;
  end;    
end;

procedure TDBModuls.DeleteAllBranch;
begin
  EmptyTableModels;
end;

procedure TDBModuls.ChangeTree;
var
  MS: TMemoryStream;
  tablename: string;
begin
  MS := TMemoryStream.Create;
  try
    TblTreeTree.SaveToStream(MS);
    tablename := TblTreeFile.AsString;
    LoadTableModels(tablename);
    if Assigned(FOnChangeTree) then FOnChangeTree(MS);
  finally
    MS.Free;
  end;
end;

//------------------------------------------------------------------------------
// Utility
//------------------------------------------------------------------------------

procedure TDBModuls.SaveStreamToField(state: TTypeSaveInTable; DestField: TField; Stream: TStream);
begin
  //DB.StartTransaction;
  case state of
    tsEdit: DestField.DataSet.Edit;
    tsInsert: DestField.DataSet.Insert;
    tsAppend: DestField.DataSet.Insert;
  else
    //DB.Rollback;
    raise Exception.Create('Cannot save stream to field!');
  end;
  try
    Stream.Position := 0;
    (DestField as TBlobField).LoadFromStream(Stream);
  finally
    DestField.DataSet.Post;
  end;
  //DB.Commit;
end;


procedure TDBModuls.ChangeModel(AFind: boolean);
var
  fail: string;
begin
  if AFind then begin
    fail := TblModelsDBStdCharts.AsString;
    OpenDBStdCharts(fail);

    fail := TblModelsDBRealCharts.AsString;
    OpenDBRealCharts(fail);

    ChangeEditor();
    ChangeView();
  end
  else begin
    OpenDBStdCharts('', AFind);
    OpenDBRealCharts('', AFind);    
    ChangeEditor(false);
  end;
end;

procedure TDBModuls.ChangeEditor(AFind: boolean = true);
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    if AFind then TblModelsInfo.SaveToStream(MS);    
    if Assigned(FOnChangeEditor) then FOnChangeEditor(MS);
  finally
    MS.Free;
  end;
end;

procedure TDBModuls.LoadTableModels(AName: string);
begin
  TblModels.Close;
  if AName <> '' then begin
    TblModels.TableName := AName;
    TblModels.Open;
  end;
end;

procedure TDBModuls.DeleteTableModels(AName: string);
begin
  TblModels.Close;
  if AName <> '' then begin
    TblModels.TableName := AName;
    if TblModels.Exists then TblModels.DeleteTable;
  end;
end;

function TDBModuls.CreateTableModels(AName: string): string;
var
  base: string;
begin
  TblModels.Close;
  base := GenerationName('models');
  TblModels.TableName := base;
  TblModels.CreateTable;
  result := base;
end;

function TDBModuls.CreateTableStdCharts(AName: string): string;
var
  base: string;
begin
  TblStdCharts.Close;
  base := GenerationName('scharts');
  TblStdCharts.TableName := base;
  TblStdCharts.CreateTable;
  result := base;
end;

procedure TDBModuls.SaveNameTableStdCharts(AName: string);
begin
  TblModels.Edit;
  TblModelsDBStdCharts.AsString := AName;
  TblModels.Post;
end;

function TDBModuls.CreateNewModels: integer;
var
  code: integer;
begin
  code := StrToInt(GenerationCode);
  with TblModels do begin

    if TblModels.RecordCount = 0 then
      Edit
    else
      Append;

    TblModelsID.AsInteger := code;
    Post;
    result := code;
  end;
end;

procedure TDBModuls.EmptyTableModels;
begin
  if not TblModels.Active then exit;

  TblModels.AfterDelete := nil;
  try
    with TblModels do begin
      first;
      while not eof do begin
        TblStdCharts.Close;
        TblStdCharts.TableName := TblModelsDBStdCharts.AsString;
        try
          TblStdCharts.DeleteTable;
        except;
        end;

        TblRealCharts.Close;
        TblRealCharts.TableName := TblModelsDBRealCharts.AsString;
        try
          TblRealCharts.DeleteTable;
        except;
        end;

        Delete;
      end;
    end;
  finally
    TblModels.AfterDelete := TblModelsAfterDelete;
  end;

end;

procedure TDBModuls.ClearFrameEditor;
begin
  if Assigned(FOnClearFrameEditor) then FOnClearFrameEditor(self);
end;

procedure TDBModuls.ClearStdFrameImage;
begin
  if Assigned(FOnClearStdFrameImage) then FOnClearStdFrameImage(self);
end;

procedure TDBModuls.ClearFrameTree;
begin
  if TblTree.RecordCount = 0 then
    if Assigned(FOnClearFrameTree) then FOnClearFrameTree(self);
end;

procedure TDBModuls.Pack(ATable: TTable);
var
   SavePlace: TBookmark;
begin
  with ATable do
  begin

    SavePlace := GetBookmark;
    try
      PackTable(ATable);

      GotoBookmark(SavePlace);
    finally
      FreeBookmark(SavePlace);
    end;
  end;

end;

procedure TDBModuls.ApplyDB;
begin
  if TblTree.Active then Pack(TblTree);
  if TblModels.Active then Pack(TblModels);
  if TblStdCharts.Active then Pack(TblStdCharts);
  if TblRealCharts.Active then Pack(TblRealCharts);  
end;

procedure TDBModuls.TblModelsAfterPost(DataSet: TDataSet);
begin
  ApplyDB;
end;

procedure TDBModuls.TblTreeAfterPost(DataSet: TDataSet);
begin
  ApplyDB;
end;

procedure TDBModuls.TblStdChartsAfterPost(DataSet: TDataSet);
begin
  ApplyDB;
end;

procedure TDBModuls.TblTreeAfterDelete(DataSet: TDataSet);
begin
  ApplyDB;
end;

procedure TDBModuls.TblStdChartsAfterDelete(DataSet: TDataSet);
begin
  ApplyDB;
end;

procedure TDBModuls.TblModelsAfterDelete(DataSet: TDataSet);
begin
  ApplyDB;
end;

function TDBModuls.AddRealImage(sender: TObject;
  AFileName: string): integer;
begin
  TblRealCharts.Append;
  TblRealChartsField.LoadFromFile(AFileName);
  TblRealCharts.Post;
  result := CountRealImage;
  ChangeRealImage;
end;

procedure TDBModuls.ChangeRealImage;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    TblRealChartsField.SaveToStream(MS);
    if Assigned(FOnChangeRealImage) then FOnChangeRealImage(MS)
  finally
    MS.Free;
  end;
end;

procedure TDBModuls.ClearRealFrameImage;
begin
  if Assigned(FOnClearRealFrameImage) then FOnClearRealFrameImage(self);
end;

procedure TDBModuls.ClearRealImage(Sender: TObject);
begin
  TblRealCharts.Edit;
  TblRealChartsField.Clear;
  TblRealCharts.Post;
  ChangeRealImage;
end;

function TDBModuls.CountRealImage: integer;
begin
  result := TblRealCharts.RecordCount;
  if result = 0 then result := 1;
end;

function TDBModuls.CreateTableRealCharts(AName: string): string;
var
  base: string;
begin
  TblRealCharts.Close;
  base := GenerationName('rcharts');
  TblRealCharts.TableName := base;
  TblRealCharts.CreateTable;
  result := base;
end;

procedure TDBModuls.DeleteRealImage(Sender: TObject);
begin
  if TblRealCharts.Eof then exit;
  TblRealCharts.Delete;
  if Assigned(FOnRecalcRealImage) then FOnRecalcRealImage(CountRealImage);
  ChangeRealImage;
end;

procedure TDBModuls.EditRealImage(Sender: TObject; AFileName: string);
begin
  TblRealCharts.Edit;
  TblRealChartsField.LoadFromFile(aFileName);
  TblRealCharts.Post;
  ChangeRealImage;
end;

procedure TDBModuls.OpenDBRealCharts(aFileName: string; AFind: Boolean);
begin
  TblRealCharts.Close;

  if AFind then begin
    if AFileName = '' then begin
      TblRealCharts.TableName := CreateTableRealCharts(AFileName);
      SaveNameTableRealCharts(TblRealCharts.TableName);
    end
    else
      TblRealCharts.TableName := AFileName;

    if not TblRealCharts.Exists then TblRealCharts.CreateTable;
    TblRealCharts.Open;


    if Assigned(FOnRecalcRealImage) then FOnRecalcRealImage(CountRealImage);
    ChangeRealImage;
  end;
end;

procedure TDBModuls.SaveNameTableRealCharts(AName: string);
begin
  TblModels.Edit;
  TblModelsDBRealCharts.AsString := AName;
  TblModels.Post;
end;

procedure TDBModuls.SelectRealImage(Sender: TObject; index: integer);
var
  i: integer;
begin
  if TblRealCharts.Active then begin
    if index >= 0 then begin
      TblRealCharts.First;
      for i := 1 to index do TblRealCharts.Next;
    end
    else
      TblRealCharts.First;
    ChangeRealImage;
  end;
end;

function TDBModuls.GenerationName(base: string): string;
var
  source_path: string;
begin
  result := base + '_' + GenerationCode + '.db';
  source_path := DBModuls.DBDirectory + '\';

  while FileExists(source_path + result) do
    result := base + '_' + GenerationCode + '.db';
end;

function TDBModuls.GenerationCode: string;
begin
  Randomize;
  result := IntToStr(Random(9)) + IntToStr(Random(9)) +
            IntToStr(Random(9)) + IntToStr(Random(9)) +
            IntToStr(Random(9)) + IntToStr(Random(9));
end;

procedure TDBModuls.TblRealChartsAfterPost(DataSet: TDataSet);
begin
  ApplyDB;
end;

procedure TDBModuls.TblRealChartsAfterDelete(DataSet: TDataSet);
begin
  ApplyDB;
end;

function TDBModuls.StdImageSendToPrint: integer;
var
  SavePlace: TBookmark;
  MS: TMemoryStream;
  count: integer; 
begin
  count := 0;
  if TblStdCharts.Active then begin
    with TblStdCharts do begin
      SavePlace := GetBookmark;
      MS := TMemoryStream.Create;
      try
        first;
        while not eof do begin
          count := count + 1;
          TblStdChartsField.SaveToStream(MS);
          next;
          if Assigned(FOnPrintStdImage) then FOnPrintStdImage(MS, eof);
          MS.Clear;
        end;
        GotoBookmark(SavePlace);
      finally
        MS.Free;
        FreeBookmark(SavePlace);
      end;
    end;
  end;
  Result := count;
end;

function TDBModuls.RealImageSendToPrint: integer;
var
  SavePlace: TBookmark;
  MS: TMemoryStream;
  count: integer;   
begin
  count := 0;
  if TblRealCharts.Active then begin
    with TblRealCharts do begin
      SavePlace := GetBookmark;
      MS := TMemoryStream.Create;
      try
        first;
        while not eof do begin
          count := count + 1;
          TblRealChartsField.SaveToStream(MS);
          next;
          if Assigned(OnPrintRealImage) then OnPrintRealImage(MS, eof);
          MS.Clear;
        end;
        GotoBookmark(SavePlace);
      finally
        MS.Free;
        FreeBookmark(SavePlace);
      end;
    end;
  end;
  Result := count;  
end;

function TDBModuls.DBDirectory: string;
var
  Param: TStringList;
  i: integer;
  str: string;
  path: PChar;
begin
  Param := TStringList.Create;
  
  try
    DBSession.GetAliasParams(DB.AliasName, Param);
    i := 0;
    New(path);
    while i < Param.Count do begin
      str := Param.Strings[i];
      StrPLCopy(path, str, 4);
      if StrLower(path) = 'path' then begin
        result := Copy(str, 6, Length(str));
      end;
      i := i+1;
    end;

  finally
    Param.Free;
  end;
end;

procedure TDBModuls.CloseConnection;
begin
  FStdChartsAcitve := TblStdCharts.Active;
  TblStdCharts.Active := false;

  FRealChartsAcitve := TblRealCharts.Active;
  TblRealCharts.Active := false;

  FModelsAcitve := TblModels.Active;
  TblModels.Active := false;
  
  FTreeActive := TblTree.Active;
  TblTree.Active := false;

  DB.Connected := false;
  DBSession.Close;
end;

procedure TDBModuls.OpenConnection;
begin
  DBSession.Open;
  DB.Connected := true;

  TblStdCharts.Active := FStdChartsAcitve;

  TblRealCharts.Active := FRealChartsAcitve;

  TblModels.Active := FModelsAcitve;

  TblTree.Active := FTreeActive;
end;

procedure TDBModuls.SelectModelIndex(Code: integer);
begin
  if not TblModels.Active then exit;
  with TblModels do begin
    EditKey;
    TblModelsID.AsInteger := Code;
    GotoKey;
  end;
end;

procedure TDBModuls.SelectTreeIndex(Code: integer);
begin
  if not TblTree.Active then exit;
  with TblTree do begin
    EditKey;
    TblTreeID.AsInteger := Code;
    GotoKey;
  end;
end;

procedure TDBModuls.ChangeView;
begin
  if Assigned(FOnChangeView) then FOnChangeView(TblModelsPositionEditor.AsInteger);
end;

procedure TDBModuls.SaveView(Position: integer);
begin
  if not TblModels.Active then exit;
  if not TblStdCharts.Active then exit;
  TblModels.Edit;
  try
    TblModelsPositionEditor.AsInteger := Position;
  finally
    TblModels.Post;
  end;
end;

end.
