# Deploying your tables
## Dev
It's possible to run dbt locally or by creating a pull request with your changes in it. Regardless of which you choose, there are some important things to note. When you deploy locally or with a pull request, your databases will be suffixed with `_dev_dbt`. They are stored at the following S3 path:
```
s3://mojap-derived-tables/dev/models/domain_name=domain/database_name=database_dev_dbt/table_name=table/data_file
```
The data in S3 and the Glue catalog entry for dev databases and tables is deleted approximately every ten days. If you come back after a break and find your tables are missing, just rerun dbt.

If you've set up a local working environment in JupyterLab or R Studio, you can deploy your models yourself. The commands you'll use most are `dbt compile`, `dbt run`, `dbt test`, `dbt seed`. We recommend you run only your directory of models, as this will speed up deployment. You can do this using the `--select` flag. See the dbt [syntax overview](https://docs.getdbt.com/reference/node-selection/syntax) guidance for more information.
When dbt runs, it creates a directory called `target` (it's created as a hidden folder, so make sure you have the 'show hidden folders' option selected in your explorer). This is where it stores the compiled SQL that is executed along with other runtime outputs.

When you're ready you can push your changes to your remote branch and create a pull request. A number of automations will run, including linting checks and a complete deployment of the dbt project into the dev environment. You can access the run artefacts of that deployment – the `target` and `logs` directories – at the path `s3://mojap-derived-tables/run_artefacts/run_time=dd-mm-yyy hh:mm:ss/`. The run time will be printed to the GitHub Actions console.

## Prod
When your changes are approved and merged into `main` a separate workflow will run and deploy your tables as per the specified schedule.

# Resources
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices