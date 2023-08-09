# Quick Reference

⚠️ This service is in beta ⚠️

This page is intended to give users who have read through the detailed [create-a-derived-table instructions](/tools/create-a-derived-table) a quick reference to refresh their memory. Please post suggestions to improve this document in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit and raise a PR.

## Contents
- [Glossary](#glossary)
- [Set up](#set-up)
- [Set up IDE](#set-up-ide)
- [Collaborating with Git](#collaborating-with-git)
- [Important dbt commands](#important-dbt-commands)
- [yamllint commands](#yamllint-commands)
- [sqlfluff commands](#sqlfluff-commands)
- [Moving the model to production](#moving-the-model-to-production)
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

5. Set up an [MoJ Analytical Platform account](https://user-guidance.analytical-platform.service.justice.gov.uk/get-started.html#2-analytical-platform-account).

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

##  Set up IDE

- Clone Git repository: <code>git clone git@github.com: moj-analytical-services/create-a-derived-table.git</code>

- Set up a Python virtual environment:
<ul>
  <li><code>python3 -m venv venv</code></li>
  <li><code>source venv/bin/activate</code></li>
  <li><code>pip install --upgrade pip</code></li>
</ul>
- Install requirements:
<ul>
  <li><code>pip install -r requirements.txt</code></li>
  <li><code>pip install -r requirements-lint.txt</code></li>
</ul>
- Set up the Bash profile:
<ul>
  <li><code>echo "export DBT_PROFILES_DIR=../.dbt/" >> ~/.bash_profile</code></li>
  <li><code>source ~/.bash_profile</code></li>
</ul>
- Set up dbt
<ul>
    <li><code>cd mojap_derived_tables</code></li>
    <li><code>dbt debug</code></li>
    <li><code>dbt deps</code></li>
</ul>

## Collaborating with Git

<ul>
<li>Use the <code>cd</code>  command to navigate to the root/main directory of the repository (create-a-derived-table).</li>

<li>Check the status of the repository with <code>git status</code>; if it's not on the main branch, switch to it using <code>git checkout main</code>.</li>

<li>Pull the latest content from the remote repository and update your local repository immediately with <code>git pull</code>.</li>

<li>To create your own branch, use the command <code>git checkout -b project_name</code>.
<li>Add changes from the working directory to the staging area with <code>git add file_name</code>.</li>
<li>Save your changes to the local repository by using <code>git commit -m "messages"</code>.</li>

<li>To see the changes that have occurred in the remote branch, perform a <code>git fetch</code>.</li>

<li>If there are any changes in the remote repository, update your local branch by executing <code>git pull</code>.</li>

<li>Switch to your own branch with the command <code>git switch your_branch_name</code>.</li>

<li>Update the main branch by merging your changes into it using <code>git merge main -m "messages"</code>.</li>
</ul>

## Important dbt commands
<ul>
    <li><code>dbt clean</code> to remove run artefacts from previous invocations of dbt</li>
    <li><code>dbt compile --select models/.../path/to/my/models/</code>, to check your SQL and YAML is syntactically correct</li>
    <li><code>dbt run --select models/.../path/to/my/models/</code>, to deploy your models</li>
    <li><code>dbt seed --select seeds/.../path/to/my/seeds/</code>, to deploy your seeds</li>
    <li><code>dbt test --select models/.../path/to/my/models/</code>, to run tests on models with tests defined</li>
    <li><code>dbt docs generate</code>, to generating your project's documentation </li>
    <li><code>dbt docs serve </code>, to serve your documentation locally </li>
</ul> 

## yamllint commands
Linting is the automated checking of your code for programmatic and stylistic errors performed by running a &lsquo;linter&rsquo;
<ul>
    <li><code>yamllint .../path/to/yaml/file.yaml</code>, to lint a single YAML file</li>
    <li><code>yamllint .../path/to/yaml/directory/</code>, to lint a whole directory of YAML files</li>
</ul>

## sqlfluff commands
- To format SQL files using SQLFluff
<ul>
    <li><code>sqlfluff lint .../path/to/sql/file.sql</code>, to lint a single SQL file</li>
    <li><code>yamllint .../path/to/yaml/directory/</code>, to lint a whole directory of SQL files</li>
</ul>

##  Moving the model to production:
When you are ready to submit a pull request to merge your models into the `main` branch, please check you have done the following:

<ol type="1">
  <li><b>Seamless User Experience:  </b>Prepare the models for use by data consumers without introducing the risk of breaking changes. Consider the following factors to enhance the user experience in terms of how models are presented:</li>
  <ul>
  <li>Should the models remain visible in the same database, or be moved to the staging database? </li>
  <li> Are the names of databases/tables/columns clear to users?</li>
  <li>How will the model appear in dbt docs?</li>
You can find more information about data modelling concepts <a href="/tools/create-a-derived-table/data-modelling-concepts">here</a>.
  
  </ul>
  <li><b>Comprehensive Testing:</b> Before moving forward to the production stage, ensure that the development models are accompanied by sufficient tests. Confirm the successful completion of these tests; it's a critical validation process. You will find more details about testing <a href= "https://user-guidance.analytical-platform.service.justice.gov.uk/tools/create-a-derived-table/tests/">here</a>.</li>
  <li><b>Successful Deployment in Development: </b>Ensure that models are working and linted locally before committing the changes and raising the PR. After raising the PR, you need to check that model successfully passes through the deploy-dev workflow. It is also recommended to check and ensure that the branch is up to date with the main branch and that any conflicts are resolved.</li>
  <li><b>Model Scheduling: </b>It is necessary to consider the most appropriate scheduling for the models while aligning with upstream pipelines. For example, if the upstream sources are only updated weekly, daily updates might be unnecessary. Linked to scheduling is the decision of whether the models should be incremental or not, which involves appending new data versus fully overwriting each run. The scheduling is managed using <a href="https://github.com/moj-analytical-services/create-a-derived-table/blob/main/mojap_derived_tables/dbt_project.yml">dbt_project.yml</a>. Additional scheduling information is provided <a href="https://user-guidance.analytical-platform.service.justice.gov.uk/tools/create-a-derived-table/scheduling-to-prod/">here</a>.</li>
</ol>


## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select <path_to_file(s)>`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select <path_to_seeds>` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.