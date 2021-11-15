--*************************************************************
--*************************************************************
-- With transaction
--*************************************************************
--*************************************************************
alter procedure master_class_2021_sproc_language.transactions_01()
as
begin atomic
	
	-- Doesn't drop if it exists
	call "UTILS.createTable"(
	    "tableName" => 'dwh.transaction_01'/* Mandatory: Fully-qualified name of the table to create */,
	    "columnsAndTypes" => 'col1|string,col2|long'/* Mandatory: Comma-delimited list of pairs columnName|dataType */
	);
	
	select 1/0;
end;;

call master_class_2021_sproc_language.transactions_01();;


--*************************************************************
--*************************************************************
-- NO transaction
--*************************************************************
--*************************************************************
alter procedure master_class_2021_sproc_language.transactions_02()
as
begin not atomic
	
	-- Doesn't drop if it exists
	call "UTILS.createTable"(
	    "tableName" => 'dwh.transaction_02'/* Mandatory: Fully-qualified name of the table to create */,
	    "columnsAndTypes" => 'col1|string,col2|long'/* Mandatory: Comma-delimited list of pairs columnName|dataType */
	);
	
	select 1/0;
end;;

call master_class_2021_sproc_language.transactions_02();;


--*************************************************************
--*************************************************************
-- NO transaction
--*************************************************************
--*************************************************************
alter procedure master_class_2021_sproc_language.transactions_03()
as
begin not atomic
	begin atomic
		call "UTILS.createTable"(
		    "tableName" => 'dwh.transaction_03a'/* Mandatory: Fully-qualified name of the table to create */,
		    "columnsAndTypes" => 'col1|string,col2|long'/* Mandatory: Comma-delimited list of pairs columnName|dataType */
		);
		select 1/0;		
	exception e
	end

	begin atomic
		call "UTILS.createTable"(
		    "tableName" => 'dwh.transaction_03b'/* Mandatory: Fully-qualified name of the table to create */,
		    "columnsAndTypes" => 'col1|string,col2|long'/* Mandatory: Comma-delimited list of pairs columnName|dataType */
		);
	exception e
	end
end;;

call master_class_2021_sproc_language.transactions_03();;




