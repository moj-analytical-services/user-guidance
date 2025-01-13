# Quick Reference

⚠️ This service is in beta ⚠️

This page is intended to give users who have read through the detailed sections of the [create-a-derived-table](/tools/create-a-derived-table) user guidance a quick reference to refresh their memory. Please post suggestions for improvements in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit this document and raise a pull request.

## Contents
- [Glossary](#glossary)
- [Set up](#set-up)
- [Virtual environment set up](#virtual-environment-set-up)
- [Git commands](#git-commands)
- [dbt commands](#dbt-commands)
- [yamllint commands](#yamllint-commands)
- [sqlfluff commands](#sqlfluff-commands)
- [Moving models to production](#moving-models-to-production)
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
This list comprises everything you need to do and consider to get set up and ready to start building models collaboratively. It is intended as a quick check or reference list and assumes you have read the detailed instructions in each section of the [create-a-derived-table](/tools/create-a-derived-table) user guidance. See [Troubleshooting](/tools/create-a-derived-table/troubleshooting) if you have any problems.

1. Read the detailed [create-a-derived-table](/tools/create-a-derived-table) user guidance.

2. Check your use case is appropriate; you may contact the Data Modelling team for advice at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9).

3. Decide an appropriate [domain](/tools/create-a-derived-table/project-structure/#domains) within `create-a-derived-table` for your project.

4. Decide on naming conventions for your `models` in the form `database_name__table_name`, note separation using `__` ("dunder"). Database name must be unique within MoJ.

5. Set up an [MoJ Analytical Platform account](https://user-guidance.analytical-platform.service.justice.gov.uk/get-started.html#2-analytical-platform-account).

6. Add your `alpha_user` name to [standard_database_access](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/project_access/standard_database_access.yaml) and raise a PR. This grants access to the `create_a_derived_table/basic` resource, which includes access to the `general` domain, `seeds` and `run_artefacts`.

7. Create a project access file for your project in [data-engineering-database-access/project_access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/project_access). 

8. In the project access file under `Resources` include the `create-a-derived-table` domains required to write models *to*, as well as the source databases you will be buildung models *from*. Full instructions [here](/tools/create-a-derived-table/database-access#your-data-engineering-database-access-project-access-file).

9. If an MoJ Analytical Platform database is not listed as a source in [source_database_names.txt](https://github.com/moj-analytical-services/create-a-derived-table/blob/main/scripts/source_database_names.txt) then you can add it, see [Adding a new source](/tools/create-a-derived-table/source-and-ref-functions#adding-a-new-source).

10. Set up an Interactive Development Environment (IDE); set up a project and clone the repo into it. See [Set up an IDE](/tools/create-a-derived-table/ide-set-up) for GUI instructions. Using Terminal navigate to where you want the `create-a-derived-table` project to sit and run `git clone git@github.com:moj-analytical-services/create-a-derived-table.git`.

11. Navigate to the `create-a-derived-table` directory in Terminal and set up a Python virtual environment; activate it, upgrade pip, and install requirements. See [Setting up a Python virtual environment](/tools/create-a-derived-table/ide-set-up#setting-up-a-python-virtual-environment) and [Virtual environment set up](#virtual-environment-set-up).


12. Use Github Workflow method to collaborate on a project. Branch off `main` and create a main branch for your project, `project-name-main`; all subsequent developers should branch off `project-name-main` to create feature branches for this project. When raising a PR ensure you merge into this branch, before merging into `main`; the PR summary should read something like "`github-user` wants to merge *X* commits into `project-name-main` from `project-name-feature-branch`". See also [Collaborating with Git](/tools/create-a-derived-table/collaborating-with-git#collaborating-with-git) and [Git commands](#git-commands).

You are now ready to start building models collaboratively with `create-a-derived-tbale`. If you have any problems please check [Troubleshooting](/tools/create-a-derived-table/troubleshooting), or ask at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) providing context and links if appropriate.

##  Virtual environment set up

Clone the `create-a-derived-table` repository

```
git clone git@github.com: moj-analytical-services/create-a-derived-table.git
```

Ensure you are in the root directory `create-a-derived-table`.

Set up and activate a Python virtual environment

```
python3 -m venv venv
source venv/bin/activate
```

Install requirements:

```
pip install --upgrade pip
pip install -r requirements.txt
pip install -r requirements-lint.txt
```

Set up and source the Bash profile

```
echo "export DBT_PROFILES_DIR=../.dbt/" >> ~/.bash_profile
source ~/.bash_profile
```

Set up dbt

```
cd mojap_derived_tables
dbt debug
dbt deps
```


## `Git` commands

Some useful `bash` and `git` commands.

|||
|--------------|--------------|
|`cd path/to/root`|navigate to the `create-a-derived-table` (root) directory of the repository|
|`cd ..`|go up one directory|
|`cd ~`|go to the top level directory (this may be `create-a-derived-table`)|
|`ls`|list directory contents|
|`git clone git@github.com:moj-analytical-services/create-a-derived-table.git`|clone the repo|
|`git branch`|check which of your local branches you are on|
|`git branch -a`|list all local and remote branches|
|`git switch main`|switch to the `main` branch|
|`git fetch`|fetch the latest content from the remote branch (view only)|
|`git pull`|pull the latest content from the remote, updating the local copy|
|`git checkout -b <new-branch>`|create a new branch off the current branch|
|`git checkout -b <new-branch> <from-branch>`|create a new branch off a specific branch|
|`git add path/to/files/`|add a direcrtory of files to the staging area|
|`git status`|check status of current branch and see what files are staged|
|`git commit -m "<descriptive message>"`|save changes to local repo with a descriptive message|
|`git push origin <new-branch>`|push local changes to the remote, if the branch doesn't exist it is created, else it is updated|
|`git fetch origin <other-branch>`|fetch latest content from a specific branch|
|`git pull origin <other-branch>`|pull latest content from a specific branch into current branch|
|`git merge origin/<other-branch>`|merge changes from specific branch into current branch|



## `dbt` commands

Remove run artefacts from previous invocations of dbt:

```
dbt clean
```

Compile model code which checks SQL and YAML is syntactically correct. The compiled model files will be saved in the corresponding directory under `mojap_derived_tables/target/compiled/`:


```
dbt compile --select models/.../path/to/my/models/
```


Deploy seeds, models and run tests (note models must be deployed before tests can run successfully):

```
dbt run --select models/.../path/to/my/models/
dbt seed --select seeds/.../path/to/my/seeds/
dbt test --select models/.../path/to/my/models
```

Build and open a local copy of the `dbt docs`:

```
dbt docs generate
dbt docs serve
```

## `yamllint` commands

To lint a single YAML file or a directory of YAML files navigate to the root directory and run:

```
yamllint .../path/to/yaml/file.yaml
yamllint .../path/to/yaml/directory/
```

Validate and reformat YAML using the online [YAML Validator](https://www.yamllint.com/) tool. Copy/paste code into it and click `Go` to validate. Note that to pass the YAML linter settings all YAML files must contain a final empty line which may not copy across from the online tool.

## `sqlfluff` commands

To lint a single SQL file or a directory of SQL files navigate to the root directory and run:

```
sqlfluff lint .../path/to/sql/file.sql
sqlfluff lint .../path/to/sql/directory/
```

To lint and fix a single SQL file or a directory of SQL files run:

```
sqlfluff fix .../path/to/sql/file.sql
sqlfluff fix .../path/to/sql/directory/
```

You are asked to confirm before proceding with the `fix` as it edits your files.

##  Moving models to production:
When you are ready to submit a pull request to merge models into the `main` branch, please check against the following list:

<ol type="1">
  <li><b>Seamless User Experience:  </b>Prepare the models following data modelling good practise, more information <a href="/tools/create-a-derived-table/data-modelling-concepts">here</a>. Consider the following factors to enhance the user experience in terms of how models are presented:</li>
  <ul>
  <li>Should a model be visible in the same database, or be moved to a staging database?</li>
  <li>Are the names of databases/tables/columns clear to users?</li>
  <li>How does the model appear in <code>dbt docs</code>?</li>
  </ul>
  <li><b>Readability: </b>Ensure linting checks pass locally on SQL and YAML code so that code layout meets organisation standards for ease of human readability.</li>
  <li><b>Comprehensive Testing:</b> Ensure that the development models are accompanied by sufficient tests. There are many tests availble at column and table level, as well as the option to create user defined tests, more information <a href= "/tools/create-a-derived-table/tests">here</a>. Confirm these tests pass consistently. This is a critical validation step to provide model quality assurance to consumers.</li>
  <li><b>Successful Deployment in Development: </b>Upon raising a pull request the <code>deploy-dev</code> workflow is triggered. This must complete successfully before any code can be merged into <code>main</code>. You may need to update your branch with the latest from <code>main</code> and resolve any conflicts.</li>
  <li><b>Model Scheduling: </b>Determine the most appropriate scheduling for the model deployment that aligns to upstream deployment pipelines. For example, if the upstream sources are only updated weekly, a daily schedule may be unnecessary. Update the <a href="https://github.com/moj-analytical-services/create-a-derived-table/blob/main/mojap_derived_tables/dbt_project.yml">dbt_project.yml</a> using the corresponding schedule <code>tag</code>, more information <a href="/tools/create-a-derived-table/scheduling-to-prod">here</a>. Please note, <i>only</i> models with a declared schedule <code>tag</code> are deployed to production.</li>
</ol>


## Tips

- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.