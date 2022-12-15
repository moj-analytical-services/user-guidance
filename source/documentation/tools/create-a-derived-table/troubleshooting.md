## Tips
- You can test out how your SQL model files look once rendered by running `dbt compile --select {path_to_file(s)}`. This saves on running and deploying your tables if you want to test your sql. The compiled model files will be saved in the `mojap_derived_tables/target/compiled` folder.
- Make sure you deploy your seeds with `dbt seed --select {path_to_seeds}` if your models depend on them.
- If you define any variables to inject into your model sql files using `{{ var(...) }}`, they need to be in the `dbt_project.yml` file.


access to data in S3

unable to do partial parsing

may need to delete data error

check cwd is dbt project

Is sqlfuff up to date?

--no-verify flag in Analytical Platform when uploading >5MB CSVs
