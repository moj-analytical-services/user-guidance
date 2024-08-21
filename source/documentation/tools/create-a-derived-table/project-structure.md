# Project Structure

last updated: 23/07/2024
dbt best practices version: [v1.7](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview)

# How we structure our create-a-derived-table projects

## 1-guide-overview

This guide aims to provide consistency in how our projects in create-a-derived-table are structured - in terms of folders, files and naming - all of which are related to how we structure our transformations.

As a group of Analytics Engineers, we have thoroughly reviewed guidance published by dbt (the technology behind create-a-derived-table) and adapted it to suit our needs in this guide.

Please take the time to familiarise yourself with this project structure guide, and our style guidance [add link], before starting projects in create-a-derived-table.


## Domains

The primary consideration relating to project structure is understanding which domain the table you want to create belongs to. In create-a-derived-table a domain should correspond to some service area or core business concept and is used to logically group databases. Domains are not mutually exclusive so the same concepts can exist in different domains. A domain may be _'people'_ relating HR and corporate, or _'risk'_ relating to a justice system service user's safety, but it could be more or less granular if appropriate.

## Databases

The secondary consideration is whether the tables you are creating belong in an existing database, if they do, then this step is easy. If you need to create a new database then you'll need to decide which domain to put it in. It's also possible to define a database across multiple domains. For example, a number of tables within your database might sit within 'domain a' while the rest sit in 'domain b'. This approach has the benefit of keeping all tables logically grouped within one database but will result in access to those tables being limited by the domain.

## Standard directory structure and naming conventions

The following is an example of how a team might build a data model whilst adhering to the standard dbt project directory structure required to work with create-a-derived-table. The Prison Safety and Security team have created a database called `prison_safety_and_security` in the `security` domain.

- From the `mojap_derived_tables` dbt project, the hierarchy of directories must follow `models` -> `domain` -> `database`. The directory structure after this is arbitrary and can be chosen to suit your needs. However, we do recommend that you arrange your models into logical folders to make it easier for users to understand the code.
- Models (`.sql` files) must be named by the database and table they relate to separated by double underscores, i.e., `<database_name>__<table_name>.sql`. This is because all models in the `models` directory must have a unique name..
- **All** staging models should live in the `staging` domain regardless of business / service area. This is to maintain visibility of the data being used on create-a-derived-table. Access should be given to databases within the staging domain, not the domain itself. 

Below is an overview of the whole create-a-derived-table folder structure. In the following sections we will go through each layer, covering in detail how we expect your project structure to look and our reasoning. 

```shell
├── mojap_derived_tables
  ├── dbt_project.yml
  └── models
      ├── sources # source domain
      │   ├── nomis.yaml # model
      │   ├── oasys_prod.yaml
      │   ├── delius_prod.yaml
      │   ├── xhibit_v1.yaml
      │   ...
      │ 
      ├── staging  # staging domain
      │   ├── stg_nomis # database
      │   │      ├── stg_nomis__docs.md # model
      │   │      ├── stg_nomis__models.yml
      │   │      ├── stg_nomis__offender.sql
      │   │      └── stg_nomis__prison.sql
      │   └── stg_xhibit
      │          ├── stg_xhibit__models.yml
      │          └── stg_xhibit__court.sql
      ├── courts
      │   ├── court_intermediate
      │   │
      │   ├── court_dimensional_layer
      │
      ├── prison  # domain
      │   ├── prison_intermediate # database
      │   │      ├──intermediate_models # model
      │   │      ...
      │   ├── prison_dimensional_layer
      │   │
      │   ├── prison_mart
```

Data modelling is hard, so if the considerations about domains, databases, or data model structures aren't clear - if you're unsure, reach out to the [data modelling team](https://asdslack.slack.com/archives/C03J21VFHQ9) and we'll do our best to help.

Please note that the use of create-a-derived-table has evolved over time, and best practices change, the reality of our project may be out of sync with the best practices stated here. 

## 2-staging

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

- **Folders.** Folder structure is extremely important in dbt. Not only do we need a consistent structure to find our way around the codebase, as with any software project, but our folder structure is also one of the key interfaces for understanding the knowledge graph encoded in our project (alongside the DAG and the data output into our warehouse). It should reflect how the data flows, step-by-step, from a wide variety of source-conformed models into fewer, richer business-conformed models. Moreover, we can use our folder structure as a means of selection in dbt [selector syntax](https://docs.getdbt.com/reference/node-selection/syntax). For example, with the above structure, if we got fresh xhibit data loaded and wanted to run all the models that build on our xhibit data, we can easily run `dbt build --select staging/xhibit_stg+` and we’re all set for building more up-to-date reports on payments.
  - ✅ **Subdirectories based on the source system**. Our internal transactional database is one system, the data we get from Stripe's API is another, and lastly the events from our Snowplow instrumentation. We've found this to be the best grouping for most companies, as source systems tend to share similar loading methods and properties between tables, and this allows us to operate on those similar sets easily.
  - ❌ **Subdirectories based on loader.** Some people attempt to group by how the data is loaded (Fivetran, Stitch, custom syncs), but this is too broad to be useful on a project of any real size.
  - ✅ **Subdirectories based on business grouping.** dbt recommends against this practice, however crate-a-derived-table has been built in a way that necessitates domains as subdirectories so that we can control access through [data egineering database access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/database_access/create_a_derived_table). This is a key deviation from dbt guidance.
- **File names.** Creating a consistent pattern of file naming is [crucial in dbt](https://docs.getdbt.com/blog/on-the-importance-of-naming). File names must be unique and correspond to the name of the model when selected and created in the warehouse. We recommend putting as much clear information into the file name as possible, including a prefix for the layer the model exists in, important grouping information, and specific information about the entity or transformation in the model.
  - ❌ `stg_[source]__[entity]s.sql` - Although it is recommended by dbt to follow this convention, where a double underscore is used between source system and entity, this will not work with create-a-derived-table. The naming convention in create-a-derived-table relies on the double underscore to distiguish between database and model names. Therefore, **you cannot use double underscores anywhere else in the name of a model**, this will result in an error when running the model. 
  - ❌ `stg_[entity].sql` - might be specific enough at first, but will break down in time. Adding the source system into the file name aids in discoverability, and allows understanding where a component model came from even if you aren't looking at the file tree.
  - ❌**Plural.** dbt's stance is that SQL, and particularly SQL in dbt, should read as much like prose as we can achieve. As such, it is suggested that unless there’s a single order in your `orders` table, plural is the correct way to describe what is in a table with multiple rows. While we agree with this approach for analyst-facing models downstream, we believe the value in maintaining the exact naming of source tables for curation purposes outweighs a technical improvement in readability for back-end models.'

### Staging: Models

Now that we’ve got a feel for how the files and folders fit together, let’s look inside one of these files and dig into what makes for a well-structured staging model.

Below, is an example of a standard staging model from one of our models (from `sop_finance_stg__hmpps_general_ledger` model) that illustrates the common patterns within the staging layer. We’ve organized our model into two <Term id='cte'>CTEs</Term>: one pulling in a source table via the [source macro](https://docs.getdbt.com/docs/build/sources#selecting-from-a-source) and the other applying our transformations.

Here we have ordered the fields based on their type, however, you may decide to order your columns differently. See our style guide [link](link to our style guide.) for more details on how you should style your models.

```sql
-- sop_finance_stg__hmpps_general_ledger.sql
source as (

    select * from {{ source('sop_finance_stg', 'hmpps_general_ledger') }}

),

renamed as (

    select

        ----------  ids
        {{ dbt_utils.generate_surrogate_key(
          ['id', 
          'a_id', ]) }} as unique_id, -- primary key
        id as cost_centre_id, -- natural key
        a_id as analysis_code_id,
        objective as cobjective_code_id,

        ---------- strings
        extract_version

        ---------- numerics
        cast(debit_amount / 100.0) as float) as debit_amount,
        cast(credit_amount / 100.0) as float) as credit_amount,
        cast(total_amount / 100.0) as float) as total_amount,
        ---------- booleans
        is_recoverable,

        ---------- dates
        date(paid_date) as paid_date,

        ---------- timestamps
        transction_at

    from source

)

select * from renamed
```

- Based on the above, the most standard types of staging model transformations are:
  - ✅ **Renaming**
  - ✅ **Type casting**
  - ✅ **Basic computations** (e.g. cents to dollars)
  - ✅ **Categorizing** (using conditional logic to group values into buckets or booleans, such as in the `case when` statements above)
  - ✅ **Generating keys** Create unique surrogate keys using the dbt utils function `dbt_utils.generate_surrogate_key(`
  - ❌ **Joins** — the goal of staging models is to clean and prepare individual source-conformed concepts for downstream usage. We're creating the most useful version of a source system table, which we can use as a new modular component for our project. In our experience, joins are almost always a bad idea here — they create immediate duplicated computation and confusing relationships that ripple downstream — there are occasionally exceptions though (refer to [base models](#staging-other-considerations) for more info).
  - ❌ **Aggregations** — aggregations entail grouping, and we're not doing that at this stage. Remember - staging models are your place to create the building blocks you’ll use all throughout the rest of your project — if we start changing the grain of our tables by grouping in this layer, we’ll lose access to source data that we’ll likely need at some point. We just want to get our individual concepts cleaned and ready for use, and will handle aggregating values downstream.
- ✅ **Materialized as views.** Looking at a partial view of our `dbt_project.yml` below, we can see that we’ve configured the entire staging directory to be materialized as <Term id='view'>views</Term>. As they’re not intended to be final artifacts themselves, but rather building blocks for later models, staging models should typically be materialized as views for two key reasons:

  - Any downstream model (discussed more in [marts](/best-practices/how-we-structure/4-marts)) referencing our staging models will always get the freshest data possible from all of the component views it’s pulling together and materialising
  - It avoids wasting space in the warehouse on models that are not intended to be queried by data consumers, and thus do not need to perform as quickly or efficiently

    ```yaml
    # dbt_project.yml
    mojap_derived_talbes:
      models:
          staging:
            +materialized: view
    ```

:::tip During development of a data model, it may be useful to materialise all your models as tables. This will allow you to more easily debug issues. When you are ready to merge your work with main then you can change the materialisation back to view.
:::
 
- Staging models are the only place we'll use the [`source` macro](/docs/build/sources), and our staging models should have a 1-to-1 relationship to our source tables. That means for each source system table we’ll have a single staging model referencing it, acting as its entry point — _staging_ it — for use downstream.

- In MOJ many of our source datasets are 'curated tables' materialised by data engineers using Create-A-Derived-Table. This means instead of using the standard source macro to pull data into our staging models, we should employ the transform_table.ref_on_prod macro.

```
-- stg_delius__address.sql

with

source as (

    select * from {{ transform_table.ref_on_prod('delius__address') }}

)

select * from source
```

In the dev environment (local runs / PR actions) [ref_on_prod](https://github.com/moj-analytical-services/create-a-derived-table/blob/main/transform_table/macros/utils/ref_on_prod.sql_) macro operates equivalent to sourcing, meaning we don't need to rebuild the whole upstream pipeline to run our dependencies nor define curated models as sources. Conversely - and as the name suggests - in prod the macro [refs](https://docs.getdbt.com/reference/dbt-jinja-functions/ref) the curated model; this allows dbt to build an appropriate dependency graph as part of the production deployment.

:::tip Don’t Repeat Yourself.
Staging models help us keep our code <Term id='dry'>DRY</Term>. dbt's modular, reusable structure means we can, and should, push any transformations that we’ll always want to use for a given component model as far upstream as possible. This saves us from potentially wasting code, complexity, and compute doing the same transformation more than once. For instance, if we know we always want our monetary values as floats in dollars, but the source system is integers and cents, we want to do the division and type casting as early as possible so that we can reference it rather than redo it repeatedly downstream.
:::

We have decided to split all staging models into their own staging domain for several reasons. First, this creates a clear separation from the source data and the derived downstream models using that data. We do not want to silo the data too early, sources are not always domain aligned, we want to allow for different domains to use the same staging models. This brings us to a key point, all downstream models using data from the same source should use the same staging models. This reduce duplication of work and data stored in the data warehouse. It also ensures that those downstream models that do use the same source data will diverge at the latest possible point and therefore reducing differences in the data.

This is a welcome change for many of us who have become used to applying the same sets of SQL transformations in many places out of necessity! For us, the earliest point for these 'always-want' transformations is the staging layer, the initial entry point in our transformation process. The DRY principle is ultimately the litmus test for whether transformations should happen in the staging layer. If we'll want them in every downstream model and they help us eliminate repeated code, they're probably okay.

### Staging: Other considerations

- **Base models when joins are necessary to stage concepts.** Sometimes, in order to maintain a clean and <Term id='dry'>DRY</Term> staging layer we do need to implement some joins to create a solid concept for our building blocks. In these cases, we recommend creating a sub-directory in the staging directory for the source system in question and building `base` models. These have all the same properties that would normally be in the staging layer, they will directly source the raw data and do the non-joining transformations, then in the staging models we’ll join the requisite base models. The most common use cases for building a base layer under a staging folder are:

  - ✅ **Joining in separate delete tables**. Sometimes a source system might store deletes in a separate table. Typically we’ll want to make sure we can mark or filter out deleted records for all our component models, so we’ll need to join these delete records up to any of our entities that follow this pattern. This is the example shown below to illustrate.

    ```sql
    -- base_xhibit_curated__defendant.sql

    with

    source as (

        select * from {{ source('xhibit_curated','defendant') }}

    ),

    customers as (

        select
            id as defendant_id,
            first_name,
            last_name,
            dob as date_of_birth

        from source

    )

    select * from customers
    ```

    ```sql
    -- base_xhibit_curated__deleted_defndants.sql

    with

    source as (

        select * from {{ source('xhibit_curated','deleted_defendant') }}

    ),

    deleted_defendants as (

        select
            id as defendant_id,
            deleted as deleted_at

        from source

    )

    select * from deleted_defendants
    ```

    ```sql
    -- stg_xhibit_curated__defendants.sql

    with

    customers as (

        select * from {{ ref('base_xhibit_curated__defendant') }}

    ),

    deleted_customers as (

        select * from {{ ref('base_xhibit_curated__deleted_defndants') }}

    ),

    join_and_mark_deleted_defendants as (

        select
            defendants.*,
            case
                when deleted_defendants.deleted_at is not null then true
                else false
            end as is_deleted

        from defendants

        left join deleted_defendants on defendants.defendants_id = deleted_defendants.defendants_id

    )

    select * from join_and_mark_deleted_defendants
    ```

  - ✅ **Unioning disparate but symmetrical sources**. A typical example here would be if you operate multiple ecommerce platforms in various territories via a SaaS platform like Shopify. You would have perfectly identical schemas, but all loaded separately into your warehouse. In this case, it’s easier to reason about our orders if _all_ of our shops are unioned together, so we’d want to handle the unioning in a base model before we carry on with our usual staging model transformations on the (now complete) set — you can dig into [more detail on this use case here](https://discourse.getdbt.com/t/unioning-identically-structured-data-sources/921).
  - ✅ Denormalising source tables of the same grain and concept (e.g. reference tables)

- **[Codegen](https://github.com/dbt-labs/dbt-codegen) to automate staging table generation.** It’s very good practice to learn to write staging models by hand, they’re straightforward and numerous, so they can be an excellent way to absorb the dbt style of writing SQL. Also, we’ll invariably find ourselves needing to add special elements to specific models at times — for instance, in one of the situations above that require base models — so it’s helpful to deeply understand how they work. Once that understanding is established though, because staging models are built largely following the same rote patterns and need to be built 1-to-1 for each source table in a source system, it’s preferable to start automating their creation. For this, we have the [codegen](https://github.com/dbt-labs/dbt-codegen) package. This will let you automatically generate all the source YAML and staging model boilerplate to speed up this step, and we recommend using it in every project.
- **Utilities folder.** While this is not in the `staging` folder, it’s useful to consider as part of our fundamental building blocks. The `models/utilities` directory is where we can keep any general purpose models that we generate from macros or based on seeds that provide tools to help us do our modeling, rather than data to model itself. The most common use case is a [date spine](https://github.com/dbt-labs/dbt-utils#date_spine-source) generated with [the dbt utils package](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/).

:::info Development flow versus DAG order.
This guide follows the order of the DAG, so we can get a holistic picture of how these three primary layers build on each other towards fueling impactful data products. It’s important to note though that developing models does not typically move linearly through the DAG. Most commonly, we should start by mocking out a design in a spreadsheet so we know we’re aligned with our stakeholders on output goals. Then, we’ll want to write the SQL to generate that output, and identify what tables are involved. Once we have our logic and dependencies, we’ll make sure we’ve staged all the necessary atomic pieces into the project, then bring them together based on the logic we wrote to generate our mart. Finally, with a functioning model flowing in dbt, we can start refactoring and optimizing that mart. By splitting the logic up and moving parts back upstream into intermediate models, we ensure all of our models are clean and readable, the story of our DAG is clear, and we have more surface area to apply thorough testing.
:::info

## 3-intermediate

Once we’ve got our atoms ready to work with, we’ll set about bringing them together into more intricate, connected molecular shapes. The intermediate layer is where these molecules live, creating varied forms with specific purposes on the way towards the more complex proteins and cells we’ll use to breathe life into our data products.

### Intermediate: Files and folders

Let’s take a look at the intermediate layer of our project to understand the purpose of this stage more concretely.

```shell
models
└── courts
    └── courts_intermediate
        ├── courts_intermediate__properties.yml
        └── courts_intermediate__int_xhibit_and_common_platform_receipts_unioned.sql
```

- **Folders**
  - ✅ **Subdirectories based on business groupings.** Much like the staging layer, we’ll house this layer of models inside their own `intermediate` database. Unlike the staging layer, here we shift towards being business-conformed, splitting our models up into subdirectories not by their source system, but by their area of business concern.
- **File names**
  - ✅ `int_[entity]s_[verb]s.sql` - the variety of transformations that can happen inside of the intermediate layer makes it harder to dictate strictly how to name them. The best guiding principle is to think about _verbs_ (e.g. `pivoted`, `aggregated_to_user`, `joined`, `fanned_out_by_quantity`, `funnel_created`, etc.) in the intermediate layer. In our example project, we use an intermediate model to pivot payments out to the order grain, so we name our model `int_payments_pivoted_to_orders`. It’s easy for anybody to quickly understand what’s happening in that model, even if they don’t know [SQL](https://mode.com/sql-tutorial/). That clarity is worth the long file name. 
  - ✅ `[database_name]__int_[entity]s_[verb]s.sql` - create-a-derived-table requires us to include the database in all model names, or if `int_[entity]s` is the database name then `int_[entity]s__[verb]s.sql`. Due to this requirement, **you cannot use double underscores anywhere else in your filenames**.

:::tip Don’t over-optimize too early!
The example project is very simple for illustrative purposes. This level of division in our post-staging layers is probably unnecessary when dealing with these few models. Remember, our goal is a _single_ _source of truth._ If two teams of analysts both have questions about counts of criminal court cases, we want them to be drawing upon the same data table(s), we want to use our dbt project as a means to bring those definitions together! As such, don’t split and optimize too early. If you have less than 10 marts models and aren’t having problems developing and using them, feel free to forego subdirectories completely (except in the staging layer, where you should always implement them as you add new source systems to your project) until the project has grown to really need them. Using dbt is always about bringing simplicity to complexity.
:::

### Intermediate: Models

Below is the lone intermediate model from our small example project. This represents an excellent use case per our principles above, serving a clear single purpose: grouping and pivoting a staging model to different grain. It utilizes a bit of Jinja to make the model DRY-er (striving to be DRY applies to the code we write inside a single model in addition to transformations across the codebase), but don’t be intimidated if you’re not quite comfortable with [Jinja](/docs/build/jinja-macros) yet. Looking at the name of the <Term id="cte">CTE</Term>, `pivot_and_aggregate_payments_to_order_grain` we get a very clear idea of what’s happening inside this block. By descriptively labeling the transformations happening inside our CTEs within model, just as we do with our files and folders, even a stakeholder who doesn’t know SQL would be able to grasp the purpose of this section, if not the code. As you begin to write more complex transformations moving out of the staging layer, keep this idea in mind. In the same way our models connect into a DAG and tell the story of our transformations on a macro scale, CTEs can do this on a smaller scale inside our model files.

```sql
-- int_payments_pivoted_to_orders.sql

{%- set payment_methods = ['bank_transfer','credit_card','coupon','gift_card'] -%}

with

payments as (

   select * from {{ ref('stg_stripe__payments') }}

),

pivot_and_aggregate_payments_to_order_grain as (

   select
      order_id,
      {% for payment_method in payment_methods -%}

         sum(
            case
               when payment_method = '{{ payment_method }}' and
                    status = 'success'
               then amount
               else 0
            end
         ) as {{ payment_method }}_amount,

      {%- endfor %}
      sum(case when status = 'success' then amount end) as total_amount

   from payments

   group by 1

)

select * from pivot_and_aggregate_payments_to_order_grain
```

- ❌ **Exposed to end users.** Intermediate models should generally not be exposed in the main production schema. They are not intended for output to final targets like dashboards or applications, so it’s best to keep them separated from models that are so you can more easily control data governance and discoverability.
- ✅ **Materialized ephemerally.** Considering the above, one popular option is to default to intermediate models being materialized [ephemerally](/docs/build/materializations#ephemeral). This is generally the best place to start for simplicity. It will keep unnecessary models out of your warehouse with minimum configuration. Keep in mind though that the simplicity of ephemerals does translate a bit more difficulty in troubleshooting, as they’re interpolated into the models that `ref` them, rather than existing on their own in a way that you can view the output of.
- ✅ **Materialized as views in a custom schema with special permissions.** A more robust option is to materialize your intermediate models as views in a specific [custom schema](/docs/build/custom-schemas), outside of your main production schema. This gives you added insight into development and easier troubleshooting as the number and complexity of your models grows, while remaining easy to implement and taking up negligible space.

:::tip Keep your warehouse tidy!
There are three interfaces to the organisational knowledge graph we’re encoding into dbt: the DAG, the files and folder structure of our codebase, and the output into the warehouse. As such, it’s really important that we consider that output intentionally! Think of the schemas, tables, and views we’re creating in the warehouse as _part of the UX,_ in addition to the dashboards, ML, apps, and other use cases you may be targeting for the data. Ensuring that our output is named and grouped well, and that models not intended for broad use are either not materialised or built into special areas with specific permissions is crucial to achieving this.
:::

- Intermediate models’ purposes, as these serve to break up complexity from our marts models, can take as many forms as [data transformation](https://www.getdbt.com/analytics-engineering/transformation/) might require. Some of the most common use cases of intermediate models include:

  - ✅ **Structural simplification.** Bringing together a reasonable number (typically 4 to 6) of entities or concepts (staging models, or perhaps other intermediate models) that will be joined with another similarly purposed intermediate model to generate a mart — rather than have 10 joins in our mart, we can join two intermediate models that each house a piece of the complexity, giving us increased readability, flexibility, testing surface area, and insight into our components.
  - ✅ **Re-graining.** Intermediate models are often used to fan out or collapse models to the right composite grain — if we’re building a mart for `order_items` that requires us to fan out our `orders` based on the `quantity` column, creating a new single row for each item, this would be ideal to do in a specific intermediate model to maintain clarity in our mart and more easily view that our grain is correct before we mix it with other components.
  - ✅ **Isolating complex operations.** It’s helpful to move any particularly complex or difficult to understand pieces of logic into their own intermediate models. This not only makes them easier to refine and troubleshoot, but simplifies later models that can reference this concept in a more clearly readable way. For example, in the `quantity` fan out example above, we benefit by isolating this complex piece of logic so we can quickly debug and thoroughly test that transformation, and downstream models can reference `order_items` in a way that’s intuitively easy to grasp.
  - ✅ **Creating a dbt `Relation` object.** dbt packages such as [dbt-utils](https://github.com/dbt-labs/dbt-utils) often require reference to a dbt [Relation](https://docs.getdbt.com/reference/dbt-classes#relation). Intermediate models can be used to materialise a `Relation` to input specific data into a downstream macro.

:::tip Narrow the DAG, widen the tables.
Until we get to the marts layer and start building our various outputs, we ideally want our DAG to look like an arrowhead pointed right. As we move from source-conformed to business-conformed, we’re also moving from numerous, narrow, isolated concepts to fewer, wider, joined concepts. We’re bringing our components together into wider, richer concepts, and that creates this shape in our DAG. This way when we get to the marts layer we have a robust set of components that can quickly and easily be put into any configuration to answer a variety of questions and serve specific needs. One rule of thumb to ensure you’re following this pattern on an individual model level is allowing multiple _inputs_ to a model, but **not** multiple _outputs_. Several arrows going _into_ our post-staging models is great and expected, several arrows coming _out_ is a red flag. There are absolutely situations where you need to break this rule, but it’s something to be aware of, careful about, and avoid when possible.
:::

## 4-marts

This is where everything comes together and we start to arrange all of our atoms (staging models) and molecules (intermediate models) into full-fledged cells that have identity and purpose. Marts are meant to represent a specific entity or concept at its unique grain. For instance, an order, a customer, a territory, a click event, a payment — each of these would be represented with a distinct mart, and each row would represent a discrete instance of these concepts.

### Marts: Files and folders

```shell
models/prison
├── prisons_modelled
│   ├── _prisons_modelled__models.yml
│   ├── prisons_modelled__fct_releases.sql
│   ├── prisons_modelled__dim_offenders.sql
│   ├── prisons_modelled__dim_prisons.sql
└── parole_board
    ├── _parole_board__models.yml
    └── parole_board__cases.sql
    └── parole_board__directions.sql
```

✅ **Facts, dimensions & flat-files.** Our analysis-ready tables are grouped into two distinct layers: the **‘conformed’ layer** consisting of fact and dimension tables developed by analytics engineers to serve a range of business needs; and a **‘marts’ layer** featuring fully denormalised tables for specific use cases. In Create A Derived Table these layers are represented as separate databases within each domain directory, example above.

- **fct_<verb>**: Fact tables are tall, narrow tables representing real-world processes that have occurred or are occurring. The heart of these models is usually an immutable event stream: sessions, transactions, orders, stories, votes.
- **dim_<noun>**: Dimension tables are wide, short tables where each row is a person, place, or thing; the ultimate source of truth when identifying and describing entities of the organisation. They are mutable, though slowly changing: customers, products, candidates, buildings, employees.
- **Marts** tend to be wide, dense tables, the result of joining facts and dimensions into a single table readymade for a particular analysis. In modern data warehousing — where storage is cheap and compute is expensive — we can borrow and add any and all data from dimensional concepts to answer questions about core entities. Building the same data in multiple places is more efficient in this paradigm than having to repeatedly rejoin these concepts in the dimensional layer.

✅ **Group by domain or area of concern.** If you have fewer than 10 or so marts you may not have much need for subfolders, so as with the intermediate layer, don’t over-optimise too early. If you do find yourself needing to insert more structure and grouping though, use useful business concepts here. We’re no longer worried about source-conformed data, so grouping by domains (criminal courts, finance, etc.) is the most common structure at this stage.

✅ **Name by entity.** Use plain English to name the file based on the concept that forms the grain of the mart `sentences`, `offenders`. Note that for pure marts, there should not be a time dimension (`orders_per_day`) here, that is typically best captured via metrics.

❌ **Build the same concept differently for different teams.** `finance_orders` and `marketing_orders` is typically considered an anti-pattern. There are, as always, exceptions — a common pattern we see is that, finance may have specific needs, for example reporting revenue to the government in a way that diverges from how the company as a whole measures revenue day-to-day. Just make sure that these are clearly designed and understandable as _separate_ concepts, not departmental views on the same concept: `tax_revenue` and `revenue` not `finance_revenue` and `marketing_revenue`.

### Complete Enterprise Data Warehouse approach using Create a Derived Table

![data-flow-diagram excalidraw](https://github.com/user-attachments/assets/3dfc54d7-e304-4e48-b06d-c0dddad40503)

### Marts: Models

Finally we’ll take a look at the best practices for models within the marts directory by examining two example marts models. These are the business-conformed — that is, crafted to our vision and needs — entities we’ve been bringing these transformed components together to create.

```sql
-- fct_orders.sql

with

orders as  (

    select * from {{ ref('stg_jaffle_shop__orders' )}}

),

order_payments as (

    select * from {{ ref('int_payments_pivoted_to_orders') }}

),

orders_and_order_payments_joined as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.total_amount, 0) as amount,
        coalesce(order_payments.gift_card_amount, 0) as gift_card_amount

    from orders

    left join order_payments on orders.order_id = order_payments.order_id

)

select * from orders_and_payments_joined
```

```sql
-- customer_orders.sql

with

customers as (

    select * from {{ ref(‘dim_customers‘)}}

),

orders as (

    select * from {{ ref(‘fct_orders‘)}}

),

customer_orders as (

    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value

    from orders

    group by 1

),

customers_and_customer_orders_joined as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value

    from customers

    left join customer_orders on customers.customer_id = customer_orders.customer_id

)

select * from customers_and_customer_orders_joined
```

- ✅ **Materialised as tables or incremental models.** Once we reach the marts layer, it’s time to start building not just our logic into the warehouse, but the data itself. This gives end users much faster performance for these later models that are actually designed for their use, and saves us costs recomputing these entire chains of models every time somebody refreshes a dashboard or runs a regression in python. A good general rule of thumb regarding materialisation is to always start with a view (as it takes up essentially no storage and always gives you up-to-date results), once that view takes too long to practically _query_, build it into a table, and finally once that table takes too long to _build_ and is slowing down your runs, [configure it as an incremental model](https://docs.getdbt.com/docs/build/incremental-models/). As always, start simple and only add complexity as necessary. The models with the most data and compute-intensive transformations should absolutely take advantage of dbt’s incremental materialization options, but rushing to make all your marts models incremental by default will introduce superfluous difficulty. We recommend reading this [post on the limits of incremental modelling](https://discourse.getdbt.com/t/on-the-limits-of-incrementality/303).
- ❌ **Too many joins in one mart.** One good rule of thumb when building dbt transformations is to avoid bringing together too many concepts in a single mart. What constitutes ‘too many’ can vary. If you need to bring 8 staging models together with nothing but simple joins, that might be fine. Conversely, if you have 4 concepts you’re weaving together with some complex and computationally heavy window functions, that could be too much. You need to weigh the number of models you’re joining against the complexity of the logic within the mart, and if it’s too much to read through and build a clear mental model of then look to modularise. While this isn’t a hard rule, if you’re bringing together more than 4 or 5 concepts to create your mart, you may benefit from adding some intermediate models for added clarity. Two intermediate models that bring together three concepts each, and a mart that brings together those two intermediate models, will typically result in a much more readable chain of logic than a single mart with six joins.
- ✅ **Build on separate marts thoughtfully.** While we strive to preserve a narrowing DAG up to the marts layer, once here things may start to get a little less strict. A common example is passing information between marts at different grains, for example, to aggregate data into the grain of another mart. Now that we’re really ‘spending’ compute and storage by actually building the data in our outputs, it’s sensible to leverage previously built resources to speed up and save costs on outputs that require similar data, versus recomputing the same views and CTEs from scratch. The right approach here is heavily dependent on your unique DAG, models, and goals — it’s just important to note that using a mart in building another, later mart is okay, but requires careful consideration to avoid wasted resources or circular dependencies.

### Marts: Other considerations

- **Troubleshoot via tables.** While stacking views and ephemeral models up until our marts — only building data into the warehouse at the end of a chain when we have the models we really want end users to work with — is ideal in production, it can present some difficulties in development. Particularly, certain errors may seem to be surfacing in our later models that actually stem from much earlier dependencies in our model chain (ancestor models in our DAG that are built before the model throws the errors). If you’re having trouble pinning down where or what a database error is telling you, it can be helpful to temporarily build a specific chain of models as tables so that the warehouse will throw the error where it’s actually occurring.

## 5-semantic-layer-marts

## 6-the-rest-of-the-project



--------------


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

## Pull-request check list

Every pull request to merge a branch with the main branch in create-a-derived-table requires a review by someone in the analytics engineering team and in some cases, when the changes affect project files, like `dbt_project.yml`, then a data engineer's review is also needed. These reviews are to ensure that the code entering the codebase is inline with best practice and our guidance, as well as ensuring it wont disrupt the scheduled runs.

This guide will provide details on what exactly will be checked and what you need to do to ensure you project passes these checks. Below is the checklist we use to review any pull request

## Analytics engineering pull request review

### Scheduling

For any new project you will need to make sure that you have explicitly stated the desired scheduling of your project in the `dbt_project.yml` file. For any existing project you will already have scheduling, but you should still ensure that this is still the dired schedule. Guidance [here]()

Extract from the create-a-derived-table `dbt_project.yml`:
```yaml
electronic_monitoring:
      +meta:
        dc_owner: matthew.price2
      ems_stg:
        +tags: em
      ems_int:
        +tags: em
    finance:
      +meta:
        dc_owner: holly.furniss
      hyperion_finance_stg:
        +tags: monthly
      sop_finance_stg:
        +tags: monthly
      lookup_finance_stg:
        +tags: monthly
      finance_derived:
        +tags:
          - daily
          - dc_display_in_catalogue
```



### Style

### Structure


## Data engineering pull request review


<br />
