# Data Modelling Concepts - placeholder

⚠️ This service is in beta ⚠️

This page is intended to give users a brief introduction to Data Modelling concepts and why we are using `dbt` as the backend for `create-a-derived-table`. Please post suggestions to improve this document in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit and raise a PR.



# How we style our dbt projects



## Why does style matter?

Style might seem like a trivial, surface-level issue, but it's a deeply material aspect of a well-built project. A consistent, clear style enhances readability and makes your project easier to understand and maintain. Highly readable code helps build clear mental models making it easier to debug and extend your project. It's not just a favor to yourself, though; equally importantly, it makes it less effort for others to understand and contribute to your project, which is essential for peer collaboration, open-source work, and onboarding new team members. [A style guide lets you focus on what matters](https://mtlynch.io/human-code-reviews-1/#settle-style-arguments-with-a-style-guide), the logic and impact of your project, rather than the superficialities of how it's written. This brings harmony and pace to your team's work, and makes reviews more enjoyable and valuable.

## What's important about style?

There are two crucial tenets of code style:

- Clarity
- Consistency

Style your code in such a way that you can quickly read and understand it. It's also important to consider code review and git diffs. If you're making a change to a model, you want reviewers to see just the material changes you're making clearly.

Once you've established a clear style, stay consistent. This is the most important thing. Everybody on your team needs to have a unified style, which is why having a style guide is so crucial. If you're writing a model, you should be able to look at other models in the project that your teammates have written and read in the same style. If you're writing a macro or a test, you should see the same style as your models. Consistency is key.

## How should I style?

You should style the project in a way you and your teammates or collaborators agree on. The most important thing is that you have a style guide and stick to it. This guide is just a suggestion to get you started and to give you a sense of what a style guide might look like. It covers various areas you may want to consider, with suggested rules. It emphasizes lots of whitespace, clarity, clear naming, and comments.

We believe one of the strengths of SQL is that it reads like English, so we lean into that declarative nature throughout our projects. Even within dbt Labs, though, there are differing opinions on how to style, even a small but passionate contingent of leading comma enthusiasts! Again, the important thing is not to follow this style guide; it's to make _your_ style guide and follow it. Lastly, be sure to include rules, tools, _and_ examples in your style guide to make it as easy as possible for your team to follow.

## Automation

Use formatters and linters as much as possible. We're all human, we make mistakes. Not only that, but we all have different preferences and opinions while writing code. Automation is a great way to ensure that your project is styled consistently and correctly and that people can write in a way that's quick and comfortable for them, while still getting perfectly consistent output.


---
title: How we style our dbt models
id: 1-how-we-style-our-dbt-models
---

## Fields and model names

- 👥 Models should be pluralized, for example, `customers`, `orders`, `products`. ALthough this is a good best practice, we accept that this may not work with the projects you are working on, so if you cannot keep to it then that is fine.
- 🔑 Each model should have a primary key.
- 🔑 The primary key of a model should be named `<object>_id`, for example, `account_id`. This makes it easier to know what `id` is being referenced in downstream joined models.
- Use underscores for naming dbt models; avoid dots.
  - ✅  `models_without_dots`
  - ❌ `models.with.dots`
  - Most data platforms use dots to separate `database.schema.object`, so using underscores instead of dots reduces your need for [quoting](/reference/resource-properties/quoting) as well as the risk of issues in certain parts of dbt Cloud. For more background, refer to [this GitHub issue](https://github.com/dbt-labs/dbt-core/issues/3246).
- 🔑 Keys should be string data types. Additionally we adives using a hash function to create unique keys.
- 🔑 Consistency is key! Use the same field names across models where possible. For example, a key to the `customers` table should be named `customer_id` rather than `user_id` or 'id'.
- ❌ Do not use abbreviations or aliases. Emphasize readability over brevity. For example, do not use `cust` for `customer` or `o` for `orders`. Again, in AE we accept that in some cases this may not be possible. We want to prioritise readability, however, if this is not practical then do not lose sleep over it.
- ❌ Avoid reserved words as column names.
    - create-a-derived-table resered words:
        -
- ➕ Booleans should be prefixed with `is_` or `has_`.
- 🕰️ Timestamp columns should be named `<event>_at`(for example, `created_at`) and should be in UTC. If a different timezone is used, this should be indicated with a suffix (`created_at_pt`).
- 📆 Dates should be named `<event>_date`. For example, `created_date.`
- 🔙 DBT suggests event dates and times should be past tense, we do not beleive this is necessary for create-a-derived-table as there are many examples of fields that are well established and changing them would cause confusion. We do however suggest following this for meta data like &mdash; `created`, `updated`, or `deleted`.
- 💱 Price/revenue fields should be in decimal currency (`19.99` for $19.99; many app databases store prices as integers in cents). If a non-decimal currency is used, indicate this with a suffix (`price_in_cents`).
- 🐍 Schema, table and column names should be in `snake_case`.
- 🏦 Use names based on the _business_ terminology, rather than the source terminology. For example, if the source database uses `user_id` but the business calls them `customer_id`, use `customer_id` in the model.
- 🔢 Versions of models should use the suffix `_v1`, `_v2`, etc for consistency (`customers_v1` and `customers_v2`).
- 🗄️ DBT suggest a consistant ordering of data types in your models, for our use case we do not see this as advantageous as it can be helpful to group fields based on their relevance to eachother, say a flag and the field it is refering to. We therefore advise that some consistent groupings is followed but it does not necessarily need to be based on field type. Where possible ids should be the first fields in a model and we expect the primary key to be **the first** field.

## Example model

```sql
with

source as (

    select * from {{ source('ecom', 'raw_orders') }}

),

renamed as (

    select

        ----------  ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,

        ---------- strings
        status as order_status,

        ---------- numerics
        (order_total / 100.0)::float as order_total,
        (tax_paid / 100.0)::float as tax_paid,

        ---------- booleans
        is_fulfilled,

        ---------- dates
        date(order_date) as ordered_date,

        ---------- timestamps
        ordered_at

    from source

)

select * from renamed
```

# How we style our SQL


## Basics

- ☁️ Use [SQLFluff](https://sqlfluff.com/) to maintain these style rules automatically.
  - Customize `.sqlfluff` configuration files to your needs.
  - Refer to our [SQLFluff config file](https://github.com/dbt-labs/jaffle-shop-template/blob/main/.sqlfluff) for the rules we use in our own projects. 

  - Exclude files and directories by using a standard `.sqlfluffignore` file. Learn more about the syntax in the [.sqlfluffignore syntax docs](https://docs.sqlfluff.com/en/stable/configuration.html#id2).
- 👻 Use Jinja comments (`{# #}`) for comments that should not be included in the compiled SQL.
- ⏭️ Use trailing commas.
- 4️⃣ Indents should be four spaces.
- 📏 Lines of SQL should be no longer than 80 characters. This is excluding model names as they can often be longer than 80 characters themselves. It is helpful to add a vertical line to your IDE (R, VS code or jupyter notebooks) to mark where 80 characters is. 
- ⬇️ Field names, keywords, and function names should all be lowercase.
- 🫧 The `as` keyword should be used explicitly when aliasing a field or table.

:::info
☁️ dbt Cloud users can use the built-in [SQLFluff Cloud IDE integration](https://docs.getdbt.com/docs/cloud/dbt-cloud-ide/lint-format) to automatically lint and format their SQL. The default style sheet is based on dbt Labs style as outlined in this guide, but you can customize this to fit your needs. No need to setup any external tools, just hit `Lint`! Also, the more opinionated [sqlfmt](http://sqlfmt.com/) formatter is also available if you prefer that style.
:::

## Fields, aggregations, and grouping

- 🔙 Fields should be stated before aggregates and window functions.
- 🤏🏻 Aggregations should be executed as early as possible (on the smallest data set possible) before joining to another table to improve performance.
- 🔢 Grouping by a number (eg. group by 1, 2) is preferred over listing the column names (see [this classic rant](https://www.getdbt.com/blog/write-better-sql-a-defense-of-group-by-1) for why). Note that if you are grouping by more than a few columns, it may be worth revisiting your model design.
- 🔢 Column names should be written out explicitly with the column names in order statements to avoid ambiguity. 

## Joins

- 👭🏻 Prefer `union all` to `union` unless you explicitly want to remove duplicates.
- 👭🏻 If joining two or more tables, _always_ prefix your column names with the table name where that column is coming from. If only selecting from one table, prefixes are not needed.
- 👭🏻 Be explicit about your join type (i.e. write `inner join` instead of `join`).
- 🥸 Avoid table aliases in join conditions (especially initialisms) — it's harder to understand what the table called "c" is as compared to "customers".
- ➡️ Always move left to right to make joins easy to reason about - `right joins` often indicate that you should change which table you select `from` and which one you `join` to.

## 'Import' CTEs

- 🔝 All `{{ ref('...') }}` statements should be placed in CTEs at the top of the file.
- 📦 'Import' CTEs should be named after the table they are referencing.
- 'Import' CTEs should be short and concise to make it easy to read what tables are being read in. Try not to have lots of fields in your select statement as it makes reading the CTEs harder, `select *` should be sufficient in most cases.
- You can use a `where` clasue to filter the data down.
- For example:

```sql
with

hyperion_metrics as (

    select * from {{ ref('finance_derived__int_hyperion_year_metrics') }}
    where financial_year = '2023'

)
```

## 'Functional' CTEs

- ☝🏻 Where performance permits, CTEs should perform a single, logical unit of work.
- 👭🏻 Where possible joins should be done separately to calculations. This is to make the code neater, we expect the table each columns comes from to be referenced and therefore can make calculations overly complicated if a join is also being performed. (see example at the end of the section)
- 📖 CTE names should be as verbose as needed to convey what they do e.g. `events_joined_to_users` instead of `user_events` (this could be a good model name, but does not describe a specific function or transformation).
- 🌉 CTEs that are duplicated across models should be pulled out into their own intermediate models. Look out for chunks of repeated logic that should be refactored into their own model.
- 🔚 The last line of a model should be a `select *` from your final output CTE. This makes it easy to materialize and audit the output from different steps in the model as you're developing it. You just change the CTE referenced in the `select` statement to see the output from that step.

## Model configuration

- 📝 Model-specific attributes (like sort/dist keys) should be specified in the model.
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

## Example SQL

```sql
with

events as (

    ...

),

{# CTE comments go here #}
filtered_events as (

    ...

)

select * from filtered_events
```

### Example SQL

```sql
with

my_data as (

    select
        field_1,
        field_2,
        field_3,
        cancellation_date,
        expiration_date,
        start_date

    from {{ ref('my_data') }}

),

some_cte as (

    select
        id,
        field_4,
        field_5

    from {{ ref('some_cte') }}

),

some_cte_agg as (

    select
        id,
        sum(field_4) as total_field_4,
        max(field_5) as max_field_5

    from some_cte

    group by 1

),

joined as (

    select
        my_data.field_1,
        my_data.field_2,
        my_data.field_3,

        -- use line breaks to visually separate calculations into blocks
        case
            when my_data.cancellation_date is null
                and my_data.expiration_date is not null
                then expiration_date
            when my_data.cancellation_date is null
                then my_data.start_date + 7
            else my_data.cancellation_date
        end as cancellation_date,

        some_cte_agg.total_field_4,
        some_cte_agg.max_field_5

    from my_data

    left join some_cte_agg
        on my_data.id = some_cte_agg.id

    where my_data.field_1 = 'abc' and
        (
            my_data.field_2 = 'def' or
            my_data.field_2 = 'ghi'
        )

    having count(*) > 1

)

select * from joined
```