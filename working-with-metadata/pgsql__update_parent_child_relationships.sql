-- PROCEDURE: dwh_dv_2_4_5.update_parent_child_relationships()

-- DROP PROCEDURE dwh_dv_2_4_5.update_parent_child_relationships();

CREATE OR REPLACE PROCEDURE dwh_dv_2_4_5.update_parent_child_relationships(
	)
LANGUAGE 'plpgsql'
AS $BODY$
declare
rc integer;
curr_depth integer;
begin

curr_depth := 0;

loop
	update dwh_dv_2_4_5."tblDataLineage" as child
	set
		parent_id = parent.id
		,depth = curr_depth + 1
	from
		dwh_dv_2_4_5."tblDataLineage" parent
	where
		parent.hashkey_data_lineage_schema_table = child.hashkey_data_lineage_schema_table and
		parent.hashkey_target_schema_table_column = child.hashkey_source_schema_table_column and
		parent.depth = curr_depth and
		child.depth = -1
	;

	get diagnostics rc = row_count;
	raise info 'updated: % rows', rc;
	exit when 0 = rc;
	curr_depth := curr_depth +1;
end loop;

end
$BODY$;
