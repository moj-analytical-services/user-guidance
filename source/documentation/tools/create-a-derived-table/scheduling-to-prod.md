# Scheduling to Prod

# Prod

A model or seed is in 'prod' when they are merged into `main`. The data modelling team will review and approve any changes before a pull request is merged into `main`. If you have added or modified seeds in your pull request, these will be deployed when the pull request is merged. If you have added or modified models in your pull request, these will be deployed at the next schedule as per the defined schedule tag. Run artefacts for prod deployments are exported to S3 and are available for 3 days. You can get the S3 path by navigating to the `Actions` tab in the Create a Derived Table repository and selecting the workflow you want the output of. Then check the `Export run artefacts to S3` output for the S3 path which will look something like this:

```
s3://mojap-derived-tables/prod/run_artefacts/run_time=yyyy-mm-dd hh:mm:ss/
```

# Scheduling

There are three options for scheduling model updates: `daily`, `weekly`, and `monthly`. The monthly schedule runs on the first Sunday of every month and the weekly schedule runs every Sunday. All schedules run at 3AM. To select a schedule for your model, add the `tags` configuration to your model's property file, like this:

```
version: 2

models:
  - name: <your_model_name>
    config:
      tags: daily
```

You can configure a directory of models to run on the same schedule by adding the `tags` configuration to the `dbt_project.yml` file by finding the `models` resource key and adding a few lines, like this:

```
models:
  mojap_derived_tables:  # this line is already in the file
    +materialized: table  # this line is already in the file
    security:
      prison_safety_and_security:
        +tags: daily
        staging:
          +tags: monthly
```

In the above example, the Prison Safety and Security team have configured their entire database to update daily except for the subdirectory of staging models that will update monthly.

<br />

