# Project Structure

## 1-guide-overview
Projects in create-a-derived-table are structured slightly differently to how dbt recommends, we have also noticed that DBT's guidence changes over time. We have therefore taken their guidance from there website [here]
(https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview) and we have adapted it where appropriate. You will find that the guidance below will be mostly the same as that in the DBT repo, however this allows us to maintain our own style and structure guide.

Below is how we want projects structured. This is an overview of how the whole create-a-derived-table projet should look and in the following sections we will break down each layer.

```shell
├── mojap_derived_tables
  ├── dbt_project.yml
  └── models
      ├── sources # source domain
      │   ├── nomis.yaml
      │   ├── oasys_prod.yaml
      │   ├── delius_prod.yaml
      │   ├── xhibit_v1.yaml
      │   ...
      │ 
      ├── staging  # staging domain
      │   ├── stg_nomis
      │   │      ├── stg_nomis__docs.md
      │   │      ├── stg_nomis__models.yml
      │   │      ├── stg_nomis__offender.sql
      │   │      └── stg_nomis__prison.sql
      │   └── stg_xhibit
      │          ├── stg_xhibit__models.yml
      │          └── stg_xhibit__court.sql
      │
      ├── prison  # domain
      │   ├── prison_intermediate # database
      │   │      ├──intermediate_models
      │   │      ...
      │   ├── prison_dimensional_layer
      │   │
      │   ├── prison_mart
```

Given create-a-derived-table is continually being worked on and improved the guidance can change to incorporate the updates. This is the case now and will be the case in the future make sure to keep up to date with isucssions [here](). As a result of the evolving nature of create-a-derived-table there will continue to be reminants of previous best practices, over time these will be slowly adapted to be in-line with the current guidance.

## 2-staging
---
title: "Staging: Preparing our atomic building blocks"
id: 2-staging
description: Preparing our atomic building blocks.
displayText: Preparing our atomic building blocks.
hoverSnippet: Preparing our atomic building blocks.
---

The staging layer is where our journey begins. This is the foundation of our project, where we bring all the individual components we're going to use to build our more complex and useful models into the project.

We'll use an analogy for working with dbt throughout this guide: thinking modularly in terms of atoms, molecules, and more complex outputs like proteins or cells (we apologize in advance to any chemists or biologists for our inevitable overstretching of this metaphor). Within that framework, if our source system data is a soup of raw energy and quarks, then you can think of the staging layer as condensing and refining this material into the individual atoms we’ll later build more intricate and useful structures with.

### Staging: Files and folders

Let's zoom into the staging directory from our `models` file tree [in the overview](/best-practices/how-we-structure/1-guide-overview) and walk through what's going on here.

```shell
models/staging
├── stg_nomis
│   ├── stg_nomis__docs.md
│   ├── stg_nomis__models.yml
│   ├── stg_nomis__offender.sql
│   └── stg_nomis__prison.sql
└── stg_xhibit
    ├── stg_xhibit__models.yml
    └── stg_xhibit__court.sql
```

- **Folders.** Folder structure is extremely important in dbt. Not only do we need a consistent structure to find our way around the codebase, as with any software project, but our folder structure is also one of the key interfaces for understanding the knowledge graph encoded in our project (alongside the DAG and the data output into our warehouse). It should reflect how the data flows, step-by-step, from a wide variety of source-conformed models into fewer, richer business-conformed models. Moreover, we can use our folder structure as a means of selection in dbt [selector syntax](https://docs.getdbt.com/reference/node-selection/syntax). For example, with the above structure, if we got fresh Stripe data loaded and wanted to run all the models that build on our Stripe data, we can easily run `dbt build --select staging.stripe+` and we’re all set for building more up-to-date reports on payments.
  - ✅ **Subdirectories based on the source system**. Our internal transactional database is one system, the data we get from Stripe's API is another, and lastly the events from our Snowplow instrumentation. We've found this to be the best grouping for most companies, as source systems tend to share similar loading methods and properties between tables, and this allows us to operate on those similar sets easily.
  - ❌ **Subdirectories based on loader.** Some people attempt to group by how the data is loaded (Fivetran, Stitch, custom syncs), but this is too broad to be useful on a project of any real size.
  - ✅ **Subdirectories based on business grouping.** Dbt recommends against this practice, however crate-a-derved-table has been built in a way that necessitates domains as subdirectories so that we can control access through [data egineering database access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/database_access/create_a_derived_table). This is a key deviation from Dbt guidance.
- **File names.** Creating a consistent pattern of file naming is [crucial in dbt](https://docs.getdbt.com/blog/on-the-importance-of-naming). File names must be unique and correspond to the name of the model when selected and created in the warehouse. We recommend putting as much clear information into the file name as possible, including a prefix for the layer the model exists in, important grouping information, and specific information about the entity or transformation in the model.
  - ❌ `stg_[source]__[entity]s.sql` - ALthough it is recommended by DBT to follow this convention, where a double underscore is used between source system and entity, this will not work with create-a-derived-table. The naming convension in create-a-derived-table relies on the double underscore to distiguish between database and model names. Therefore, **you cannot use double underscores anywhere else in the name of a model**, this will result in an error when running the model. 
  - ❌ `stg_[entity].sql` - might be specific enough at first, but will break down in time. Adding the source system into the file name aids in discoverability, and allows understanding where a component model came from even if you aren't looking at the file tree.
  - ✅ **Plural.** SQL, and particularly SQL in dbt, should read as much like prose as we can achieve. We want to lean into the broad clarity and declarative nature of SQL when possible. As such, unless there’s a single order in your `orders` table, plural is the correct way to describe what is in a table with multiple rows.

### Staging: Models

Now that we’ve got a feel for how the files and folders fit together, let’s look inside one of these files and dig into what makes for a well-structured staging model.

Below, is an example of a standard staging model from one of our models (from `stg_stripe__payments` model) that illustrates the common patterns within the staging layer. We’ve organized our model into two <Term id='cte'>CTEs</Term>: one pulling in a source table via the [source macro](https://docs.getdbt.com/docs/build/sources#selecting-from-a-source) and the other applying our transformations.

Below we have chosen to order our fields in a way that is meaningful to the data that the models represents, the key here is that it is well organised. DBT recommends following the same order of variables for every model (something like ids, strings, numerics, boleans, dates and timesptamps), we have agreed that this does not alway work for how we work with the data. We therefore dont have a suggested order, only that we recommend there be some order to the feilds that is logical. We do recommend that your primary and foreign keys make up the first fields, then after that it is for you to decide.

```sql
-- stg_stripe__payments.sql

with

source as (

    select * from {{ source('common_platform_curated','payment') }}

),

renamed as (

    select
        -- ids
        id as payment_id,
        orderid as order_id,

        -- strings
        paymentmethod as payment_method,
        case
            when payment_method in ('stripe', 'paypal', 'credit_card', 'gift_card') then 'credit'
            else 'cash'
        end as payment_type,
        status,

        -- numerics
        amount as amount_cents,
        amount / 100.0 as amount,

        -- booleans
        case
            when status = 'successful' then true
            else false
        end as is_completed_payment,

        -- dates
        date_trunc('day', created) as created_date,

        -- timestamps
        created::timestamp_ltz as created_at

    from source

)

select * from renamed
```

```sql
-- stg_stripe__payments.sql

with

source as (

    select * from {{ source('stripe','payment') }}

),

renamed as (

    select
        -- ids
        id as payment_id,
        orderid as order_id,

        -- strings
        paymentmethod as payment_method,
        case
            when payment_method in ('stripe', 'paypal', 'credit_card', 'gift_card') then 'credit'
            else 'cash'
        end as payment_type,
        status,

        -- numerics
        amount as amount_cents,
        amount / 100.0 as amount,

        -- booleans
        case
            when status = 'successful' then true
            else false
        end as is_completed_payment,

        -- dates
        date_trunc('day', created) as created_date,

        -- timestamps
        created::timestamp_ltz as created_at

    from source

)

select * from renamed
```

- Based on the above, the most standard types of staging model transformations are:
  - ✅ **Renaming**
  - ✅ **Type casting**
  - ✅ **Basic computations** (e.g. cents to dollars)
  - ✅ **Categorizing** (using conditional logic to group values into buckets or booleans, such as in the `case when` statements above)
  - ❌ **Joins** — the goal of staging models is to clean and prepare individual source-conformed concepts for downstream usage. We're creating the most useful version of a source system table, which we can use as a new modular component for our project. In our experience, joins are almost always a bad idea here — they create immediate duplicated computation and confusing relationships that ripple downstream — there are occasionally exceptions though (refer to [base models](#staging-other-considerations) for more info).
  - ❌ **Aggregations** — aggregations entail grouping, and we're not doing that at this stage. Remember - staging models are your place to create the building blocks you’ll use all throughout the rest of your project — if we start changing the grain of our tables by grouping in this layer, we’ll lose access to source data that we’ll likely need at some point. We just want to get our individual concepts cleaned and ready for use, and will handle aggregating values downstream.
- ✅ **Materialized as views.** Looking at a partial view of our `dbt_project.yml` below, we can see that we’ve configured the entire staging directory to be materialized as <Term id='view'>views</Term>. As they’re not intended to be final artifacts themselves, but rather building blocks for later models, staging models should typically be materialized as views for two key reasons:

  - Any downstream model (discussed more in [marts](/best-practices/how-we-structure/4-marts)) referencing our staging models will always get the freshest data possible from all of the component views it’s pulling together and materializing
  - It avoids wasting space in the warehouse on models that are not intended to be queried by data consumers, and thus do not need to perform as quickly or efficiently

    ```yaml
    # dbt_project.yml
    mojap_derived_talbes:
      models:
          staging:
            +materialized: view
    ```

:::tip During development of a data model, it may be useful to materialise all you models as tables. This will allow you to easier debug issues. When you are ready to merge your work with main then you can change the materialisation back to view.
:::
 
- Staging models are the only place we'll use the [`source` macro](/docs/build/sources), and our staging models should have a 1-to-1 relationship to our source tables. That means for each source system table we’ll have a single staging model referencing it, acting as its entry point — _staging_ it — for use downstream.

:::tip Don’t Repeat Yourself.
Staging models help us keep our code <Term id='dry'>DRY</Term>. dbt's modular, reusable structure means we can, and should, push any transformations that we’ll always want to use for a given component model as far upstream as possible. This saves us from potentially wasting code, complexity, and compute doing the same transformation more than once. For instance, if we know we always want our monetary values as floats in dollars, but the source system is integers and cents, we want to do the division and type casting as early as possible so that we can reference it rather than redo it repeatedly downstream.
:::

This is a welcome change for many of us who have become used to applying the same sets of SQL transformations in many places out of necessity! For us, the earliest point for these 'always-want' transformations is the staging layer, the initial entry point in our transformation process. The DRY principle is ultimately the litmus test for whether transformations should happen in the staging layer. If we'll want them in every downstream model and they help us eliminate repeated code, they're probably okay.

### Staging: Other considerations

- **Base models when joins are necessary to stage concepts.** Sometimes, in order to maintain a clean and <Term id='dry'>DRY</Term> staging layer we do need to implement some joins to create a solid concept for our building blocks. In these cases, we recommend creating a sub-directory in the staging directory for the source system in question and building `base` models. These have all the same properties that would normally be in the staging layer, they will directly source the raw data and do the non-joining transformations, then in the staging models we’ll join the requisite base models. The most common use cases for building a base layer under a staging folder are:

  - ✅ **Joining in separate delete tables**. Sometimes a source system might store deletes in a separate table. Typically we’ll want to make sure we can mark or filter out deleted records for all our component models, so we’ll need to join these delete records up to any of our entities that follow this pattern. This is the example shown below to illustrate.

    ```sql
    -- base_jaffle_shop__customers.sql

    with

    source as (

        select * from {{ source('jaffle_shop','customers') }}

    ),

    customers as (

        select
            id as customer_id,
            first_name,
            last_name

        from source

    )

    select * from customers
    ```

    ```sql
    -- base_jaffle_shop__deleted_customers.sql

    with

    source as (

        select * from {{ source('jaffle_shop','customer_deletes') }}

    ),

    deleted_customers as (

        select
            id as customer_id,
            deleted as deleted_at

        from source

    )

    select * from deleted_customers
    ```

    ```sql
    -- stg_jaffle_shop__customers.sql

    with

    customers as (

        select * from {{ ref('base_jaffle_shop__customers') }}

    ),

    deleted_customers as (

        select * from {{ ref('base_jaffle_shop__deleted_customers') }}

    ),

    join_and_mark_deleted_customers as (

        select
            customers.*,
            case
                when deleted_customers.deleted_at is not null then true
                else false
            end as is_deleted

        from customers

        left join deleted_customers on customers.customer_id = deleted_customers.customer_id

    )

    select * from join_and_mark_deleted_customers
    ```

  - ✅ **Unioning disparate but symmetrical sources**. A typical example here would be if you operate multiple ecommerce platforms in various territories via a SaaS platform like Shopify. You would have perfectly identical schemas, but all loaded separately into your warehouse. In this case, it’s easier to reason about our orders if _all_ of our shops are unioned together, so we’d want to handle the unioning in a base model before we carry on with our usual staging model transformations on the (now complete) set — you can dig into [more detail on this use case here](https://discourse.getdbt.com/t/unioning-identically-structured-data-sources/921).

- **[Codegen](https://github.com/dbt-labs/dbt-codegen) to automate staging table generation.** It’s very good practice to learn to write staging models by hand, they’re straightforward and numerous, so they can be an excellent way to absorb the dbt style of writing SQL. Also, we’ll invariably find ourselves needing to add special elements to specific models at times — for instance, in one of the situations above that require base models — so it’s helpful to deeply understand how they work. Once that understanding is established though, because staging models are built largely following the same rote patterns and need to be built 1-to-1 for each source table in a source system, it’s preferable to start automating their creation. For this, we have the [codegen](https://github.com/dbt-labs/dbt-codegen) package. This will let you automatically generate all the source YAML and staging model boilerplate to speed up this step, and we recommend using it in every project.
- **Utilities folder.** While this is not in the `staging` folder, it’s useful to consider as part of our fundamental building blocks. The `models/utilities` directory is where we can keep any general purpose models that we generate from macros or based on seeds that provide tools to help us do our modeling, rather than data to model itself. The most common use case is a [date spine](https://github.com/dbt-labs/dbt-utils#date_spine-source) generated with [the dbt utils package](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/).

:::info Development flow versus DAG order.
This guide follows the order of the DAG, so we can get a holistic picture of how these three primary layers build on each other towards fueling impactful data products. It’s important to note though that developing models does not typically move linearly through the DAG. Most commonly, we should start by mocking out a design in a spreadsheet so we know we’re aligned with our stakeholders on output goals. Then, we’ll want to write the SQL to generate that output, and identify what tables are involved. Once we have our logic and dependencies, we’ll make sure we’ve staged all the necessary atomic pieces into the project, then bring them together based on the logic we wrote to generate our mart. Finally, with a functioning model flowing in dbt, we can start refactoring and optimizing that mart. By splitting the logic up and moving parts back upstream into intermediate models, we ensure all of our models are clean and readable, the story of our DAG is clear, and we have more surface area to apply thorough testing.
:::info

## 3-intermediate

## 4-marts

## 5-semantic-layer-marts

## 6-the-rest-of-the-project




The Create a Derived Table service should be used for creating tables with well defined use cases, like to serve a performance metric, publication, or MI report. This is because the _dbt project_ (`mojap_derived_tables`) is a shared space and so knowing where to put your work in the broader structure of the project is key. That's not to say you can't explore and experiment with dbt within the dbt project, there's a development envionment where you can try things out without having to worry about making a mess of things. More on that later.

## Domains

The primary consideration relating to project structure is understanding which domain the table you want to create belongs to. In Create a Derived Table a domain should correspond to some service area or core business concept and is used to logically group databases. Domains are not mutually exclusive so the same concepts can exist in different domains. A domain may be _'people'_ relating HR and corporate, or _'risk'_ relating to a justice system service user's safety, but it could be more or less granular if appropriate.

## Databases

The secondary consideration is whether the tables you are creating belong in an existing database, if they do, then this step is easy. If you need to create a new database then you'll need to decide which domain to put it in. It's also possible to define a database across multiple domains. For example, a number of tables within your database might sit within 'domain a' while the rest sit in 'domain b'. This approach has the benefit of keeping all tables logically grouped within one database but will result in access to those tables being limited by the domain.

## Standard directory structure and naming conventions

The following is an example of how a team might build a data model whilst adhearing to the standard dbt project directory structure required to work with Create a Derived Table. The Prison Safety and Security team have created a database called `prison_safety_and_security` in the `security` domain.

- From the `mojap_derived_tables` dbt project, the hierarchy of directories must follow `models` -> `domain` -> `database`. The directory structure after this is arbitrary and can be chosen to suit your needs. However, we do recommend that you arrange your models into data marts and suffix your models with descriptions (this will be discussed in more detail).
- Directory and file names should only use snake case, as in, `no-hyphens-like-this`, `just_underscores_like_this`.
- Models (`.sql` files) must be named by the database and table they relate to separated by double underscores, i.e., `<database_name>__<table_name>.sql`. This is because all models in the `models` directory must have a unique name.
- Suffixes should be added that describe each model's purpose.
  - Fact and dimension models should be suffixed with `_fct` and `_dim` respectively.
  - Intermediate models should be suffixed with the main transformation being applied in past tense, e.g., `_grouped` or `_left_joined`.
- You may want to arrange staging models into a specific staging database, or within a single database for all your tables.
  - Staging models should be suffixed with `_stg` unless built into a specific staging database.
- Fact, dimension, and staging models must have their own property file that has the same filename as the model they define properties for.
- Intermediate models should have a single configuration file named `properties.yaml`.
- Seed property files must have the same filename as the seed they define properties for.

If you have ideas about how you would like to structure your data model, please get in touch as we'd love to hear from you to help guide best practice principles.

```
├── mojap_derived_tables
  ├── dbt_project.yml
  └── models
      ├── sources
      │   ├── nomis.yaml
      │   ├── oasys_prod.yaml
      │   ├── delius_prod.yaml
      │   ├── xhibit_v1.yaml
      │   ...
      ├── security  # domain
      │   ├── prison_safety_and_security  # database
      │   │   ├── marts
      │   │   │   ├── intermediate
      │   │   │   │   ├── prison_safety_and_security__inc_ids_grouped.sql  # intermediate table
      │   │   │   │   ├── prison_safety_and_security__questions_filtered.sql  # intermediate table
      │   │   │   │   ├── prison_safety_and_security__question_set_joined.sql  # intermediate table
      │   │   │   │   └── properties.yaml  # intermediate tables property file
      │   │   │   └── question_answers  # arbitrary grouping
      │   │   │       ├── prison_safety_and_security__dates_dim.sql  # dimension table
      │   │   │       ├── prison_safety_and_security__dates_dim.yaml  # table property file
      │   │   │       ├── prison_safety_and_security__incidents_fct.sql  # fact table
      │   │   │       ├── prison_safety_and_security__incidents_fct.yaml  # table property file
      │   │   │       ├── prison_safety_and_security__question_answer_fct.sql  # fact table
      │   │   │       └── prison_safety_and_security__question_answer_fct.yaml  # table property file
      │   │   └── staging
      │   │       ├── prison_safety_and_security__nomis_mod_stg.md  # markdown to be rendered in documentation
      │   │       ├── prison_safety_and_security__nomis_mod_stg.sql  # staging table
      │   │       └── prison_safety_and_security__nomis_mod_stg.yaml  # table property file
```

## Data modelling

Data modelling is hard, so if the considerations about domains, databases, or data model structures aren't clear, reach out to the [data modelling team](https://asdslack.slack.com/archives/C03J21VFHQ9) and we'll do our best to help you out.

<br />