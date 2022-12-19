# Create a Derived Table Quickstart

This page is intended to give users who have read through the detailed instructions a quickstart reference to refresh their memory or refer to particular code snippets. Please post suggestions to improve this document in our slack channel ![#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit and raise a PR.

## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select {path_to_file(s)}`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select {path_to_seeds}` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.