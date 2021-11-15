drop table if exists dwh.sproc_cache;;


create table dwh.sproc_cache(
	"concatenated_params" string,
	"hashed_params" STRING,
	"rowid" long,
	"salesorderid" integer,
	"carriertrackingnumber" STRING
);;


alter procedure master_class_2021_sproc_language.cached_sproc(
	param1 integer,
	param2 string
) 
returns (
	"rowid" long,
	"salesorderid" integer,
	"carriertrackingnumber" STRING
)as
BEGIN
	declare string logger_name = 'dv_logging_example';
	
	begin
		EXEC SYSADMIN.executeCli(script => '/subsystem=logging/logger=' || logger_name || ':add(level=DEBUG)') without return;
	Exception e
	end
	
	declare string concatenated_params = (call "x_utils.concat_ws"('|', param1, param2));
	declare string hash = cast(to_chars(SHA2_512(concatenated_params), 'HEX') as string);
	
	if (not exists(select 1 from dwh.sproc_cache where hashed_params = hash))
	begin
		insert into dwh.sproc_cache
		select concatenated_params, hash, rowid, salesorderid, carriertrackingnumber from "dwh.sales_order_details"
		where rowid = param1;
	end

	select rowid, salesorderid, carriertrackingnumber from dwh.sproc_cache
	where hashed_params = hash;

	begin
		EXEC SYSADMIN.executeCli(script => '/subsystem=logging/logger=' || logger_name || ':remove') without return;
	exception e
	end
end;;



call master_class_2021_sproc_language.cached_sproc(1, 'foo1');;
call master_class_2021_sproc_language.cached_sproc(1, 'foo2');;
call master_class_2021_sproc_language.cached_sproc(2, 'foo1');;
call master_class_2021_sproc_language.cached_sproc(2, 'foo2');;

select * from dwh.sproc_cache;;


