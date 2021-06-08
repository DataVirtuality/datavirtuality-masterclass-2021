# datavirtuality-masterclass-2021
## Working with Metadata

This repository contains all material from the Data Virtuality Masterclass 2021, including the recording, code samples, snippets for everyday work, some links and more.

Please find the links to the recorded masterclass sessions here.

[Working with Metadata](https://vimeo.com/558984786/95cd10680a)

### The code

All of the code is self contained in the virtual schema `metadata`.

The examples are in the virtual schema `master_class_2021_sample_data`. The examples are **NOT** self contained. The examples depend on the data source `mssql_advworks_2019` that connects to a MS SQL Server 2019 instance.

### Installation

Load the file `metadata-export.sql` into Data Virtuality Studio and execute the file. This will create the virtual schema, views, and stored procedures.

If you want to set the child-parent relationships in the `tblDataLineage`, you will need to install the following stored procedures on the server where the `tblDataLineage` is located. These specific versions are for PostgreSQL.

* pgsql__reset_parent_child_relationships.sql
* pgsql__update_parent_child_relationships.sql

If you are using different a SQL server, you will have to translate them to your specific dialect.

If you translate them, please create a pull request and we will gladly add them to our repo.


### Installation of samples

Install `AdventureWorks2019` on a MS SQL Server.

You can download the database backup here [AdventureWorks2019.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak)

Create a data source to the `AdventureWorks2019`. Use `master_class_2021_sample_data-export.sql` as basis for your data source.

Load `master_class_2021_sample_data-export.sql` into Data Virtuality Studio and create sample virtual schema, views, and stored procedures.

### Notes on running the examples

Some examples require tables to be created and values inserted into the table. Please review the PowerPoint file and the video for detailed information.
