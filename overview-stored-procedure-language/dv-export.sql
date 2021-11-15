/* Data Virtuality exported objects */
/* Created: 15.11.21  14:02:40.778 */
/* Server version: 2.4.14 */
/* Build: 29d746e */
/* Build date: 2021-10-13 */
/* Exported by Studio ver.2.4.14 (rev.b121bf6). Build date is 2021-10-13. */
/* Please set statement separator to ;; before importing */




/* Exported connections and data sources */
EXEC SYSADMIN.importConnection("name" => 'dv_output', "jbossCLITemplateName" => 'ufile', "connectionOrResourceAdapterProperties" => 'ParentDirectory=/mnt/hgfs/vm_host_tmp_folder/dv_output/,decompressCompressedFiles=false', "encryptedProperties" => '') ;;
EXEC SYSADMIN.importDataSource("name" => 'dv_output', "translator" => 'ufile', "modelProperties" => 'importer.useFullSchemaName=false', "translatorProperties" => '', "encryptedModelProperties" => '', "encryptedTranslatorProperties" => '') ;;

/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'x_utils') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'master_class_2021_sproc_language') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure x_utils.INT(obj object) 
returns (res integer) as
begin
	select cast(obj as integer);
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure x_utils.TRANSLATE_db2(str string, to_str string, from_str string, pad string default '' '') 
returns (res string) as
begin
	if (to_str is null or from_str is null)
		select ucase(str);
	else if (pad = '''')
	begin
		declare string replace_str = right(from_str, length(from_str) - length(to_str));
		declare string escaped_replace_str = ''['' || REGEXP_REPLACE(replace_str, ''[|\\{}()\[\]^$+*?.]'', ''\\$0'', ''g'') || '']'';
		declare string res = REGEXP_REPLACE(str, escaped_replace_str, '''', ''g'');
		declare string i_from_str  = from_str;
		declare string i_to_str = to_str;
		if (length(i_from_str) < length(i_to_str))
			i_to_str = left(i_to_str, length(i_from_str));
		else if (length(i_to_str) < length(i_from_str))
			i_from_str = left(i_from_str, length(i_to_str));
		select translate(res, i_from_str, i_to_str);
	end
	else
	begin
		declare string i_from_str  = from_str;
		declare string i_to_str = to_str;
		if (length(i_from_str) < length(i_to_str))
			i_to_str = left(i_to_str, length(i_from_str));
		else if (length(i_to_str) < length(i_from_str))
			i_to_str = rpad(i_to_str, length(from_str), pad);
		select translate(str, from_str, i_to_str);
	end
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure x_utils.tailLog(IN lines long) 
returns (loglines clob)
as
BEGIN
select      
	loglines
from
     (
         OBJECTTABLE (
        	language    ''javascript'' ''
			var logfile = java.lang.System.getProperty("jboss.server.log.dir") +  java.lang.System.getProperty("file.separator") +  "server.log";
			var fileHandler =  new java.io.RandomAccessFile( logfile, "r" );
	        var fileLength = fileHandler.length() - 1;
	        var sb = new java.lang.StringBuilder();
	        var nline = 0;
	        for(var filePointer = fileLength; filePointer != -1; filePointer--){
	            fileHandler.seek( filePointer );
	            var readByte = fileHandler.readByte();
	             if( readByte == 0xA ) {
	                if (filePointer < fileLength) {
	                    nline = nline + 1;
	                }
	            } else if( readByte == 0xD ) {
	                if (filePointer < fileLength-1) {                
	                    nline = nline + 1;
	                }
	            }
	            if (nline >= lines) {
	                break;
	            }
	            sb.append(  new java.lang.Character(readByte ));
	        }
	        var lastLines = sb.reverse().toString();
	        lastLines''
		PASSING 
			lines AS lines 
		COLUMNS 
			"loglines" clob ''dv_row''
        ) AS x
     );
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure x_utils.tailLogRows(IN lines long) 
returns (loglines string) 
as
BEGIN
select      
	loglines
from
    (
    	OBJECTTABLE (
             language    ''javascript'' ''
             	var logfile = java.lang.System.getProperty("jboss.server.log.dir") +  java.lang.System.getProperty("file.separator") +  "server.log";
				var fileHandler =  new java.io.RandomAccessFile( logfile, "r" );
		        var fileLength = fileHandler.length() - 1;
		        var sb = [new java.lang.StringBuilder()];
		        var nline = 0;
		        for(var filePointer = fileLength; filePointer != -1; filePointer--){
		            fileHandler.seek( filePointer );
		            var readByte = fileHandler.readByte();
		             if( readByte == 0xA ) {
		                if (filePointer < fileLength) {
		                    sb[nline] = sb[nline].reverse().toString()
		                    nline = nline + 1;
		                    sb[nline] = new java.lang.StringBuilder();
		                }
		            } else if( readByte == 0xD ) {
		                if (filePointer < fileLength-1) {
		                    sb[nline] = sb[nline].reverse().toString();
		                    nline = nline + 1;
		                    sb[nline] = new java.lang.StringBuilder();
		                }
		            }
		            if (nline >= lines) {
		                break;
		            }
		            sb[nline].append(  new java.lang.Character(readByte ));
		        }		        
		        sb''
			PASSING 
				lines AS lines 
			COLUMNS 
				"loglines" string ''dv_row''
		) AS x
	);
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure master_class_2021_sproc_language.api_checkstatus() as
begin
	SELECT 
		"xmlTable.idColumn",
		"xmlTable.status"
	FROM 
		"dv_localhost_restapi".invokeHTTP(
		endpoint => ''http://localhost:8080/rest/api/status'',
		action => ''GET'',
		requestContentType => ''application/json''
		) w,
		XMLTABLE(XMLNAMESPACES( ''http://www.w3.org/2001/XMLSchema-instance'' as "xsi" ),''/root'' PASSING JSONTOXML(''root'',to_chars(w.result,''UTF-8''))
			COLUMNS 
			"idColumn" FOR ORDINALITY,
			"status" STRING  PATH ''status''
		) "xmlTable";
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_sproc_language.api_query(
) 
returns(
	"rowid" integer,
	"salesorderid" integer,
	"salesorderdetailid" integer,
	"carriertrackingnumber" STRING,
	"orderqty" integer,
	"productid" integer,
	"unitprice" bigdecimal,
	"linetotal" bigdecimal,
	"modifieddate" timestamp,
	"hash_of_values" STRING,
	"processed" boolean
) as
begin
	SELECT 
		"xmlTable.rowid",
		"xmlTable.salesorderid",
		"xmlTable.salesorderdetailid",
		"xmlTable.carriertrackingnumber",
		"xmlTable.orderqty",
		"xmlTable.productid",
		"xmlTable.unitprice",
		"xmlTable.linetotal",
		"xmlTable.modifieddate",
		"xmlTable.hash_of_values",
		"xmlTable.processed"
	FROM 
		"dv_localhost_restapi".invokeHTTP(
			request => ''{ "sql": "SELECT * FROM dwh.sales_order_details" }'',
			endpoint => ''http://localhost:8080/rest/api/query?array=false&headers=true'',
			action => ''POST'',
			requestContentType => ''application/json''
		) w,
		XMLTABLE(XMLNAMESPACES( ''http://www.w3.org/2001/XMLSchema-instance'' as "xsi" ),''/root/root'' PASSING JSONTOXML(''root'',to_chars(w.result,''UTF-8''))
			COLUMNS 
			"rowid" integer  PATH ''rowid'',
			"salesorderid" integer  PATH ''salesorderid'',
			"salesorderdetailid" integer  PATH ''salesorderdetailid'',
			"carriertrackingnumber" STRING  PATH ''carriertrackingnumber'',
			"orderqty" integer  PATH ''orderqty'',
			"productid" integer  PATH ''productid'',
			"unitprice" bigdecimal  PATH ''unitprice'',
			"linetotal" bigdecimal  PATH ''linetotal'',
			"modifieddate" timestamp  PATH ''modifieddate'',
			"hash_of_values" STRING  PATH ''hash_of_values'',
			"processed" boolean  PATH ''processed''
		) "xmlTable";
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure x_utils.DATE(obj object) 
returns (res date) as
begin
	select cast(obj as date);
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_sproc_language.InitCreateTable() as
begin
	--*******************************************************
	--*******************************************************
	-- dwh.sales_order_details
	--*******************************************************
	--*******************************************************
	drop table if exists dwh.sales_order_details;

	call "SYSADMIN.copyOver"(
	    "dwh_table" => ''dwh.sales_order_details'',
	    "source_table" => ''master_class_2021_sproc_language.DataFromCsv'',
	    "cleanup_method" => ''drop''
	) without return;
	
	-- https://documentation.datavirtuality.com/24/reference-guide/system-schema/system-procedures/index-management#IndexManagement-SYSADMIN.createIndex
	call "SYSADMIN.createIndex"(
	    "columnName" => ''rowid'',
	    "indexType" => ''MANUAL'',
	    "indexKind" => ''SINGLE'',
	    "tableName" => ''dwh.sales_order_details''
	) without return;
end;') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE PROCEDURE master_class_2021_sproc_language.anonymize(plain_text STRING NOT NULL, out atxt string, out text_len integer) 
RETURNS (anonymized STRING NOT NULL) AS
BEGIN
    atxt = LEFT(plain_text, 1) || ''***'' || RIGHT(plain_text, 1);
    text_len = length(atxt);
    select atxt;
END') ;;

EXEC SYSADMIN.importProcedure("text" => '--*************************************************************
--*************************************************************
-- NO transaction
--*************************************************************
--*************************************************************
CREATE procedure master_class_2021_sproc_language.transactions_02()
as
begin not atomic
	
	-- Doesn''t drop if it exists
	call "UTILS.createTable"(
	    "tableName" => ''dwh.transaction_02''/* Mandatory: Fully-qualified name of the table to create */,
	    "columnsAndTypes" => ''col1|string,col2|long''/* Mandatory: Comma-delimited list of pairs columnName|dataType */
	);
	
	select 1/0;
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure x_utils.sleep(ms integer not null) as
begin
	SELECT "x.result" 
	FROM (OBJECTTABLE(
		LANGUAGE ''javascript''
		''java.lang.Thread.sleep(ms);
		"success";''
		passing ms as ms
		COLUMNS "result" string ''dv_row'') AS x);
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure x_utils.concat_ws (separator string not null, VARIADIC data string) RETURNS (x string) AS
BEGIN
	SELECT x.concated
	FROM 
		OBJECTTABLE(       
			LANGUAGE ''javascript'' 
			''var ar = [];
	    	ar = data.getArray();
			java.lang.String.join(separator, ar);''
			PASSING 
				"data" as "data", 
				"separator" as "separator"
			COLUMNS  
				"concated" string ''dv_row'' 
		) AS x;
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure master_class_2021_sproc_language.test_def_value(a integer default ''-8'')
returns(x integer)
as
begin
select a;
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure master_class_2021_sproc_language."test_drop_table"() as
begin
	declare string sqlcode;	

	sqlcode = ''drop table if exists dwh.test_drop;'';
	execute immediate (sqlcode);
	
	sqlcode = ''
	create table dwh.test_drop (
	    data_lineage_table_schema string
	    ,data_lineage_table_name string
	    ,data_lineage_table_type string
	    ,depth integer
	    ,source_table_Schema string
	    ,source_table_name string
	    ,source_column_name string
	    ,target_table_schema string
	    ,target_table_name string
	    ,target_column_name string
	    ,hashkey_data_lineage_schema_table string
	    ,hashkey_source_schema_table string
	    ,hashkey_source_schema_table_column string
	    ,hashkey_target_schema_table string
	    ,hashkey_target_schema_table_column string
	    ,default_order integer
	    ,id string
	    ,parent_id string
	);;'';
	execute immediate (sqlcode);
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure x_utils.array_to_string(
	any_array object not null, 
	delimiter string not null,
	optional_null_string string default ''''
	)
returns(str string)
OPTIONS (Annotation ''Modeled after the PostgreSQL function array_to_string'')
as
begin
	-- Modeled after the PostgreSQL function array_to_string
	DECLARE integer i = 1;
	CREATE LOCAL TEMPORARY TABLE #x(s string);
	WHILE (i <= array_length(any_array))
	BEGIN
		INSERT INTO #x(s) VALUES (ifnull(cast(array_get(any_array, i) as string), optional_null_string));
		i = i + 1;
	END
	
	SELECT cast(string_agg(x.s, delimiter) as string) from #x as x;
end') ;;
EXEC SYSADMIN.setRemark("name" => 'x_utils.array_to_string', "remark" => 'Modeled after the PostgreSQL function array_to_string') OPTION $NOFAIL ;;

EXEC SYSADMIN.importProcedure("text" => 'create VIRTUAL PROCEDURE master_class_2021_sproc_language.execExternalProcessWithAggregatedResult (
    IN command string, IN workdir string, IN "delimiter" string
) RETURNS (
    result clob
) AS
BEGIN
    SELECT
            result
        FROM
            OBJECTTABLE (
                LANGUAGE ''javascript'' ''
    var result = new java.util.ArrayList();
    try {
      var line="";
      var content="";
       if( workdir == null ) {
        var p = java.lang.Runtime.getRuntime().exec(command);
      } else {
        var p = java.lang.Runtime.getRuntime().exec(command,null,java.io.File(workdir) );
      }
      var bri = new java.io.BufferedReader
        (new java.io.InputStreamReader(p.getErrorStream()));
        
      while ((line = bri.readLine()) != null) {
        if( delimiter == null ) {
            content += line;
        } else {
            content += line + delimiter;
        }
      }
      result.add(content);
      bri.close();
      p.waitFor();
    }
    catch (err) {
      result.add(err.message+" exeption");
    }
   
result'' PASSING command AS command, workdir as workdir, "delimiter" as "delimiter" COLUMNS result Clob ''dv_row''
            ) AS x ;
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'create Virtual Procedure x_utils.RegexReplace (
	IN initialString string not null,
	IN regex string not null,
	IN replacement string not null
	)
Returns (resultString string)
As
Begin
	Select
		resultString
	From 
		ObjectTable (language ''javascript'' ''
			(new java.lang.String(initialString)).replaceAll(regex, replacement)
			''Passing
			initialString as initialString,
			regex as regex,
			replacement as replacement
			Columns
			resultString string ''dv_row''
		) o;
End') ;;

EXEC SYSADMIN.importProcedure("text" => 'create VIRTUAL PROCEDURE x_utils.EndOfMonth(
	IN getdate date 
) 
returns (
	outdate date
) as
BEGIN
 
    DECLARE date monthlater =  timestampadd( SQL_TSI_MONTH, 1, getdate );
    select  timestampadd( SQL_TSI_DAY, - dayofmonth(monthlater), monthlater);
/*
Examples:
call demos.endofmonth( cast ( ''2012-02-07'' as date ) );;
 
call demos.endofmonth( curdate() );;
 
SELECT foo from table.bar WHERE column = ( call endofmonth( curdate() ) );;

*/
END') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_sproc_language.manual_filter
as

SELECT *
FROM "dwh.sales_order_details" 
where 
	(hasrole(''reporting-role'') = false or (hasrole(''reporting-role'') = true and productid < 750))
LIMIT 500') ;;

EXEC SYSADMIN.importProcedure("text" => 'create virtual procedure x_utils.dateaxis(
	IN startdate date,
	IN enddate date
) 
returns (
	xdate date
)
as
begin
	DECLARE date idate;
	idate=startdate;
	CREATE LOCAL TEMPORARY TABLE #x(xdate date);
	WHILE (idate<=enddate)
	BEGIN
		INSERT INTO #x(xdate) VALUES (idate);
		idate=timestampadd(SQL_TSI_DAY,1,idate);
	END
	SELECT * from #x;
end') ;;

EXEC SYSADMIN.importProcedure("text" => '--*************************************************************
--*************************************************************
-- Return values
--*************************************************************
--*************************************************************
CREATE PROCEDURE master_class_2021_sproc_language.sproc_syntax_01(
	val1 STRING NOT NULL, 
	val2 bigdecimal, 
	out txt string, 
	inout txt_len integer) 
RETURNS (
	txt STRING NOT NULL,	
	val1 STRING NOT NULL,
	num integer
) AS
BEGIN
	txt = ''some text'';
	txt_len = length(txt);
    select ''first'', val1, 7;
    select ''second'', val1, 8;
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_sproc_language.CreateTableLimitations()
returns(
	col1 string,col2 long
)
as
begin
	drop table if exists dwh.test1;
--	create table dwh.test1(col1 string, col2 long not null, PRIMARY KEY (col1));
--	EXECUTE immediate ''create table dwh.test1(col1 string, col2 long not null, PRIMARY KEY (col1));'' without return;
	call "UTILS.createTable"(
	    "tableName" => ''dwh.test1''/* Mandatory: Fully-qualified name of the table to create */,
	    "columnsAndTypes" => ''col1|string,col2|long''/* Mandatory: Comma-delimited list of pairs columnName|dataType */
	) without return;
	
	
	insert into dwh.test1 values(''test'', 1);
	
	drop table if exists dwh.test2;
--	select * into dwh.test2 from dwh.test1;
	EXECUTE immediate ''select * into dwh.test2 from dwh.test1;'' without return;

	drop table if exists #test3;
--	CREATE LOCAL TEMPORARY TABLE #test3(col1 string, col2 long not null);
--	CREATE LOCAL TEMPORARY TABLE #test3(col1 string, col2 long);
--	create LOCAL temporary table #test3(col1 string, col2 long, PRIMARY KEY (col1));

	drop table if exists #test4;
	select * into #test4 from dwh.test1;
	
	select * from #test4;
end') ;;

EXEC SYSADMIN.importProcedure("text" => '--*************************************************************
--*************************************************************
-- With transaction
--*************************************************************
--*************************************************************
CREATE procedure master_class_2021_sproc_language.transactions_01()
as
begin atomic
	
	-- Doesn''t drop if it exists
	call "UTILS.createTable"(
	    "tableName" => ''dwh.transaction_01''/* Mandatory: Fully-qualified name of the table to create */,
	    "columnsAndTypes" => ''col1|string,col2|long''/* Mandatory: Comma-delimited list of pairs columnName|dataType */
	);
	
	select 1/0;
end') ;;

EXEC SYSADMIN.importProcedure("text" => '--*************************************************************
--*************************************************************
-- NO transaction
--*************************************************************
--*************************************************************
CREATE procedure master_class_2021_sproc_language.transactions_03()
as
begin atomic
	begin atomic
		call "UTILS.createTable"(
		    "tableName" => ''dwh.transaction_03a''/* Mandatory: Fully-qualified name of the table to create */,
		    "columnsAndTypes" => ''col1|string,col2|long''/* Mandatory: Comma-delimited list of pairs columnName|dataType */
		);
		select 1/0;		
	exception e
	end

	begin atomic
		call "UTILS.createTable"(
		    "tableName" => ''dwh.transaction_03b''/* Mandatory: Fully-qualified name of the table to create */,
		    "columnsAndTypes" => ''col1|string,col2|long''/* Mandatory: Comma-delimited list of pairs columnName|dataType */
		);
	exception e
	end
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure master_class_2021_sproc_language.logging_01()
returns (
	xdate date
)
as
begin
	declare string logger_name = ''dv_logging_example'';
	EXEC SYSADMIN.executeCli(script => ''/subsystem=logging/logger='' || logger_name || '':add(level=DEBUG)'') without return;

	-- https://documentation.datavirtuality.com/24/reference-guide/data-types/escaped-literal-syntax
	DECLARE date startdate = {d ''2021-11-08''};
	DECLARE date idate;
	DECLARE date enddate = {d ''2021-11-11''};
	
	idate=startdate;
	CREATE LOCAL TEMPORARY TABLE #x(xdate date);
	WHILE (idate<=enddate)
	BEGIN
		INSERT INTO #x(xdate) VALUES (idate);
		
		CALL SYSADMIN.logMsg(msg => ''Date: '' || idate, context => logger_name, level => ''DEBUG'') without return;
		
		idate=timestampadd(SQL_TSI_DAY,1,idate);
	END
	SELECT * from #x;

	EXEC SYSADMIN.executeCli(script => ''/subsystem=logging/logger='' || logger_name || '':remove'') without return;
end') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_sproc_language.DataFromCsv as
SELECT
	row_number() over(order by 	"csv_table"."SalesOrderID", "csv_table"."SalesOrderDetailID") as rowid,
	"csv_table"."SalesOrderID",
	"csv_table"."SalesOrderDetailID",
	"csv_table"."CarrierTrackingNumber",
	"csv_table"."OrderQty",
	"csv_table"."ProductID",
	"csv_table"."UnitPrice",
	"csv_table"."LineTotal",
	"csv_table"."ModifiedDate",
	cast(to_chars(SHA2_512((call x_utils.concat_ws(''|'',
		"csv_table"."SalesOrderID",
		"csv_table"."SalesOrderDetailID",
		"csv_table"."CarrierTrackingNumber",
		"csv_table"."OrderQty",
		"csv_table"."ProductID",
		"csv_table"."UnitPrice",
		"csv_table"."LineTotal",
		"csv_table"."ModifiedDate"
	))), ''HEX'') as string) as "hash_of_values",
	false as processed
FROM
	"dv_output".getFiles(''./SalesOrderDetail.csv'') f,
	TEXTTABLE(to_chars(f.file,''UTF-8'') 
		COLUMNS 
		"SalesOrderID" INTEGER ,
		"SalesOrderDetailID" INTEGER ,
		"CarrierTrackingNumber" STRING ,
		"OrderQty" INTEGER ,
		"ProductID" INTEGER ,
		"SpecialOfferID" INTEGER ,
		"UnitPrice" BIGDECIMAL ,
		"UnitPriceDiscount" BIGDECIMAL ,
		"LineTotal" BIGDECIMAL ,
		"rowguid" STRING ,
		"ModifiedDate" TIMESTAMP 
		DELIMITER '','' 
		QUOTE ''"'' 
		HEADER 1 
	) "csv_table"') ;;

EXEC SYSADMIN.importProcedure("text" => '--*************************************************************
--*************************************************************
-- No return values
--*************************************************************
--*************************************************************
CREATE PROCEDURE master_class_2021_sproc_language.sproc_syntax_03(
	val1 STRING NOT NULL, 
	val2 bigdecimal, 
	out txt string, 
	inout txt_len integer) 
--RETURNS (
--	txt STRING NOT NULL,
--	val1 STRING NOT NULL,
--	num integer
--)
AS
BEGIN
	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => ''first call'');
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_sproc_language.restartable_process() as
BEGIN
	declare string logger_name = ''dv_logging_example'';
	
	begin
		EXEC SYSADMIN.executeCli(script => ''/subsystem=logging/logger='' || logger_name || '':add(level=DEBUG)'') without return;
	Exception e
	end
	
	LOOP ON (
		SELECT
			"rowid", 
			"salesorderid", 
			"salesorderdetailid", 
			"carriertrackingnumber", 
			"orderqty", 
			"productid", 
			"unitprice", 
			"linetotal", 
			"modifieddate", 
			"hash_of_values", 
			"processed"
        FROM "dwh.sales_order_details"
		where processed = false
	) AS Cur
	begin
		declare string ErrorMsg = null;
		declare boolean success = true;
		
		begin
			-- pretend this is some time consuming API call
			call "x_utils.sleep"("ms" => 500);
			if (RAND() < 0.10)
				ERROR ''Raise a random error'';
       		CALL SYSADMIN.logMsg(msg => ''Successful API call: '' || cur.rowid, context => logger_name, level => ''DEBUG'') without return;       
	    Exception e				    
           	ErrorMsg = cast(jsonobject(e.STATE, e.ERRORCODE, e.TEIIDCODE, e.EXCEPTION, e.CHAIN) as string);
       		CALL SYSADMIN.logMsg(msg => ''Exception: '' || ErrorMsg, context => logger_name, level => ''DEBUG'') without return;       
       		success = false;
	    end

		begin
	        update dwh.sales_order_details
			set processed = VARIABLES.success
			where rowid = cur.rowid;
	    Exception e				    
           	ErrorMsg = cast(jsonobject(e.STATE, e.ERRORCODE, e.TEIIDCODE, e.EXCEPTION, e.CHAIN) as string);
       		CALL SYSADMIN.logMsg(msg => ''Exception: '' || ErrorMsg, context => logger_name, level => ''DEBUG'') without return;       
	    end
	end
	
	begin
		EXEC SYSADMIN.executeCli(script => ''/subsystem=logging/logger='' || logger_name || '':remove'') without return;
	exception e
	end
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_sproc_language.cached_sproc(
	param1 integer,
	param2 string
) 
returns (
	"rowid" long,
	"salesorderid" integer,
	"carriertrackingnumber" STRING
)as
BEGIN
	declare string logger_name = ''dv_logging_example'';
	
	begin
		EXEC SYSADMIN.executeCli(script => ''/subsystem=logging/logger='' || logger_name || '':add(level=DEBUG)'') without return;
	Exception e
	end
	
	declare string concatenated_params = (call "x_utils.concat_ws"(''|'', param1, param2));
	declare string hash = cast(to_chars(SHA2_512(concatenated_params), ''HEX'') as string);
	
	if (not exists(select 1 from dwh.sproc_cache where hashed_params = hash))
	begin
		insert into dwh.sproc_cache
		select concatenated_params, hash, rowid, salesorderid, carriertrackingnumber from "dwh.sales_order_details"
		where rowid = param1;
	end

	select rowid, salesorderid, carriertrackingnumber from dwh.sproc_cache
	where hashed_params = hash;

	begin
		EXEC SYSADMIN.executeCli(script => ''/subsystem=logging/logger='' || logger_name || '':remove'') without return;
	exception e
	end
end') ;;

EXEC SYSADMIN.importProcedure("text" => '--*************************************************************
--*************************************************************
-- call sproc without return
--*************************************************************
--*************************************************************
CREATE PROCEDURE master_class_2021_sproc_language.sproc_syntax_02(
	val1 STRING NOT NULL, 
	val2 bigdecimal, 
	out txt string, 
	inout txt_len integer) 
RETURNS (
	txt STRING NOT NULL,	
	val1 STRING NOT NULL,
	num integer
) AS
BEGIN
	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => ''first call'');
--	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => ''second call'');
	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => ''second call'') without return;
END') ;;








