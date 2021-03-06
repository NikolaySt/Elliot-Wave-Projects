object Form2: TForm2
  Left = 191
  Top = 181
  Width = 832
  Height = 480
  HorzScrollBar.Position = 399
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object QuickRep: TQuickRep
    Left = 493
    Top = 10
    Width = 653
    Height = 845
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = customer
    Description.Strings = (
      'This customer listing report shows the following basic features:'
      '- Setup of some common bands'
      '  (title, column header, detail and page footer)'
      '- Connecting a dataset'
      '- Use TQRLabel to print static text'
      '- Use TQRDBText to print table fields'
      ''
      'You can also see how to'
      '- Use TQRSysData to print current time and page number'
      '- Use different fonts, sizes and colors'
      '- How to right align text'
      '- How to center text in a band')
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = Letter
    Page.Values = (
      100
      2794
      100
      2159
      100
      100
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = First
    PrintIfEmpty = False
    SnapToGrid = True
    Units = MM
    Zoom = 80
    object DetailBand1: TQRBand
      Left = 30
      Top = 146
      Width = 593
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        1961.22395833333)
      BandType = rbDetail
      object QRDBText1: TQRDBText
        Left = 6
        Top = 3
        Width = 159
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          19.84375
          9.921875
          525.859375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = customer
        DataField = 'Company'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText2: TQRDBText
        Left = 170
        Top = 3
        Width = 163
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          562.239583333333
          9.921875
          539.088541666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = customer
        DataField = 'Contact'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText3: TQRDBText
        Left = 340
        Top = 3
        Width = 85
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1124.47916666667
          9.921875
          281.119791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = customer
        DataField = 'Phone'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText4: TQRDBText
        Left = 430
        Top = 3
        Width = 87
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1422.13541666667
          9.921875
          287.734375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = customer
        DataField = 'FAX'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRDBText5: TQRDBText
        Left = 530
        Top = -1
        Width = 45
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1752.86458333333
          -3.30729166666667
          148.828125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = customer
        DataField = 'CustNo'
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object ColumnHeaderBand1: TQRBand
      Left = 30
      Top = 127
      Width = 593
      Height = 19
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        62.8385416666667
        1961.22395833333)
      BandType = rbColumnHeader
      object QRLabel1: TQRLabel
        Left = 3
        Top = 3
        Width = 162
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          9.921875
          9.921875
          535.78125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Company'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel2: TQRLabel
        Left = 170
        Top = 3
        Width = 163
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          562.239583333333
          9.921875
          539.088541666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Contact'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel3: TQRLabel
        Left = 340
        Top = 3
        Width = 85
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1124.47916666667
          9.921875
          281.119791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Phone'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel4: TQRLabel
        Left = 430
        Top = 3
        Width = 87
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1422.13541666667
          9.921875
          287.734375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Fax'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel5: TQRLabel
        Left = 530
        Top = 3
        Width = 46
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1752.86458333333
          9.921875
          152.135416666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Cust no.'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object PageFooterBand1: TQRBand
      Left = 30
      Top = 162
      Width = 593
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        66.1458333333333
        1961.22395833333)
      BandType = rbPageFooter
      object QRSysData1: TQRSysData
        Left = 3
        Top = 6
        Width = 65
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          9.921875
          19.84375
          214.973958333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsDate
        Text = 'Printed '
        Transparent = False
        FontSize = 10
      end
      object QRSysData2: TQRSysData
        Left = 529
        Top = 6
        Width = 64
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          1749.55729166667
          19.84375
          211.666666666667)
        Alignment = taRightJustify
        AlignToBand = True
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Text = 'Page '
        Transparent = False
        FontSize = 10
      end
    end
    object TitleBand1: TQRBand
      Left = 30
      Top = 30
      Width = 593
      Height = 97
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        320.807291666667
        1961.22395833333)
      BandType = rbTitle
      object QRLabel6: TQRLabel
        Left = 0
        Top = 1
        Width = 177
        Height = 27
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          89.296875
          0
          3.30729166666667
          585.390625)
        Alignment = taLeftJustify
        AlignToBand = True
        AutoSize = True
        AutoStretch = False
        Caption = 'Customer Listing'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 20
      end
      object QRLabel7: TQRLabel
        Left = 0
        Top = 41
        Width = 177
        Height = 27
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          89.296875
          0
          135.598958333333
          585.390625)
        Alignment = taLeftJustify
        AlignToBand = True
        AutoSize = True
        AutoStretch = False
        Caption = 'Customer Listing'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 20
      end
      object QRRichText1: TQRRichText
        Left = 190
        Top = 2
        Width = 397
        Height = 87
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          287.734375
          628.385416666667
          6.61458333333333
          1312.99479166667)
        Alignment = taLeftJustify
        AutoStretch = True
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'object QRLabel6: TQRLabel'
          '  Left = 208'
          '  Top = 3'
          '  Width = 177'
          '  Height = 27'
          '  Frame.Color = clBlack'
          '  Frame.DrawTop = False'
          '  Frame.DrawBottom = False'
          '  Frame.DrawLeft = False'
          '  Frame.DrawRight = False'
          '  Size.Values = ('
          '    89.296875'
          '    687.916666666667'
          '    9.921875'
          '    585.390625)'
          '  Alignment = taCenter'
          '  AlignToBand = True'
          '  AutoSize = True'
          '  AutoStretch = False'
          '  Caption = '#39'Customer Listing'#39
          '  Color = clWhite'
          '  Font.Charset = DEFAULT_CHARSET'
          '  Font.Color = clNavy'
          '  Font.Height = -27'
          '  Font.Name = '#39'Arial'#39
          '  Font.Style = [fsBold, fsItalic]'
          '  ParentFont = False'
          '  Transparent = False'
          '  WordWrap = True'
          '  FontSize = 20'
          'end')
      end
    end
  end
  object QuickRep1: TQuickRep
    Left = 7
    Top = 32
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Frame.Width = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Values = (
      300
      2970
      100
      2100
      100
      100
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.OutputBin = Auto
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 100
    object QRBand2: TQRBand
      Left = 38
      Top = 336
      Width = 718
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333
        1899.70833333333)
      BandType = rbDetail
      object QRRichText3: TQRRichText
        Left = 10
        Top = 2
        Width = 705
        Height = 111
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          293.6875
          26.4583333333333
          5.29166666666667
          1865.3125)
        Alignment = taLeftJustify
        AutoStretch = True
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'object QRLabel6: TQRLabel'
          '  Left = 208'
          '  Top = 3'
          '  Width = 177'
          '  Height = 27'
          '  Frame.Color = clBlack'
          '  Frame.DrawTop = False'
          '  Frame.DrawBottom = False'
          '  Frame.DrawLeft = False'
          '  Frame.DrawRight = False'
          '  Size.Values = ('
          '    89.296875'
          '    687.916666666667'
          '    9.921875'
          '    585.390625)'
          '  Alignment = taCenter'
          '  AlignToBand = True'
          '  AutoSize = True'
          '  AutoStretch = False'
          '  Caption = '#39'Customer Listing'#39
          '  Color = clWhite'
          '  Font.Charset = DEFAULT_CHARSET'
          '  Font.Color = clNavy'
          '  Font.Height = -27'
          '  Font.Name = '#39'Arial'#39
          '  Font.Style = [fsBold, fsItalic]'
          '  ParentFont = False'
          '  Transparent = False'
          '  WordWrap = True'
          '  FontSize = 20'
          'end')
      end
    end
    object QRBand1: TQRBand
      Left = 38
      Top = 78
      Width = 718
      Height = 258
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = True
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        682.625
        1899.70833333333)
      BandType = rbTitle
      object QRImage1: TQRImage
        Left = 4
        Top = 4
        Width = 105
        Height = 105
        Frame.Color = clBlack
        Frame.DrawTop = True
        Frame.DrawBottom = True
        Frame.DrawLeft = True
        Frame.DrawRight = True
        Size.Values = (
          277.8125
          10.5833333333333
          10.5833333333333
          277.8125)
        AutoSize = True
        Center = True
        Stretch = True
      end
    end
    object QRBand3: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333
        1899.70833333333)
      BandType = rbPageHeader
      object QRSysData3: TQRSysData
        Left = 5
        Top = 2
        Width = 68
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          13.2291666666667
          5.29166666666667
          179.916666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsDateTime
        Transparent = False
        FontSize = 10
      end
      object QRSysData4: TQRSysData
        Left = 663
        Top = 2
        Width = 75
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1754.1875
          5.29166666666667
          198.4375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Text = 'Стр.:'
        Transparent = False
        FontSize = 10
      end
      object QRLabel8: TQRLabel
        Left = 317
        Top = 4
        Width = 58
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          838.729166666667
          10.5833333333333
          153.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'QRLabel8'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
  end
  object customer: TTable
    Active = True
    DatabaseName = 'DBDEMOS'
    TableName = 'customer.db'
    Left = 8
    Top = 8
    object customerCustNo: TFloatField
      Alignment = taLeftJustify
      CustomConstraint = 'CustNo IS NOT NULL'
      ConstraintErrorMessage = 'CustNo cannot be blank'
      FieldName = 'CustNo'
      DisplayFormat = 'CN 0000'
      MaxValue = 9999
      MinValue = 1000
    end
    object customerCompany: TStringField
      CustomConstraint = 'X IS NOT NULL'
      ConstraintErrorMessage = 'Company Field has to have a value'
      FieldName = 'Company'
      Size = 30
    end
    object customerAddr1: TStringField
      FieldName = 'Addr1'
      Size = 30
    end
    object customerAddr2: TStringField
      FieldName = 'Addr2'
      Size = 30
    end
    object customerCity: TStringField
      FieldName = 'City'
      Size = 15
    end
    object customerState: TStringField
      FieldName = 'State'
    end
    object customerZip: TStringField
      FieldName = 'Zip'
      Size = 10
    end
    object customerCountry: TStringField
      FieldName = 'Country'
    end
    object customerPhone: TStringField
      FieldName = 'Phone'
      Size = 15
    end
    object customerFAX: TStringField
      FieldName = 'FAX'
      Size = 15
    end
    object customerTaxRate: TFloatField
      FieldName = 'TaxRate'
      DisplayFormat = '0.00%'
      MaxValue = 100
    end
    object customerContact: TStringField
      FieldName = 'Contact'
    end
    object customerLastInvoiceDate: TDateTimeField
      FieldName = 'LastInvoiceDate'
    end
  end
  object Table1: TTable
    DatabaseName = 'MasteringWavesDB'
    TableName = 'models_4341.DB'
    Left = 20
    Top = 62
    object Table1ID: TIntegerField
      FieldName = 'ID'
    end
    object Table1Info: TMemoField
      FieldName = 'Info'
      BlobType = ftMemo
      Size = 240
    end
    object Table1DBStdCharts: TStringField
      FieldName = 'DBStdCharts'
    end
    object Table1DBRealCharts: TStringField
      FieldName = 'DBRealCharts'
    end
  end
  object Table2: TTable
    DatabaseName = 'MasteringWavesDB'
    TableName = 'rcharts_0027.DB'
    Left = 84
    Top = 60
    object Table2Charts: TBlobField
      FieldName = 'Charts'
      BlobType = ftBlob
      Size = 240
    end
  end
end
