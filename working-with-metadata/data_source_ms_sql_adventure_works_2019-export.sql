/* Data Virtuality exported objects */
/* Created: 08.06.21  14:19:53.234 */
/* Server version: 2.4.6 */
/* Build: ce8ff20 */
/* Build date: 2021-05-28 */
/* Exported by Studio ver.2.4.6 (rev.cb1b700). Build date is 2021-05-28. */
/* Please set statement separator to ;; before importing */




/* Exported connections and data sources */
EXEC SYSADMIN.importConnection("name" => 'mssql_advworks_2019', "jbossCLITemplateName" => 'mssql', "connectionOrResourceAdapterProperties" => 'user-name=sa,port=1433,host=alienck,db=AdventureWorks2019', "encryptedProperties" => 'password=secret') ;;
EXEC SYSADMIN.importDataSource("name" => 'mssql_advworks_2019', "translator" => 'sqlserver', "modelProperties" => 'importer.useCatalogName=true,importer.excludeTables=(.*[.]sys[.].*|.*[.]INFORMATION_SCHEMA[.].*),importer.useFullSchemaName=true,importer.defaultSchema=dbo', "translatorProperties" => '', "encryptedModelProperties" => '', "encryptedTranslatorProperties" => '') ;;








