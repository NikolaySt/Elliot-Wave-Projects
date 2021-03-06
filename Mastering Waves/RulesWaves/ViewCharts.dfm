object Form1: TForm1
  Left = 192
  Top = 109
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 688
    Height = 451
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'Model')
    TabIndex = 0
    object Chart1: TChart
      Left = 4
      Top = 56
      Width = 680
      Height = 391
      BackWall.Brush.Color = clWhite
      BackWall.Color = clWhite
      MarginBottom = 5
      MarginLeft = 0
      MarginRight = 5
      MarginTop = 0
      Title.Text.Strings = (
        'Mastering Waves')
      BackColor = clWhite
      BottomAxis.Automatic = False
      BottomAxis.AutomaticMaximum = False
      BottomAxis.AutomaticMinimum = False
      BottomAxis.Axis.Width = 1
      BottomAxis.Grid.Color = clSilver
      BottomAxis.Grid.Style = psDashDotDot
      BottomAxis.Grid.SmallDots = True
      BottomAxis.Maximum = 46
      Chart3DPercent = 5
      DepthAxis.MinorGrid.Color = clSilver
      DepthAxis.MinorTicks.Color = clSilver
      LeftAxis.Automatic = False
      LeftAxis.AutomaticMaximum = False
      LeftAxis.AutomaticMinimum = False
      LeftAxis.Axis.Width = 1
      LeftAxis.AxisValuesFormat = '#,##0.###0'
      LeftAxis.Grid.Color = clSilver
      LeftAxis.Grid.SmallDots = True
      LeftAxis.Maximum = 1097
      LeftAxis.Minimum = -1000
      LeftAxis.StartPosition = 1
      LeftAxis.EndPosition = 96
      Legend.Visible = False
      View3D = False
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object Series1: TFastLineSeries
        Marks.Arrow.Color = clRed
        Marks.ArrowLength = 8
        Marks.BackColor = 8421631
        Marks.Clip = True
        Marks.Font.Charset = DEFAULT_CHARSET
        Marks.Font.Color = clWhite
        Marks.Font.Height = -11
        Marks.Font.Name = 'Arial'
        Marks.Font.Style = []
        Marks.Frame.Color = clWhite
        Marks.Frame.SmallDots = True
        Marks.Style = smsLabelPercent
        Marks.Transparent = True
        Marks.Visible = False
        SeriesColor = clBlue
        LinePen.Color = clBlue
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
      object Series2: TArrowSeries
        Marks.Arrow.Visible = False
        Marks.ArrowLength = 0
        Marks.BackColor = clWhite
        Marks.Frame.Color = clRed
        Marks.Frame.Style = psDashDotDot
        Marks.Frame.SmallDots = True
        Marks.Frame.Visible = False
        Marks.Transparent = True
        Marks.Visible = False
        SeriesColor = clRed
        Pointer.HorizSize = 1
        Pointer.InflateMargins = False
        Pointer.Style = psRectangle
        Pointer.VertSize = 1
        Pointer.Visible = True
        XValues.DateTime = True
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
        EndXValues.DateTime = True
        EndXValues.Name = 'EndX'
        EndXValues.Multiplier = 1
        EndXValues.Order = loNone
        EndYValues.DateTime = False
        EndYValues.Name = 'EndY'
        EndYValues.Multiplier = 1
        EndYValues.Order = loNone
        StartXValues.DateTime = True
        StartXValues.Name = 'X'
        StartXValues.Multiplier = 1
        StartXValues.Order = loAscending
        StartYValues.DateTime = False
        StartYValues.Name = 'Y'
        StartYValues.Multiplier = 1
        StartYValues.Order = loNone
      end
      object Series3: TChartShape
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clWhite
        Alignment = taRightJustify
        Brush.Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Style = chasLine
        Transparent = True
        X0 = 1
        X1 = 1
        Y0 = 579.5
        Y1 = 1
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
      object Series4: TChartShape
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clWhite
        Alignment = taRightJustify
        Brush.Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Style = chasLine
        X0 = 1
        X1 = 1
        Y0 = 502
        Y1 = 1013
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1
        YValues.Order = loNone
      end
    end
    object ToolBar1: TToolBar
      Left = 4
      Top = 24
      Width = 680
      AutoSize = True
      BorderWidth = 2
      Flat = True
      Indent = 4
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Transparent = True
      Wrapable = False
      object ToolButton6: TToolButton
        Left = 4
        Top = 0
        Caption = 'ToolButton3'
        ImageIndex = 12
        OnClick = ToolButton6Click
      end
      object ToolButton7: TToolButton
        Left = 27
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 14
        Style = tbsSeparator
      end
    end
  end
end
