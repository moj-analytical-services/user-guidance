# Deploying to Dev

## Important Note - Before you deploy

As detailed in the section on [models](/tools/create-a-derived-table/models), you will need to add the standardised **config block** to your model before attempting to deploy. The block is as follows:

```
{{ config(
    external_location=generate_s3_location()
) }}
```

If you do not include this block, your models will attempt to write to an invalid path in S3, and thusly will fail to deploy. You can include other config values in the block if doing so is useful for your model, but all models **must** include the `external_location=generate_s3_location()` statement to deploy succesfully.

You can run any dbt command in the terminal in RStudio (JupyterLab coming soon) to deploy models and seeds, or to run tests. When you deploy models and seeds from RStudio the database they are built in to will be suffixed with `_dev_dbt` and the underlying data that gets generated will be written to the following S3 path:

```
s3://mojap-derived-tables/dev/models/domain_name=domain/database_name=database_dev_dbt/table_name=table/data_file
```

The data in S3 and the Glue catalog entry for dev databases and tables is deleted approximately every 10 days. If you come back after a break and find your tables are missing, just rerun dbt.

When you're ready, raise a pull request to merge your changes into the `main` branch. When you do this a number of workflows will run including, deploying your changes to _dev_, and SQL and YAML linting checks. Run artefacts for the dev deployment are exported to S3 and are available for 3 days. To get the S3 path that your run artefacts have been exported to, check the `Export run artefacts to S3` output of the `Deploy dbt dev` workflow. The path will look something like:

```
s3://mojap-derived-tables/dev/run_artefacts/run_time=2000-01-01T00:00:00/
```

## Helpful commands

As previously mentioned, the `mojap_derived_tables` dbt project is a shared space and so when deploying your models and other resources you'll want to make use of the [_node selection syntax_](https://docs.getdbt.com/reference/node-selection/syntax) so you don't end up running everyone else's. Don't worry if you do, it will just take a long time to run and then the deployed resources will eventually be deleted. You should cancel the execution with `ctrl+c` or `ctrl+z` and save yourself some time.

To select a single model or seed, add the following to your dbt command:

```
--select database_name__model_name
```

or a number of models by running:

```
--select database_name__model_1_name database_name__model_2_name
```

To select a full directory of models, add the following to your dbt command:

```
--select models/.../path/to/my/models/
```

As you develop and run your models you'll generate a lot of logs and run artefacts. This can become unwieldy and messy so it's helpful to clear them out from time to time. To remove run artefacts from previous invocations of dbt, run:

```
dbt clean
```

To check your SQL and YAML is syntactically correct, run:

```
dbt compile --select models/.../path/to/my/models/
```

To deploy your models, run:

```
dbt run --select models/.../path/to/my/models/
```

To deploy your seeds, run:

```
dbt seed --select seeds/.../path/to/my/seeds/
```

Don't forget that if your models depend on your seeds, you'll need to deploy your seeds before your models.

To run tests on models with tests defined, run:

```
dbt test --select models/.../path/to/my/models/
```

## <a id="using-the-plus-prefix"></a>Using the + prefix

The `+` prefix is a `dbt` syntax feature which helps disambiguate between resource paths and configurations in the `dbt_project.yml` file. If you see it used in the `dbt_project.yml` file and wonder what it is, read [dbt's guidance on using the `+` prefix](https://docs.getdbt.com/reference/resource-configs/plus-prefix). It is also used to configure properties in a nested dictionary which take a dictionary of values in a model, seed or test config `.yaml`. For example, use `+column_types` rather than `column_types` since what follows are further key and value pairs defining the column names and the required data type. It doesn't hurt to use `+` prefix so it is recommended to always do so.

```
version: 2

models:
  - name: prison_safety_and_security__question_answer_fct
    description: The question and answer fact table.
    config:
      materialized: incremental
      incremental_strategy: append
      partitioned_by: ['snapshot_date']
      +column_types:
        column_1: varchar(5)
        column_2: int
        column_3: string
```

## How to use the incremental materialisation with the append strategy

You may want your final derived table to retain previous versions of itself and not be overwritten each time your table is deployed. The following example will detail how you can achieve creating snapshots of the data and partitioning the table by those snapshots.

If you had a model producing a final table at `models/some_domain/some_database/some_database__final_derived_table.sql` with a snapshot date column of `table_snapshot_date` you should have a respective YAML config file saved at `models/some_domain/some_database/some_database__final_derived_table.yml` looking something like the below (with the names of your model and columns)

```
version: 2

models:
  - name: some_database__final_derived_table

  config:
    # makes the model append any new data to the existing table partitioned
    # by the list of columns given. Effectively creating snapshots
    materialized: incremental
    incremental_strategy: append
    partitioned_by: ['table_snapshot_date']
    tags: monthly

  description: what a table.

  columns:
    - name: unique_id
      description: a unqiue identifier
    - name: something_interesting
      description: some good data
    - name: table_snapshot_date
      description: snapshot date column and also table partition.
```

One important thing to note is that partition columns need to be the last column in your table. And if you have multiple partition columns they would all need to be the last columns and in the same order in the paritioned_by key list value in your yaml config as they appear in your table.

If you have defined the config for your model as above, every time you run `dbt run --select ...` locally via a command in your terminal, the data from that run will be appended to the previous data in the dev version of your database.

If you wanted to test the data is being materialised as intended then run once with an early snapshot date and again with a later snapshot date and inspect your data in athena, with a query like:

```
select table_snapshot_date, count(*)
from some_database_dev_dbt.final_dervied_table
group by table_snapshot_date
```

You can also inspect the s3 bucket and folder where your data will be saved. In the case of this example it would be `mojap_derived_tables/dev/models/domain_name=some_domain/database_name=some_database/table_name=final_derived_table/`. You'd expect to see a number of timestamped folders each containing a partition of your table's data (based on how many times you've run your models).

If you want to run your models and disregard all previous snapshots you should add the flag `--full-refresh` to `dbt run`, e.g. `dbt run --select models/some_domain/some_database/some_database__final_dervied_table.sql --full-refresh`.
