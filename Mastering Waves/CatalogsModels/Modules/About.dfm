object FormAbout: TFormAbout
  Left = 324
  Top = 297
  BorderStyle = bsDialog
  Caption = 'Информация'
  ClientHeight = 160
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOK: TButton
    Left = 292
    Top = 126
    Width = 75
    Height = 25
    Caption = 'Затвори'
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 235
    Height = 103
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      '"Ариадна ООД" - 2007'
      '/всички права запазени /'
      '')
    ReadOnly = True
    TabOrder = 1
  end
end
