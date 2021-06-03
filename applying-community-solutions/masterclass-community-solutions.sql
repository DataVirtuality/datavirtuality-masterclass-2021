--Please adjust the path in the file_xml datasource

/* Exported connections and data sources */
EXEC SYSADMIN.createConnection("name" => 'PostgreSQL', "jbossCLITemplateName" => 'postgresql', "connectionOrResourceAdapterProperties" => 'user-name=readonly_user,port=5432,host=dv-learn-pg.cv1lqj6ulech.eu-central-1.rds.amazonaws.com,db=dv-learn-pg', "encryptedProperties" => 'password=SjzyXrGvHOxzTSHkWZROj6Q6iWhcDPt1') ;;
EXEC SYSADMIN.createDataSource("name" => 'PostgreSQL', "translator" => 'postgresql', "modelProperties" => 'importer.tableTypes="TABLE,VIEW",importer.importIndexes=TRUE,importer.useFullSchemaName=FALSE,importer.schemaPattern=public', "translatorProperties" => '', "encryptedModelProperties" => '', "encryptedTranslatorProperties" => '') ;;

-- Pleas
EXEC SYSADMIN.createConnection("name" => 'file_xml', "jbossCLITemplateName" => 'ufile', "connectionOrResourceAdapterProperties" => 'ParentDirectory="G:/Masterclass Prep/210854723-handle-multi-valued-XML-paths",decompressCompressedFiles=false', "encryptedProperties" => '') ;;
EXEC SYSADMIN.createDataSource("name" => 'file_xml', "translator" => 'ufile', "modelProperties" => 'importer.useFullSchemaName=false', "translatorProperties" => '', "encryptedModelProperties" => '', "encryptedTranslatorProperties" => '') ;;

EXEC SYSADMIN.createConnection("name" => 'MySQL', "jbossCLITemplateName" => 'mysql', "connectionOrResourceAdapterProperties" => 'user-name=readonly_user,port=3306,host=dv-learn-mysql.cv1lqj6ulech.eu-central-1.rds.amazonaws.com,db=dv_learn_mysql', "encryptedProperties" => 'password=wN1dJjvH01TW6U2FCYKIm3BE8LLzVjam') ;;
EXEC SYSADMIN.createDataSource("name" => 'MySQL', "translator" => 'mysql5', "modelProperties" => 'importer.tableTypes="TABLE,VIEW",importer.importIndexes=TRUE,importer.useFullSchemaName=FALSE,importer.defaultSchema=dv_learn_mysql', "translatorProperties" => '', "encryptedModelProperties" => '', "encryptedTranslatorProperties" => '') ;;

/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_utils_highlights') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_regex_replace') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_recopts_without_schedule') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_optional_join') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_multi_valued_xml') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_mat_tables') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_lambda_architecture') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_key_value') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_drop_mat_tables') ;;

EXEC SYSADMIN.createVirtualSchema("name" => 'masterclass_date_axis') ;;

create view masterclass_mat_tables.mat_table_overview as
SELECT a.*

FROM (SELECT "t.Name" as "TableName", "mt.accessState", SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1)as "TablePrefix", CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer) as "TableNumberInfix",

CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer)as "MatTableStage", RANK() OVER (PARTITION BY SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1) ORDER BY CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer) DESC) as "StagePriority"

FROM  "SYS.Tables" t INNER JOIN "SYSADMIN.MaterializedTable" mt ON("mt.name" = "t.name")

WHERE "t.SchemaName" = 'dwh' AND "mt.accessState" = 'READY'

ORDER BY CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer)) as a

WHERE "a.StagePriority" <= 10

ORDER BY "a.TableNumberInfix", "a.StagePriority" ASC ;;

CREATE VIEW "masterclass_optional_join.no_optional_join" AS 
SELECT 
	"salesorderdetail.orderqty",
	"salesorderdetail.linetotal"
FROM 
	"MySQL.salesorderdetail" INNER JOIN "PostgreSQL.product" ON "salesorderdetail.productid" = "product.productid" ;;

CREATE VIEW "masterclass_optional_join.optional_join" AS 
SELECT 
	"salesorderdetail.orderqty",
	"salesorderdetail.linetotal"
FROM 
	"MySQL.salesorderdetail" INNER JOIN /*+ optional */ "PostgreSQL.product" ON "salesorderdetail.productid" = "product.productid" ;;

create VIEW "masterclass_optional_join.optional_join_both_tables_used" AS 
SELECT 
	"salesorderdetail.orderqty",
	"salesorderdetail.linetotal",
	"product.name"
FROM 
	"MySQL.salesorderdetail" INNER JOIN /*+ optional */ "PostgreSQL.product" ON "salesorderdetail.productid" = "product.productid" ;;

CREATE view masterclass_multi_valued_xml.step_1_select_data as
select 
*
FROM 
	(call "file_xml".getFiles('\data01.json')) f ;;

create view masterclass_multi_valued_xml.step_3_indexed_path_expression as
SELECT 
	"xmlTable.idColumn",
	"xmlTable.firstelem",
	"xmlTable.secondelem",
	"xmlTable.thirdelem"
FROM 
	(call "file_xml".getFiles('\data01.json')) f,
	XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/included' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
		COLUMNS 
		"idColumn" FOR ORDINALITY,
		"firstelem" STRING  PATH 'attributes[1]',
		"secondelem" STRING  PATH 'attributes[2]',
		"thirdelem" STRING  PATH 'attributes[3]'
	) "xmlTable" ;;

create view masterclass_multi_valued_xml.step_4_multiple_XMLTABLE_parsing as
SELECT 
	"xmlTable.idColumn",
	"attr"."attributes"
FROM 
	(call "file_xml".getFiles('\data01.json')) f,
	XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/included' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
		COLUMNS 
		"idColumn" FOR ORDINALITY,
		"attributes" XML PATH '.'
	) "xmlTable", 
	XMLTABLE( 'attributes' PASSING "xmlTable"."attributes"
		COLUMNS 
		"attributes" STRING PATH '.'
	) "attr" ;;

create view masterclass_multi_valued_xml.step_5_array_approach as
SELECT 
	"xmlTable.idColumn",
	"xmlTable.attributes",
	array_get("xmlTable.attributes", 1) as "firstelem",
	array_get("xmlTable.attributes", 2) as "secondelem",
	array_get("xmlTable.attributes", 3) as "thirdelem"
FROM 
		(call "file_xml".getFiles('\data01.json')) f,
	XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/included' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
		COLUMNS 
		"idColumn" FOR ORDINALITY,
		"type" STRING  PATH 'type',
		"id" STRING  PATH 'id',
		"attributes" STRING[]  PATH 'attributes'
	) "xmlTable" ;;

create view masterclass_multi_valued_xml.step_6_multiple_rows as
select 
	to_chars(f.file, 'UTF-8'),
	jsontoxml('root', f.file)
FROM 
	(call "file_xml".getFiles('\data02.json')) f ;;

create view masterclass_multi_valued_xml.step_7_indexed_path_expression as
SELECT 
	"xmlTable.idColumn",
	"xmlTable.firstelem",
	"xmlTable.secondelem",
	"xmlTable.thirdelem"
FROM 
	(call "file_xml".getFiles('\data02.json')) f,
	XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/included' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
		COLUMNS 
		"idColumn" FOR ORDINALITY,
		"firstelem" STRING  PATH 'attributes[1]',
		"secondelem" STRING  PATH 'attributes[2]',
		"thirdelem" STRING  PATH 'attributes[3]'
	) "xmlTable" ;;

create view masterclass_multi_valued_xml.step_8_multiple_XMLTABLE_parsing as
SELECT 
	"xmlTable.idColumn",
	"attr"."attributes"
FROM 
	(call "file_xml".getFiles('\data02.json')) f,
	XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/included' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
		COLUMNS 
		"idColumn" FOR ORDINALITY,
		"attributes" XML PATH '.'
	) "xmlTable", 
	XMLTABLE( 'attributes' PASSING "xmlTable"."attributes"
		COLUMNS 
		"attributes" STRING PATH '.'
	) "attr" ;;

create view masterclass_multi_valued_xml.step_9_array_approach as
SELECT 
	"xmlTable.idColumn",
	"xmlTable.attributes",
	array_get("xmlTable.attributes", 1) as "firstelem",
	array_get("xmlTable.attributes", 2) as "secondelem",
	array_get("xmlTable.attributes", 3) as "thirdelem"
FROM 
		(call "file_xml".getFiles('\data02.json')) f,
	XMLTABLE(XMLNAMESPACES( 'http://www.w3.org/2001/XMLSchema-instance' as "xsi" ),'/root/included' PASSING JSONTOXML('root',to_chars(f.file,'UTF-8'))
		COLUMNS 
		"idColumn" FOR ORDINALITY,
		"type" STRING  PATH 'type',
		"id" STRING  PATH 'id',
		"attributes" STRING[]  PATH 'attributes'
	) "xmlTable" ;;

create view masterclass_utils_highlights.create_table as select
        *
    from
        (
            call UTILS.createTable (
                tableName => 'dwh._TableName'
                ,columnsAndTypes => 'stringColumn,intColumn|integer,decimalColumn|decimal,timestampColumn|timestamp,_crazyName'
            )
        ) a ;;

CREATE view masterclass_utils_highlights.table_to_json as select
        *
    from
        (
            call "UTILS.tableToJson" (
                "tableName" => 'MySQL.salesperson'
            )
        ) a ;;

CREATE view masterclass_utils_highlights.try_cast as select
        *
    from
        (
            call "UTILS.tryCast" (
                "originalValue" => 'abcd'
                ,"targetType" => 'decimal'
            )
        ) a ;;

create view masterclass_drop_mat_tables.table_stages as
SELECT a.*
FROM (SELECT "t.Name" as "TableName", "mt.accessState", SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1)as "TablePrefix", CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer) as "TableNumberInfix",
CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer)as "MatTableStage", RANK() OVER (PARTITION BY SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1) ORDER BY CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer) DESC) as "StagePriority"
FROM  "SYS.Tables" t INNER JOIN "SYSADMIN.MaterializedTable" mt ON("mt.name" = "t.name")
WHERE "t.SchemaName" = 'dwh' AND "mt.accessState" = 'READY'
ORDER BY CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer)) as a
WHERE "a.StagePriority" <= 10
ORDER BY "a.TableNumberInfix", "a.StagePriority" ASC ;;

create view masterclass_regex_replace.javascript_example as
SELECT x.* 
FROM ( OBJECTTABLE(    
	LANGUAGE 'javascript' 
	'var rows = [];        
	firstrow = { "col1": "foo", "col2": "bar" };        
	rows.push( firstrow );        
	secondrow = { "col2": "foo", "col3": "bar" };        
	rows.push( secondrow );        
	rows;'         
	COLUMNS         
	"col1" string 'dv_row.col1',        
	"col2" string 'dv_row.col2',        
	"col3" string 'dv_row.col3',        
	"col4" string 'dv_row.col4' ) AS x) ;;

CREATE view masterclass_regex_replace.reverse_data_type_names as
SELECT 
	"k.Name","x.Reversed"  
FROM 
	SYS.DataTypes AS "k", 
	OBJECTTABLE(       
		LANGUAGE 'javascript' 
		'function reverse(s){ return s.split("").reverse().join(""); }                 
		reverse(tabname);'                  
		PASSING "k.Name" AS "tabname"                 
		COLUMNS  "Reversed" string 'dv_row' 
	) AS x ;;

create view masterclass_multi_valued_xml.step_2_select_data_content as
select 
	to_chars(f.file, 'UTF-8'),
	jsontoxml('root', f.file)
FROM 
	(call "file_xml".getFiles('data01.json')) f ;;

create view masterclass_recopts_without_schedule.list_recopts_without_schedule as
SELECT ro.id
   ,ro.Matchdescriptor
   ,sj.description
   ,sd.*
 FROM
   "SYSADMIN.RecommendedOptimizations" ro
   left join "SYSADMIN.ScheduleJobs" sj
   on ro.id = sj.groupId
   left join "SYSADMIN.Schedules" sd
   on sj.ID = sd.jobID
 WHERE
   "ro"."Enabled" = true
   and sd.ID IS NULL ;;

CREATE VIEW masterclass_lambda_architecture."salesorderdetail" AS SELECT "salesorderid", "linenumber", "productid", "specialofferid", "carriertrackingnumber", "orderqty", "unitprice", "unitpricediscount", "modifieddate", "rowguid", "linetotal" FROM "MySQL.salesorderdetail" where salesorderid > 154000 ;;

create view masterclass_lambda_architecture.salesorderdetail_live_data as select
        *
    from
        "MySQL.salesorderdetail"
    where
        salesorderid >= 154000 ;;

create view masterclass_utils_highlights.array_to_table_test as select
        *
    from
        (
            call "UTILS.arrayToTable" (
                "items" => (
                    'a'
                    ,'b'
                    ,'c'
                )
            )
        ) a ;;

CREATE VIRTUAL PROCEDURE masterclass_mat_tables.deleteMatTableStages(IN maxStagesToKeep integer NOT NULL)

AS

BEGIN

IF (maxStagesToKeep <1)

BEGIN

ERROR 'The value of the input parameter must be at least 1. You must keep at least the most current stage for each mat table group.';

END

LOOP ON (SELECT a.*

FROM (SELECT "t.Name" as "TableName", "mt.accessState", SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1)as "TablePrefix", CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer) as "TableNumberInfix",

CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer)as "MatTableStage", RANK() OVER (PARTITION BY SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1) ORDER BY CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer) DESC) as "StagePriority"

FROM  "SYS.Tables" t INNER JOIN "SYSADMIN.MaterializedTable" mt ON("mt.name" = "t.name")

WHERE "t.SchemaName" = 'dwh' AND "mt.accessState" = 'READY'

ORDER BY CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer)) as a

WHERE "a.StagePriority" > maxStagesToKeep

ORDER BY "a.TableNumberInfix", "a.StagePriority" ASC) as cur

BEGIN

EXECUTE IMMEDIATE 'DROP TABLE dwh.' || cur.TableName;

END

END ;;

CREATE VIRTUAL PROCEDURE masterclass_key_value.parse_params (
    IN params object,IN "key" string
) RETURNS (
    "argument_number" integer, "key" string, "value" object)
    AS
BEGIN
    DECLARE integer VARIABLES.i = 0 ;
    CREATE LOCAL TEMPORARY TABLE "#__LOCAL__keyvalue_store" (
        "argument_number" integer, "key" string, "value" object) ;
    WHILE (
        i < array_length (params)
    )
    BEGIN
        INSERT
            INTO "#__LOCAL__keyvalue_store" SELECT
                    VARIABLES.i + 1 as "argument_number"
                    ,cast (
                        params[i + 1 ][1] as string
                    ) AS "key"
                    ,params[i + 1 ][2] as "value" ;
        VARIABLES.i = VARIABLES.i + 1 ;
    END
    IF ("key" IS NOT NULL)
 	    SELECT * from "#__LOCAL__keyvalue_store" WHERE "key" = "parse_params.key" ;
    ELSE 
	    SELECT * from "#__LOCAL__keyvalue_store" ;
END ;;

Create Virtual Procedure masterclass_regex_replace.RegexReplace (
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
		ObjectTable (language 'javascript' '
			(new java.lang.String(initialString)).replaceAll(regex, replacement)
			'Passing
			initialString as initialString,
			regex as regex,
			replacement as replacement
			Columns
			resultString string 'dv_row'
		) o;
End ;;

CREATE virtual procedure masterclass_date_axis.dateaxis (
    IN startdate date
    ,IN enddate date
) returns (
    xdate date
) as
begin
    DECLARE date idate ;
    idate = startdate ;
    CREATE LOCAL TEMPORARY TABLE #x (
        xdate date
    ) ;
    WHILE (
        idate <= enddate
    )
    BEGIN
        INSERT
            INTO #x (xdate)
            VALUES (idate) ;
        idate = timestampadd (
            SQL_TSI_DAY
            ,1
            ,idate
        ) ;
    END
    SELECT
            *
        from
            #x ;
end ;;

CREATE VIRTUAL PROCEDURE masterclass_drop_mat_tables.deleteMatTableStages(IN maxStagesToKeep integer NOT NULL)

AS

BEGIN

IF (maxStagesToKeep <1)

BEGIN

ERROR 'The value of the input parameter must be at least 1. You must keep at least the most current stage for each mat table group.';

END

LOOP ON (SELECT a.*

FROM (SELECT "t.Name" as "TableName", "mt.accessState", SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1)as "TablePrefix", CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer) as "TableNumberInfix",

CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer)as "MatTableStage", RANK() OVER (PARTITION BY SUBSTRING("t.Name",0,LOCATE('_st',"t.Name")-1) ORDER BY CAST(SUBSTRING("t.Name",LOCATE('_st',"t.Name")+3) as integer) DESC) as "StagePriority"

FROM  "SYS.Tables" t INNER JOIN "SYSADMIN.MaterializedTable" mt ON("mt.name" = "t.name")

WHERE "t.SchemaName" = 'dwh' AND "mt.accessState" = 'READY'

ORDER BY CAST(SUBSTRING("t.Name",11,LOCATE('_st',"t.Name")-11) as integer)) as a

WHERE "a.StagePriority" > maxStagesToKeep

ORDER BY "a.TableNumberInfix", "a.StagePriority" ASC) as cur

BEGIN

EXECUTE IMMEDIATE 'DROP TABLE dwh.' || cur.TableName;

END

END ;;

create view masterclass_key_value.example as select
        *
    from
        (
            call masterclass_key_value.parse_params (
                ARRAY (
                    ARRAY (
                        'master'
                        ,'class'
                    )
                    ,ARRAY (
                        'stored'
                        ,'procedure'
                    )
                )
            )
        ) a ;;

create view masterclass_key_value.example_key_select as select
        *
    from
        (
            call masterclass_key_value.parse_params (
                "params" => ARRAY (
                    ARRAY (
                        'master'
                        ,'class'
                    )
                    ,ARRAY (
                        'stored'
                        ,'procedure'
                    )
                )
                ,"key" => 'master'
            )
        ) a ;;

create view masterclass_regex_replace.regex_replace_demo as
select
	k.Name,
	(call masterclass_regex_replace.RegexReplace(
		    "initialString" => k.Name,
		    "regex" => '[aeiouAEIOU]',
		    "replacement" => '**'
	)) as regex_replacement
from
	SYS.DataTypes AS k ;;

create view "masterclass_date_axis.dateaxis_demo" as select
        *
    from
        (
            call "masterclass_date_axis.dateaxis" (
                "startdate" => '2021-01-01' /* Optional */
                ,"enddate" => curdate (
                ) /* Optional */
            )
        ) a ;;

create view masterclass_lambda_architecture.salesorderdetail_lambda as select
        *
    from
        "masterclass_lambda_architecture.salesorderdetail"
union
all select
        *
    from
        "masterclass_lambda_architecture.salesorderdetail_live_data" ;;


