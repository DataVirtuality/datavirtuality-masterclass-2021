
--*************************************************************
--*************************************************************
-- Return values
--*************************************************************
--*************************************************************
alter PROCEDURE master_class_2021_sproc_language.sproc_syntax_01(
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
	txt = 'some text';
	txt_len = length(txt);
    select 'first', val1, 7;
    select 'second', val1, 8;
END;;

call  master_class_2021_sproc_language.sproc_syntax_01("val1" => null);;
call  master_class_2021_sproc_language.sproc_syntax_01("val1" => 'a string');;


--*************************************************************
--*************************************************************
-- call sproc without return
--*************************************************************
--*************************************************************
alter PROCEDURE master_class_2021_sproc_language.sproc_syntax_02(
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
	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => 'first call');
--	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => 'second call');
	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => 'second call') without return;
END;;

call  master_class_2021_sproc_language.sproc_syntax_02("val1" => 'a string');;


--*************************************************************
--*************************************************************
-- No return values
--*************************************************************
--*************************************************************
alter PROCEDURE master_class_2021_sproc_language.sproc_syntax_03(
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
	call  master_class_2021_sproc_language.sproc_syntax_01("val1" => 'first call');
END;;

call  master_class_2021_sproc_language.sproc_syntax_03("val1" => 'a string');;


