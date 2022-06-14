# Using databases and data for apps

This section covers how and when to use different tools to query our databases on the Analytical Platform and what to consider when giving data to a deployed app. This section assumes you are getting data from databases that are already created on the Analytical Platform. If you need to upload data to the platform see the sections on [S3](#s3) and [information governance](#information-governance).

## Guidance on using our databases for analysis

We use `pydbtools` (for Python) and `dbtools` (for R) on the Analytical Platform to query our databases. You can find out more information about them in the [dbtools section](#dbtools). Both these tools use an [SQL](#sql) Engine called [Athena](#amazon-athena) to query large datasets in S3 just like a normal relational database system. When you want to manipulate or query the databases on the Analytical Platform consider the following:

- A good general rule is first to use SQL (via `dbtools` or `pydbtools`) for aggregation, joins, and filtering of your data, and then to bring the resulting table into RStudio or JupyterLab for more nuanced analytical calculations and transforms.

- If you just need to aggregate, join or filter your data and not do anything special with it then it might be worth considering doing all of your transforms using SQL with `dbtools` or `pydbtools`.

- Performing joins, aggregates, and filters with SQL via `dbtools` or `pydbtools` is likely to be much faster than doing this within RStudio or JupyterLab environment using e.g. `dplyr` or `pandas`.

- When you read the data into RStudio/JupyterLab it will store it in the memory (RAM) of your environment. Currently environments have 12GB of memory, which is easily sufficient for most needs. If your data is too large for this capacity it will break the environment, and crash.

If in doubt about best practices we have Slack channels for R, Python, SQL, etc where you can ask.

## Guidance on using databases / data for deployed apps

This section of the guidance covers best practice for using data on the platform for deployed apps. If you want to know how to set up an app bucket go to the [deploy an R shiny app section](#deploying-an-r-shiny-app) of the guidance.

### What to consider when giving an app access to data

Apps are typically accessed by users without Analytical Platform accounts, so we have to be more careful about security. To this end we like to restrict how much data apps can access, in order to prevent unwanted data leaks in the unlikely event of an app being compromised. In order to describe how this affects things when we give apps access to databases, we need to briefly touch on 'roles' within the Analytical Platform.

When you access things on the Analytical Platform, you do so by taking on your 'role', which lists the set of things that you are permitted to do. This is how you interact with RStudio, Jupyter, Airflow, S3 buckets, etc. Since apps also need permissions to access things, they also have roles. When app users are interacting with an app, it will be carrying out tasks using its own role. In order to minimise the damage that an app could do in the unlikely event of it being compromised, we provide apps with much more restricted roles than those given to users. What this means is:

- Apps cannot access (read/write) S3 buckets created by the AP users (instead they have their own 'app buckets' prefixed with `alpha-app-`)
- Apps cannot access curated databases created by the Data Engineering Team
- Both apps and users can access (read/write) app buckets (permissions to do this are given via the Control Panel).

If you create an app that needs specific data from our databases then you need to consider the following practices:

#### Data minimisation

When writing data to your app bucket you should only ever give the app the minimal data that it needs. For example, if your app presents analytical results at an aggregated level, you should put just the aggregated data into the app bucket, even if the underlying analysis that creates these results requires personal or low level data. You should never put data in the app bucket that you do not want users to see (even if the code behind the app itself has no method to expose that data to the user via the app).

#### Writing data to an app bucket

There are multiple ways you can do this and it is up to you to determine how best to do it.

- You could manually run some code from your RStudio or JupyterLab environment that writes the necessary data to the app bucket whenever it needs updating
- You could write an Airflow script that writes data from a database to the app bucket.
- When updating data for Shiny apps you often need to restart the R session so it refreshes the cached data. You can ask the AP team to create a cron job to automate this.

#### Creating a database for your app

> Note this is only recommended for users who understand how to create/manage databases on Athena. See other parts of guidance on these tools for more details on how to use them.

In most cases you will not need to do this. Apps typically do not require this volume of data (see "Data minimisation"). However, if you feel like you do need to create an Athena SQL database because your app requires the processing power from Athena or the data you are reading in is too large to be cached then you will need to do the following:

- Create an Athena database that will be used for your app (the data will still sit in the app bucket but it will also need a Glue schema created in order for Athena to query it).
- Message on the data-engineer slack channel to ask them to add this database for your app. Explain why the Athena database is needed for the app.

Your app role will then be given access to only read the specific database for your app and no other databases. This again restricts what an app can access, compared to the wider access given to AP users. If you need to update the app database you can follow the same tips / routes to writing data in S3 in the ["writing data to an app bucket" section](#writing-data-to-an-app-bucket).

If exposing your app to SQL you need to be careful with [SQL injection](https://www.w3schools.com/sql/sql_injection.asp). You should avoid things like f-strings or inserting values into SQL strings. There are tools that deal with this like [sqlalchemy](https://www.sqlalchemy.org/). On top of this we also restrict apps to only have read access to the Glue Catalogue.
