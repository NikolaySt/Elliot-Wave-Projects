object FormEdit: TFormEdit
  Left = 293
  Top = 277
  BorderStyle = bsDialog
  Caption = 'Нов елемент'
  ClientHeight = 131
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 36
    Width = 82
    Height = 13
    Caption = 'Наименование: '
  end
  object Edit1: TEdit
    Left = 94
    Top = 32
    Width = 201
    Height = 21
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 132
    Top = 100
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 222
    Top = 100
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
