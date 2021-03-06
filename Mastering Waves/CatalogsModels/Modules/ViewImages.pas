unit ViewImages;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Grids, DBGrids, ExtCtrls, ImgList, ExtDlgs, StdCtrls,
  ActnList;

type

  TNotifyAddImage = function(Sender: TObject; AFileName: string): integer of object;
  TNotifyEditImage = procedure(Sender: TObject; AFileName: string) of object;
  TNotifyClearImage = procedure(Sender: TObject) of object;
  TNotifyDeleteImage = procedure(Sender: TObject) of object;
  TNotifySelectImage = procedure(Sender: TObject; index: integer) of object;


  TViewImagesFrame = class(TFrame)
    ImageListCharts: TImageList;
    OpenImage: TOpenPictureDialog;
    EditToolBar: TToolBar;
    BtnAdd: TToolButton;
    BtnEdit: TToolButton;
    BtnDelete: TToolButton;
    ToolButton1: TToolButton;
    BtnStrech: TToolButton;
    ListImageToolBar: TToolBar;
    ScrollBox2: TScrollBox;
    DBImage: TImage;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Bevel1: TBevel;
    SmallImage: TImage;
    Label1: TLabel;
    ActionWorkImage: TActionList;
    Action_AddImage: TAction;
    Action_EditImage: TAction;
    Action_DeleteImage: TAction;
    Action_StrechImage: TAction;
    Action_SaveImage: TAction;
    BtnSaveImage: TToolButton;
    ToolButton3: TToolButton;
    SaveImage: TSaveDialog;
    CoolBar1: TCoolBar;
    procedure ButtonChartsChange(Sender: TObject);
    procedure DBImageDblClick(Sender: TObject);
    procedure Action_AddImageExecute(Sender: TObject);
    procedure Action_EditImageExecute(Sender: TObject);
    procedure Action_DeleteImageExecute(Sender: TObject);
    procedure Action_StrechImageExecute(Sender: TObject);
    procedure ScrollBox2Resize(Sender: TObject);
    procedure Action_SaveImageExecute(Sender: TObject);

  private
    FOnDeleteImage: TNotifyDeleteImage;
    FOnSelectImage: TNotifySelectImage;
    FOnClearImage: TNotifyClearImage;
    FOnEditImage: TNotifyEditImage;
    FOnAddImage: TNotifyAddImage;

    procedure ScallImage;

    procedure DisabledImageControls();
    procedure EnabledImageControls();
  public
    procedure AddAllBtnChart(count: integer; select_index: integer = -1);
    function AddBtnChat(btn_index: integer; select_index: integer = -1): TToolButton;

    procedure ChangeImage(Stream: TStream);
    procedure RecalcImage(count: integer);
    procedure ClearFrameImage(Sender: TObject);

    procedure SelectImage(index: integer; OpenScreen: boolean = false);

    procedure CreateFrame();
  published
    property OnDeleteImage: TNotifyDeleteImage read FOnDeleteImage write FOnDeleteImage;
    property OnSelectImage: TNotifySelectImage read FOnSelectImage write FOnSelectImage;
    property OnClearImage: TNotifyClearImage read FOnClearImage write FOnClearImage;
    property OnEditImage: TNotifyEditImage read FOnEditImage write FOnEditImage;
    property OnAddImage: TNotifyAddImage read FOnAddImage write FOnAddImage;
  end;

implementation

{$R *.DFM}

uses UtilsImage, FullScreen, MessagesConst;

{ TStandardImageFrame }

function TViewImagesFrame.AddBtnChat(btn_index: integer; select_index: integer = -1): TToolButton;
begin
  result := TToolButton.Create(ListImageToolBar);
  with result do begin
    Parent := ListImageToolBar;

    Caption := '???: ' + IntToStr(btn_index);

    Style := tbsCheck;
    OnClick := ButtonChartsChange;
    if select_index = -1 then
      Down := false
    else
      if btn_index = select_index then Down := True;
  end;
end;

procedure TViewImagesFrame.AddAllBtnChart(count: integer; select_index: integer = -1);
var
  i: integer;
begin
  while ListImageToolBar.ButtonCount > 0 do
     ListImageToolBar.Buttons[0].Free;

  if count = 0 then
    DisabledImageControls
  else
    EnabledImageControls;     

  for i := count downto 1 do
    if select_index = -1 then
      AddBtnChat(i, 1)
    else
      AddBtnChat(i, select_index);
end;

procedure TViewImagesFrame.ChangeImage(Stream: TStream);
begin
  LoadImageFromStream(Stream, DBImage);
  ScallImage;
end;

procedure TViewImagesFrame.ButtonChartsChange(Sender: TObject);
var
  i: integer;
begin
  if (Sender is TToolButton) then begin

    if Assigned(FOnSelectImage) then FOnSelectImage(self,(Sender as TToolButton).Index);

    ScallImage;
    if FormFullScreen.Visible then FormFullScreen.View(DBImage);

    for i := 0 to ListImageToolBar.ButtonCount - 1 do
      if ListImageToolBar.Buttons[i].Down then
        ListImageToolBar.Buttons[i].Down := false;

    (Sender as TToolButton).Down := true;
  end;
end;

procedure TViewImagesFrame.DBImageDblClick(Sender: TObject);
begin
  //ADD view fullScreen;
  FormFullScreen.View(DBImage);
end;

procedure TViewImagesFrame.DisabledImageControls;
var
  i: integer;
begin
  for i := 0 to EditToolBar.ButtonCount - 1 do
    EditToolBar.Buttons[i].Enabled := false;

  while ListImageToolBar.ButtonCount > 0 do
    ListImageToolBar.Buttons[0].Free;

  ListImageToolBar.Enabled := false;
  ClearImage(DBImage);
end;

procedure TViewImagesFrame.EnabledImageControls;
var
  i: integer;
begin
  for i := 0 to EditToolBar.ButtonCount - 1 do
    EditToolBar.Buttons[i].Enabled := true;

  ListImageToolBar.Enabled := true;
end;

procedure TViewImagesFrame.Action_AddImageExecute(Sender: TObject);
begin
  if OpenImage.Execute then
    if Assigned(FOnAddImage) then begin
      if FOnAddImage(self, OpenImage.FileName) > 1 then
      AddAllBtnChart( ListImageToolBar.ButtonCount + 1, ListImageToolBar.ButtonCount + 1);
    end;
end;

procedure TViewImagesFrame.Action_EditImageExecute(Sender: TObject);
begin
  if OpenImage.Execute then
    if Assigned(FOnEditImage) then FOnEditImage(self, OpenImage.FileName);
end;

procedure TViewImagesFrame.Action_DeleteImageExecute(Sender: TObject);
begin
  if MessageDlg(const_mess_delete_image_record, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    if Assigned(FOnDeleteImage) then FOnDeleteImage(self);
end;

procedure TViewImagesFrame.Action_StrechImageExecute(Sender: TObject);
begin
  if BtnStrech.Down then begin
    ScallImage;
    BtnStrech.Down := true;
  end
  else begin
    DBImage.Stretch := false;
    DBImage.AutoSize := true;
    BtnStrech.Down := false;
  end;
end;

procedure TViewImagesFrame.RecalcImage(count: integer);
begin
  AddAllBtnChart(count);
end;

procedure TViewImagesFrame.CreateFrame;
begin
  DisabledImageControls;
end;

procedure TViewImagesFrame.ClearFrameImage(Sender: TObject);
begin
  DisabledImageControls;
end;

procedure TViewImagesFrame.ScallImage;
var
  ImageHeight, ImageWidth: integer;
  APageHeight, APageWidth: integer;

  procedure RescalVertical;
  var
    ratio: double;
  begin
    ratio := (APageHeight/ImageHeight);
    DBImage.Height := Round(ImageHeight * ratio);
    DBImage.Width :=  Round(ImageWidth * ratio);
  end;

  procedure RescalHorizontal;
  var
    ratio: double;
  begin
    ratio := (APageWidth/ImageWidth);
    DBImage.Width :=  Round(ImageWidth * ratio);
    DBImage.Height :=  Round(ImageHeight * ratio);
  end;

  procedure GetRealImageSize;
  begin
    ImageHeight := DBImage.Picture.Height;
    ImageWidth := DBImage.Picture.Width;
  end;
  procedure GetScallImageSize;
  begin
    ImageHeight := DBImage.Height;
    ImageWidth := DBImage.Width;
  end;

begin
  if not BtnStrech.Down then exit;
 
  DBImage.AutoSize := false;
  DBImage.Stretch := true;

  APageHeight := ScrollBox2.Height;
  APageWidth := ScrollBox2.Width;

  GetRealImageSize;
  if not (ImageHeight > APageHeight) and not (ImageWidth > APageWidth) then begin
    DBImage.AutoSize := true;
    DBImage.Stretch := false;
    exit;
  end;

  if ImageHeight > APageHeight then begin
    RescalVertical;
    GetScallImageSize;
  end;
  if ImageWidth > APageWidth then
    RescalHorizontal;
end;

procedure TViewImagesFrame.ScrollBox2Resize(Sender: TObject);
begin
  ScallImage;
end;

procedure TViewImagesFrame.SelectImage(index: integer; OpenScreen: boolean = false);
var
  i: integer;
begin
  if (index > 0) and (index <= ListImageToolBar.ButtonCount) then begin
    if Assigned(FOnSelectImage) then FOnSelectImage(self, index - 1);

    ScallImage;

    for i := 1 to ListImageToolBar.ButtonCount do begin
      if i = index then
        ListImageToolBar.Buttons[i-1].Down := true
      else
        ListImageToolBar.Buttons[i-1].Down := false;
    end;
    if OpenScreen then DBImageDblClick(DBImage);
      
  end
  else
    MessageDlg(const_mess_error_index_chart, mtInformation, [mbOk], 0);
end;

procedure TViewImagesFrame.Action_SaveImageExecute(Sender: TObject);
begin
   if not DBImage.Picture.Bitmap.Empty then begin
    if SaveImage.Execute then  begin
    	If FileExists(SaveImage.FileName) Then
	    	If MessageDlg(const_mess_OverrideFile,	mtConfirmation, [mbYES, mbNO], 0) = mrNo Then Exit;

      DBImage.Picture.SaveToFile(SaveImage.FileName);
    end
  end
  else
    MessageDlg(const_mess_error_image_empty, mtInformation, [mbOk], 0);
end;

end.


