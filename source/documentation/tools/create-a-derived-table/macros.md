# Macros

Macros are just Jinja functions. You can write your own macros which should live at [`./mojap_derived_tables/macros/`](./mojap_derived_tables/macros/), see [dbt's docs on Jinja macros](https://docs.getdbt.com/docs/building-a-dbt-project/jinja-macros).


There is an ecosystem of packages containing helpful macros and tests you can use, see [dbt package hub](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/). If you need a package adding to the dbt project, update the [`packages.yml`](./mojap_derived_tables/packages.yml) file then rerun `dbt deps`.