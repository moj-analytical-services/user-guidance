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
- `table`: tabular data in the usual sense; also the default materialisation type for a `model`.


## Set up
This list comprises everything you need to do to get set up and ready to start building models. 

0. Read the detailed [create-a-derived-table instructions](/tools/create-a-derived-table/index).
1. Check your use case is appropriate; you may wish to contact the Data Modelling team for advice at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9).
2. Decide an appropriate domain within `create-a-derived-table` for your project.
3. Decide on naming conventions for your `models` in the form `database_name__table_name`, note separation using `__` ("dunder").
4. Set up an [MoJ Analytical Platform account](https://user-guidance.services.alpha.mojanalytics.xyz/get-started.html#2-analytical-platform-account).
5. Add yourself to [standard_database_access](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/project_access/standard_database_access.yaml) and raise a PR to gain access to `create_a_derived_table/basic` resource including access to`seeds` and `run_artefacts`.
6. Create a project access file for your project in [data-engineering-database-access/project_access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/project_access). 
7. Under resources include the domains required to write models to, as well as the source databases. 
8. If an MoJ Analytical Platform database is not listed as a source under [mojap_derived_tables/models/sources](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/sources) then it will need to be added, see [CONTRIBUTING](https://github.com/moj-analytical-services/create-a-derived-table/blob/main/CONTRIBUTING.md#updating-dbt-source-files).
9. Set up RStudio IDE; set up a project and clone the repo into it, either via the GUI or Terminal,
```
git clone git@github.com:moj-analytical-services/create-a-derived-table.git
```
10. Set up a Python virtual environment; activate; install requirements
```
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```
11. Set the environment variable `DBT_PROFILES_DIR` in your Bash profile and source it,
```
echo "export DBT_PROFILES_DIR=../.dbt/" >> ~/.bash_profile
source ~/.bash_profile
```
12. Navigate to the `mojap_derived_tables` directory to run `dbt` commands. Check active connection with `dbt debug` and install `dbt` packages with `dbt deps`
```
dbt debug
dbt deps
```
13. Use Github Workflow method to collaborate on a project. Branch off `main` and create a main branch for your project, `project-name-main`, then all subsequent developers should branch off `project-name-main` to create their own feature branches for this project and merge into `project-name-main` before thi sis merged into `main`.


## Using Create a Derived Table and dbt
Bear in mind `create-a-derived-table` 





## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select {path_to_file(s)}`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select {path_to_seeds}` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.