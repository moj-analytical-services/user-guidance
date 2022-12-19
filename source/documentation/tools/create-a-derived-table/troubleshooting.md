## Troubleshooting

This page is intended to help users self-diagnose errors and is an evolving resource! Please check here first and then, if necessary, ask in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9). If you discover new errors and/or solutions please post on slack or edit this document and raise a PR.

### General troubleshooting tips
- when you deploy dev models logs are created locally under `mojap_derived_tables/logs` these usually contain more helpful error messages.
- `dbt clean` cleans out the local `logs` and `target` folders; it is good  practise to start a session with a clean slate.
- Under `mojap_derived_tables/target` there exist `compiled` and `run` folders containing a duplicate folder structure as from `mojap_derived_tables`. Here you can find you SQL code as compiled (with the Jinja rendered) and the DDL code. You can test each of these in Athena to check your SQL works as expected. Athena will also tell you if there are any read access permission issues.

### Can't find profiles.yml error
- Check you are in the `mojap_derived_tables` directory before running any `dbt` command. 

### Can't find dbt_project.yml error
- Check you are in the `mojap_derived_tables` directory before running any `dbt` command. 


### Permission denied error
- The resource list in your project access config file in data-engineeering-database-access must include both the source databases as referenced in the database access folder and any domains within create-a-derived-table that you wish to have read or write access to.

### Problems with other models
- you are getting fail errors on dev deployment pointing to models other than those you are working on.
- this can be due to these models having been successfully deployed to prod and now the dev versions have expireed, however the dev tests  all still run
- current fix is to redeploy to dev the models causing the problem
- run `dbt run test` locally to check all tests pass before creating a PR.

### May need to delete data error
- this suggestion is usually unhelpful, and the location suggested may not even exist

### Partial parse save file not found
- Not an error; simply a statement that there is no pre-existing attempt to parse models and a full parse must be done.

### Is sqlfuff up to date?


### --no-verify flag in Analytical Platform when uploading >5MB CSVs

