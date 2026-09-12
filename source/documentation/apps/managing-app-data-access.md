# Managing data access for your app

The processing for giving your App access to data is slightly different depending on whether your data is in a warehouse data source or webapp data source.

## App access to a Webapp data source

First create a webapp data source following the instructions in [Amazon S3](/data/amazon-s3.html) section. To give your app access to the files in your webapp data source bucket:

1.  Go to the Analytical Platform [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
2.  Select the __Webapps__ tab.
3.  Click Manage App next to your App.
4.  Scroll to App data sources at the bottom and choose the relevant webapp data source from below `Connect an app data source`.

## App access to a Warehouse data source

To give your app access to the files in your warehouse data source bucket:

1.  Go to the [data-engineering-database-access GitHub repository](https://github.com/moj-analytical-services/data-engineering-database-access).
2.  Follow the instructions to create the database access and project access files.
3.  Under users in the project access yaml file list your app name (it should start with `alpha_app_`).
4.  Submit a PR and wait for it to be merged.

## Athena query permissions

> Note: the data used to build your Athena table must be located in a webapp or warehouse data source the App has access to as described above.

If your app needs access to run Athena queries you will need to do the following as well.

1.  Go to the [data-engineering-database-access GitHub repository](https://github.com/moj-analytical-services/data-engineering-database-access).
2.  Go to the [db_app_policies.py](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/scripts/db_app_policies.py) file.
3.  Add your app under `app_policies` using the following template:


    ```
    {
        "role": "alpha_app_app-name",  # app role
        "glue_resources": [
            "database/dbname",
            "table/dbname/*",
        ],
        "write": False,  # Can it edit the above schemas (True or False)
        "ctas": True,  # Does it use CTAS in pydbtools (True or False)
    },
    ```
   
 
4.  Set write to be `True` if it needs to write to an Athena table
5.  Submit a PR and wait for it to be merged.
