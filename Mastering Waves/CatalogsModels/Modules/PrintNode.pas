unit PrintNode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Qrctrls;

type
  TNotifyImageData = function: integer of object;

  TFrmPrint = class(TForm)
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRBandHeader: TQRBand;
    QRSysData2: TQRSysData;
    QRSysData1: TQRSysData;
    QRBandFooter: TQRBand;
    QRLabel1: TQRLabel;
    QRLabelCaption: TQRLabel;
    QRRichText1: TQRRichText;
    procedure QuickRep1AfterPreview(Sender: TObject);
    procedure QuickRep1AfterPrint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOnReadStdImageFromDB: TNotifyImageData;
    FOnReadRealImageFromDB: TNotifyImageData;    

    FTopChart, FLeftChart, FBandWidth, FPreviewPictHeight: double;

    FQRBand: TQRCustomBand;

    FQRImageOld: TQRImage;
    FCoundImageOnPage: integer;

    FArrayImage: array[0..200] of TObject;
    FCountImageArray: integer;

    procedure InitQRImage;
    procedure SelectNextBand;
    function CheckNewPage(Aheight: double): boolean;
    function CheckNextRow(AWidth: double): boolean;

    function ScaleImage(QRImage: TQRImage): boolean;
    procedure CenterImage(QRImage: TQRImage);

    function CreateQRImage: TQRImage;

    procedure FreeImageInstance;
    procedure InitBands;

    function PageHeight: double;
    function PageWidth: double;
  public
    procedure AddTextToEditor(MS: TStream; NewPage: boolean = true);
    procedure AddCaption(text: string);
    function AddStdImage: integer;
    function AddRealImage: integer;

    procedure Preview(title: string = '');
    procedure Setup;
    procedure Print(title: string = '');

    procedure AddImageFromDB(MS: TStream; EndImage: boolean = false);
  published
    property OnReadStdImageFromDB: TNotifyImageData read FOnReadStdImageFromDB write FOnReadStdImageFromDB;
    property OnReadRealImageFromDB: TNotifyImageData read FOnReadRealImageFromDB write FOnReadRealImageFromDB;    
  end;

var
  FrmPrint: TFrmPrint;

implementation

{$R *.DFM}

uses UtilsImage;

{ TFrmPrint }

procedure TFrmPrint.AddCaption(text: string);
begin
  QRLabelCaption.Caption := Text;
end;

function TFrmPrint.AddStdImage(): integer;
begin
  InitQRImage;
  result := 0;
  if Assigned(FOnReadStdImageFromDB) then result := FOnReadStdImageFromDB;
end;

procedure TFrmPrint.AddImageFromDB(MS: TStream; EndImage: boolean = false);
var
  QRImage: TQRImage;
  pict_width, pict_height: double;
begin
  if MS.Size > 0 then begin
    QRImage := CreateQRImage();
    LoadPictureFromStream(MS, QRImage.Picture);

    pict_width := QRImage.Size.Width;
    pict_height := QRImage.Size.Height;

    if FCountImageArray = 1 then  begin
      //направо поставя първата снимка
    end            
    else begin
      //Проверка дали височината не е по-голяма от размера на страницата по височина
      if CheckNewPage(FTopChart + pict_height) then begin
        QRImage.Parent := FQRBand;
      end
      else begin
        //проверка дали мястото на реда е свършило и преминаване на следващияъ ред
        if CheckNextRow(FLeftChart + pict_width) then begin

          //Проверка дали широчината на реда е достатъчна за новата снимка
          if (FLeftChart + pict_width) > FQRBand.Size.Width then begin
            SelectNextBand();
            QRImage.Parent := FQRBand;
            //завъртa и скалира снимката т.к идва от предипната страница
            RotateImage(QRImage.Picture);
            ScaleImage(QRImage);
            CenterImage(QRImage);
            
            FQRBand.Size.Height := PageHeight;
          end
          else
           //Проверка дали височината не е по-голяма от размера на страницата по височина
            if CheckNewPage(FTopChart + pict_height)  then
              QRImage.Parent := FQRBand;
        end;
      end;
    end;
    FCoundImageOnPage := FCoundImageOnPage + 1;
    
    QRImage.Size.Left := FLeftChart;
    QRImage.Size.Top := FTopChart;


    FQRImageOld := QRImage;

    FLeftChart := FLeftChart + pict_width;
    
    if FTopChart = 0 then
      FQRBand.Size.Height := pict_height
    else
      FQRBand.Size.Height := FTopChart;

    FPreviewPictHeight := QRImage.size.Height;
  end;

  //за последната снимка ако е само на страницата я поставя посредата и ако се налага я завърта
  if EndImage and Assigned(QRImage) then
    if FCoundImageOnPage = 1 then
    begin
      if QRImage.Size.Width > FQRBand.Size.Width then
        RotateImage(FQRImageOld.Picture);

      ScaleImage(FQRImageOld);
      CenterImage(FQRImageOld);

      FQRBand.Size.Height := PageHeight;
    end;
end;

procedure TFrmPrint.AddTextToEditor(MS: TStream; NewPage: boolean = true);
begin
  MS.Position := 0;

  if not Assigned(FQRBand) then FQRBand := QRBand2; 


  FQRBand.HasChild := NewPage;
  if NewPage then FQRBand := FQRBand.ChildBand;
  FQRBand.ForceNewPage := NewPage;

  FQRBand.Size.Height := 20;


  QRRichText1.Parent := FQRBand;
  QRRichText1.Size.Top := 1;
  QRRichText1.Size.Left := 1;
  QRRichText1.Size.Height := 15;
  QRRichText1.Size.Width := (QRRichText1.Parent as TQRCustomBand).Size.Width - 6;
  (QRRichText1.Parent as TQRCustomBand).ForceNewPage := NewPage and (MS.Size > 1024);

  QRRichText1.Lines.LoadFromStream(MS);
end;

procedure TFrmPrint.FreeImageInstance;
var
  i: integer;
begin
  for i := 0 to FCountImageArray do begin
    if Assigned(FArrayImage[i]) then begin
      FArrayImage[i].Free;
    end;      
    FArrayImage[i] := nil;      
  end;
  FCountImageArray := 0;
end;

procedure TFrmPrint.Preview(title: string = '');
begin
  QuickRep1.ReportTitle := title;
  QuickRep1.PreviewModal;
end;

procedure TFrmPrint.Print(title: string = '');
begin
  QuickRep1.ReportTitle := title;
  QuickRep1.Print;
end;

procedure TFrmPrint.QuickRep1AfterPreview(Sender: TObject);
begin
  FreeImageInstance;
  InitBands;
end;

procedure TFrmPrint.QuickRep1AfterPrint(Sender: TObject);
begin
  FreeImageInstance;
  InitBands;
end;

procedure TFrmPrint.FormDestroy(Sender: TObject);
begin
  FreeImageInstance;
end;

function TFrmPrint.CreateQRImage: TQRImage;
begin
  result := TQRImage.Create(FrmPrint);

  FArrayImage[FCountImageArray] := result;
  FCountImageArray := FCountImageArray + 1;

  with result do begin
    Parent := FQRBand;
    ParentReport := QuickRep1;
    AutoSize := true;
    Stretch := true;
    Frame.DrawTop := False;
    Frame.DrawLeft := False;
    Frame.DrawRight := False;
    Frame.DrawBottom := False;
  end;  
end;

procedure TFrmPrint.InitQRImage;
begin
  if not Assigned(FQRBand) then FQRBand := QRBand2
  else begin
    FQRBand.HasChild := true;
    FQRBand := FQRBand.ChildBand;
    FQRBand.Size.Height := 3.2;
    FQRBand.ForceNewPage := false;
  end;    

  FTopChart := 0;
  FLeftChart := 0;

  FBandWidth := FQRBand.Size.Width;

  FPreviewPictHeight := 0;
  FCoundImageOnPage := 0;
end;

procedure TFrmPrint.SelectNextBand;
begin
  if FCoundImageOnPage = 1 then
  begin
    if FQRImageOld.Size.Width > FQRBand.Size.Width then
      RotateImage(FQRImageOld.Picture);

    ScaleImage(FQRImageOld);
    CenterImage(FQRImageOld);
  end;
 

  FQRBand.HasChild := true;
  FQRBand := FQRBand.ChildBand;
  FQRBand.Size.Height := 3.2;
  FQRBand.ForceNewPage := True;  

  FCoundImageOnPage := 0;
  
  FTopChart := 0;
  FLeftChart := 0;
  FPreviewPictHeight := 0;
  
  FBandWidth := FQRBand.Size.Width;
end;

function TFrmPrint.CheckNewPage(Aheight: double): boolean;
begin
  if Aheight > PageHeight then begin
    SelectNextBand();
    result := true;
  end else
    result := false;
end;

function TFrmPrint.CheckNextRow(AWidth: double): boolean;
begin
  if AWidth  > FBandWidth then begin
    FLeftChart := 0;
    FTopChart := FTopChart + FPreviewPictHeight + 1;
    result := true;
  end
  else
    result := false;
end;

function TFrmPrint.ScaleImage(QRImage: TQRImage): boolean;
var
  ImageHeight, ImageWidth: double;

  procedure RescalVertical;
  var
    ratio: double;
  begin
    ratio := (PageHeight/ImageHeight);
    QRImage.Size.Height := ImageHeight * ratio  - 1;
    QRImage.Size.Width := ImageWidth * ratio - 1;
  end;

  procedure RescalHorizontal;
  var
    ratio: double;
  begin
    ratio := (PageWidth/ImageWidth);
    QRImage.Size.Width := ImageWidth * ratio - 1;
    QRImage.Size.Height := ImageHeight * ratio - 1;
  end;

  procedure GetImageSize;
  begin
    ImageHeight := QRImage.Size.Height;
    ImageWidth := QRImage.Size.Width;
  end;
begin
  GetImageSize;

  result := false;

  if ImageHeight > PageHeight then begin
    QRImage.AutoSize := false;
    RescalVertical;
    GetImageSize;
    result := true;
  end;
  if ImageWidth > PageWidth then begin
    QRImage.AutoSize := false;
    RescalHorizontal;
    GetImageSize;
    result := true;
  end;
end;

procedure TFrmPrint.CenterImage(QRImage: TQRImage);
var
  ImageHeight, ImageWidth: double;
  offset_x, offset_y: double;
begin
  ImageHeight := QRImage.Size.Height;
  ImageWidth := QRImage.Size.Width;

  offset_x := (PageWidth - ImageWidth) / 2;
  offset_y := (PageHeight - ImageHeight) / 2;

  QRImage.Size.Top := QRImage.Size.Top + offset_y;
  QRImage.Size.Left := QRImage.Size.Left + offset_x;  
end;

function TFrmPrint.PageHeight: double;
begin
  result := QuickRep1.Page.Length - QuickRep1.Page.BottomMargin -
      QuickRep1.Page.TopMargin - QRBandHeader.Size.Height - QRBandFooter.Size.Height - 1;
end;

function TFrmPrint.PageWidth: double;
begin
  result := QuickRep1.Page.Width - QuickRep1.Page.LeftMargin - QuickRep1.Page.RightMargin - 1;
end;

procedure TFrmPrint.InitBands;

  procedure FreeChild(Band:  TQRCustomBand);
  begin
    if Band.HasChild then FreeChild(Band.ChildBand);
    if Assigned(Band) then begin
      Band.ForceNewPage := false;
      Band.HasChild := false;
    end;
  end;
  
begin
  QRRichText1.Parent := QRBandFooter;
  QRRichText1.Lines.Clear;  
  QRRichText1.Size.Height := 1;
  QRRichText1.Size.Width := 1;
  QRRichText1.Size.Top := 0;
  QRRichText1.Size.Left := 0;  

  FreeChild(QRBand2);

  QRBand2.Size.Height := 3.2;
  QRBand2.ForceNewPage := false;  
  QRBand2.HasChild := false;

  FQRBand := nil;
end;

function TFrmPrint.AddRealImage: integer;
begin
  InitQRImage;
  result := 0;
  if Assigned(FOnReadRealImageFromDB) then result := FOnReadRealImageFromDB;
end;

procedure TFrmPrint.FormCreate(Sender: TObject);
begin
  FCountImageArray := 0;
end;

procedure TFrmPrint.Setup;
begin
  QuickRep1.PrinterSetup;
end;

end.
