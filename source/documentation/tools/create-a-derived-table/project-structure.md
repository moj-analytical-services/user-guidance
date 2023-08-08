# Project Structure

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