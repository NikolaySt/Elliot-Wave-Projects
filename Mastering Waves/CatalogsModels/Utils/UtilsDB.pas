unit UtilsDB;

interface

uses dbtables;

procedure PackTable(Table: TTable);
procedure CheckDBAlias(DB: TDataBase; Session: TSession);

implementation

uses BDE, DB, Sysutils, FileCtrl, classes, ProgramConst;

procedure PackTable(Table: TTable);
var
  Props: CURProps;
  hDb: hDBIDb;
  TableDesc: CRTblDesc;
begin
  // Make sure the table is open exclusively so we can get the db handle...
  if not Table.Active then
    raise EDatabaseError.Create('Table must be opened to pack');
  if not Table.Exclusive then
    raise EDatabaseError.Create('Table must be opened exclusively to pack');

  // Get the table properties to determine table type...
  Check(DbiGetCursorProps(Table.Handle, Props));

  // If the table is a Paradox table, you must call DbiDoRestructure...
  if Props.szTableType = szPARADOX then begin


    // Blank out the structure...
    FillChar(TableDesc, sizeof(TableDesc), 0);
    // Get the database handle from the table's cursor handle...

    Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
    // Put the table name in the table descriptor...
    StrPCopy(TableDesc.szTblName, Table.TableName);
    // Put the table type in the table descriptor...
    StrPCopy(TableDesc.szTblType, Props.szTableType);
    // Set the Pack option in the table descriptor to TRUE...
    TableDesc.bPack := True;
    // Close the table so the restructure can complete...
    Table.Close;
    // Call DbiDoRestructure...

    Check(DbiDoRestructure(hDb, 1, @TableDesc, nil, nil, nil, False));
  end;

  Table.Open;
end;

procedure CheckDBAlias(DB: TDataBase; Session: TSession);
var
  AParams: TStringList;
  Dir, DBPath: String;
begin
	if not Session.IsAlias(const_DB_AliasName) then begin

		DBPath := ExtractFileDir(ParamStr(0)) + '\' + const_DB_directory;

  	if not DirectoryExists(DBPath) then ForceDirectories(DBPath);

    Session.AddStandardAlias(const_DB_AliasName, DBPath, 'Paradox');
    Session.SaveConfigFile;

  end
  else begin
  	AParams := TStringList.Create;
    try

	    Session.GetAliasParams(const_DB_AliasName, AParams);
  	  Dir := Copy(AParams.Strings[0], 6, 255);

      if not DirectoryExists(Dir) then begin

     		DBPath := ExtractFileDir(ParamStr(0)) + '\' + const_DB_directory;

      	ForceDirectories(DBPath);

	      AParams.Clear;
        AParams.Add('PATH=' + DBPath);

    	  Session.ModifyAlias(const_DB_AliasName, AParams);
        Session.SaveConfigFile;
    	end;
    finally
    	AParams.Free;
    end;
	end;
  DB.AliasName := const_DB_AliasName;
end;


end.

