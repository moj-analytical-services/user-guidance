# Quick Reference

This page is intended to give users who have read through the detailed [create-a-derived-table instructions](/tools/create-a-derived-table) a quick reference to refresh their memory. Please post suggestions to improve this document in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit and raise a PR.

## Contents
- [Glossary](#glossary)
- [Set up](#set-up)
- [Tips](#tips)


## Glossary
Glossary of key words in the context of `create-a-derived-table` / `dbt`.

- `_dim`: dimension model suffix naming convention.
- `_fct`: fact model suffix naming convention.
- `_stg`: staging model suffix naming convention.
- `.yaml`: preferred YAML file extension (rather than `.yml`).
- `create-a-derived-table`: MoJ tool to create derived tables and serve them in AWS Athena. 
- `dbt`: data build tool open source software which `create-a-derived-table` is built on.
- `dbt-athena`: an open source community built `dbt` adapter to allow `dbt` to work with AWS Athena. MoJ currently uses its own fork.
- `model`: more or less synonymous with `table`.
- `run_artefacts`: files created when models are compiled or run.
- `seed`: lookup table.
- `source`: any table on the MoJ Analytical Platform *not* created by `create-a-derived-table` which may be used as a starting point to derived models. 
- `table`: tabular data in the usual sense; also the default materialisation type for a `model`.


## Set up
This list comprises everything you need to do and consider to get set up and ready to start building models collaboratively. It is intended as a quick check or reference list and assumes you have read the detailed [create-a-derived-table instructions](/tools/create-a-derived-table). See [Troubleshooting](/tools/create-a-derived-table/troubleshooting) if you have any problems.

1. Read the detailed [create-a-derived-table instructions](/tools/create-a-derived-table).

2. Check your use case is appropriate; you may contact the Data Modelling team for advice at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9).

3. Decide an appropriate domain within `create-a-derived-table` for your project.

4. Decide on naming conventions for your `models` in the form `database_name__table_name`, note separation using `__` ("dunder"). Database name must be unique within MoJ.

5. Set up an [MoJ Analytical Platform account](https://user-guidance.services.alpha.mojanalytics.xyz/get-started.html#2-analytical-platform-account).

6. Add yourself to [standard_database_access](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/project_access/standard_database_access.yaml) and raise a PR to gain access to the `create_a_derived_table/basic` resource, which includes access to`seeds` and `run_artefacts`.

7. Create a project access file for your project in [data-engineering-database-access/project_access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/project_access). 

8. In the project access file under `Resources` include the `create-a-derived-table` domains required to write models *to*, as well as the source databases you will be buildung models *from*. 

9. If an MoJ Analytical Platform database is not listed as a source under [mojap_derived_tables/models/sources](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/sources) then it will need to be added, see [CONTRIBUTING](https://github.com/moj-analytical-services/create-a-derived-table/blob/main/CONTRIBUTING.md#updating-dbt-source-files).

10. Set up RStudio IDE; set up a project and clone the repo into it. See [Set up the RStudio working environment](/tools/create-a-derived-table#set-up-the-rstudio-working-environment) for GUI instructions. Using Terminal navigate to where you want the `create-a-derived-table` project to sit and run `git clone git@github.com:moj-analytical-services/create-a-derived-table.git`.

11. Navigate to the root of your `create-a-derived-table` directory in Terminal and set up a Python virtual environment; activate it, upgrade pip, and install requirements. See [Setting up a Python virtual environment](/tools/create-a-derived-table#setting-up-a-python-virtual-environment).

    1. Set the environment variable `DBT_PROFILES_DIR` in your Bash profile and source it.

    2. Navigate to the `mojap_derived_tables` directory in Terminal to run `dbt` commands. Check you have an active connection, `dbt debug`

    3. Install `dbt` packages with `dbt deps`.

12. Use Github Workflow method to collaborate on a project. Branch off `main` and create a main branch for your project, `project-name-main`; all subsequent developers should branch off `project-name-main` to create feature branches for this project. When raising a PR ensure you merge into this branch, before merging into `main`; the PR summary should read something like "`github-user` wants to merge *X* commits into `project-name-main` from `project-name-feature-branch`". See also [Collaborating with Git](/tools/create-a-derived-table#collaborating-with-git).

You are now ready to start building models collaboratively with `create-a-derived-tbale`. If you have any problems please check [Troubleshooting](/tools/create-a-derived-table/troubleshooting), or ask at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) providing context and links if appropriate.


## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select <path_to_file(s)>`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select <path_to_seeds>` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.