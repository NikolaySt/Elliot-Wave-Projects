unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, QuickRpt, Qrctrls, ExtCtrls, StdCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    customer: TTable;
    customerCustNo: TFloatField;
    customerCompany: TStringField;
    customerAddr1: TStringField;
    customerAddr2: TStringField;
    customerCity: TStringField;
    customerState: TStringField;
    customerZip: TStringField;
    customerCountry: TStringField;
    customerPhone: TStringField;
    customerFAX: TStringField;
    customerTaxRate: TFloatField;
    customerContact: TStringField;
    customerLastInvoiceDate: TDateTimeField;
    QuickRep: TQuickRep;
    DetailBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    ColumnHeaderBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    PageFooterBand1: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    TitleBand1: TQRBand;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRRichText1: TQRRichText;
    Table1: TTable;
    Table1ID: TIntegerField;
    Table1Info: TMemoField;
    QuickRep1: TQuickRep;
    Table2: TTable;
    QRBand2: TQRBand;
    QRRichText3: TQRRichText;
    QRBand1: TQRBand;
    QRImage1: TQRImage;
    QRBand3: TQRBand;
    QRSysData3: TQRSysData;
    QRSysData4: TQRSysData;
    QRLabel8: TQRLabel;
    Table1DBStdCharts: TStringField;
    Table1DBRealCharts: TStringField;
    Table2Charts: TBlobField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

end.
