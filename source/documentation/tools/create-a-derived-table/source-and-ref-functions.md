# Source and Ref Functions 

## Sources

Sources are descriptions of the databases and tables already in Analytical Platform. With those tables defined as sources in dbt, it is then possible to select from source tables in your models using the [`source()`](https://docs.getdbt.com/reference/dbt-jinja-functions/source) function which helps define the lineage of your data. To see which sources have been defined, look in the [`./mojap_derived_tables/models/sources/`](./mojap_derived_tables/models/sources/) directory. 
Below is an example of using the `source()` function to select from the `contact` table in the `delius_prod` database:

`model_a.sql`

```
select * from {{ source("delius_prod", "contact") }} limit 10
```


## Adding a new source

If a database hasn't been defined as a source it will need to be added. Please follow the instructions below:

- Create a new branch off `main`.
- Add the source database name exactly as it appears in AWS Athena to the list in `scripts/source_database_name.txt`. Ensure it is in alphabetical order for ease of use.
- Commit and push the changes, then raise a pull request.

The `update-source` workflow is scheduled to run weekly. When run it will add any new source databases and refresh all existing source databases. Please contact the Data Modelling team at [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) if you have any queries.


## The `ref` function

The most important function in dbt is [`ref()`](https://docs.getdbt.com/reference/dbt-jinja-functions/ref); it's impossible to build even moderately complex models without it. `ref()` is how you reference one model within another as typically models are built to be 'stacked' on top of one another. These references between models are then used to automatically build the dependency graph. Here is how this looks in practice:

`model_b.sql`

```
select contact_id from {{ ref("model_a") }} 
where mojap_current_record=true
```
