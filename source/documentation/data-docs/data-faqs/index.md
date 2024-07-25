# Data FAQs

## What types of data are on the Platform?

Data on the Analytical Platform can largely be split into four categories:

- `Raw`: data that has been uploaded to the Analytical Platform without any changes made to it
- `Curated`: data that has been validated, deduplicated and versioned by the Data Engineers ready to be used by Analytical Platform users
- `Derived`: data that has been [denormalized](https://en.wikipedia.org/wiki/Denormalization#:~:text=Denormalization%20is%20a%20strategy%20used,data%20or%20by%20grouping%20data.), aggregated, and turned into a data model to fit specific needs of Analytical Platform users
- `Processed`: data that has been processed by Analytical Platform users to fit their own needs

## Where do I find out what data is already on the Platform?

> 🚩 Note: in the future the Data Catalog will be developed and provide a useful resource for finding data

The Data Engineering and Modelling Team (DMET) maintain a number of databases on the Platform (*curated* and *derived* databases). The best way to find out about *curated* and *derived* databases is using the [data discovery tool](https://data-discovery-tool.analytical-platform.service.justice.gov.uk/) (access to the tool is now governed via GitHub; Analytical Platform users have access by default). The data discovery tool can be updated by anyone, so if you find something out about the data that isn't already documented, please do add to it. *Derived* tables can also be found by visiting the [create-a-derived-table repository](https://github.com/moj-analytical-services/create-a-derived-table). For more information about *curated* databases please visit [#ask-data-engineering](https://moj.enterprise.slack.com/archives/C8X3PP1TN) and for *derived* databases please visit [#ask-data-modelling](https://moj.enterprise.slack.com/archives/C03J21VFHQ9).

In addition to this users can create their own S3 buckets which may have *processed* data useful to other teams, you may have to ask around to see if there is an existing dataset that may suit your needs.

## How do I gain access to existing data?

Access to databases is granted via the [database access repository](https://github.com/moj-analytical-services/data-engineering-database-access). Have a read through the guidance on there. If you are finding the process a little tricky, please ask for help in [#ask-data-engineering](https://moj.enterprise.slack.com/archives/C8X3PP1TN). A data engineer will happily guide you through things.

If you are looking for access to a user created bucket, then the admin of that bucket should be able to grant you access. If you don't know who the admin is, or they are not able to grant you access, then ask in the [#analytical-platform-support](https://app.slack.com/client/T02DYEB3A/C4PF7QAJZ) Slack channel or via [GitHub](https://github.com/ministryofjustice/data-platform-support/issues/new/choose). If the bucket admin is unavailable, the Analytical Platform team will need to receive approval from your line manager before you can be given any access to the bucket.

## Where should I store my own data?

> ⚠️ We can only hold 1,000 S3 buckets on the Analytical Platform. Before you create a new bucket, please check whether you can re-use an existing one, or create a domain-level S3 bucket and use folders and [path specific access](https://user-guidance.analytical-platform.service.justice.gov.uk/data/amazon-s3/#path-specific-access) for project level access.

Data should be stored in an S3 bucket. You can create a new S3 bucket in the [AP Control Panel](https://user-guidance.analytical-platform.service.justice.gov.uk/tools/control-panel.html). Data can be uploaded manually via the AWS console (which can be accessed through the control panel) or you can write it from RStudio, Visual Studio Code or JupyterLab.

If your data contains anything that could be considered personal information, you must follow guidance from the data protection team which can be found on the [intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/).

## How do I read/write data from an s3 bucket?

**Python**: You can read/write directly from S3 using a variety of tools such as pandas, boto3, aws wrangler. However, to get the best representation of the column types in the resulting Pandas dataframe(s), you may wish to use [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser).

**R**: Whilst initially the recommended package was [botor](https://github.com/daroczig/botor),
you are also encouraged to try out [Rs3tools](https://github.com/moj-analytical-services/Rs3tools) a community
maintained, R-native version of S3tools that removes some of the complexity around using Python.

## How do I query a database on the Platform?

Databases on the AP use Amazon Athena which allow you to query data using SQL. You shouldn't need to know about Athena in detail to query databases on the AP, but if you are interested you may wish to [read more about it](https://aws.amazon.com/athena/). There are three ways you can query data (there is more detail on all three of these in `Data` section of this guidance):

**The Amazon Athena workbench**: If you [log into the AWS console](https://aws.services.analytical-platform.service.justice.gov.uk) and click Services -> Athena, you'll see the Athena workbench. This is good for testing your queries.

**Create a Derived Table**: You can also use [Create a Derived Table](https://user-guidance.analytical-platform.service.justice.gov.uk/tools/create-a-derived-table/index.html) to run SQL statements to query Athena.

If you get `assumed-role/... is not authorized to perform: glue:GetDatabases`, [request database access](https://github.com/moj-analytical-services/data-engineering-database-access#standard-database-access).

**Python**: To run queries and/or read data into a pandas DataFrame, use `pydbtools`. More details are [here](https://github.com/moj-analytical-services/pydbtools). Remember to install the latest version!

**R**: There is currently no single recommended package for querying databases in R. There is [dbtools](https://github.com/moj-analytical-services/dbtools) which should work on the "old" platform. [Rdbtools](https://github.com/moj-analytical-services/Rdbtools) should work on the "new" platform. This package is maintained by the analytical platform user community.

## What should I use to process my data?

Please refer to [tools for processing my data](#link)

## I am running into memory issues using Python/R, what should I do?

You should do as much data manipulation in Athena/SQL as you possibly can, before reading into your analytical tool of choice. You should consider filtering out unnecessary rows or columns, or aggregating results if appropriate. The function `create_temp_table` in `pydbtools` is particularly useful for helping with this.

If the data is stored in your own S3 bucket, you may wish to create your own Athena database.

## How do I create my own Athena database?

**Athena workbench/Python/R**: You can run `CREATE DATABASE` and `CREATE TABLE AS SELECT` (CTAS) queries to create your own database and tables from data you have in S3. There are more details in this guidance or you can use what is provided by [AWS](https://docs.aws.amazon.com/athena/latest/ug/language-reference.html). When running CTAS queries a key thing to remember is to specify the location (s3 bucket and path) of the data. There is a nice example [here](https://github.com/moj-analytical-services/mojap-aws-tools-demo/blob/main/creating_and_maintaining_database_tables_in_athena.ipynb) of setting up your own database. The tutorial is in python but the SQL can be ran from any tool on the AP.

**Create a Derived Table**: When you create and run an SQL script with [Create a Derived Table](https://user-guidance.analytical-platform.service.justice.gov.uk/tools/create-a-derived-table/index.html) it will automatically build your database and table. See the user guidance for more information.
