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