alter PROCEDURE master_class_2021_sproc_language.anonymize(plain_text STRING NOT NULL, out atxt string, out text_len integer) 
RETURNS (anonymized STRING NOT NULL) AS
BEGIN
    atxt = LEFT(plain_text, 1) || '***' || RIGHT(plain_text, 1);
    text_len = length(atxt);
    select atxt;
END;;


begin
	declare string txt = 'long test string';
	declare string atxt;
	declare string result;
	declare integer len;

	call master_class_2021_sproc_language.anonymize("plain_text" => txt, "atxt" => atxt, "text_len" => len) without return;
	
	select txt, result, atxt, len;
end;;


begin
	declare string txt = 'long test string';
	declare string atxt;
	declare string result;
	declare integer len;

	result = (call master_class_2021_sproc_language.anonymize("plain_text" => txt, "atxt" => atxt, "text_len" => len));
	
	select txt, result, atxt, len;
end;;


begin
	declare string txt = 'long test string';
	declare string atxt;
	declare string result;
	declare integer len;

	select * from (call master_class_2021_sproc_language.anonymize("plain_text" => txt, "atxt" => atxt, "text_len" => len)) x;	
end;;



begin
	declare string txt = 'long test string';
	declare string atxt;
	declare string result;
	declare integer len;

	select * into #tmp from (call master_class_2021_sproc_language.anonymize("plain_text" => txt, "atxt" => atxt, "text_len" => len)) x;	
	
	select anonymized from #tmp;
end;;






