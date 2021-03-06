unit UtilsTree;

interface

uses comctrls, classes, Sysutils, Windows;

procedure TreeViewLoadFromStream(TreeView: TTreeView; Stream: TStream);
procedure TreeViewLoadFromFile(TreeView: TTreeView; AFileName: string);
procedure TreeViewSaveToStream(TreeView: TTreeView; Stream: TStream);


procedure TreeViewExpanded(TreeView: TTreeView);

function AddNodeRood(TreeView: TTreeView; name: string; code: integer): TTreeNode;


function AddNodeChild(TreeView: TTreeView; Alevel: TTreeNode;
  name: string; code: integer): TTreeNode;

procedure EditNode(Node: TTreeNode; AName: string; code: integer);
procedure DeleteNode(node: TTreeNode);
procedure CountChildNode(node: TTreeNode; var count: integer);
procedure GetCodeIntAllChildren(select: TTreeNode; var arr_codes: array of integer);

implementation

uses Math;

procedure TreeViewExpanded(TreeView: TTreeView);
var
  i: integer;
begin
  for i := 0 to TreeView.Items.Count - 1 do begin
    if TreeView.Items[i].Parent = nil then
      TreeView.Items[i].Expanded := true;
  end;
end;
  
procedure TreeViewLoadFromFile(TreeView: TTreeView; AFileName: string);
var
  FS: TFileStream;
begin
  FS := TFileStream.Create(AFileName, fmOpenRead );
  try
    TreeViewLoadFromStream(TreeView, FS);
  finally
    FS.Free;
  end;
end;

procedure LoadTreeFromStream(Owner: TTreeNodes; Stream: TStream);
var
  ANode, NextNode: TTreeNode;
  ALevel, i, ACode: Integer;
  CurrStr: PChar;
  List: TStringList;

const
  sInvalidLevelEx = 'Invalid level (%d) for item "%s"';

  function GetBufStart(Buffer: PChar; var Level: Integer): PChar;
  begin
    Level := 0;
    while Buffer^ in [' ', #9] do
    begin
      Inc(Buffer);
      Inc(Level);
    end;
    Result := Buffer;
  end;

  procedure GetCode(var AText: PChar; var ACode: integer);
  var
    ch_exit: boolean;
    code_str: string;
    ch: char;
    n, j, len: integer;
  begin
    //прочита кода на всеки ред ако има такъв зададен от ":"
    len := StrLen( PChar(AText));
    n := len - 1;
    ch_exit := false;
    while not ch_exit and (n >= 0) do begin
      ch := AText[n];
      if ch = ':' then ch_exit := true
      else
        n := n - 1;
    end;


    if ch_exit then begin
      code_str := '';
      for j := n + 1 to len - 1 do begin
        code_str := code_str + AText[j];
      end;
      Acode := StrToInt(code_str);
      AText := StrLCopy(PChar(AText), PChar(AText), n);
    end
    else
      Acode := 0;
    //----------------------------------------------------;
  end;    
  
begin
  try
    list := TStringList.Create;
    try
      Stream.Position := 0;
      List.LoadFromStream(Stream);
      ANode := nil;
      for i := 0 to List.Count - 1 do
      begin
        CurrStr := GetBufStart(PChar(List[i]), ALevel);
        GetCode(CurrStr, ACode);
        if ANode = nil then
          ANode := Owner.AddChild(nil, CurrStr)
        else if ANode.Level = ALevel then
          ANode := Owner.AddChild(ANode.Parent, CurrStr)
        else if ANode.Level = (ALevel - 1) then
          ANode := Owner.AddChild(ANode, CurrStr)
        else if ANode.Level > ALevel then
        begin
          NextNode := ANode.Parent;
          while NextNode.Level > ALevel do
            NextNode := NextNode.Parent;
          ANode := Owner.AddChild(NextNode.Parent, CurrStr);
        end
        else raise ETreeViewError.CreateFmt(sInvalidLevelEx, [ALevel, CurrStr]);
        ANode.ImageIndex := Min(ALevel, 3);
        ANode.SelectedIndex := Min(ALevel, 3);
        ANode.Data := Pointer(ACode);
      end;
    finally
      List.Free;
    end;
  except
    raise;
  end;
end;


procedure TreeViewLoadFromStream(TreeView: TTreeView; Stream: TStream);
begin
  TreeView.Items.Clear;
  LoadTreeFromStream(TreeView.Items, Stream);
end;

procedure TreeViewSaveToStream(TreeView: TTreeView; Stream: TStream);
const
  TabChar = #9;
  EndOfLine = #13#10;
var
  i, code: Integer;
  ANode: TTreeNode;
  NodeStr: string;
begin
  if TreeView.Items.Count > 0 then
  begin
    ANode := TreeView.Items[0];
    while ANode <> nil do
    begin
      NodeStr := '';
      for i := 0 to ANode.Level - 1 do NodeStr := NodeStr + TabChar;

      code := Integer(ANode.Data);
      
      if code <> 0 then
        NodeStr := NodeStr + ANode.Text + ':' + intToStr(code)+ EndOfLine
      else
        NodeStr := NodeStr + ANode.Text + EndOfLine;

      Stream.Write(Pointer(NodeStr)^, Length(NodeStr));
      ANode := ANode.GetNext;
    end;
  end;
end;  

function AddNodeChild(TreeView: TTreeView; Alevel: TTreeNode;
  name: string; code: integer): TTreeNode;
begin
  result := TreeView.Items.AddChild(Alevel, name);
  with result do begin
    Data := Pointer(code);
    ImageIndex := Min(Alevel.Level + 1, 3);
    SelectedIndex := Min(Alevel.Level + 1, 3);
  end;
end;

procedure EditNode(Node: TTreeNode; AName: string; code: integer);
begin
  with Node do begin
    text := AName;
    if code <> 0 then Data := Pointer(code);
  end;
end;

procedure AddCodeInArray(node: TTreeNode; var arr_codes: array of integer; var index: integer);
var
  i: integer;
begin
  for i := 0 to node.count - 1 do begin
    arr_codes[index] := Integer(node.item[i].data);
    index := index + 1;
    AddCodeInArray(node.item[i], arr_codes, index);
  end;
end;

procedure GetCodeIntAllChildren(select: TTreeNode; var arr_codes: array of integer);
var
  index: integer;
begin
  arr_codes[0] := Integer(select.data);
  index := 1;
  AddCodeInArray(select, arr_codes, index);
end;  

procedure DeleteNode(node: TTreeNode);
begin
  node.Free;
end;

procedure CountChildNode(node: TTreeNode; var count: integer);
var
  i: integer;
begin
  count := count + node.count;
  for i := 0 to node.count - 1 do
    CountChildNode(node.item[i], count);
end;

function AddNodeRood(TreeView: TTreeView; name: string; code: integer): TTreeNode;
begin
  result := TreeView.Items.Add(nil, name);
  with result do begin
    Data := Pointer(code);
    ImageIndex := 0;
    SelectedIndex := 0;
  end;  
end;


end.
