-- PROCEDURE: dwh_dv_2_4_5.reset_parent_child_relationships()

-- DROP PROCEDURE dwh_dv_2_4_5.reset_parent_child_relationships();

CREATE OR REPLACE PROCEDURE dwh_dv_2_4_5.reset_parent_child_relationships(
	)
LANGUAGE 'plpgsql'
AS $BODY$
declare
rc integer;
begin

update dwh_dv_2_4_5."tblDataLineage" as child
set
	parent_id = null
	,depth = -1
;

get diagnostics rc = row_count;
raise info 'updated: % rows', rc;

update dwh_dv_2_4_5."tblDataLineage" as child
set
	parent_id = id
	,depth = 0
where
	hashkey_data_lineage_schema_table = hashkey_source_schema_table
;

get diagnostics rc = row_count;
raise info 'updated: % rows', rc;

end
$BODY$;
