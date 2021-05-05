# Using Databases and data for Apps

This section covers how and when to use different tools to query our database on the Analytical Platform and what to consider when giving data to a deployed app. This section assumes you are getting data from Curated Databases or databases that are already created on the platform. If you need t

## Guidance on using our databases for analysis

We use `pydbtools` (for Python) and `dbtools` (for R) on the Analytical Platform to query our curated databases (You can find out more information about them in the [dbtools section](#dbtools)). Both these tools query the databases with an SQL engine called Athena which is used to query large datasets that sit in S3 like you would in a normal relation database system. You can find more details on [SQL](#sql) and [Athena](#amazon-athena) in their relevant sections in the guidance. When you want to manipulate or querying the our curated databases on the Analytical Platform consider the following:

- Is the data you are querying large? If so you might want to consider aggregating it or only selecting the columns you need using SQL (Athena) first before you read the data into an R/Python dataframe. R/Python are going to read that data into memory so that at some point of the dataset is too large is will kill your AP instance (on the flip side Athena takes that load for you so better to use Athena for big table queries and joins).

- If you need to do joins across datasets it is most likely that Athena is going to be much faster than Python/R unless your datasets are very small. So if you are doing some analysis with many joins use Athena.

- A good rule of thumb is to do any aggregates, joins filtering in SQL on our curated databases (using Athena) first and then bring the resulting table into R/Python for more nuanced analytical calculations / transforms. If you just need to aggregate, join or filter your data and not do anything special with it then it might be worth considering doing all of your transforms using SQL Athena.

If in doubt about best practices we have slack channels for R, python, SQL, etc where you can ask.

## Guidance on using databases / data for deployed apps

This section of the guidance covers best practice for using data on the platform for deployed apps. If you want to know how to setup an app bucket go to the [deploy an R shiny app section](#deploying-an-r-shiny-app) of the guidance.

### What to consider when giving an app access to data

We do not give any app on the Analytical Platform access to our databases we expose and create for analysis. This is because apps can be accessed to users outside of the analytical platform, so we like to air gap the permissions and access of the App. For ease we are going to refer to two types of AP roles, the first is you the AP-user (most likely you) who has access to the tools on the Analytical Platform like R/Python, GitHub, etc. Then the other role is the App just like users each App will have individual permissions but will only ever be able to access things on the platform that are specifically for the App (so much more restricted access and also does not represent an individual). Whoever is using the deployed app is using it with that App's role. What this means is:

- Apps cannot access (read/write) S3 buckets created by the AP users (instead they have their own buckets prefixed with `alpha-app-`)
- Apps cannot access Databases created for the AP users (these are all of the curated databases created by the Data Engineers)
- Users can access read/write to App buckets (permissions to do this are given via the Control Panel).

So if you create an app that needs specific data from our databases then you need to consider the following practices:

#### Data Minimisation

When writing data to your app-bucket you should only ever give the app what it needs. I.e. even though your analysis might require personal or low level data. If the calculations on your App do not need the data at this lower level, then only write data to the app-bucket that is an aggregate of the data you take. You should never put data in the app-bucket that you do not want users to see (even if the code behind the app itself has no method to expose that data to the user via the app).


#### Writing data to an App bucket

There are multiple ways you can do this and it is up to you to determine how best to do it.

- You could manually run a script from your AP User instance that writes the necessary data to the app bucket whenever it needs updating
- You could write an airflow script that writes data from a database to the app bucket (this is because the airflow role will be seperate to the app role). Meaning the app still only has access to it's very specific area in AWS.
- If you want a database backend but nothing as big as Athena you could write your data into an SQLite and save to to the app-bucket. Then just like how R/Python would read in a file from S3. You could load in SQLite database into memory and use that as a backend database for your app.

> When updating data for Rshiny Apps you often need to restart the R session so it refreshes the cached data. You can do this using airflow (to see how to do this search the airflow-dags repository for the `BashOperator`).


#### Creating a database for your app

> Note this is only recommended for users who understand how to create/manage databases on Athena. See other parts of guidance on these tools for more details on how to use them.

In most cases you will not need to do this and it is unnecessary. However, if you feel like you do need to create an Athena SQL database because your app requires the processing power from Athena and the data you are reading in is too large to be cached and there is no way around it then you will need to do the following:

- Create an athena database that will be used for your app (the data will still sit in the apps S3 bucket but it will also need a Glue schema created in order for Athena to query it).
- Message on the data-engineer slack channel to ask them to add this database for your app.

Your app role will then be given access to only read the specific database for your app and no other databases. This again ensures the airgap between what an app can access and the wider resources given to AP-users. If you require to update the app database follow the same tips / routes to writing data in S3 in the ["writing data to an app bucket" section](#writing-data-to-an-app-bucket).

If exposing your App to SQL you need to be careful with SQL injection. You should avoid things like f-strings or inserting values into SQL strings. Or use a tool as your sql interface to deal with that like sqlalchemy.
