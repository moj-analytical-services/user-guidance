# Create a Derived Table Quickstart

This page is intended to give users who have read through the [detailed instructions](/tools/create-a-derived-table/index) a quickstart reference to refresh their memory or refer to particular code snippets quickly. Please post suggestions to improve this document in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit and raise a PR.

## Glossary
- `create-a-derived-table`: MoJ tool to create derived tables and serve them in AWS Athena. 
- `dbt`: data build tool open source software which `create-a-derived-table` is built on.
- `dbt-athena`: MoJ forked version of an open source community built `dbt` adapter to allow `dbt` to work with AWS Athena.
- `model`: more or less synonymous with `table`.
- `run_artefacts`: files created when models are compiled or run.
- `seed`: lookup table.
- `source`: any table on the MoJ Analytical Platform *not* created by `create-a-derived-table` which may be used as a starting point to derived models. 
- `table`: tabular data in the usual sense; also a materialisation type that can be chosen for a `model`.


## Step by step
0. Read the detailed [create-a-derived-table instructions](/tools/create-a-derived-table/index).
1. Check your use case is appropriate; you may wish to contact the Data Modelling team for advice at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9).
2. Decide an appropriate domain within `create-a-derived-table` for your project.
3. Decide on naming conventions for your `models` in the form `database_name__table_name`, note separation using `__` ("dunder", "double underscore").
4. Add yourself to [standard_database_access](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/project_access/standard_database_access.yaml) and raise a PR to gain access to `create_a_derived_table/basic` resource including access to`seeds` and `run_artefacts`.
5. Create a project access file for your project in [data-engineering-database-access/project_access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/project_access). Ensure to include thee domains required to write models to under resources, as well as the source databases. If an MoJ Analytical Platform database is not listed as a source in is not listed in 





## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select {path_to_file(s)}`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select {path_to_seeds}` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.