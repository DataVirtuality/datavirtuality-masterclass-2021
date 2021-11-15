


alter virtual procedure master_class_2021_sproc_language.logging_01()
returns (
	xdate date
)
as
begin
	declare string logger_name = 'dv_logging_example';
--	EXEC SYSADMIN.executeCli(script => '/subsystem=logging/logger=' || logger_name || ':add(level=DEBUG)') without return;

	-- https://documentation.datavirtuality.com/24/reference-guide/data-types/escaped-literal-syntax
	DECLARE date startdate = {d '2021-11-08'};
	DECLARE date idate;
	DECLARE date enddate = {d '2021-11-11'};
	
	idate=startdate;
	CREATE LOCAL TEMPORARY TABLE #x(xdate date);
	WHILE (idate<=enddate)
	BEGIN
		INSERT INTO #x(xdate) VALUES (idate);
		
		CALL SYSADMIN.logMsg(msg => 'Date: ' || idate, context => logger_name, level => 'DEBUG') without return;
		
		idate=timestampadd(SQL_TSI_DAY,1,idate);
	END
	SELECT * from #x;

--	EXEC SYSADMIN.executeCli(script => '/subsystem=logging/logger=' || logger_name || ':remove') without return;
end;;

call master_class_2021_sproc_language.logging_01();;
