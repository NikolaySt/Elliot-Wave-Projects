object DBModuls: TDBModuls
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 201
  Top = 142
  Height = 532
  Width = 911
  object TblModels: TTable
    AfterPost = TblModelsAfterPost
    AfterDelete = TblModelsAfterDelete
    DatabaseName = 'DBProject'
    SessionName = 'DBSession_1'
    Exclusive = True
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'Info'
        DataType = ftMemo
        Size = 240
      end
      item
        Name = 'DBRules'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DBStdCharts'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DBRealCharts'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'PositionEditor'
        DataType = ftInteger
      end>
    IndexDefs = <
      item
        Name = 'TblModelsIndex1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
      end>
    IndexFieldNames = 'ID'
    StoreDefs = True
    Left = 18
    Top = 18
    object TblModelsID: TIntegerField
      FieldName = 'ID'
    end
    object TblModelsInfo: TMemoField
      FieldName = 'Info'
      BlobType = ftMemo
      Size = 240
    end
    object TblModelsDBRules: TStringField
      FieldName = 'DBRules'
    end
    object TblModelsDBStdCharts: TStringField
      FieldName = 'DBStdCharts'
    end
    object TblModelsDBRealCharts: TStringField
      FieldName = 'DBRealCharts'
    end
    object TblModelsPositionEditor: TIntegerField
      FieldName = 'PositionEditor'
    end
  end
  object DSModels: TDataSource
    DataSet = TblModels
    Left = 18
    Top = 64
  end
  object TblStdCharts: TTable
    AfterPost = TblStdChartsAfterPost
    AfterDelete = TblStdChartsAfterDelete
    DatabaseName = 'DBProject'
    SessionName = 'DBSession_1'
    Exclusive = True
    FieldDefs = <
      item
        Name = 'Charts'
        DataType = ftBlob
        Size = 240
      end>
    StoreDefs = True
    Left = 76
    Top = 194
    object TblStdChartsField: TBlobField
      FieldName = 'Charts'
      BlobType = ftBlob
      Size = 240
    end
  end
  object TblRules: TTable
    DatabaseName = 'DBProject'
    SessionName = 'DBSession_1'
    Exclusive = True
    Left = 14
    Top = 194
    object TblRulesSegment: TStringField
      FieldName = 'Segment'
    end
    object TblRulesRule: TStringField
      FieldName = 'Rule'
    end
    object TblRulesParagraphs: TMemoField
      FieldName = 'Paragraphs'
      BlobType = ftMemo
      Size = 1024
    end
  end
  object DSRules: TDataSource
    DataSet = TblRules
    Left = 12
    Top = 240
  end
  object TblTree: TTable
    AfterPost = TblTreeAfterPost
    AfterDelete = TblTreeAfterDelete
    DatabaseName = 'DBProject'
    SessionName = 'DBSession_1'
    Exclusive = True
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftInteger
      end
      item
        Name = 'Info'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Tree'
        DataType = ftBlob
        Size = 240
      end
      item
        Name = 'Fail'
        DataType = ftString
        Size = 25
      end>
    IndexDefs = <
      item
        Name = 'TblTreeIndex1'
        Fields = 'ID'
        Options = [ixPrimary, ixUnique]
      end>
    IndexFieldNames = 'ID'
    StoreDefs = True
    TableName = 'trees.db'
    Left = 182
    Top = 20
    object TblTreeID: TIntegerField
      FieldName = 'ID'
    end
    object TblTreeInfo: TStringField
      FieldName = 'Info'
      Size = 255
    end
    object TblTreeTree: TBlobField
      FieldName = 'Tree'
      BlobType = ftBlob
      Size = 240
    end
    object TblTreeFile: TStringField
      FieldName = 'Fail'
      Size = 25
    end
  end
  object DB: TDatabase
    AliasName = 'MasteringWavesDB'
    DatabaseName = 'DBProject'
    Exclusive = True
    SessionName = 'DBSession_1'
    TransIsolation = tiDirtyRead
    Left = 144
    Top = 136
  end
  object DBSession: TSession
    Active = True
    AutoSessionName = True
    Left = 190
    Top = 134
  end
  object DSTree: TDataSource
    DataSet = TblTree
    Left = 182
    Top = 66
  end
  object TblRealCharts: TTable
    AfterPost = TblRealChartsAfterPost
    AfterDelete = TblRealChartsAfterDelete
    DatabaseName = 'DBProject'
    SessionName = 'DBSession_1'
    Exclusive = True
    FieldDefs = <
      item
        Name = 'Charts'
        DataType = ftBlob
        Size = 240
      end>
    StoreDefs = True
    Left = 154
    Top = 194
    object TblRealChartsField: TBlobField
      FieldName = 'Charts'
      BlobType = ftBlob
      Size = 240
    end
  end
end
