alter procedure master_class_2021_sproc_language.CreateTableLimitations()
as
begin
	drop table if exists dwh.test1;
--	create table dwh.test1(col1 string, col2 long not null, PRIMARY KEY (col1));
--	EXECUTE immediate 'create table dwh.test1(col1 string, col2 long not null, PRIMARY KEY (col1));' without return;
	
--	insert into dwh.test1 values('test', 1);
	
	drop table if exists dwh.test2;
--	select * into dwh.test2 from dwh.test1;
--	EXECUTE immediate 'select * into dwh.test2 from dwh.test1;' without return;

	drop table if exists #test3;
--	CREATE LOCAL TEMPORARY TABLE #test3(col1 string, col2 long not null);
--	CREATE LOCAL TEMPORARY TABLE #test3(col1 string, col2 long);
--	create LOCAL temporary table #test3(col1 string, col2 long, PRIMARY KEY (col1));

	drop table if exists #test4;
--	select * into #test4 from dwh.test1;
end;;

call master_class_2021_sproc_language.CreateTableLimitations();;

/*
select 'dwh.test1' as tblName, x.* from "dwh.test1" x
union all
select 'dwh.test2' as tblName, x.* from "dwh.test2" x
;;
*/
	

