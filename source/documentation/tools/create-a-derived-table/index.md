# Create a Derived Table


:warning: This service is in beta :warning:
Read on to find out more or get in touch at the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel.

Table of Contents
=================

* [What is Create a Derived Table?](#what-is-create-a-derived-table)
* [Getting started](#getting-started)
   * [Getting access to your tables](#getting-access-to-your-tables)
   * [Setting up your working environment](#setting-up-your-working-environment)
      * [R Studio](#r-studio)
      * [JupyterLab](#jupyterlab)
* [Creating models](#creating-models)
   * [What is a model?](#what-is-a-model)
   * [Standard directory structure and naming conventions](#standard-directory-structure-and-naming-conventions)
   * [Configuring your models](#configuring-your-models)
      * [Where can I define configs?](#where-can-i-define-configs)
      * [Config inheritance](#config-inheritance)
   * [Writing models](#writing-models)
      * [The ref function](#the-ref-function)
      * [Sources](#sources)
* [What else?](#what-else)
   * [Tests](#tests)
   * [Macros](#macros)
   * [Seeds](#seeds)
   * [Linting](#linting)
* [Scheduling](#scheduling)
* [Deploying your tables](#deploying-your-tables)
   * [Dev](#dev)
   * [Prod](#prod)
* [Resources](#resources)
* [License](#license)

# What is Create a Derived Table?
It's a service to allow you to deploy tables derived from data available on the Analytical Platform straight to Athena in a reproducible way and define a schedule for those tables to be updated on. All you’ll need to do is submit the SQL to derive your table along with a few configuration files in a GitHub PR. To make this happen we’re using some software called dbt which is packed full of features for transforming data using SQL. You don't need to worry about how it works under the hood but you will need to get familiar with certain bits of syntax. To learn more, take a look at [dbt's documentation](https://docs.getdbt.com/docs/introduction). We’re still in beta so would love to get some of you using Create a Derived Table to get your feedback and to be able to integrate it with our existing infrastructure that much better.

Some of the basics about working with dbt are covered below, but you can also sign up and work through [dbt's own training courses](https://courses.getdbt.com/collections) for free.

# Getting started
The first thing you'll need to work with Create a Derived Table is standard database access. If you don't have that already, follow the [guidance on how to make changes to the standard database access project file](https://github.com/moj-analytical-services/data-engineering-database-access#standard-database-access) in the Data Engineering Database Access repo.
The `mojap_derived_tables` directory is where you'll find the dbt project with all the resources you'll be contributing to like `models`, `seeds`, and `tests`. This service should be used for creating tables with well defined use cases, like to serve a performance metric, publication, or MI report. This is because the dbt project (`mojap_derived_tables`) is a shared space and so knowing where to put your work in the broader structure of the project is key. The primary consideration is understanding which domain the table you want to create belongs to. A domain is a logical grouping of databases. A domain may be 'prisons', or 'HR' for example, but it could be more or less granular if appropriate. The secondary consideration is whether the table you are creating belongs in an existing database. If those considerations aren't easy to answer, reach out to the [data modelling team](https://asdslack.slack.com/archives/C03J21VFHQ9), who will be able to advise you.

## Getting access to your tables
You won't automatically get access to the tables you create. Access to derived tables is granted at the domain level. This means you will need to know in which domain you will be creating derived tables before you start working. If you don't know which domain is the right one, get in touch with the [data modelling team](https://asdslack.slack.com/archives/C03J21VFHQ9) who will be able to advise you.
Once that's done, you'll need to setup a Data Engineering Database Access project access file. To learn how to do that, follow the [Access to curated databases](https://github.com/moj-analytical-services/data-engineering-database-access#access-to-curated-databases) guidance in the Data Engineering Database Access repo. Your project file should include the domain and source databases you want access to. A list of already available domains can be found in the [database access resources for Create a Derived Table](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/database_access/create_a_derived_table). If you're creating a new database and there isn't a relevant domain for it to go in, get in touch at the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel and we'll set one up for you.
A typical project access file might look like:
```
project_id: Probation Team 1 Derived Tables

review_date: 2022-10-20
approver_position: >=G7 of Probation Team 1 Derived Tables
approver_email: approver.name@justice.gov.uk
alternative_approver_emails:
  - alternative.approver-name@justice.gov.uk

resources:
  - create_a_derived_table/probation
  - delius_prod/full
  - oasys_prod/full

users:
  - alpha_user_name_a
  - alpha_user_name_b
  - alpha_user_name_c

business_case: >
  To create derived tables for Probation Team 1.
```
Note that you will need access to any database whose tables your tables are derived from. To create derived tables from tables that aren't available in Data Engineering Database Access, you'll need the owner of those tables to give you access to the S3 bucket where the data is stored.

## Setting up your working environment
### R Studio
The first thing you’ll need to do is clone the repository and setup Python virtual environment. To do this, run the following command:
```
git clone git@github.com:moj-analytical-services/create-a-derived-table.git
```
then `cd` into the root of the repository and then run:
```
python3 -m venv venv
```
```
source venv/bin/activate
```
```
git checkout -b <your-branch-name-here>
```
```
pip install --upgrade pip
```
```
pip install -r requirements.txt
```
Set the following environment variable in your Bash profile:
```
echo "export DBT_PROFILES_DIR=../.dbt/" >> ~/.bash_profile
```
Then source your Bash profile by running:
```
source ~/.bash_profile
```
You'll need to be in the dbt project to run dbt commands. This is the `mojap_derived_tables` directory:
```
cd mojap_derived_tables
```
Then to check an active connection, run:
```
dbt debug
```
If that's successful, to install dbt packages, run:
```
dbt deps
```
You're now ready to get dbt-ing!

### JupyterLab
We're working to get Create a Derived Table up and running with JupyterLab, please bear with us.

# Creating models
## What is a model?
A model is a `select` statement. Models are defined in `.sql` files and each `.sql` file contains one model/`select` statement.

## Standard directory structure and naming conventions
There is a standard directory structure that you must adhere to when working with Create a Derived Table. In the example below, the Prisons Safety and Security team have created a database called `prisons_safety_and_security` in the `prisons` domain.
- The hierarchy of directories must go `models` -> `domain` -> `database`. The directory structure after this is arbitrary and can be chosen to suit your needs. However, we do recommend that you arrange your tables into marts and suffix your models with descriptions (this will be discussed in more detail).
- Directory and file names should only use snake case, as in, `no-hyphens-like-this`, `just_underscores_like_this`.
- Models (`.sql` files) must be named by the database and table they relate to separated by double underscores, i.e., `<database_name>__<table_name>.sql`. This is because all models in the `models` directory must have a unique name.
- Suffixes should be added that describe each table's purpose.
  - Fact and dimension tables should be suffixed with `_fct` and `_dim` respectively.
  - Intermediate tables should be suffixed with the main transformation being applied in past tense, e.g., `_grouped` or `_left_join`.
- Mart and staging models must have their own configuration file and should have the same filename as the model they configure.
- Intermediate tables should have a single configuration file named `properties.yaml`.
- You may want to arrange staging tables into a specific staging database, or within a single database for all your tables.
If you have ideas about how you would like to arrange your tables, please get in touch as we'd love to hear from you to help guide best practice principles.

```
├── dbt_project.yaml
└── models
    ├── sources
    │   ├── nomis.yaml
    │   ├── oasys.yaml
    │   ├── delius.yaml
    │   ├── xhibit.yaml
    ├── prisons  # domain
    │   ├── prisons_safety_and_security  # database
    │   │   ├── marts
    │   │   │   ├── intermediate
    │   │   │   │   ├── prisons_safety_and_security__inc_ids_grouped.sql  # intermediate table
    │   │   │   │   ├── prisons_safety_and_security__questions_filtered.sql  # intermediate table
    │   │   │   │   ├── prisons_safety_and_security__question_set_joined.sql  # intermediate table
    │   │   │   │   └── properties.yaml  # intermediate table configs
    │   │   │   └── question_answers  # arbitrary grouping
    │   │   │       ├── prisons_safety_and_security__dates_dim.sql  # dimension table
    │   │   │       ├── prisons_safety_and_security__dates_dim.yaml  # table config
    │   │   │       ├── prisons_safety_and_security__incidents_fct.sql  # fact table
    │   │   │       ├── prisons_safety_and_security__incidents_fct.yaml  # table config
    │   │   │       ├── prisons_safety_and_security__question_answer_fct.sql  # fact table
    │   │   │       └── prisons_safety_and_security__question_answer.yaml  # table config
    │   │   └── staging
    │   │       ├── prisons_safety_and_security__nomis_mod_stg.md  # markdown to be rendered in documentation
    │   │       ├── prisons_safety_and_security__nomis_mod_stg.sql  # staging table
    │   │       └── prisons_safety_and_security__nomis_mod_stg.yaml  # table config
```

## Configuring your models
Resources in your project—models, seeds, tests, and the rest—can have a number of declared properties. Resources can also define configurations, which are a special kind of property that bring extra abilities. What's the distinction?
- Properties are declared for resources one-by-one in `.yaml` files. Configs can be defined there, nested under a config property. They can also be set one-by-one via a `config()` macro (right within `.sql` files), and for many resources at once in `dbt_project.yaml`.
- Because configs can be set in multiple places, they are also applied hierarchically. An individual resource might inherit or override configs set elsewhere.
- A rule of thumb: properties declare things about your project resources; configs go the extra step of telling dbt how to build those resources in your warehouse. This is generally true, but not always, so it's always good to check!

For example, you can use resource properties to:
- Describe models, snapshots, seed files, and their columns
- Assert "truths" about a model, in the form of tests, e.g. "this id column is unique"
- Define pointers to existing tables that contain raw data, in the form of sources, and assert the expected "freshness" of this raw data
- Define official downstream uses of your data models, in the form of exposures

Whereas you can use configurations to:
- Change how a model will be materialised (table, view, incremental, etc)
- Declare where a seed will be created in the database (`<database>.<schema>.<alias>`)
- Declare whether a resource should persist its descriptions as comments in the database
- Apply tags and "meta" properties

### Where can I define configs?
Depending on the resource type, configurations can be defined:
- Using a `config()` Jinja macro within a model or test SQL file
- Using a config property in a `.yaml` file
- From the `dbt_project.yaml` file, under the corresponding resource key (models:, tests:, etc)

### Config inheritance
Configurations are prioritised in order of specificity, which is generally the order above: an in-file `config()` block takes precedence over properties defied in a `.yaml` file, which takes precedence over a config defined in the project file. (Note that generic tests work a little differently when it comes to specificity. See dbt's documentation on [test configs](https://docs.getdbt.com/reference/test-configs).)

To apply a configuration to a model, or directory of models, define the resource path as nested dictionary keys. In the example below the `materialized: table` config has been applied to the entire `mojap_derived_tables` project. The `sentences` and `question_answers` directories have `tags` configured for all models in those respective directories.
:warning: Only add configurations to your own work. :warning:
```
models:
  mojap_derived_tables:
    +materialized: table

    prisons:
      de_prisons_safety_and_security:
        marts:
          sentences:
            +tags: profiles_ids_sentences

          question_answers:
            +tags: qna_extract_t1
```

## Writing models
### The ref function
The most important function in dbt is `ref()`; it's impossible to build even moderately complex models without it. `ref()` is how you reference one model within another. This is a very common behavior, as typically models are built to be 'stacked' on top of one another. Here is how this looks in practice:
`model_a.sql`
```
select * from public.raw_data
```
`model_b.sql`
```
select * from {{ref('model_a')}}
```
`ref()` is, under the hood, actually doing two important things. First, it is interpolating the schema into your model file to allow you to change your deployment schema via configuration. Second, it is using these references between models to automatically build the dependency graph. 

### Sources
Sources are descriptions of the databases and tables already on the Analytical Platform. With those tables defined as sources in dbt, it is then possible to select from source tables in your models using the {{ source() }} function which helps define the lineage of your data. To see which sources have been defined, look in the `./mojap_derived_tables/models/sources/` directory. If a database or table hasn't been defined as a source, let the data modellers know at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9).

# What else?
The rest is up to you, but have a look at the following documentation for ideas.
## Tests
Tests can be _bespoke_ or _generic_. Bespoke tests can be anything you want, are written in SQL, and live at `./mojap_derived_tables/tests`. dbt ships with some generic tests and the `dbt_utils` package adds a whole bunch more. Tests can be used to check columns for nulls or uniqueness, or to do things like compare row counts of tables. You can call bespoke or generic tests by defining them in your configuration files, which might look something like this:
```
version: 2

models:
  - name: <model_a>

    tests:
      - dbt_utils.equal_rowcount:
          compare_model: <model_b>
    columns:
      - name: <column_a>
        tests:
          - not_null
          - dbt_utils.not_constant
```
For more information, see [here](https://docs.getdbt.com/docs/building-a-dbt-project/tests).

## Macros
Macros are just Jinja functions. You can write your own macros which should live at `./mojap_derived_tables/macros`, see [dbt's docs on Jinja macros](https://docs.getdbt.com/docs/building-a-dbt-project/jinja-macros). You can also make use of a bunch of predefined macros that come with the `dbt_utils` package, see [here](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/).

## Seeds
Seeds are lookup tables easily created from a `.csv` file. Put the `.csv` in the `./mojap_derived_tables/seeds/` directory and follow the same directory structure requirements and naming conventions as for models. As with marts models your seeds should have configurations files that have the same filename as the seed.
Seeds can be accessed by anyone with standard database access. If you don't have that, add your alpha username to the standard database project access file. There's [guidance on how to do that in the Data Engineering Database Access readme](https://github.com/moj-analytical-services/data-engineering-database-access#standard-database-access).
:warning: Seeds must not contain sensitive data. :warning:

## Linting
You can lint your SQL files by running:
```
sqlfluff path/to/sql/file.sql
```
Or a whole directory of files by running:
```
sqlfluff path/to/sql/directory/
```

# Scheduling
There are three options for scheduling table updates: 'daily', 'weekly', and 'monthly'. The monthly schedule runs on the first Sunday of every month and the weekly schedule runs every Sunday. All schedules run at 3AM. To select a schedule for your table, add the 'tags' property to your model's configuration file, like this:
```
version: 2

models:
  - name: <your_model_name>
    config:
      tags: daily
```

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