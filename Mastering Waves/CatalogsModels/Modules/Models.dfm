object ModelsForm: TModelsForm
  Left = 162
  Top = 99
  Caption = 'Ariadna Catalogs 1.0'
  ClientHeight = 519
  ClientWidth = 787
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormExtCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 337
    Top = 0
    Width = 2
    Height = 519
    ResizeStyle = rsLine
    ExplicitHeight = 526
  end
  object Panel1: TPanel
    Left = 339
    Top = 0
    Width = 448
    Height = 519
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 0
      Top = 408
      Width = 448
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 415
      ExplicitWidth = 456
    end
    object MainPage: TPageControl
      Left = 0
      Top = 0
      Width = 448
      Height = 408
      ActivePage = TabSheet2
      Align = alClient
      MultiLine = True
      Style = tsFlatButtons
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = #1061#1072#1088#1072#1082#1090#1077#1088#1080#1089#1090#1080#1082#1080
        object Splitter2: TSplitter
          Left = 0
          Top = 375
          Width = 440
          Height = 2
          Cursor = crVSplit
          Align = alBottom
          ResizeStyle = rsLine
          OnMoved = Splitter2Moved
          ExplicitTop = 382
          ExplicitWidth = 448
        end
        inline StandardImageFrame: TViewImagesFrame
          Left = 0
          Top = 0
          Width = 440
          Height = 162
          Align = alClient
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          ExplicitWidth = 440
          ExplicitHeight = 162
          inherited ScrollBox2: TScrollBox
            Top = 29
            Width = 109
            Height = 133
            ExplicitWidth = 109
            ExplicitHeight = 133
            inherited Panel1: TPanel
              inherited Label1: TLabel
                Width = 34
                ExplicitWidth = 34
              end
            end
          end
          inherited DBGrid1: TDBGrid
            Left = 109
            Top = 29
            Height = 133
            TitleFont.Name = 'MS Sans Serif'
            Columns = <
              item
                Expanded = False
                FieldName = 'ID'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Info'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DBRules'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DBStdCharts'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DBRealCharts'
                Visible = True
              end>
          end
          inherited CoolBar1: TCoolBar
            Width = 440
            Height = 29
            Bands = <
              item
                Control = StandardImageFrame.EditToolBar
                ImageIndex = -1
                Width = 166
              end
              item
                Break = False
                Control = StandardImageFrame.ListImageToolBar
                ImageIndex = -1
                Width = 264
              end>
            ExplicitWidth = 440
            ExplicitHeight = 29
            inherited EditToolBar: TToolBar
              Width = 153
              ExplicitWidth = 153
            end
            inherited ListImageToolBar: TToolBar
              Left = 181
              Width = 255
              ExplicitLeft = 181
              ExplicitWidth = 255
            end
          end
        end
        inline EditorFrame: TEditorFrame
          Left = 0
          Top = 162
          Width = 440
          Height = 213
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Default'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          ExplicitTop = 162
          ExplicitWidth = 440
          ExplicitHeight = 213
          inherited Ruler: TPanel
            Width = 440
            ExplicitTop = 30
            ExplicitWidth = 440
            inherited Bevel1: TBevel
              Width = 440
              ExplicitWidth = 448
            end
          end
          inherited StatusBar: TStatusBar
            Top = 194
            Width = 440
            ExplicitTop = 194
            ExplicitWidth = 440
          end
          inherited StandardToolBar: TToolBar
            Width = 440
            ExplicitWidth = 440
            inherited UpDown1: TUpDown
              Left = 427
              ExplicitLeft = 427
            end
            inherited ToolButton2: TToolButton
              Left = 442
              ExplicitLeft = 442
            end
            inherited BoldButton: TToolButton
              Left = 450
              ExplicitLeft = 450
            end
            inherited ItalicButton: TToolButton
              Left = 473
              ExplicitLeft = 473
            end
            inherited UnderlineButton: TToolButton
              Left = 496
              ExplicitLeft = 496
            end
            inherited ToolButton16: TToolButton
              Left = 519
              ExplicitLeft = 519
            end
            inherited LeftAlign: TToolButton
              Left = 527
              ExplicitLeft = 527
            end
            inherited CenterAlign: TToolButton
              Left = 550
              ExplicitLeft = 550
            end
            inherited RightAlign: TToolButton
              Left = 573
              ExplicitLeft = 573
            end
            inherited ToolButton20: TToolButton
              Left = 596
              ExplicitLeft = 596
            end
            inherited BulletsButton: TToolButton
              Left = 604
              ExplicitLeft = 604
            end
            inherited ToolButton4: TToolButton
              Left = 627
              ExplicitLeft = 627
            end
            inherited ToolButton3: TToolButton
              Left = 635
              ExplicitLeft = 635
            end
          end
          inherited Editor: TRichEditURl
            Width = 440
            Height = 138
            ExplicitWidth = 440
            ExplicitHeight = 138
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = #1056#1077#1072#1083#1085#1080' '#1084#1086#1076#1077#1083#1080
        ImageIndex = 1
        inline RealImageFrame: TViewImagesFrame
          Left = 0
          Top = 0
          Width = 440
          Height = 377
          Align = alClient
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          ExplicitWidth = 440
          ExplicitHeight = 377
          inherited ScrollBox2: TScrollBox
            Width = 109
            Height = 336
            ExplicitWidth = 109
            ExplicitHeight = 348
            inherited Panel1: TPanel
              inherited Label1: TLabel
                Width = 34
                ExplicitWidth = 34
              end
            end
          end
          inherited DBGrid1: TDBGrid
            Left = 109
            Height = 336
            TitleFont.Name = 'MS Sans Serif'
            Columns = <
              item
                Expanded = False
                FieldName = 'ID'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Info'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DBRules'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DBStdCharts'
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'DBRealCharts'
                Visible = True
              end>
          end
          inherited CoolBar1: TCoolBar
            Width = 440
            Bands = <
              item
                Control = RealImageFrame.EditToolBar
                ImageIndex = -1
                Width = 163
              end
              item
                Break = False
                Control = RealImageFrame.ListImageToolBar
                ImageIndex = -1
                Width = 267
              end>
            ExplicitWidth = 440
            inherited EditToolBar: TToolBar
              Width = 150
              ExplicitWidth = 150
            end
            inherited ListImageToolBar: TToolBar
              Left = 178
              Width = 258
              ExplicitLeft = 178
              ExplicitWidth = 258
            end
          end
        end
      end
    end
    object DBGrid3: TDBGrid
      Left = 0
      Top = 412
      Width = 448
      Height = 107
      Align = alBottom
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Visible = False
      Columns = <
        item
          Expanded = False
          FieldName = 'Standard'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Real'
          Visible = True
        end>
    end
  end
  inline TreeModelsFrame: TTreeModelsFrame
    Left = 0
    Top = 0
    Width = 337
    Height = 519
    Align = alLeft
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ExplicitHeight = 519
    inherited TabControl: TTabControl
      Top = 29
      Height = 490
      ExplicitTop = 23
      ExplicitHeight = 496
      inherited TreeViewModels: TTreeView
        Height = 344
        ExplicitLeft = 4
        ExplicitTop = 4
        ExplicitHeight = 350
      end
      inherited DBGrid1: TDBGrid
        Top = 348
        TitleFont.Name = 'MS Sans Serif'
      end
    end
    inherited CoolBar1: TCoolBar
      Height = 29
      Bands = <
        item
          ImageIndex = -1
          MinHeight = 22
          Width = 335
        end>
      ExplicitHeight = 29
      inherited ToolBar1: TToolBar
        Left = 183
        Top = -1
        Width = 148
        ExplicitLeft = 183
        ExplicitTop = -1
        ExplicitWidth = 148
      end
      inherited EditToolBar: TToolBar
        Width = 166
        ExplicitWidth = 166
      end
    end
    inherited TreeImagesState: TImageList
      Left = 156
      Top = 212
    end
    inherited TreeImagesEdit: TImageList
      Left = 249
      Top = 253
    end
    inherited PopupMenuEditTree: TPopupMenu
      Left = 76
      Top = 106
    end
  end
  object MainMenu1: TMainMenu
    Left = 28
    Top = 420
    object MenuFail: TMenuItem
      Caption = #1060#1072#1081#1083
      object MenuArchives: TMenuItem
        Caption = #1040#1088#1093#1080#1074#1080#1088#1072#1085#1077'...'
        ShortCut = 16467
        OnClick = MenuArchivesClick
      end
      object MenuExit: TMenuItem
        Caption = #1048#1079#1093#1086#1076
        ShortCut = 16499
        OnClick = MenuExitClick
      end
    end
    object MenuSoftware: TMenuItem
      Caption = #1047#1072' '#1087#1088#1086#1075#1088#1072#1084#1072#1090#1072
      object MenuAbout: TMenuItem
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
        OnClick = MenuAboutClick
      end
    end
  end
end
