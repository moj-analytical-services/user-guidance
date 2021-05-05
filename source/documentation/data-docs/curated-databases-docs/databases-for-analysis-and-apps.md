# Using Databases and data for Apps

This section covers how and when to use different tools to query our databases on the Analytical Platform and what to consider when giving data to a deployed app. This section assumes you are getting data from databases that are already created on the Analytical platform. If you need to upload data to the platform see the sections on [S3](#s3) and [information governance](#information-governance).

## Guidance on using our databases for analysis

We use `pydbtools` (for Python) and `dbtools` (for R) on the Analytical Platform to query our databases (You can find out more information about them in the [dbtools section](#dbtools)). Both these tools use an [SQL](#sql) Engine called [Athena](#amazon-athena) to query large datasets in S3 just like a normal relational database system. When you want to manipulate or query the databases on the Analytical Platform consider the following:

- A good general rule is to do any aggregates, joins filtering in SQL on our databases (using Athena) first and then bring the resulting table into R/Python for more nuanced analytical calculations / transforms. If you just need to aggregate, join or filter your data and not do anything special with it then it might be worth considering doing all of your transforms using SQL Athena.

- Is the data you are querying large? If so you might want to consider aggregating it or only selecting the columns you need using SQL (Athena) first before you read the data into an R/Python dataframe. R/Python are going to read that data into memory so that at some point of the dataset is too large is will kill your AP instance (on the flip side Athena takes that load for you so better to use Athena for big table queries and joins).

- If you need to do joins across datasets it is most likely that Athena is going to be much faster than Python/R unless your datasets are very small. So if you are doing some analysis with many joins use Athena.

If in doubt about best practices we have slack channels for R, python, SQL, etc where you can ask.

## Guidance on using databases / data for deployed apps

This section of the guidance covers best practice for using data on the platform for deployed apps. If you want to know how to set up an app bucket go to the [deploy an R shiny app section](#deploying-an-r-shiny-app) of the guidance.

### What to consider when giving an app access to data

This is because apps are typically accessed by users without Analytical Platform accounts. To add additional security for our data, we like to restrict how much data apps can access, in order to prevent unwanted data leaks in the unlikely event of an app being compromised. In order to describe how this affects things when we give apps access to databases, we need to briefly touch on 'roles' within the Analytical Platform.

When you access things on the Analytical Platform, you do so by taking on your 'role', which lists the set of things that you are permitted to do. This is how you interact with RStudio, Jupyter, Airflow, S3 buckets, etc. Since apps also need permissions to access things, they also have roles. When app users are interacting with the app, it will be carrying out tasks using its own role. In order to minimise the damage that an app could do in the unlikely event of it being compromised, we provide apps with much more restricted roles than those given to users. What this means is:

- Apps cannot access (read/write) S3 buckets created by the AP users (instead they have their own 'app buckets' prefixed with `alpha-app-`)
- Apps cannot access databases created for the AP users (these are all of the "curated" databases created by the Data Engineering Team)
- Users can access read/write to app buckets (permissions to do this are given via the Control Panel).

So if you create an app that needs specific data from our databases then you need to consider the following practices:

#### Data Minimisation

When writing data to your app bucket you should only ever give the app the minimal data that it needs. For example, even though your analysis might require personal or low level data, your app may well be presenting this data at an aggregated level, in which case you should put just the aggregated data into the app bucket. You should never put data in the app bucket that you do not want users to see (even if the code behind the app itself has no method to expose that data to the user via the app).

#### Writing data to an App bucket

There are multiple ways you can do this and it is up to you to determine how best to do it.

- You could manually run some code from your RStudio or JupyterLab environment that writes the necessary data to the app bucket whenever it needs updating
- You could write an Airflow script that writes data from a database to the app bucket meaning the app still only has access to it's very specific area in AWS.
- When updating data for Rshiny apps you often need to restart the R session so it refreshes the cached data. You can do this using Airflow (to see how to do this search the [airflow dags repository](https://github.com/moj-analytical-services/airflow-dags) for the `BashOperator`).

#### Creating a database for your app

> Note this is only recommended for users who understand how to create/manage databases on Athena. See other parts of guidance on these tools for more details on how to use them.

In most cases you will not need to do this as it will be unnecessary. However, if you feel like you do need to create an Athena SQL database because your app requires the processing power from Athena or the data you are reading in is too large to be cached then you will need to do the following:

- Create an Athena database that will be used for your app (the data will still sit in the app bucket but it will also need a Glue schema created in order for Athena to query it).
- Message on the data-engineer slack channel to ask them to add this database for your app. As well as explaining why the Athena database is needed for the app.

Your app role will then be given access to only read the specific database for your app and no other databases. This again restricts what an app can access, compared to the wider access given to AP users. If you require to update the app database follow the same tips / routes to writing data in S3 in the ["writing data to an app bucket" section](#writing-data-to-an-app-bucket).

If exposing your app to SQL you need to be careful with [SQL injection](https://www.w3schools.com/sql/sql_injection.asp). You should avoid things like f-strings or inserting values into SQL strings. There are tools that deal with this like [sqlalchemy](https://www.sqlalchemy.org/). On top of this we also restrict apps to only have read access to the Glue Catalogue.
