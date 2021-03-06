unit TreeModels;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, ComCtrls, ToolWin, StdCtrls, Grids, DBGrids, DBCtrls, ActnList,
  Menus, ExtCtrls;

type

  TNotifyFind = procedure (var Code: Integer) of object;
  TNotifyReadAllTree = procedure (List: TStrings) of object;
  TNotifyAddTree = procedure (index: Integer; AName: string) of object;
  TNotifyEditNameTree = procedure (AName: string) of object;
  TNotifyDelete = procedure (Index: Integer) of object;
  TNotifyStream = procedure (Stream: TStream) of object;
  TNotifyDeleteBranch = procedure (var Arr_code: array of integer; size: Integer) of object;
  TNotifyDeleteAllBranch = procedure of object;
  TNotifyEditorModified = procedure (var Modified: boolean) of object;

  TTreeModelsFrame = class(TFrame)
    TreeImagesState: TImageList;
    TreeImagesEdit: TImageList;
    TabControl: TTabControl;
    EditToolBar: TToolBar;
    BtnAddRoot: TToolButton;
    BtnAdd: TToolButton;
    BtnEdit: TToolButton;
    BtnDelete: TToolButton;
    TreeViewModels: TTreeView;
    DBGrid1: TDBGrid;
    OpenDialog: TOpenDialog;
    ActionWorkTree: TActionList;
    Action_AddNodeInRoot: TAction;
    Action_AddNodeInChild: TAction;
    Action_EditNode: TAction;
    Action_DeleteNode: TAction;
    Action_OpenTreeFromFile: TAction;
    Action_SaveTreeInDB: TAction;
    PopupMenuEditTree: TPopupMenu;
    N2: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PopupMenuEditTab: TPopupMenu;
    ActionWorkPages: TActionList;
    Action_AddTab: TAction;
    Action_EditTab: TAction;
    Action_DeleteTab: TAction;
    N8: TMenuItem;
    ActionEditTab1: TMenuItem;
    ActionDeleteTab1: TMenuItem;
    TabImagesEdit: TImageList;
    ToolBar1: TToolBar;
    BtnNewTree: TToolButton;
    BtnEditTree: TToolButton;
    BtnDeleteTree: TToolButton;
    BtnClear: TToolButton;
    Action_DeleteAllNode: TAction;
    Action_PrintSelection: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    N9: TMenuItem;
    CoolBar1: TCoolBar;
    procedure TreeViewModelsCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeViewModelsChange(Sender: TObject; Node: TTreeNode);
    procedure TabControlChange(Sender: TObject);
    procedure Action_AddNodeInRootExecute(Sender: TObject);
    procedure Action_AddNodeInChildExecute(Sender: TObject);
    procedure Action_EditNodeExecute(Sender: TObject);
    procedure Action_DeleteNodeExecute(Sender: TObject);
    procedure Action_OpenTreeFromFileExecute(Sender: TObject);
    procedure Action_AddTabExecute(Sender: TObject);
    procedure Action_EditTabExecute(Sender: TObject);
    procedure Action_DeleteTabExecute(Sender: TObject);
    procedure TreeViewModelsDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure TreeViewModelsDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure TreeViewModelsEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure TreeViewModelsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeViewModelsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Action_DeleteAllNodeExecute(Sender: TObject);
    procedure Action_PrintSelectionExecute(Sender: TObject);
    procedure TreeViewModelsEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure TreeViewModelsEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure TreeViewModelsChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
  private
    fInsertKey: Boolean;
    FOnFindModel: TNotifyFind;
    FOnReadAllTree: TNotifyReadAllTree;
    FOnFindTree: TNotifyFind;
    FOnAddTree: TNotifyAddTree;
    FOnDeleteTree: TNotifyDelete;
    FOnEditNameTree: TNotifyEditNameTree;
    FOnSaveTree: TNotifyStream;
    FOnDeleteBranch: TNotifyDeleteBranch;
    FOnDeleteAllBranch: TNotifyDeleteAllBranch;
    FOnEditorModified: TNotifyEditorModified;
    FOnEditorSave: TNotifyEvent;
    procedure DisabledTreeControls;
    procedure EnabledTreeControls;
    function GetTreeIndex: integer;
    function GetModelIndex: integer;
  protected
    procedure Save;    
  public
    procedure ChangeTree(Stream: TStream);
    procedure CreateFrame;
    procedure ClearFrameTree(Sender: TObject);
    function CaptionNode(): string;
  published
    property OnFindModel: TNotifyFind read FOnFindModel write FOnFindModel;
    property OnFindTree: TNotifyFind read FOnFindTree write FOnFindTree;
    property OnReadAllTree: TNotifyReadAllTree read FOnReadAllTree write FOnReadAllTree;
    property OnAddTree: TNotifyAddTree read FOnAddTree  write FOnAddTree ;
    property OnEditNameTree: TNotifyEditNameTree read FOnEditNameTree  write FOnEditNameTree ;
    property OnDeleteTree: TNotifyDelete read FOnDeleteTree write FOnDeleteTree;
    property OnDeleteBranch : TNotifyDeleteBranch read FOnDeleteBranch write FOnDeleteBranch;
    property OnDeleteAllBranch : TNotifyDeleteAllBranch read FOnDeleteAllBranch write FOnDeleteAllBranch;    
    property OnSaveTree: TNotifyStream read FOnSaveTree write FOnSaveTree;
    property OnEditorModified: TNotifyEditorModified read FOnEditorModified write FOnEditorModified;
    property OnEditorSave: TNotifyEvent read FOnEditorSave write FOnEditorSave;
    property TreeIndex: integer read GetTreeIndex;
    property ModelIndex: integer read GetModelIndex;    
  end;

implementation

uses UtilsTree, EditTreeFrm, MessagesConst{, PrintNode}, Models;

{$R *.DFM}

procedure TTreeModelsFrame.TreeViewModelsCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  with Sender.Canvas do
  begin

    if (Sender.Selected = Node) and (not Sender.Focused) then begin
      Font.Color := clHighlightText;
      Brush.Color := clHighlight;
    end;

    DefaultDraw := True;
  end;

end;

procedure TTreeModelsFrame.TreeViewModelsChange(Sender: TObject;
  Node: TTreeNode);
var
  code: integer;
begin
  code := Integer(Node.Data);
  if Assigned(FOnFindModel) then FOnFindModel(code);
  if code <> Integer(Node.Data) then begin
    Node.Data := Pointer(code);
    Save;
  end;    
end;

procedure TTreeModelsFrame.CreateFrame;
begin
  TreeViewModels.Items.Clear;
  TabControl.Tabs.Clear;
  if Assigned(FOnReadAllTree) then begin
    FOnReadAllTree(TabControl.Tabs);
    TabControl.TabIndex := 0;
  end;
end;

procedure TTreeModelsFrame.TabControlChange(Sender: TObject);
var
  index: integer;
begin
  index := TreeIndex;
  if Assigned(FOnFindTree) then
  begin
    FOnFindTree(index);
    //if TreeViewModels.Items.Count > 0 then
    //  TreeViewModels.Items[0].Selected := true;
  end;    
end;

procedure TTreeModelsFrame.ChangeTree(Stream: TStream);
begin
  TreeViewModels.OnChange := nil;
  try
    EnabledTreeControls;
    TreeViewLoadFromStream(TreeViewModels, Stream);
    TreeViewExpanded(TreeViewModels);
  finally
    TreeViewModels.OnChange := TreeViewModelsChange;
  end;
end;

procedure TTreeModelsFrame.Action_AddNodeInRootExecute(Sender: TObject);
var
  ANode: TTreeNode;
begin
  if FormEdit.ShowModalEdit('', '??? ?????? ????') = mrOK then begin
    ANode := AddNodeRood(TreeViewModels, FormEdit.EditText, 0);
    ANode.Selected := true;
  end;
end;

procedure TTreeModelsFrame.Action_AddNodeInChildExecute(Sender: TObject);
var
  ANode: TTreeNode;  
begin
  if TreeViewModels.Selected <> nil then begin
    if FormEdit.ShowModalEdit('', '??? ????') = mrOK then begin
      ANode := AddNodeChild(TreeViewModels, TreeViewModels.Selected, FormEdit.EditText, 0);
      ANode.Selected := true;
    end;
  end
  else
    MessageDlg(const_mess_err_addchild_item_treeview, mtInformation, [mbOK], 0);
end;

procedure TTreeModelsFrame.Action_EditNodeExecute(Sender: TObject);
begin
  if FormEdit.ShowModalEdit(TreeViewModels.Selected.Text, '??????? ?? ??????') = mrOK then begin
    EditNode(TreeViewModels.Selected, FormEdit.EditText, 0);
    Save
  end;    
end;

procedure TTreeModelsFrame.Action_DeleteNodeExecute(Sender: TObject);
var
  arr_codes: array of integer;
  size: integer;
  select: TTreeNode;
begin
  if TreeViewModels.Selected <> nil then begin
    if MessageDlg(
        Format(const_mess_delete_item_treeview, [TreeViewModels.Selected.Text]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin

      select := TreeViewModels.Selected;
      size := 1;
      CountChildNode(select, size);
      SetLength(arr_codes, size);
      GetCodeIntAllChildren(select, arr_codes);

      DeleteNode(select);
      if Assigned(FOnDeleteBranch) then FOnDeleteBranch(arr_codes, size);
      Save;
    end;
  end
  else
    MessageDlg(const_mess_err_delete_item_treeview, mtInformation, [mbOK], 0);
end;

procedure TTreeModelsFrame.Action_OpenTreeFromFileExecute(Sender: TObject);
begin
  if OpenDialog.Execute then begin

    if Assigned(FOnDeleteBranch) then begin
      FOnDeleteAllBranch();
      TreeViewModels.Items.Clear;
    end;
    try
      TreeViewLoadFromFile(TreeViewModels, OpenDialog.FileName);
    finally
      Save;
    end;      
  end;
end;

procedure TTreeModelsFrame.Action_AddTabExecute(Sender: TObject);
begin
  if FormEdit.ShowModalEdit('', '??? ???????') = mrOK then begin
    TabControl.Tabs.Add(FormEdit.EditText);

    if Assigned(FOnAddTree) then
      FOnAddTree(TabControl.Tabs.Count, FormEdit.EditText);

    TabControl.TabIndex := TabControl.Tabs.Count - 1;
  end;
end;

procedure TTreeModelsFrame.Action_EditTabExecute(Sender: TObject);
begin
  if FormEdit.ShowModalEdit(  TabControl.Tabs[TabControl.TabIndex], '??????? ?? ????? ?? ????????' ) = mrOK then begin
    TabControl.Tabs[TabControl.TabIndex] := FormEdit.EditText;
    if Assigned(FOnEditNameTree) then FOnEditNameTree(FormEdit.EditText);
  end;
end;

procedure TTreeModelsFrame.Action_DeleteTabExecute(Sender: TObject);
var
  index, count: integer;
begin
  if MessageDlg(
      Format(const_mess_delete_tab_tabcontrol, [TabControl.Tabs[TabControl.TabIndex]]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin

    if Assigned(FOnDeleteTree) then FOnDeleteTree(TabControl.TabIndex);

    index := TabControl.TabIndex;
    count := TabControl.Tabs.Count;
    TabControl.Tabs.Delete( index );

    if index >= 0 then begin

      if index + 1 = count then
        //?????? ?? ??????? ????????? ?????
        TabControl.TabIndex :=  index - 1
      else
        //?????? ?? ??????? ???????? ?????      
        TabControl.TabIndex :=  index;
    end;
       
  end;
end;

procedure TTreeModelsFrame.TreeViewModelsDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if (TreeViewModels.GetNodeAt(X, Y) is TTreeNode) then
    Accept := true
  else
    Accept := false;
end;

procedure TTreeModelsFrame.TreeViewModelsDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var 
  AnItem: TTreeNode;
  AttachMode: TNodeAttachMode;
  HT: THitTests;
begin
  if TreeViewModels.Selected = nil then Exit;
  HT := TreeViewModels.GetHitTestInfoAt(X, Y);
  AnItem := TreeViewModels.GetNodeAt(X, Y);
  if (HT - [htOnItem, htOnIcon, htNowhere, htOnIndent] <> HT) then 
  begin
    if (htOnItem in HT) or (htOnIcon in HT) then
      AttachMode := naAddChild
    else
      if htNowhere in HT then
        AttachMode := naAdd
      else
        if htOnIndent in HT then
          AttachMode := naInsert
        else
          AttachMode := naAdd;
          
    if fInsertKey then AttachMode := naInsert;

    TreeViewModels.Selected.MoveTo(AnItem, AttachMode);

  end;
end;

procedure TTreeModelsFrame.TreeViewModelsEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  Save;
end;

procedure TTreeModelsFrame.TreeViewModelsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = VK_SHIFT then  fInsertKey := true;
end;

procedure TTreeModelsFrame.TreeViewModelsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  fInsertKey := false;
end;

procedure TTreeModelsFrame.ClearFrameTree(Sender: TObject);
begin
  DisabledTreeControls;
end;

procedure TTreeModelsFrame.DisabledTreeControls;
var
  i: integer;
begin
  TreeViewModels.ReadOnly := true;
  for i := 0 to EditToolBar.ButtonCount - 1 do
    EditToolBar.Buttons[i].Enabled := False;

  BtnEditTree.Enabled := False;
  BtnDeleteTree.Enabled := False;
end;

procedure TTreeModelsFrame.EnabledTreeControls;
var
  i: integer;
begin
  TreeViewModels.ReadOnly := false;
  for i := 0 to EditToolBar.ButtonCount - 1 do
    EditToolBar.Buttons[i].Enabled := True;

  BtnEditTree.Enabled := True;
  BtnDeleteTree.Enabled := True;
end;

procedure TTreeModelsFrame.Action_DeleteAllNodeExecute(Sender: TObject);
begin
  if MessageDlg(const_mess_delete_all_item_treeview, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin

    if Assigned(FOnDeleteBranch) then begin
      FOnDeleteAllBranch();
      TreeViewModels.Items.Clear;
      Save;
    end;
          
  end;
end;

procedure TTreeModelsFrame.Action_PrintSelectionExecute(Sender: TObject);
var
  MS: TMemoryStream;
  title: string;
  node: TTreeNode;

  procedure AddDataInPrintForm;
  var
    image_count: integer;
  begin
    //FrmPrint.AddCaption( CaptionNode );
    //image_count := FrmPrint.AddStdImage;
    MS := TMemoryStream.Create;
    try
      ModelsForm.EditorFrame.SaveEditorToStream(MS);
      //FrmPrint.AddTextToEditor(MS, (image_count > 0) and (MS.Size > 150) );
    finally
      MS.Free;
    end;
    //FrmPrint.AddRealImage;
  end;
  
begin

  node := TreeViewModels.Selected;
  if not Assigned(node) then begin
    MessageDlg(const_mess_err_select_item_treeview, mtInformation, [mbOK], 0);
    Exit;
  end;

  AddDataInPrintForm;
  //FrmPrint.Preview('Ariadna Catalog: ' + title);
end;

function TTreeModelsFrame.CaptionNode: string;
var
  node: TTreeNode;
begin
  node := TreeViewModels.Selected;
  result := '';
  while Assigned(node) do begin
    if result = '' then result := node.text
    else result := node.text + ' -> ' + result;
    node := node.Parent;
  end;
end;

function TTreeModelsFrame.GetTreeIndex: integer;
begin
  result := TabControl.TabIndex + 1;
end;

function TTreeModelsFrame.GetModelIndex: integer;
begin
  if Assigned(TreeViewModels.Selected) then
    result := Integer(TreeViewModels.Selected.Data)
  else
    result := 0;
end;

procedure TTreeModelsFrame.Save;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    TreeViewSaveToStream(TreeViewModels, MS);
    if Assigned(FOnSaveTree) then FOnSaveTree(MS);
  finally
    MS.Free;
  end;
end;

procedure TTreeModelsFrame.TreeViewModelsEdited(Sender: TObject;
  Node: TTreeNode; var S: String);
begin
  Node.Text := s;
  save;
end;

procedure TTreeModelsFrame.TreeViewModelsEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := false;
end;

procedure TTreeModelsFrame.TreeViewModelsChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
var
  modified: boolean;
  msg_result: word;
begin
  if Assigned(FOnEditorModified) then FOnEditorModified(modified);
  if modified then begin
    msg_result := MessageDlg(const_mess_modified_editor, mtConfirmation, mbYesNoCancel, 0);
    case msg_result of
      mrYes:
          begin
            if Assigned(FOnEditorSave) then begin
              FOnEditorSave(sender);
              AllowChange := true;
            end;
          end;
      mrNo: AllowChange := true;
      mrCancel: AllowChange := false;
    end;        
  end;

end;

end.


