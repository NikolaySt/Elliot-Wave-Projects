unit TextEditor;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ComCtrls, ClipBrd,
  ToolWin, ActnList, ImgList, DBCtrls, RichEditURL;         

type
  TNotifySaveEditor = procedure (sender: TObject; Stream: TStream) of object;
  TNotifyGetCaption = function: string of object;
  TNotifySelectFigure = procedure (index: integer; OpenScreen: boolean = false) of object;

  TEditorFrame = class(TFrame)
    MainMenu: TMainMenu;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    FilePrintItem: TMenuItem;
    FileExitItem: TMenuItem;
    EditUndoItem: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    Ruler: TPanel;
    FontDialog1: TFontDialog;
    FirstInd: TLabel;
    LeftInd: TLabel;
    RulerLine: TBevel;
    RightInd: TLabel;
    N5: TMenuItem;
    miEditFont: TMenuItem;
    StatusBar: TStatusBar;
    StandardToolBar: TToolBar;
    OpenButton: TToolButton;
    SaveButton: TToolButton;
    PrintButton: TToolButton;
    ToolButton5: TToolButton;
    UndoButton: TToolButton;
    CutButton: TToolButton;
    CopyButton: TToolButton;
    PasteButton: TToolButton;
    ToolButton10: TToolButton;
    FontName: TComboBox;
    FontSize: TEdit;
    ToolButton11: TToolButton;
    UpDown1: TUpDown;
    BoldButton: TToolButton;
    ItalicButton: TToolButton;
    UnderlineButton: TToolButton;
    ToolButton16: TToolButton;
    LeftAlign: TToolButton;
    CenterAlign: TToolButton;
    RightAlign: TToolButton;
    ToolButton20: TToolButton;
    BulletsButton: TToolButton;
    ToolbarImages: TImageList;
    ActionList1: TActionList;
    FileNewCmd: TAction;
    FileOpenCmd: TAction;
    FileSaveCmd: TAction;
    FilePrintCmd: TAction;
    FileExitCmd: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Bevel1: TBevel;
    EditCutCmd: TAction;
    EditCopyCmd: TAction;
    EditPasteCmd: TAction;
    EditUndoCmd: TAction;
    EditFontCmd: TAction;
    FileSaveAsCmd: TAction;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    EditPopupMenu: TPopupMenu;
    Font1: TMenuItem;
    N3: TMenuItem;
    PopMenuCut: TMenuItem;
    PopMenuCopy: TMenuItem;
    PopMenuPaste: TMenuItem;
    Editor: TRichEditURl;

    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SelectionChange(Sender: TObject);
    procedure ShowHint(Sender: TObject);
    procedure FileNew(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure FilePrint(Sender: TObject);
    procedure FileExit(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure EditCut(Sender: TObject);
    procedure EditCopy(Sender: TObject);
    procedure EditPaste(Sender: TObject);
    procedure SelectFont(Sender: TObject);
    procedure RulerResize(Sender: TObject);

    procedure BoldButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure AlignButtonClick(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure BulletsButtonClick(Sender: TObject);

    procedure RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RulerItemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RightIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure RichEditChange(Sender: TObject);
    procedure ActionList2Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure ToolButton3Click(Sender: TObject);
    procedure EditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditorURLClick(Sender: TObject; const Link: String);
  private

    FFileName: string;
    FUpdating: Boolean;
    FDragOfs: Integer;
    FDragging: Boolean;

    FOnSaveEditor: TNotifySaveEditor;
    FOnGetCaption: TNotifyGetCaption;
    FOnSelectFigure: TNotifySelectFigure;

    function CurrText: TTextAttributes;
    procedure GetFontNames;
    procedure SetFileName(const FileName: String);
    procedure CheckFileSave;
    procedure SetupRuler;
    procedure SetEditRect;
    procedure UpdateCursorPos;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure PerformFileOpen(const AFileName: string);
    procedure SetModified(Value: Boolean);

    procedure DisabledEditorControls;
    procedure EnabledEditorControls;
  public
    procedure CreateFrame;
    procedure ChangeEditor(MS: TStream);
    procedure ClearFrameEditor(Sender: TObject);
    procedure SaveEditorToStream(MS: TStream);
    procedure GetModified(var Modified: boolean);
  published
    property OnSaveEditor: TNotifySaveEditor read FOnSaveEditor write FOnSaveEditor;
    property OnGetCaption: TNotifyGetCaption read FOnGetCaption write FOnGetCaption;
    property OnSelectFigure: TNotifySelectFigure read FOnSelectFigure write FOnSelectFigure;
  end;

//var
  //MainForm: TMainForm;

implementation

uses RichEdit, ShellAPI{, PrintNode}, MessagesConst;

resourcestring
  sSaveChanges = 'Save changes to %s?';
  sOverWrite = 'OK to overwrite %s';
  sUntitled = 'Untitled';
  sModified = 'Modified';
  sColRowInfo = 'Line: %3d   Col: %3d';

const
  RulerAdj = 4/3;
  GutterWid = 6;

  ENGLISH = (SUBLANG_ENGLISH_US shl 10) or LANG_ENGLISH;

{$R *.DFM}

procedure TEditorFrame.SelectionChange(Sender: TObject);
begin
  with Editor.Paragraph do
  try
    FUpdating := True;
    FirstInd.Left := Trunc(FirstIndent*RulerAdj)-4+GutterWid;
    LeftInd.Left := Trunc((LeftIndent+FirstIndent)*RulerAdj)-4+GutterWid;
    RightInd.Left := Ruler.ClientWidth-6-Trunc((RightIndent+GutterWid)*RulerAdj);
    BoldButton.Down := fsBold in Editor.SelAttributes.Style;
    ItalicButton.Down := fsItalic in Editor.SelAttributes.Style;
    UnderlineButton.Down := fsUnderline in Editor.SelAttributes.Style;
    BulletsButton.Down := Boolean(Numbering);
    FontSize.Text := IntToStr(Editor.SelAttributes.Size);
    FontName.Text := Editor.SelAttributes.Name;
    case Ord(Alignment) of
      0: LeftAlign.Down := True;
      1: RightAlign.Down := True;
      2: CenterAlign.Down := True;
    end;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
end;

function TEditorFrame.CurrText: TTextAttributes;
begin
  if Editor.SelLength > 0 then
    Result := Editor.SelAttributes
  else
    Result := Editor.DefAttributes;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

procedure TEditorFrame.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FontName.Items));
  ReleaseDC(0, DC);
  FontName.Sorted := True;
end;

procedure TEditorFrame.SetFileName(const FileName: String);
begin
  FFileName := FileName;
//  Caption := Format('%s - %s', [ExtractFileName(FileName), Application.Title]);
end;

procedure TEditorFrame.CheckFileSave;
var
  SaveResp: Integer;
begin
  if not Editor.Modified then Exit;
  SaveResp := MessageDlg(Format(sSaveChanges, [FFileName]),
    mtConfirmation, mbYesNoCancel, 0);
  case SaveResp of
    idYes: FileSave(Self);
    idNo: {Nothing};
    idCancel: Abort;
  end;
end;

procedure TEditorFrame.SetupRuler;
var
  I: Integer;
  S: String;
begin
  SetLength(S, 201);
  I := 1;
  while I < 200 do
  begin
    S[I] := #9;
    S[I+1] := '|';
    Inc(I, 2);
  end;
  Ruler.Caption := S;
end;

procedure TEditorFrame.SetEditRect;
var
  R: TRect;
begin
  with Editor do
  begin
    R := Rect(GutterWid, 0, ClientWidth-GutterWid, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
  end;
end;

{ Event Handlers }

procedure TEditorFrame.CreateFrame();
begin
  Application.OnHint := ShowHint;
  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  SetFileName(sUntitled);
  GetFontNames;
  SetupRuler;
  SelectionChange(Self);

  CurrText.Name := DefFontData.Name;
  CurrText.Size := -MulDiv(DefFontData.Height, 72, Screen.PixelsPerInch);
//  SwitchLanguage(LanguageEnglish);
end;

procedure TEditorFrame.ShowHint(Sender: TObject);
begin
  if Length(Application.Hint) > 0 then
  begin
    StatusBar.SimplePanel := True;
    StatusBar.SimpleText := Application.Hint;
  end
  else StatusBar.SimplePanel := False;
end;

procedure TEditorFrame.FileNew(Sender: TObject);
begin
  SetFileName(sUntitled);
  Editor.Lines.Clear;
  Editor.Modified := False;
  SetModified(False);
end;

procedure TEditorFrame.PerformFileOpen(const AFileName: string);
begin
  Editor.Lines.LoadFromFile(AFileName);
  SetFileName(AFileName);
  Editor.SetFocus;
  Editor.Modified := False;
  SetModified(True);
end;

procedure TEditorFrame.FileOpen(Sender: TObject);
begin
  CheckFileSave;
  if OpenDialog.Execute then
  begin
    PerformFileOpen(OpenDialog.FileName);
    Editor.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TEditorFrame.FileSave(Sender: TObject);
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    if Assigned(FOnSaveEditor) then begin
      Editor.Lines.SaveToStream(MS);
      FOnSaveEditor(self, MS);
      Editor.Modified := False;
      SetModified(False);
    end;
  finally
    MS.Free;
  end;    
end;

procedure TEditorFrame.FileSaveAs(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
      if MessageDlg(Format(sOverWrite, [SaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
    Editor.Lines.SaveToFile(SaveDialog.FileName);
    SetFileName(SaveDialog.FileName);
    Editor.Modified := False;
    SetModified(False);
  end;
end;

procedure TEditorFrame.FilePrint(Sender: TObject);

  procedure AddEditorToPrint;
  var
     MS: TMemoryStream;
  begin
    MS := TMemoryStream.Create;
    try
      SaveEditorToStream(MS);
      //FrmPrint.AddTextToEditor(MS, false);
    finally
      MS.Free;
    end;
  end;

begin {
  if Assigned(FOnGetCaption) then FrmPrint.AddCaption( FOnGetCaption )
  else FrmPrint.AddCaption( '' );

  AddEditorToPrint();
  FrmPrint.Preview('Ariadna Catalog');
  }
end;

procedure TEditorFrame.FileExit(Sender: TObject);
begin
//  Close;
end;

procedure TEditorFrame.EditUndo(Sender: TObject);
begin
  with Editor do
    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TEditorFrame.EditCut(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TEditorFrame.EditCopy(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

procedure TEditorFrame.EditPaste(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TEditorFrame.SelectFont(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  SelectionChange(Self);
  Editor.SetFocus;
end;

procedure TEditorFrame.RulerResize(Sender: TObject);
begin
  RulerLine.Width := Ruler.ClientWidth - (RulerLine.Left*2);
end;

procedure TEditorFrame.FormResize(Sender: TObject);
begin
  SetEditRect;
  SelectionChange(Sender);
end;

procedure TEditorFrame.FormPaint(Sender: TObject);
begin
  SetEditRect;
end;

procedure TEditorFrame.BoldButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if BoldButton.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TEditorFrame.ItalicButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if ItalicButton.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TEditorFrame.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Size := StrToInt(FontSize.Text);
end;

procedure TEditorFrame.AlignButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TEditorFrame.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.Items[FontName.ItemIndex];
  SelectionChange(Self);
  Editor.SetFocus;
end;

procedure TEditorFrame.UnderlineButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if UnderlineButton.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TEditorFrame.BulletsButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  Editor.Paragraph.Numbering := TNumberingStyle(BulletsButton.Down);
end;

procedure TEditorFrame.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    CheckFileSave;
  except
    CanClose := False;
  end;
end;

{ Ruler Indent Dragging }

procedure TEditorFrame.RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragOfs := (TLabel(Sender).Width div 2);
  TLabel(Sender).Left := TLabel(Sender).Left+X-FDragOfs;
  FDragging := True;
end;

procedure TEditorFrame.RulerItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDragging then
    TLabel(Sender).Left :=  TLabel(Sender).Left+X-FDragOfs
end;

procedure TEditorFrame.FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.FirstIndent := Trunc((FirstInd.Left+FDragOfs-GutterWid) / RulerAdj);
  LeftIndMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TEditorFrame.LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.LeftIndent := Trunc((LeftInd.Left+FDragOfs-GutterWid) / RulerAdj)-Editor.Paragraph.FirstIndent;
  SelectionChange(Sender);
end;

procedure TEditorFrame.RightIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.RightIndent := Trunc((Ruler.ClientWidth-RightInd.Left+FDragOfs-2) / RulerAdj)-2*GutterWid;
  SelectionChange(Sender);
end;

procedure TEditorFrame.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  CharPos.Y := SendMessage(Editor.Handle, EM_EXLINEFROMCHAR, 0,
    Editor.SelStart);
  CharPos.X := (Editor.SelStart -
    SendMessage(Editor.Handle, EM_LINEINDEX, CharPos.Y, 0));
  Inc(CharPos.Y);
  Inc(CharPos.X);
  StatusBar.Panels[0].Text := Format(sColRowInfo, [CharPos.Y, CharPos.X]);
end;

procedure TEditorFrame.FormShow(Sender: TObject);
begin
  UpdateCursorPos;
  DragAcceptFiles(Handle, True);
  RichEditChange(nil);
  Editor.SetFocus;
  { Check if we should load a file from the command line }
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    PerformFileOpen(ParamStr(1));
end;

procedure TEditorFrame.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      CheckFileSave;
      PerformFileOpen(CFileName);
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TEditorFrame.RichEditChange(Sender: TObject);
begin
  SetModified(Editor.Modified);
end;

procedure TEditorFrame.SetModified(Value: Boolean);
begin
  if Value then begin
    StatusBar.Panels[1].Text := sModified
  end
  else StatusBar.Panels[1].Text := '';

  SaveButton.Enabled := Value;
end;

procedure TEditorFrame.ActionList2Update(Action: TBasicAction;
  var Handled: Boolean);
begin
 { Update the status of the edit commands }
  EditCutCmd.Enabled := Editor.SelLength > 0;
  EditCopyCmd.Enabled := EditCutCmd.Enabled;
  if Editor.HandleAllocated then
  begin
    EditUndoCmd.Enabled := Editor.Perform(EM_CANUNDO, 0, 0) <> 0;
    EditPasteCmd.Enabled := Editor.Perform(EM_CANPASTE, 0, 0) <> 0;
  end;
end;

procedure TEditorFrame.ToolButton3Click(Sender: TObject);
begin
  StandardToolBar.Visible := not StandardToolBar.Visible;
  Ruler.Visible := not Ruler.Visible;
  StatusBar.Visible := not StatusBar.Visible;
  Editor.ReadOnly := not Editor.ReadOnly;  
end;

procedure TEditorFrame.ChangeEditor(MS: TStream);
begin
  EnabledEditorControls;
  if Assigned(MS) then begin
    MS.Position := 0;
    Editor.Lines.LoadFromStream(MS);
  end
  else
    Editor.Lines.Clear;

  //if Editor.Visible then Editor.SetFocus;
  Editor.Modified := False;
  SetModified(False);
end;

procedure TEditorFrame.ClearFrameEditor(Sender: TObject);
begin
  DisabledEditorControls;
end;

procedure TEditorFrame.DisabledEditorControls;
var
  i: integer;
  comp: TComponent;
begin
  Editor.Lines.Clear;
  for i := 0 to ComponentCount - 1 do
  begin
    comp := Components[i];
    if comp is TControl then
      (comp as TControl).Enabled := false;
  end;
  SetModified(False);
end;

procedure TEditorFrame.EnabledEditorControls;
var
  i: integer;
  comp: TComponent;
begin
  Editor.ReadOnly := false;
  for i := 0 to ComponentCount - 1 do
  begin
    comp := Components[i];
    if comp is TControl then
      (comp as TControl).Enabled := true;
  end;
end;

procedure TEditorFrame.SaveEditorToStream(MS: TStream);
begin
  if Assigned(MS) then Editor.Lines.SaveToStream(MS);
end;

procedure TEditorFrame.GetModified(var Modified: boolean);
begin
  Modified := Editor.Modified;
end;

procedure TEditorFrame.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and ((Key = Ord('b')) or (Key = Ord('B'))) then begin
    BoldButton.Down := not BoldButton.Down;
    BoldButtonClick(nil);
  end else
  if (Shift = [ssCtrl]) and ((Key = Ord('i')) or (Key = Ord('I'))) then begin
    ItalicButton.Down := not ItalicButton.Down;
    ItalicButtonClick(nil);
  end else
  if (Shift = [ssCtrl]) and ((Key = Ord('u')) or (Key = Ord('U'))) then begin
    UnderlineButton.Down := not UnderlineButton.Down;
    UnderlineButtonClick(nil);
  end;
end;

procedure TEditorFrame.EditorURLClick(Sender: TObject; const Link: String);
var
  fig: integer;
  str: string;
  openscreen: boolean;

  function GetChar(Buffer: PChar; find: char): PChar;
  var
    l, i: integer;
  begin
    l := length(buffer);
    i := 0;
    while not (Buffer^ in [find]) and (i < l) do
    begin
      Inc(Buffer);
      i := i+1
    end;
    Inc( Buffer );
    Result := Buffer;
  end;

begin
  str := GetChar(pChar(Link), ':');
  if AnsiStrPos(PChar(str), '???.') <> nil then begin
    openscreen := AnsiStrPos(PChar(str), 'fs') <> nil;
    str := GetChar(pChar(str), '.');
    try
      fig := StrToInt(str);
      if Assigned(FOnSelectFigure) then FOnSelectFigure(fig, openscreen);
    except
      MessageDlg(const_mess_not_found_fig_number, mtInformation, [mbOk], 0);
    end;
  end
  else
    MessageDlg(const_mess_error_fig_prefix, mtInformation, [mbOk], 0);
end;

end.
