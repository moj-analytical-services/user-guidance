# Data FAQs

## Where do I find out what data is already on the Platform?

The data engineering team maintain a number of databases on the Platform (curated databases). The best way to find out about these is using the [data discovery tool](https://data-discovery-tool.apps.alpha.mojanalytics.xyz). To access the tool, you must sign in using an email link. Many users will have had their justice emails automatically added to the allow list. If you enter your email and are denied access, you can request to be added in `#ask-data-engineering` in Data and Analysis slack. The tool can be updated by anyone, so if you find something out about the data that isn't already documented, please do add to it!

In addition to this users can create their own S3 buckets which may have data useful to other teams, you may have to ask around to see if there is an existing dataset that may suit your needs.

## How do I gain access to existing data?

Access to curated databases is granted via the [database access repository](https://github.com/moj-analytical-services/data-engineering-database-access). Have a read through the guidance on there. If you are finding the process a little tricky, please ask for help in `#ask-data-engineering`. A data engineer will happily guide you through things. 

If you are looking for access to a user created bucket, then the admin of that bucket should be able to grant you access. If you don't know who the admin is, or they are not able to grant you access, then ask in the `#analytical-platform` slack channel.

## Where should I store my own data?

Data should be stored in an s3 bucket. You can create a new s3 bucket in the control panel. Data can be uploaded manually via the AWS console (which can be accessed through the control panel) or you can write it from RStudio or JupyterLab.

If your data contains anything that could be considered personal information, you must follow guidance from the data privacy team which can be found on the [intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/).

## How do I read/write data from an s3 bucket?

**Python/JupyterLab**: You can read/write directly from s3 using pandas. However, to get the best representation of the column types in the resulting Pandas dataframe(s), you may wish to use [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser).

**R/Rstudio**: The recommended package to use is [botor](https://github.com/daroczig/botor).

## How do I query a database on the Platform?

Databases on the AP use Amazon Athena which allow you to query data using SQL. You shouldn't need to know about Athena in detail to query databases on the AP, but if you are interested you may wish to [read more about it](https://aws.amazon.com/athena/). There are three ways you can query data (there is more detail on all three of these in `Data` section of this guidance):

**The Amazon Athena workbench**: If you [log into the AWS console](aws.services.analytical-platform.service.justice.gov.uk.) and click Services -> Athena, you'll see the Athena workbench. This is good for testing your queries.

**Python/JupyterLab**: To run queries and/or read data into a pandas DataFrame, use `pydbtools`. More details are [here](https://github.com/moj-analytical-services/pydbtools). Remember to install the latest version!

**R/RStudio**: There is currently no single recommended package for querying databases in R. There is [dbtools](https://github.com/moj-analytical-services/dbtools) which should work on the "old" platform. [Rdbtools](https://github.com/moj-analytical-services/Rdbtools) should work on the "new" platform, but is not officially supported so should be used with caution.

## I am running into memory issues, what should I do?

You should do as much data manipulation in Athena/SQL as you possibly can, before reading into your analytical tool of choice. If you are using the curated databases consider filtering out unnecessary rows or columns, or aggregating results if appropriate. The function `create_temp_table` in `pydbtools` is particularly useful for helping with this.

If the data is stored in your own s3 bucket, you may wish to create your own Athena database.

## How do I create my own Athena database?

**Athena workbench/JupyterLab/RStudio**: You can run `CREATE DATABASE` and `CREATE TABLE AS SELECT` (CTAS) queries to create your own database and tables from data you have in s3. There are more details in this guidance or you can use what is provided by [AWS](https://docs.aws.amazon.com/athena/latest/ug/language-reference.html). When running CTAS queries a key thing to remember is to specify the location (s3 bucket and path) of the data. There is a nice example [here](https://github.com/moj-analytical-services/mojap-aws-tools-demo/blob/main/creating_and_maintaining_database_tables_in_athena.ipynb) of setting up your own database. The tutorial is in python but the SQL can be ran from any tool on the AP.
