## Troubleshooting

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

## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select {path_to_file(s)}`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select {path_to_seeds}` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.

Is sqlfuff up to date?

--no-verify flag in Analytical Platform when uploading >5MB CSVs

