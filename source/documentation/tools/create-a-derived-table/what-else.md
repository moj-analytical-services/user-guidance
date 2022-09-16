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