object Form1: TForm1
  Left = 351
  Top = 135
  Width = 622
  Height = 496
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 30
    Top = 82
    Width = 75
    Height = 25
    Caption = 'Code...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 567
    Height = 21
    TabOrder = 1
    Text = 
      'C:\Documents and Settings\Nikolay\My Documents\Delphi\Mastering ' +
      'Waves\RulesWaves\Resource\'
  end
  object Edit2: TEdit
    Left = 8
    Top = 34
    Width = 567
    Height = 21
    TabOrder = 2
    Text = 
      'C:\Documents and Settings\Nikolay\My Documents\Delphi\Mastering ' +
      'Waves\RulesWaves'
  end
  object Button2: TButton
    Left = 30
    Top = 196
    Width = 75
    Height = 25
    Caption = 'Expand MM'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 236
    Width = 123
    Height = 217
    ItemHeight = 13
    TabOrder = 4
    OnClick = ListBox1Click
  end
  object RichEdit1: TRichEdit
    Left = 152
    Top = 64
    Width = 449
    Height = 397
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 5
  end
  object GoldZip1: TGoldZip
    AddPath = False
    PathToExpand = 'c:\windows\temp\'
    CompressionLevel = clDefault
    MemoryExpand = True
    ShowMessage = False
    OnExpandStream = GoldZip1ExpandStream
    Left = 52
    Top = 146
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.*'
    Left = 164
    Top = 148
  end
end
