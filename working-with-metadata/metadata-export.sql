/* Data Virtuality exported objects */
/* Created: 22.07.21  23:17:50.014 */
/* Server version: 2.4.9 */
/* Build: 506e8e1 */
/* Build date: 2021-07-08 */
/* Exported by Studio ver.2.4.9 (rev.32b0c52). Build date is 2021-07-08. */
/* Please set statement separator to ;; before importing */




/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'metadata') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineage" as
SELECT * FROM "dwh.tblDataLineage"') ;;

EXEC SYSADMIN.importView("text" => 'create view "metadata"."ResourceDependencies" as
SELECT * FROM "dwh.tblResourceDependencies"') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawIndexes" as
SELECT
     k.VDBName as table_catalog
    ,k.SchemaName as table_schema
    ,k.TableName as table_name
    ,k.Name as index_name
    ,kc.Name as column_name
    ,kc.Position as ordinal_position
    ,k.Description as index_description
    ,k.NameInSource as name_in_source
    ,k.Type as index_type
    ,k.IsIndexed as is_indexed
    ,k.RefKeyUID as foreign_key_uid
    ,k.UID as index_uid
    ,kc.TableUID
FROM
    SYS.KeyColumns kc
	join SYS.Keys k
		on kc.UID = k.UID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawPermissions" as
SELECT
     U.id as user_id
    ,U.name as user_name
    ,U.roles as user_has_roles
    ,U.creationDate as user_creation_date
    ,U.lastModifiedDate as user_last_modified_date
    ,U.creator as user_creator
    ,U.modifier as user_modifier
    ,R.id as role_id
    ,R.name as role_name
    ,R.allowCreateTempTables as role_allow_create_temp_tables
    ,R.users as role_has_users
    ,R.creationDate as role_creation_date
    ,R.lastModifiedDate as role_last_modified_date
    ,R.creator as role_creator
    ,R.modifier as role_modifier
    ,UR.id as user_role_id
    --,UR.userName as user_role_name
    --,UR.roleName as user_role_name
    ,UR.creationDate as user_role_creation_date
    ,UR.lastModifiedDate as user_role_last_modified_date
    ,UR.creator as user_role_creator
    ,UR.modifier as user_role_modifier
    ,P.id as permission_id
    --,P.role as permission_role
    ,P.resource as permission_resource
    ,P.permission
    ,P.condition as permission_condition
    ,P.isConstraint as permission_is_constraint
    ,P.mask as permission_mask
    ,P.maskOrder as permission_mask_order
    ,P.creationDate as permission_creation_date
    ,P.lastModifiedDate as permission_last_modified_date
    ,P.creator as permission_creator
    ,P.modifier as permission_modifier
    ,case when P.permission like ''%C%'' then true else false end as permission_create
    ,case when P.permission like ''%R%'' then true else false end as permission_read
    ,case when P.permission like ''%U%'' then true else false end as permission_update
    ,case when P.permission like ''%D%'' then true else false end as permission_delete
    ,case when P.permission like ''%E%'' then true else false end as permission_execute
    ,case when P.permission like ''%A%'' then true else false end as permission_alter
    ,case when P.permission like ''%L%'' then true else false end as permission_language
FROM
    SYSADMIN.Users U 
    JOIN SYSADMIN.UserRoles UR
    	ON UR.userName = U.name 
    JOIN SYSADMIN.Roles R
    	ON R.name = UR.roleName 
    JOIN SYSADMIN.Permissions P
    	ON P.role = UR.roleName') ;;

EXEC SYSADMIN.importView("text" => 'create view "metadata"."_RawResourceDependencies"
as
select * from (call "SYSADMIN.getResourceDependencies"("resourceName" => ''*'')) as a') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view metadata."_RawViewDefinitions" as
SELECT
     vd.id
    ,vd.name as SchemaDotName
    ,vd.definition
    ,vd.creationDate
    ,vd.lastModifiedDate
    ,vd.state
    ,vd.failureReason
    ,vd.inSyncWithSource
    ,vd.notInSyncReason
    ,vd.creator
    ,vd.modifier
    ,t.VDBName
    ,t.SchemaName
    ,t.Name
    ,t.Type
    ,t.NameInSource
    ,t.IsPhysical
    ,t.SupportsUpdates
    ,t.UID
    ,t.Cardinality
    ,t.Description
    ,t.IsSystem
    ,t.IsMaterialized
    ,t.SchemaUID
FROM
    SYS.Tables t
    join SYSADMIN.ViewDefinitions vd
    	on (t.SchemaName || ''.'' || t.Name) = vd.name
where
	t.Type = ''View''') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawColumns" as
SELECT
     icol.table_catalog
    ,icol.table_schema
    ,icol.table_name
    ,icol.column_name
    ,icol.ordinal_position
    ,icol.column_default
    ,icol.is_nullable
    ,icol.udt_name
    ,icol.character_maximum_length
    ,icol.character_octet_length
    ,icol.numeric_precision
    ,icol.numeric_precision_radix
    ,icol.numeric_scale
    ,icol.datetime_precision
    ,icol.character_set_catalog
    ,icol.character_set_schema
    ,icol.character_set_name
    ,icol.collation_catalog
    ,icol.is_updatable
	,scol.NameInSource
	,scol.IsLengthFixed
	,scol.SupportsSelect
	,scol.SupportsUpdates
	,scol.IsCaseSensitive
	,scol.IsSigned
	,scol.IsCurrency
	,scol.IsAutoIncremented
	,scol.SearchType
	,scol.Format
	,scol.DefaultValue
	,scol.Precision
	,scol.CharOctetLength
	,scol.Radix
	,scol.UID
	,scol.Description
	,t.SchemaUID
	,scol.TableUID
	,scol.ColumnSize
	,cast(to_chars(SHA2_512(lower(table_schema || ''].['' || table_name)),''HEX'') as string) as hashkey_schema_table
	,cast(to_chars(SHA2_512(lower(table_schema || ''].['' || table_name || ''].['' || column_name)),''HEX'') as string) as hashkey_schema_table_column	
FROM
    INFORMATION_SCHEMA.columns icol 
	join SYS.Columns scol
		on lower(icol.table_catalog) = lower(scol.VDBName) and
			lower(icol.table_schema) = lower(scol.SchemaName) and
			lower(icol.table_name) = lower(scol.TableName) and
			lower(icol.column_name) = lower(scol.Name)
	join SYS.Tables t
		on t.UID = scol.TableUID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view metadata."_RawProcedureDefinitions" as
SELECT
     p.VDBName
    ,p.SchemaName
    ,p.Name
    ,p.NameInSource
    ,p.ReturnsResults
    ,p.UID
    ,p.Description
    ,p.SchemaUID
    ,pd.id
    ,pd.name as SchemaDotName
    ,pd.definition
    ,pd.creationDate
    ,pd.lastModifiedDate
    ,pd.state
    ,pd.failureReason
    ,pd.creator
    ,pd.modifier
FROM
    SYSADMIN.ProcDefinitions pd
    join SYS.Procedures p
		on (p.SchemaName || ''.'' || p.Name) = pd.name') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure "metadata"."getDependencies"(resourceName string)
returns(
	dependentResourceName string, 
	dependentResourceType string, 
	parentResourceName string, 
	parentResourceType string
) as
begin

WITH cte AS 
(
	select distinct d.dependentResourceName, d.dependentResourceType, d.parentResourceName, d.parentResourceType
	from 
		dwh.tblResourceDependencies d
	where lower(d.dependentResourceName) like (''%'' || lower(resourceName) || ''%'')
	union
	select distinct d.dependentResourceName, d.dependentResourceType, d.parentResourceName, d.parentResourceType
	from 
		dwh.tblResourceDependencies d
		join cte c
			on c.parentResourceName = d.dependentResourceName
)
select dependentResourceName, dependentResourceType, parentResourceName, parentResourceType
from cte
order by dependentResourceName, dependentResourceType, parentResourceName, parentResourceType;

end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure metadata."_InitDataLineage"() as
begin
	declare string sqlcode;	

	delete from dwh.tblDataLineage;

    loop on (
    	select * from INFORMATION_SCHEMA.tables 
    	where table_schema in (''master_class_2021_sample_data'',''dwh'') -- include these schemas
    	and not(table_schema = ''dwh'' and table_name like ''mat_table_%'') -- exclude materialized tables
    ) as cur
    begin
        sqlcode = ''select * from "'' || cur.table_schema || ''.'' || cur.table_name || ''";'';
        
        insert into dwh.tblDataLineage (
            data_lineage_table_schema
            ,data_lineage_table_name
            ,data_lineage_table_type
            ,depth
            ,source_table_Schema
            ,source_table_name
            ,source_column_name
            ,target_table_schema
            ,target_table_name
            ,target_column_name
            ,hashkey_data_lineage_schema_table
            ,hashkey_source_schema_table
            ,hashkey_source_schema_table_column
            ,hashkey_target_schema_table
            ,hashkey_target_schema_table_column
            ,default_order
            ,id
            ,parent_id
        ) 
        select
            cur.table_schema as data_lineage_table_schema
            ,cur.table_name as data_lineage_table_name
            ,cur.table_type as data_lineage_table_type
            ,case
            	when lower(cur.table_schema || ''.'' || cur.table_name) = lower(dl.sourceColumnSchema || ''.'' || dl.sourceColumnTable) then 0
            	else -1
            end as depth
            ,dl.sourceColumnSchema as source_table_Schema
            ,dl.sourceColumnTable as source_table_name
            ,dl.sourceColumnName as source_column_name
            ,dl.targetColumnSchema as target_table_schema
            ,dl.targetColumnTable as target_table_name
            ,dl.targetColumnName as target_column_name
            ,cast(to_chars(SHA2_512(lower(cur.table_schema || ''.'' || cur.table_name)),''HEX'') as string) as hashkey_data_lineage_schema_table
            ,cast(to_chars(SHA2_512(lower(dl.sourceColumnSchema || ''.'' || dl.sourceColumnTable)),''HEX'') as string) as hashkey_source_schema_table
            ,cast(to_chars(SHA2_512(lower(dl.sourceColumnSchema || ''.'' || dl.sourceColumnTable || ''.'' || dl.sourceColumnName)),''HEX'') as string) as hashkey_source_schema_table_column
            ,cast(to_chars(SHA2_512 (lower(dl.targetColumnSchema || ''.'' || dl.targetColumnTable)),''HEX'') as string) as hashkey_target_schema_table
            ,cast(to_chars(SHA2_512 (lower(dl.targetColumnSchema || ''.'' || dl.targetColumnTable || ''.'' || dl.targetColumnName)),''HEX'') as string) as hashkey_target_schema_table_column
            ,row_number() over(order by 1) as default_order
            ,uuid() as id
            ,null as parent_id
        from
            (call SYSADMIN.getDataLineageWithRelationsOnly("sql" => sqlcode)) dl;
            
	end
	
	-- Use this when troubleshooting the sproc "update_parent_child_relationships"
	--call "dwh.native"("request" => ''CALL dwh_dv_2_4_9.reset_parent_child_relationships();'');
	
	-- Connect the child (id) and parent rows (parent_id)
	call "dwh.native"("request" => ''CALL dwh_dv_2_4_9.update_parent_child_relationships();'');
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'create procedure metadata.searchMetadata_standalone(searchTerm string) 
returns(
	SchemaName string, 
	TableName string, 
	ColumnName string, 
	ProcedureName string, 
	Type string,
	Description string,
	SchemaUID string,
	TableUID string,
	ColumnUID string,
	ProcedureUID string,
	JobUID string
) as
begin
declare string srchTerm = lower(''%'' || searchTerm || ''%'');

SELECT distinct Name as SchemaName, null as TableName, null as ColumnName, null as ProcedureName,
	''Schema'' as Type, Description, UID as SchemaUID, null as TableUID, null as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM SYS.Schemas
where 
	lower(Name) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, t.Name as TableName, null as ColumnName, null as ProcedureName,
	Type, Description, SchemaUID, UID as TableUID, null as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM
    SYS.Tables t
    join SYSADMIN.ViewDefinitions vd
    	on (t.SchemaName || ''.'' || t.Name) = vd.name
where 
	lower(t.Name) like srchTerm or 
	lower(definition) like srchTerm or
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, Name as TableName, null as ColumnName, null as ProcedureName,
	Type, Description, SchemaUID, UID as TableUID, null as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM SYS.Tables
where
	Type = ''Table'' and (
		lower(Name) like srchTerm or 
		lower(Description) like srchTerm
	)

union

SELECT distinct icol.table_schema as SchemaName, icol.table_name as TableName, icol.column_name as ColumnName, null as ProcedureName,
	''Column'' as Type, scol.Description, t.SchemaUID, scol.TableUID, scol.UID as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM 
    INFORMATION_SCHEMA.columns icol 
	join SYS.Columns scol
		on lower(icol.table_catalog) = lower(scol.VDBName) and
			lower(icol.table_schema) = lower(scol.SchemaName) and
			lower(icol.table_name) = lower(scol.TableName) and
			lower(icol.column_name) = lower(scol.Name)
	join SYS.Tables t
		on t.UID = scol.TableUID	
where
	lower(icol.column_name) like srchTerm or 
	lower(scol.Description) like srchTerm

union

SELECT distinct SchemaName, null as TableName, null as ColumnName, p.Name as ProcedureName,
	''Procedure'' as Type, Description, SchemaUID, null as TableUID, null as ColumnUID, UID as ProcedureUID,
	null as JobUID
FROM
    SYSADMIN.ProcDefinitions pd
    join SYS.Procedures p
		on (p.SchemaName || ''.'' || p.Name) = pd.name
where
	lower(p.name) like srchTerm or 
	lower(Definition) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct null as SchemaName, null as TableName, null as ColumnName, null as ProcedureName,
	''Job'' as Type, Description, null as SchemaUID, null as TableUID, null as ColumnUID, null as ProcedureUID,
	jobName as JobUID
FROM SYSADMIN.ScheduleJobs
where
	lower(jobType) like srchTerm or 
	lower(description) like srchTerm or 
	lower(script) like srchTerm or 
	lower(newRowCheckExpression) like srchTerm or 
	lower(identityExpression) like srchTerm or 
	lower(lastExecutionStatus) like srchTerm or 
	lower(lastExecutionFailureReason) like srchTerm
--	lower(lastWarnings) like srchTerm
;

end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure metadata."_Init"() as
begin
	declare string sqlcode;	

--	call "dwh.native"("request" => ''drop table if exists dwh.tblDataLineage;'');
	sqlcode = ''drop table if exists dwh.tblDataLineage;'';
	execute immediate (sqlcode);

	
--	declare boolean tblExists;
--	tblExists = (call UTILS.tableExists("tableName" => ''dwh.tblDataLineage''));
	--if (not tblExists)
	--begin
		sqlcode = ''
		create table dwh.tblDataLineage (
		    data_lineage_table_schema string
		    ,data_lineage_table_name string
		    ,data_lineage_table_type string
		    ,depth integer
		    ,source_table_Schema string
		    ,source_table_name string
		    ,source_column_name string
		    ,target_table_schema string
		    ,target_table_name string
		    ,target_column_name string
		    ,hashkey_data_lineage_schema_table string
		    ,hashkey_source_schema_table string
		    ,hashkey_source_schema_table_column string
		    ,hashkey_target_schema_table string
		    ,hashkey_target_schema_table_column string
		    ,default_order integer
		    ,id string
		    ,parent_id string
		);;'';
		execute immediate (sqlcode);
	--end
	
	sqlcode = ''drop table if exists dwh.tblResourceDependencies;'';
	execute immediate (sqlcode);
	
--	tblExists = (call UTILS.tableExists("tableName" => ''dwh.tblResourceDependencies''));
--	if (not tblExists)
--	begin
		sqlcode = ''
		create table dwh.tblResourceDependencies(
			dependentResourceName string not null,
			dependentResourceType string not null, 
			parentResourceName string not null,
			parentResourceType string not null,
			permissionRoleName string not null,
			permissionText string not null,
			parentPath string not null,
			path string not null,
			depth integer not null
		);'';
		execute immediate (sqlcode);
--	end
end') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawForeignKeys" as
/*
importedKeyCascade 	0
importedKeyRestrict 	1
importedKeySetNull 	2	
importedKeyNoAction 	3
importedKeySetDefault 	4
importedKeyInitiallyDeferred 	5
importedKeyInitiallyImmediate 	6
importedKeyNotDeferrable 	7
*/
SELECT
	 rkc.PKTABLE_CAT as pk_table_catalog
	,rkc.PKTABLE_SCHEM as pk_table_schema
	,rkc.PKTABLE_NAME as pk_table_name
	,rkc.PKCOLUMN_NAME as pk_column_name
	,rkc.PK_NAME as pk_index_name
	,pk.index_uid
	,pk.TableUID as pk_TableUID
		
	,rkc.FKTABLE_CAT as fk_table_catalog
	,rkc.FKTABLE_SCHEM as fk_table_schema
	,rkc.FKTABLE_NAME as fk_table_name
	,rkc.FKCOLUMN_NAME as fk_column_name
	,rkc.FK_NAME as fk_index_name
	,fk.index_uid as foreign_key_uid
	,fk.TableUID as fk_TableUID
	,rkc.KEY_SEQ as key_sequence
	
	,rkc.UPDATE_RULE as index_update_rule_key
	,coalesce(ur.key_name, ''undefined'') as index_update_rule_name
	,coalesce(ur.description, ''undefined'') as index_update_rule_description
	
	,rkc.DELETE_RULE as index_delete_rule_key
	,coalesce(dr.key_name, ''undefined'') as index_delete_rule_name
	,coalesce(dr.description, ''undefined'') as index_delete_rule_description
	
	,rkc.DEFERRABILITY as index_deferrability_key
	,coalesce(def.key_name, ''undefined'') as index_deferrability_name
	,coalesce(def.description, ''undefined'') as index_deferrability_description
FROM
	SYS.ReferenceKeyColumns rkc

	left join "metadata"."_RawIndexes" pk
		on lower(rkc.PKTABLE_CAT) = lower(pk.table_catalog) and
			lower(rkc.PKTABLE_SCHEM) = lower(pk.table_schema) and
			lower(rkc.PKTABLE_NAME) = lower(pk.table_name) and
			lower(rkc.PKCOLUMN_NAME) = lower(pk.column_name) and
			lower(rkc.PK_NAME) = lower(pk.index_name)

	left join "metadata"."_RawIndexes" fk
		on lower(rkc.FKTABLE_CAT) = lower(fk.table_catalog) and
			lower(rkc.FKTABLE_SCHEM) = lower(fk.table_schema) and
			lower(rkc.FKTABLE_NAME) = lower(fk.table_name) and
			lower(rkc.FKCOLUMN_NAME) = lower(fk.column_name) and
			lower(rkc.FK_NAME) = lower(fk.index_name)
	
	left join (
		-- From: http://man.hubwiz.com/docset/Mono.docset/Contents/Resources/Documents/api.xamarin.com/monodoc319d-6.html
		-- UPDATE_RULE - short - a value giving the rule for how to treat the foreign key when the corresponding primary key is updated:
		select ''importedKeyNoAction''   as key_name, 3 as key, ''don''''t allow the primary key to be updated if it is imported as a foreign key'' as description union all
		select ''importedKeyCascade''    as key_name, 0 as key, ''change the imported key to match the primary key update'' as description union all
		select ''importedKeySetNull''    as key_name, 2 as key, ''set the imported key to null'' as description union all
		select ''importedKeySetDefault'' as key_name, 4 as key, ''set the imported key to its default value'' as description union all
		select ''importedKeyRestrict''   as key_name, 1 as key, ''same as importedKeyNoAction: don''''t allow the primary key to be updated if it is imported as a foreign key'' as description
	) ur
		on rkc.UPDATE_RULE = ur.key

	left join (
		-- From: http://man.hubwiz.com/docset/Mono.docset/Contents/Resources/Documents/api.xamarin.com/monodoc319d-6.html
		-- DELETE_RULE - short - how to treat the foreign key when the corresponding primary key is deleted:
		select ''importedKeyNoAction''   as key_name, 3 as key, ''don''''t allow the primary key to be updated if it is imported as a foreign key'' as description union all
		select ''importedKeyCascade''    as key_name, 0 as key, ''change the imported key to match the primary key update'' as description union all
		select ''importedKeySetNull''    as key_name, 2 as key, ''set the imported key to null'' as description union all
		select ''importedKeySetDefault'' as key_name, 4 as key, ''set the imported key to its default value'' as description union all
		select ''importedKeyRestrict''   as key_name, 1 as key, ''same as importedKeyNoAction: don''''t allow the primary key to be updated if it is imported as a foreign key'' as description
	) dr
		on rkc.DELETE_RULE = dr.key

	left join (
		-- From: http://man.hubwiz.com/docset/Mono.docset/Contents/Resources/Documents/api.xamarin.com/monodoc319d-6.html
		-- DEFERRABILITY - short - defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions): 
		select ''importedKeyInitiallyDeferred''  as key_name, 5 as key, ''defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions)'' as description union all
		select ''importedKeyInitiallyImmediate'' as key_name, 6 as key, ''defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions)'' as description union all
		select ''importedKeyNotDeferrable''      as key_name, 7 as key, ''defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions)'' as description
	) def
		on rkc.DEFERRABILITY = def.key') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineageTargetProperties" as
select 
	* 
from 
	dwh.tblDataLineage dl
	left join metadata."_RawColumns" cp
		on dl.hashkey_target_schema_table_column = cp.hashkey_schema_table_column') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineageWithColumnTypesSizes" as

SELECT
	 dl.data_lineage_table_schema
	,dl.data_lineage_table_name
	,dl.data_lineage_table_type
	,dl.depth
	,dl.source_table_schema
	,dl.source_table_name
	,dl.source_column_name
    ,src.is_nullable as source_column_name_is_nullable
    ,src.udt_name as source_column_name_udt_name
    ,src.character_maximum_length as source_column_name_character_maximum_length
	,dl.target_table_schema
	,dl.target_table_name
	,dl.target_column_name
    ,tgt.is_nullable as source_column_name_is_nullable
    ,tgt.udt_name as source_column_name_udt_name
    ,tgt.character_maximum_length as source_column_name_character_maximum_length
	,dl.default_order
	,dl.id
	,dl.parent_id
FROM
	dwh.tblDataLineage dl
    left join metadata."_RawColumns" src
		on dl.hashkey_source_schema_table_column = src.hashkey_schema_table_column
    left join metadata."_RawColumns" tgt
		on dl.hashkey_target_schema_table_column = tgt.hashkey_schema_table_column') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineageSourceProperties" as
select 
	* 
from 
	dwh.tblDataLineage dl
	left join metadata."_RawColumns" cp
		on dl.hashkey_source_schema_table_column = cp.hashkey_schema_table_column') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure metadata.searchMetadata(searchTerm string) 
returns(
	SchemaName string, 
	TableName string, 
	ColumnName string, 
	ProcedureName string, 
	Type string,
	Description string,
	SchemaUID string,
	TableUID string,
	ColumnUID string,
	ProcedureUID string,
	JobUID string
) as
begin
declare string srchTerm = lower(''%'' || searchTerm || ''%'');

SELECT distinct Name as SchemaName, null as TableName, null as ColumnName, null as ProcedureName,
	''Schema'' as Type, Description, UID as SchemaUID, null as TableUID, null as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM SYS.Schemas
where 
	lower(Name) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, Name as TableName, null as ColumnName, null as ProcedureName,
	Type, Description, SchemaUID, UID as TableUID, null as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM metadata."_RawViewDefinitions"
where 
	lower(Name) like srchTerm or 
	lower(definition) like srchTerm or
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, Name as TableName, null as ColumnName, null as ProcedureName,
	Type, Description, SchemaUID, UID as TableUID, null as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM SYS.Tables
where
	Type = ''Table'' and (
		lower(Name) like srchTerm or 
		lower(Description) like srchTerm
	)

union

SELECT distinct table_schema as SchemaName, table_name as TableName, column_name as ColumnName, null as ProcedureName,
	''Column'' as Type, Description, SchemaUID, TableUID, UID as ColumnUID, null as ProcedureUID,
	null as JobUID
FROM metadata."_RawColumns"
where
	lower(column_name) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, null as TableName, null as ColumnName, Name as ProcedureName,
	''Procedure'' as Type, Description, SchemaUID, null as TableUID, null as ColumnUID, UID as ProcedureUID,
	null as JobUID
FROM metadata."_RawProcedureDefinitions"
where
	lower(name) like srchTerm or 
	lower(Definition) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct null as SchemaName, null as TableName, null as ColumnName, null as ProcedureName,
	''Job'' as Type, Description, null as SchemaUID, null as TableUID, null as ColumnUID, null as ProcedureUID,
	jobName as JobUID
FROM SYSADMIN.ScheduleJobs
where
	lower(jobType) like srchTerm or 
	lower(description) like srchTerm or 
	lower(script) like srchTerm or 
	lower(newRowCheckExpression) like srchTerm or 
	lower(identityExpression) like srchTerm or 
	lower(lastExecutionStatus) like srchTerm or 
	lower(lastExecutionFailureReason) like srchTerm or 
	lower(lastWarnings) like srchTerm
;

end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure metadata."_InitResourceDependencies"() as
begin
	
	declare string sqlcode;
		
	delete from dwh.tblResourceDependencies;

	insert into dwh.tblResourceDependencies(
		dependentResourceName,
		dependentResourceType, 
		parentResourceName, 
		parentResourceType, 
		permissionRoleName, 
		permissionText,
		parentPath,
		path,
		depth
	)
	select
		''/'' as dependentResourceName,
		''ROOT'' as dependentResourceType, 
		'''' as parentResourceName, 
		'''' as parentResourceType, 
		'''' as permissionRoleName, 
		'''' as permissionText,
		'''' as parentPath,
		''/'' as path,
		0 as depth
	;
	
	
	insert into dwh.tblResourceDependencies(
		dependentResourceName,
		dependentResourceType, 
		parentResourceName, 
		parentResourceType, 
		permissionRoleName, 
		permissionText,
		parentPath,
		path,
		depth
	)
	select distinct
		d.parentResourceName as dependentResourceName,
		d.parentResourceType as dependentResourceType, 
		''<ROOT>'' as parentResourceName, 
		''ROOT'' as parentResourceType, 
		'''' as permissionRoleName, 
		'''' as permissionText,
		''/'' as parentPath,
		''/'' || d.parentResourceName || ''/'' as path,
		1 as depth
	from
		metadata."_RawResourceDependencies" d
	where
		parentResourceType = ''SCHEMA''
	;
	
	
	declare integer curr_depth = 1;
	declare integer inserted_rows = 1;	
	
	while (inserted_rows > 0)
	begin
		insert into dwh.tblResourceDependencies(
			dependentResourceName,
			dependentResourceType, 
			parentResourceName, 
			parentResourceType, 
			permissionRoleName, 
			permissionText,
			parentPath,
			path,
			depth
		)
		select distinct
			a.dependentResourceName,
			a.dependentResourceType, 
			a.parentResourceName, 
			a.parentResourceType, 
			a.permissionRoleName, 
			a.permissionText,
			d.path as parentPath,
			d.path || a.dependentResourceName || ''/'' as path,
			curr_depth +1 as depth
		from
			dwh.tblResourceDependencies d
			join metadata."_RawResourceDependencies" a
				on d.dependentResourceName = a.parentResourceName
					and d.dependentResourceType = a.parentResourceType
		where
			d.depth = curr_depth
		;
		
		curr_depth = curr_depth + 1;
		inserted_rows = VARIABLES.ROWCOUNT;
	end


end') ;;








