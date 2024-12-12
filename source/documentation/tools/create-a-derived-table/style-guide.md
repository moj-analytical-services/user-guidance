# Project and Model Style Guide

- **last updated:** 19/08/2024
- based on dbt best practices version [v1.7](https://docs.getdbt.com/best-practices/how-we-style/0-how-we-style-our-dbt-projects) 

## How we style our create-a-derived-table projects

### Why does style matter?

Style might seem like a trivial, surface-level issue, but it's an important aspect of a well-built project. A consistent, clear style enhances readability and makes your project easier to understand and maintain. Highly readable code helps build clear mental models making it easier to debug and extend your project. It's not just a favor to yourself, though; equally importantly, it makes it less effort for others to understand and contribute to your project, which is essential for peer collaboration, open-source work, and onboarding new team members. [A style guide lets you focus on what matters](https://mtlynch.io/human-code-reviews-1/#settle-style-arguments-with-a-style-guide), the logic and impact of your project, rather than the superficialities of how it's written. This brings harmony and pace to your team's work, and makes reviews more enjoyable and valuable.

As a group of Analytics Engineers, we have thoroughly reviewed guidance published by dbt (the technology behind create-a-derived-table) and adapted it to suit our needs in this style guide.

Please take the time to familiarise yourself with this style guide before starting projects in create-a-derived-table.

### What's important about style?

There are two crucial tenets of code style:

- Clarity
- Consistency

Style your code in such a way that you can quickly read and understand it. It's also important to consider code review and git diffs. If you're making a change to a model, you want reviewers to see just the material changes you're making clearly.

Once you've established a clear style, stay consistent. This is the most important thing. Everybody on your team needs to have a unified style, which is why having a style guide is so crucial. If you're writing a model, you should be able to look at other models in the project that your teammates have written and read in the same style. If you're writing a macro or a test, you should see the same style as your models. Consistency is key.

## How we style our dbt models

### Column and model names

#### Essential styling
- 🔑 Each model should have a primary key and that primary key should be the first column in the table.
- 🔑 The primary key of a model should be named `<object>_id`, for example, `account_id`. This makes it easier to know what `id` is being referenced in downstream joined models.
- 🔑 Consistency is key! Use the same column names across models where possible. For example, a key to the `customers` table should be named `customer_id` rather than `user_id` or 'id'. This helps users to understand how tables can be joined together.
- Use underscores (i.e. snake case) for naming dbt models; avoid dots or camel case.
  - ✅ `models_without_dots`
  - ❌ `models.with.dots`
  - ❌ `CamelCaseModels`
  - Most data platforms use dots to separate `database.schema.object`, so using underscores instead of dots reduces your need for [quoting](/reference/resource-properties/quoting). For more background, refer to [this GitHub issue](https://github.com/dbt-labs/dbt-core/issues/3246).
- 🔑 Keys should be string data types. We advise using the hash function `dbt_utils.generate_surrogate_key` ([guidance here](https://github.com/dbt-labs/dbt-utils?tab=readme-ov-file#generate_surrogate_key-source)) to create unique keys - this ensures there is a unique id for each row, as well as making the ids uniform in length. Some advice (for example Kimball) suggests integer data type instead of string, but we feel this is outdated.
- ❌ Avoid reserved words as column names. create-a-derived-table reserved words, for example `order` (full list [here](https://docs.aws.amazon.com/athena/latest/ug/reserved-words.html)). 
- ➕ Booleans should be prefixed with `is_` or `has_`.
- 🕰️ Timestamp columns should be named `<event>_at`(for example, `created_at`) and should be in UTC. If a different timezone is used, this should be indicated with a suffix (`created_at_pt`).
- 📆 Dates should be named `<event>_date`. For example, `created_date.`
- 💱 Price/revenue columns should be in decimal currency (`19.99` for £19.99; many app databases shop prices as integers in pence). If a non-decimal currency is used, indicate this with a suffix (`price_in_pence`).
- 🐍 Schema, table and column names should be in `snake_case`.
- 🏦 Use names based on the _business_ terminology, rather than the source terminology. For example, if the source database uses `user_id` but the business calls them `customer_id`, use `customer_id` in the model.

#### Optional styling
- 👥 Models should be pluralized, for example, `customers`, `orders`, `products`. Although this is a good best practice, we accept that this may not work with the projects you are working on, so if you cannot keep to it then that is fine.
- ❌ Do not use abbreviations or aliases. Emphasize readability over brevity, even if this means your column or model names are long. For example, do not use `cust` for `customer` or `o` for `orders`. We accept that in rare cases this may not be possible - if you're not sure, ask for guidance in #ask-data-modelling.
- 🔙 DBT suggests event dates and times should be past tense. We don't believe this is necessary in our projects, as there are many examples of columns that are well established and changing them would cause confusion. We do however suggest following this for meta data like &mdash; `created`, `updated`, or `deleted`.
- 🗄️ DBT suggest a consistant ordering of data types in your models, for our use case we do not see this as advantageous as it can be helpful to group columns based on their relevance to eachother, say a flag and the column it is referring to. We therefore advise that a consistent grouping is followed but it does not necessarily need to be based on column type. Where possible ids should be the first columns in a model and we expect the primary key to be **the first** column.

### Example model

Below is an example finance model, following the dbt style of grouping by column type.

```sql
with

source as (

    select * from {{ source('sop_finance_stg', 'base_hmpps_general_ledger_gl01') }}

),

renamed as (

    select

        ----------  ids
        id as cost_centre_id, -- primary key
        a_id as analysis_code_id,
        objective as cobjective_code_id,

        ---------- strings
        version

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

## How we style our SQL

### Basics

- 👻 Use Jinja comments (`{# #}`) for comments that should not be included in the compiled SQL. When dbt compiles your code it will include code using SQL comments like `/* */` and `--`
- ⏭️ Use trailing commas in lists for readability. e.g.
```SQL
select
    defendant_id,
    court_id,
    disposal_date,
    ho_offence_code
    ...
```
rather than
```SQL
select
    defendant_id
    , court_id
    , disposal_date
    , ho_offence_code
    ...
```

- ⬇️ Column names, keywords, and function names (`select`, `as`, `group by`, etc...) should all be lowercase.
- 4️⃣ Indents should be four spaces.
- 📏 Lines of SQL should be no longer than 80 characters. This is excluding model names as they can often be longer than 80 characters themselves. It is helpful to add a vertical line to your IDE (R, VS code or jupyter notebooks. See [here](https://stackoverflow.com/questions/29968499/how-can-i-have-multiple-vertical-rulers-in-vs-code) for a guide) to mark where 80 characters is. 
- 🫧 The `as` keyword should be used explicitly when aliasing a column or table. e.g. `id as defendant_id` not `id defendant_id`


### Columns, aggregations, and grouping

- 🔙 Columns should be stated before aggregates and window functions (i.e. those using over()).
- 🤏🏻 Aggregations should be executed as early as possible (on the smallest data set possible) before joining to another table to improve performance.
- 🔢 Grouping by a number (eg. group by 1, 2) is preferred over listing the column names (see [this classic rant](https://www.getdbt.com/blog/write-better-sql-a-defense-of-group-by-1) for why). Note that if you are grouping by more than a few columns, it may be worth revisiting your model design.
- 🔢 Column names should be written out explicitly in order statements to avoid ambiguity. 
Example:

```SQL
select
    defendant_on_case_id,
    result_priority,
    custodial_period_days,
    monetary,
    final_offence_ho_code_priority,
    final_offence_ho_code,
    defendant_on_offence_id,
    disposal2_id,
    row_number()
        over (
            partition by
                defendant_on_case_id
            order by
                result_priority asc nulls last,
                custodial_period_days desc nulls last,
                monetary desc nulls last,
                final_offence_ho_code_priority asc nulls last,
                final_offence_ho_code asc nulls last,
                defendant_on_offence_id asc nulls last,
                disposal2_id asc nulls last
        ) as most_serious_disposal_rank,
from disposals
group by 1, 2, 3, 4, 5, 6, 7, 8
order by defendant_on_case_id
```

### Joins

- 👭🏻 Prefer `union all` to `union` unless you explicitly want to remove duplicates.
- 👭🏻 If joining two or more tables, _always_ prefix your column names with the table name where that column is coming from. If only selecting from one table, prefixes are not needed.
- 👭🏻 Be explicit about your join type (i.e. write `inner join` instead of `join`).
- 🥸 Avoid table aliases in join conditions (especially initialisms) — it's harder to understand what the table called "c" is as compared to "customers".
- ➡️ Always move left to right (i.e. use `left joins`) - `right joins` often indicate that you should change which table you select `from` and which one you `join` to.

### 'Import' CTEs (Common Table Expressions)

'Import' CTEs are used at the start of each model, to introduce the building blocks required for the model. 

For more information on CTEs (Common Table Expressions), see the [dbt docs](https://docs.getdbt.com/terms/cte).

- 🔝 All `{{ ref('...') }}` statements should be placed in CTEs at the top of the file.
- 📦 'Import' CTEs should be named after the table they are referencing.
- 'Import' CTEs should be short and concise to make it easy to read what tables are being read in. Try not to have lots of columns in your select statement as it makes reading the CTEs harder, `select *` should be sufficient in most cases.
- You can use a `where` clause to filter out any data you don't need.
- For example:

```sql
with

requirements as (
    select * from {{ ref("derived_delius_stg__base_rqmnt") }}
),

reference_1 as (
    select * from {{ ref("derived_delius_stg__stg_standard_reference_1") }} 
    where code_set_name = 'REQUIREMENT SUB CATEGORY'
),

reference_2 as (
    select * from {{ ref("derived_delius_stg__stg_standard_reference_2") }}
    where code_set_name = 'ADDITIONAL REQUIREMENT SUB CATEGORY'
),

reference_3 as (
    select * from {{ ref("derived_delius_stg__stg_standard_reference_3") }}
    where code_set_name = 'REQUIREMENT TERMINATION REASON'
),

reference_4 as (
    select * from {{ ref("derived_delius_stg__stg_standard_reference_4") }}
    where code_set_name = 'UNITS'  
),

joined as (

    select
    requirements.rqmnt_id,
    requirements.disposal_id,
    requirements.start_date,
    requirements.length,
    requirements.rqmnt_notes,
    requirements.commencement_date,
    requirements.termination_date,
    requirements.partition_area_id,
    requirements.expected_start_date,
    requirements.soft_deleted,
    requirements.expected_end_date,

    -- For rqmnt main type sub-cat
    reference_1.code_value as rqmnt_type_sub_category_code,
    reference_1.code_description as rqmnt_type_sub_category_desc,

    -- For rqmnt main type sub-cat
    reference_2.code_value as ad_rqmnt_type_sub_category_code,
    reference_2.code_description as ad_rqmnt_type_sub_category_desc,

    -- For terminations
    reference_3.code_value as rqmnt_termination_reason_code,
    reference_3.code_description as rqmnt_termination_reason_desc,

    -- For units, bring code_value and code_description from standard_reference_list_id
    reference_4.code_value as rqmnt_type_main_units_code,
    reference_4.code_description as rqmnt_type_main_units_desc

    from requirements

    left join reference_1
        on requirements.rqmnt_type_sub_category_id = reference_1.standard_reference_list_id

    left join reference_2
        on requirements.ad_rqmnt_type_sub_category_id = reference_2.standard_reference_list_id

    left join reference_3
        on requirements.rqmnt_termination_reason_id = reference_3.standard_reference_list_id

    left join reference_4
        on requirements.units_id = reference_4.standard_reference_list_id
)

select * from joined
```

### 'Functional' CTEs

'Functional' or 'logical' CTEs contain unique transformations used to generate the final product.

- ☝🏻 Where performance permits, CTEs should perform a single, logical unit of work.
- 👭🏻 Where possible joins should be done separately to calculations. This is to make the code neater, we expect the table each columns comes from to be referenced and therefore can make calculations overly complicated if a join is also being performed. (see example at the end of the section)
- 📖 CTE names should be as verbose as needed to convey what they do e.g. `events_joined_to_users` instead of `user_events` (this could be a good model name, but does not describe a specific function or transformation).
- 🌉 CTEs that are duplicated across models should be pulled out into their own intermediate models. Look out for chunks of repeated logic that should be refactored into their own model.
- 🔚 The last line of a model should be a `select *` from your final output CTE. This makes it easy to materialise and audit the output from different steps in the model as you're developing it. You just change the CTE referenced in the `select` statement to see the output from that step.

### Model configuration

- 📝 Model-specific attributes (like sort/dist keys) should be specified in the model (this is only relevant if sort/dist keys are used in the model)
- 📂 If a particular configuration applies to all models in a directory, it should be specified in the `dbt_project.yml` file.
- 👓 In-model configurations should be specified like this for maximum readability:

```sql
{{
    config(
      materialized = 'table',
      sort = 'id',
      dist = 'id'
    )
}}
```

### Example SQL

```sql
with

my_data as (

    select
        column_1,
        column_2,
        column_3,
        cancellation_date,
        expiration_date,
        start_date

    from {{ ref('my_data') }}

),

some_cte as (

    select
        id,
        column_4,
        column_5

    from {{ ref('some_cte') }}

),

some_cte_agg as (

    select
        id,
        sum(column_4) as total_column_4,
        max(column_5) as max_column_5

    from some_cte

    group by 1

),

joined as (

    select
        my_data.column_1,
        my_data.column_2,
        my_data.column_3,

        -- use line breaks to visually separate calculations into blocks
        case
            when my_data.cancellation_date is null
                and my_data.expiration_date is not null
                then expiration_date
            when my_data.cancellation_date is null
                then my_data.start_date + 7
            else my_data.cancellation_date
        end as cancellation_date,

        some_cte_agg.total_column_4,
        some_cte_agg.max_column_5

    from my_data

    left join some_cte_agg
        on my_data.id = some_cte_agg.id

    where my_data.column_1 = 'abc' and
        (
            my_data.column_2 = 'def' or
            my_data.column_2 = 'ghi'
        )

    having count(*) > 1

)

select * from joined
```

## How we style our Jinja

### Basics

- 🫧 When using Jinja delimiters, use spaces on the inside of your delimiter, like {{ this }} instead of {{this}}
- 🆕 Use newlines to visually indicate logical blocks of Jinja.
- 4️⃣ Indent 4 spaces into a Jinja block to indicate visually that the code inside is wrapped by that block.
- ❌ Don't worry (too much) about Jinja whitespace control, focus on your project code being readable. The time you save by not worrying about whitespace control will far outweigh the time you spend in your compiled code where it might not be perfect.

### Example Jinja

```jinja
{% macro make_cool(uncool_id) %}

    do_cool_thing({{ uncool_id }})

{% endmacro %}
```

## How we style our YAML

### Basics

- 2️⃣ Indents should be two spaces
- ➡️ List items should be indented
- 🆕 Use a new line to separate list items that are dictionaries where appropriate
- 📏 Lines of YAML should be no longer than 80 characters.
- 🛠️ Use the dbt JSON schema with any compatible IDE and a YAML formatter (we recommend Prettier) to validate your YAML files and format them automatically.

### Example YAML

```yaml
version: 2

models:
  - name: events
    columns:
      - name: event_id
        description: This is a unique identifier for the event
        tests:
          - unique
          - not_null

      - name: event_time
        description: "When the event occurred in UTC (eg. 2018-01-01 12:00:00)"
        tests:
          - not_null

      - name: user_id
        description: The ID of the user who recorded the event
        tests:
          - not_null
          - relationships:
              to: ref('users')
              field: id
```
