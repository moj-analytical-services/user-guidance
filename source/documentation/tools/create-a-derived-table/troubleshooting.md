## Troubleshooting

This page is intended to help users self-diagnose errors and is an evolving resource! Please check here first and then, if necessary, ask in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9). If you discover new errors and/or solutions please post on slack or edit this document and raise a PR.

### General troubleshooting tips
- when you deploy `dev` models via the MoJ Analytical Platform logs are created locally in `mojap_derived_tables/logs/dbt.log`. This file details each step of the run and is useful for debugging.
- the logs for `dev` and `prod` models deployed via GitHub actions are stored temporariliy in the S3 bucket `mojap-derived-tables`, and are accessible under [standard_database_access](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/project_access/standard_database_access.yaml).
- `dbt clean` cleans out the local `logs` and `target` folders; it is good  practise to start a session with a clean slate.
- Under `mojap_derived_tables/target` there exist `compiled` and `run` folders containing a duplicate folder structure as under `mojap_derived_tables`. Here you can find your SQL code as compiled (with the Jinja rendered) and the DDL/DML run code. You can test each of these in Athena to check your SQL works as expected. 
- Testing your code in Athena will also highlight any read access permission issues.


### Can't find profiles.yml error
- Check you are in the `mojap_derived_tables` directory before running any `dbt` command. 

### Can't find dbt_project.yml error
- Check you are in the `mojap_derived_tables` directory before running any `dbt` command. 


### Source access - does not exist error
- For `create-a-derived-table` to be able to use an MoJ Analytical Platform database as a `source` it must be added to the [list of sources](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/sources). If a requied source is not listed contact [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) and ask for it to be added.

### Resource access - permission denied error
- The resource list in your project access config file in [data-engineeering-database-access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/project_access) must include both the source databases as referenced in the database access folder and any domains within `create-a-derived-table` that you wish to have read or write access to. For example
```
resources:
  - create_a_derived_table/domain_a
  - create_a_derived_table/domain_b
```
- 

### Problems with other models - does not exist error
- you are getting fail errors on dev deployment pointing to models other than those you are working on.
- this can be due to these models having been successfully deployed to prod and now the dev versions have expireed, however the dev tests all still run
- current fix is to redeploy to dev the models causing the problem
- run `dbt run test` locally to check *all* tests pass before creating a PR.

### Overwrite error in `dev` - HIVE_PATH_ALREADY_EXISTS
```
HIVE_PATH_ALREADY_EXISTS: Target directory for table ‘database_name_dev_dbt.table_name’ already exists: s3://mojap-derived-tables/dev/models/domain_name=domain_name/database_name=database_name_dev_dbt/table_name=table_name. 
```
- Normally when you redeploy a model the model is overwritten (unless you are using `incremental` strategy). However, sometimes, when developing code, things can get messy and you may need to manually delete the Glue database and tables from the Glue catalogue and the correspinding underlying data in the `mojap-derived-tables` S3 bucket. Note that admin permissions are required to perform the latter; please post in [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) 

### database 'mojap' does not exist
```
...
create schema if not exists database_name_dev_dbt
...
Athena adapter: Error running SQL: macro create_schema
...
create schema if not exists database_name_dev_dbt
...
Athena adapter: Error running SQL: macro create_schema
...
Runtime Error
  Runtime Error
    FAILED: SemanticException [Error 10072]: Database does not exist: mojap
```
This error appears to be an issue with `dbt-athena` failing to create the required database name, `mojap` is set as the default name (and does not exist) hence the error. Best guess this is a problem with phantom remains of failed attempts to create the schema blocking new attempts, or maybe a flakey connection between `dbt-athena` and Athena, or a timeout on the connection. When this issue first occured it seemed jinx a particular database name, the code worked fine under a different name! If anyone has any ideas on this issue please post in [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit this document.


Did not collect database names - dbt-athena
mojap database does not exist
Suggested limit - after 2 weeks of trying to repeat something

### May need to delete data at dbt-query-dump
```
You may need to manually clean the data at location ‘s3://dbt-query-dump/tables/...’ before retrying. Athena will not delete data in your account.
```
- Note *may*; this suggestion is usually unhelpful, and the location suggested may not exist.
- Check your local logs under `create-a-a-derived-table/mojap_derived_tables/logs/dbt.log` 
- However, it *may* help to delete your Glue database and tables from the Glue catalogue and the corresponding underlying data in the `mojap-derived-tables` S3 bucket. Note that admin permissions are required to perform the latter; please post in [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) 

### Partial parse save file not found
- Not an error; simply a statement that there is no pre-existing attempt to parse models and a full parse must be done.

### Is sqlfuff up to date?


### --no-verify flag in Analytical Platform when uploading >5MB CSVs

