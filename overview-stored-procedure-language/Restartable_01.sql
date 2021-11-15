

alter procedure master_class_2021_sproc_language.restartable_process() as
BEGIN
	declare string logger_name = 'dv_logging_example';
	
	begin
		EXEC SYSADMIN.executeCli(script => '/subsystem=logging/logger=' || logger_name || ':add(level=DEBUG)') without return;
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
				ERROR 'Raise a random error';
       		CALL SYSADMIN.logMsg(msg => 'Successful API call: ' || cur.rowid, context => logger_name, level => 'DEBUG') without return;       
	    Exception e				    
           	ErrorMsg = cast(jsonobject(e.STATE, e.ERRORCODE, e.TEIIDCODE, e.EXCEPTION, e.CHAIN) as string);
       		CALL SYSADMIN.logMsg(msg => 'Exception: ' || ErrorMsg, context => logger_name, level => 'DEBUG') without return;       
       		success = false;
	    end

		begin
	        update dwh.sales_order_details
			set processed = VARIABLES.success
			where rowid = cur.rowid;
	    Exception e				    
           	ErrorMsg = cast(jsonobject(e.STATE, e.ERRORCODE, e.TEIIDCODE, e.EXCEPTION, e.CHAIN) as string);
       		CALL SYSADMIN.logMsg(msg => 'Exception: ' || ErrorMsg, context => logger_name, level => 'DEBUG') without return;       
	    end
	end
	
	begin
		EXEC SYSADMIN.executeCli(script => '/subsystem=logging/logger=' || logger_name || ':remove') without return;
	exception e
	end
end;;

call master_class_2021_sproc_language.restartable_process();;



