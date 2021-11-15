drop table if exists dwh.test1;;
create table dwh.test1(col1 string, col2 long not null, PRIMARY KEY (col1));;

drop table if exists dwh.test2;;
select * into dwh.test2 from dwh.test1;;

call "UTILS.prepareTargetTable"(
    "sourceObject" => '$col1|string,col2|long'
    	/* Mandatory: The fully-qualified name of the source. Can be an existing table or a stored procedure, returning data. Can also be an arbitrary table specification in for of a string of $column1|dataType1,column2|dataType3,column3[|string] */,
    "isSourceATable" => true
    	/* Optional: True or null if the source is a table, false, if procedure */,
    "target_table" => 'dwh.test1'/* Optional: The fully-qualified name of the target table */,
    "cleanupMethod" => 'DROP'/* Optional: DELETE or DROP. Any other value will throw an error. NULL or Whitespace will not perform any cleanup */
);;

drop table if exists dwh.test1;;
-- Doesn't drop if it exists
call "UTILS.createTable"(
    "tableName" => 'dwh.test1'/* Mandatory: Fully-qualified name of the table to create */,
    "columnsAndTypes" => 'col1|string,col2|long'/* Mandatory: Comma-delimited list of pairs columnName|dataType */
);;

call "UTILS.cleanTable"(
    "tableName" => 'dwh.test1'/* Optional: Physical table to be emptied */,
    "cleanupMethod" => 'DROP'/* Optional: DELETE or DROP. Any other value will throw an error. NULL or Whitespace will not perform any cleanup */
);;

