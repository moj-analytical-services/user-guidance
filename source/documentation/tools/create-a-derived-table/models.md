# Models

## What is a model?

A model is a `select` statement. Models are defined in `.sql` files and each `.sql` file contains one model/`select` statement. The term 'model' is almost synonymous with 'table' and for the most part can be used interchangeably and thought of the same thing. The term 'model' is used because a model can be materialised in different ways; it can be ephemeral, a view, or indeed a table. More on materialisations later. From here on the term 'model' will be used instead of 'table'.

## Model properties

Resources in your project — models, seeds, tests, and the rest — can have a number of declared properties. Resources can also define configurations, which are a special kind of property that bring extra abilities. What's the distinction?

- Properties are declared for resources one-by-one in `.yaml` files. Configs can be defined there, nested under a `config` property. They can also be set one-by-one via a `config()` macro directly in model (`.sql`) files, and for many resources at once in `dbt_project.yml`.
- Because configs can be set in multiple places, they are also applied hierarchically. An individual resource might inherit or override configs set elsewhere.
- A rule of thumb: properties declare things about your project resources; configs go the extra step of telling dbt how to build those resources in Athena. This is generally true, but not always, so it's always good to check!

For example, you can use resource properties to:

- Describe models, snapshots, seed files, and their columns
- Assert "truths" about a model, in the form of tests, e.g. "this id column is unique"
- Define pointers to existing tables that contain raw data, in the form of sources, and assert the expected "freshness" of this raw data
- Define official downstream uses of your data models, in the form of exposures

Whereas you can use configurations to:

- Change how a model will be materialised (table, view, incremental, etc)
- Overwrite where model or seed data will be written to
- Declare whether a resource should persist its descriptions as comments in the database
- Apply tags and "meta" properties

## Where can I define configs?

Configure a whole directory of models, seeds, tests, etc. from the `dbt_project.yml` file, under the corresponding resource key (`models:`, `seeds:`, `tests:`, etc). In the example below the `materialized: table` configuration has been applied to the entire `mojap_derived_tables` project. The `sentences/` and `question_answers/` directories have schedule `tags` configured for all models in those respective directories. ⚠️ Only add configurations to your own work! ⚠️

```
models:
  mojap_derived_tables:
    +materialized: table

    prison:
      prison_safety_and_security:
        marts:
          sentences:
            +tags: monthly

          question_answers:
            +tags: weekly
```

Configure an individual model, seed, or test using a `config` property in a `.yaml` property file. This is the preferred method for applying configurations because it groups the configurations with defined properties for a given model, etc. and provides good visibility of what's being applied. The below example applies the incremental materialisation and partitioned by configuration to the `question_answer_fct` model.

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
```

If for some reason it is not possible or reasonable to apply a configuration in a property file, you can use a `config()` Jinja macro within a model or test SQL file. The following example shows how the same configuration above can be applied in a model or test file.

```
{{
  config(
      materialized='incremental'
      incremental_strategy='append'
      partitioned_by=['snapshot_date']
      external_location=generate_s3_location()
  )
}}
```

## Important - Required Config

In order to ensure that data is stored in an orderly manner within the bucket, we enforce a specific naming convention through use of a build in macro to generate the file path your data will be saved in S3 with. This is done through the config block within the SQL definition of the model, and is usually seen as starting the file with the following:

```
{{ config(
    external_location=generate_s3_location()
) }}
```

Although it is possible to apply further config values by the methods detailed before as an optional feature, the config block itself **must** feature the `external_location=generate_s3_location()` statement at a minimum. Failing to supply this config value will cause the table to attempt to deploy to an incorrect location and then fail with a generic `access denied` error.

## Config inheritance

Configurations are prioritised in order of specificity, which is generally the inverse of the order above: an in-file `config()` block takes precedence over properties defied in a `.yaml` property file, which takes precedence over a configuration defined in the `dbt_project.yml` file. (Note that generic tests work a little differently when it comes to specificity. See dbt's documentation on [test configs](https://docs.getdbt.com/reference/test-configs).)

## Materialisations

Materialisations are strategies for persisting dbt models in a warehouse. There are four types of materializations built into dbt. They are:

- [table](https://docs.getdbt.com/docs/build/materializations#table)
- [view](https://docs.getdbt.com/docs/build/materializations#view) ⚠️ not currently supported ⚠️
- [incremental](https://docs.getdbt.com/docs/build/materializations#incremental)
- [ephemeral](https://docs.getdbt.com/docs/build/materializations#ephemeral)
