/* Data Virtuality exported objects */
/* Created: 08.06.21  14:22:49.936 */
/* Server version: 2.4.6 */
/* Build: ce8ff20 */
/* Build date: 2021-05-28 */
/* Exported by Studio ver.2.4.6 (rev.cb1b700). Build date is 2021-05-28. */
/* Please set statement separator to ;; before importing */




/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'master_class_2021_adv_sql') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_adv_sql.Data_without_modified_date as
select 1 as id, ''a'' as col1, ''d'' as col2
union all
select 2 as id, ''b'' as col1, ''e'' as col2
union all
select 3 as id, ''c'' as col1, ''f'' as col2') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_adv_sql.Data_without_modified_date_v2 as
select 1 as id, ''a'' as col1, ''CHANGED'' as col2
union all
select 2 as id, ''b'' as col1, ''CHANGED'' as col2
union all
select 3 as id, ''c'' as col1, ''f'' as col2') ;;

EXEC SYSADMIN.importView("text" => 'create view "master_class_2021_adv_sql"."ReverseDataTypeNames" as
SELECT 
	"k.Name","x.Reversed"  
FROM 
	SYS.DataTypes AS "k", 
	OBJECTTABLE(       
		LANGUAGE ''javascript'' 
		''function reverse(s){ return s.split("").reverse().join(""); }                 
		reverse(tabname);''                  
		PASSING "k.Name" AS "tabname"                 
		COLUMNS  "Reversed" string ''dv_row'' 
	) AS x') ;;

EXEC SYSADMIN.importView("text" => 'create view "master_class_2021_adv_sql"."javascript_example" as
SELECT x.* 
FROM ( OBJECTTABLE(    
	LANGUAGE ''javascript'' 
	''var rows = [];        
	firstrow = { "col1": "foo", "col2": "bar" };        
	rows.push( firstrow );        
	secondrow = { "col2": "foo", "col3": "bar" };        
	rows.push( secondrow );        
	rows;''         
	COLUMNS         
	"col1" string ''dv_row.col1'',        
	"col2" string ''dv_row.col2'',        
	"col3" string ''dv_row.col3'',        
	"col4" string ''dv_row.col4'' ) AS x)') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure master_class_2021_adv_sql."_InitNumberTable"() as
begin


SELECT ROW_NUMBER() OVER(ORDER BY 1) AS n
INTO dwh.Numbers
FROM 
	(select * from INFORMATION_SCHEMA.columns limit 1000) tb1,
	(select * from INFORMATION_SCHEMA.columns limit 1000) tb2
order by n
limit 1000000
OPTION $ALLOW_CARTESIAN EXPLICIT;


call "dwh.native"("request" => ''ALTER TABLE "dwh_dv_2_4_5"."Numbers" ADD PRIMARY KEY (n);'');


end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure master_class_2021_adv_sql.dateaxis(
	IN start_date date,
	IN num_days integer
) 
returns (
	xdate date
)
as
begin
	select 
		cast(timestampadd(SQL_TSI_DAY, n.n-1, start_date) as date)
	from
		"dwh.Numbers" n
	where n.n <= num_days;
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure master_class_2021_adv_sql.split_text(
	IN str string
) 
returns (
	position long,
	xchar string(1)
)
as
begin
	select
		n.n,
		SUBSTRING(str, cast(n.n as integer), 1)
	from
		"dwh.Numbers" n
	where n.n <= length(str);
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure master_class_2021_adv_sql.array_to_string(
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
EXEC SYSADMIN.setRemark("name" => 'master_class_2021_adv_sql.array_to_string', "remark" => 'Modeled after the PostgreSQL function array_to_string') OPTION $NOFAIL ;;

EXEC SYSADMIN.importProcedure("text" => 'create virtual procedure master_class_2021_adv_sql.dateaxis_start_end(
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

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_adv_sql."_InitInvoices"() as
begin


drop table if exists dwh.tblInvoices;

declare string sqlcode = ''
create table dwh.tblInvoices (
    invoice_num integer
    ,license_start date
    ,license_end date
);;'';

execute immediate (sqlcode);

insert into dwh.tblInvoices(invoice_num, license_start, license_end)
values(1, cast(''2020-06-01'' as date), cast(''2020-07-01'' as date)),
(2, cast(''2020-07-01'' as date), cast(''2020-07-31'' as date)),
(3, cast(''2020-08-01'' as date), cast(''2020-08-31'' as date)),
(6, cast(''2020-09-01'' as date), cast(''2020-09-15'' as date)),
(7, cast(''2020-10-01'' as date), cast(''2020-10-31'' as date)),
(8, cast(''2020-10-15'' as date), cast(''2020-11-30'' as date))
;


end') ;;

EXEC SYSADMIN.importProcedure("text" => 'Create Virtual Procedure "master_class_2021_adv_sql"."RegexReplace" (
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

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure master_class_2021_adv_sql.ReplacingText(
	IN proc_name string not null,
	IN metrics STRING NOT NULL,
	IN elements STRING NOT NULL
	)
returns (sql_code string)
AS
begin

declare string dummy_sproc_template = 
''
create procedure master_class_2021_adv_sql.<<proc_name>>(
	IN reportId INTEGER NOT NULL
	) 
RETURNS (
	"date" string,
	"year" string,
	"month" string,
	"day" string,
	"hour" string,
<<element_columns>>,
<<metric_columns>>
) AS
begin
	/* !*!*! Dummy sproc. Will be replaced dynamically. !*!*! */
end
'';
	
declare string proc_sql = (select replace(replace(replace(
	dummy_sproc_template, ''<<element_columns>>'', elements),
	''<<metric_columns>>'', metrics),
	''<<proc_name>>'', proc_name)
);

execute (proc_sql) without return;

select proc_sql;

end') ;;

EXEC SYSADMIN.importProcedure("text" => '
create procedure master_class_2021_adv_sql.dummy_sproc(
	IN reportId INTEGER NOT NULL
	) 
RETURNS (
	"date" string,
	"year" string,
	"month" string,
	"day" string,
	"hour" string,
string_elements string,
string_metrics string
) AS
begin
	/* !*!*! Dummy sproc. Will be replaced dynamically. !*!*! */
end
') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_adv_sql.License_missing_dates as
select
	d.xdate
from
	"master_class_2021_adv_sql.dateaxis_start_end"(
            "startdate" => ''2020-06-01'', 
            "enddate" => ''2020-11-30''
        ) as d
except
select
	d.xdate
FROM 
    "dwh.tblInvoices" as i
    join "master_class_2021_adv_sql.dateaxis_start_end"(
            "startdate" => ''2020-06-01'', 
            "enddate" => ''2020-11-30''
        ) as d
        on d.xdate between i.license_start and i.license_end') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_adv_sql.License_dates as
SELECT i.invoice_num, i.license_start, i.license_end, d.xdate
FROM 
    "dwh.tblInvoices" as i
    join "master_class_2021_adv_sql.dateaxis_start_end"(
            "startdate" => ''2020-06-01'', 
            "enddate" => ''2020-11-30''
        ) as d
        on d.xdate between i.license_start and i.license_end') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view master_class_2021_adv_sql.License_overlapping_dates as
with cteAllDates as (
select
     i.invoice_num, i.license_start, i.license_end, d.xdate
FROM 
    "dwh.tblInvoices" as i
    join "master_class_2021_adv_sql.dateaxis_start_end"(
            "startdate" => ''2020-06-01'', 
            "enddate" => ''2020-11-30''
        ) as d
        on d.xdate between i.license_start and i.license_end
)
select
    alld.xdate
from cteAllDates as alld
group by alld.xdate
having count(*) > 1') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_adv_sql.License_overlapping_dates_v2 as
with cteAllDates as (
select
     i.invoice_num, i.license_start, i.license_end, d.xdate
FROM 
    "dwh.tblInvoices" as i
    join "master_class_2021_adv_sql.dateaxis_start_end"(
            "startdate" => ''2020-06-01'', 
            "enddate" => ''2020-11-30''
        ) as d
        on d.xdate between i.license_start and i.license_end
),
cteDuplicateDates as (
select
    alld.xdate
from cteAllDates as alld
group by alld.xdate
having count(*) > 1
)
select
    ad.*
from 
    cteAllDates as ad
    join cteDuplicateDates as dd
        on ad.xdate = dd.xdate') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "master_class_2021_adv_sql"."RegexReplaceExample"
as

select
	k.Name,
	(call demos.RegexReplace(
		    "initialString" => k.Name,
		    "regex" => ''[aeiouAEIOU]'',
		    "replacement" => ''**''
	)) as regex_replacement
from
	SYS.DataTypes AS k') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure master_class_2021_adv_sql.HowToAlterStoredProcedure()
returns(resultString string) as
begin

declare string proc_def = (select definition FROM "SYSADMIN.ProcDefinitions" where name = ''master_class_2021_adv_sql.dummy_sproc'');

select * from (call "master_class_2021_adv_sql.RegexReplace"(
    "initialString" => proc_def,
    "regex" => ''^\s*create '',
    "replacement" => ''alter ''
)) as a;

end') ;;

EXEC SYSADMIN.importView("text" => 'create view master_class_2021_adv_sql.License_contiguous_dates_grouped as
with cteDistinctDates as (
    SELECT distinct "xdate" FROM "master_class_2021_adv_sql.License_dates"
),
cteNumberedDistinctDates as (
    SELECT xdate, row_number() over(order by xdate) as row_num 
    FROM cteDistinctDates
),
cteDiff as (
select
    c1.xdate as xdate_curr, c1.row_num as row_num_curr, c2.xdate as xdate_prev, c2.row_num as row_num_prev, 
    case
        when c2.xdate is null then 1
        else TIMESTAMPDIFF(SQL_TSI_DAY, c2.xdate, c1.xdate)
    end as diff_prev_date
from
    cteNumberedDistinctDates c1
    left join cteNumberedDistinctDates c2
        on c1.row_num = c2.row_num +1
)
select
    cteDiff.*,
    sum(cteDiff.diff_prev_date) over(order by cteDiff.row_num_curr rows unbounded preceding) as cum_sum,
    sum(cteDiff.diff_prev_date) over(order by cteDiff.row_num_curr rows unbounded preceding) - cteDiff.row_num_curr as grp
from cteDiff') ;;








