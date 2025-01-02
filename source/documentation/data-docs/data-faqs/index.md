# Data FAQs

## What types of data are on the Platform?

Data on the Analytical Platform can largely be split into four categories:

- `Raw`: data that has been uploaded to the Analytical Platform without any changes made to it
- `Curated`: data that has been validated, deduplicated and versioned by the Data Engineers ready to be used by Analytical Platform users
- `Derived`: data that has been [denormalized] and turned into a data model to fit the general needs of Analytical Platform users
- `Processed`: data that has been processed by Analytical Platform users to fit their specific needs

## Where do I find out what data is already on the Platform?

> 🚩 Note: in the future the Data Catalogue will be developed and provide a useful resource for finding data

The Data Engineering and Modelling Team (DMET) maintain a number of databases on the Platform (_curated_ and _derived_ databases). The best way to find out about _curated_ and _derived_ databases is using the [data discovery tool] \(access to the tool is now governed via GitHub; Analytical Platform users have access by default\). The data discovery tool can be updated by anyone, so if you find something out about the data that isn't already documented, please do add to it. _Derived_ tables can also be found by visiting the [create-a-derived-table repository]. For more information about _curated_ databases please visit [#ask-data-engineering] and for _derived_ databases please visit [#ask-data-modelling].

In addition to this users can create their own S3 buckets which may have _processed_ data useful to other teams, you may have to ask around to see if there is an existing dataset that may suit your needs.

## How do I gain access to existing data?

Access to **databases** is granted via the [database access repository]. Have a read through the guidance on there. If you are finding the process a little tricky, please ask for help in [#ask-data-engineering]. A data engineer will happily guide you through things.

If you are looking for access to a **user-created bucket**, then the admin of that bucket should be able to grant you access. If you don't know who the admin is, or they are not able to grant you access, then raise a ticket via the [#analytical-platform-support] Slack channel or via [GitHub]. If the bucket admin is unavailable, the Analytical Platform team will need to receive approval from your line manager before you can be given any access to the bucket.

## Where should I store my own data?

> ⚠️ We can only hold 1,000 S3 buckets on the Analytical Platform. Before you [create a new secure data storage folder](../amazon-s3.md#create-a-new-warehouse-data-source), please check whether you can re-use an existing one, or create a domain-level S3 bucket and use folders and [path-specific access](../amazon-s3.md#path-specific-access) for project level access.

Data should be stored in a [Warehouse data source](../amazon-s3.md#warehouse-data-sources) (a folder within an S3 bucket with managed access). You can [create a new secure data storage folder](../amazon-s3.md#create-a-new-warehouse-data-source) through the AP Control Panel 'Warehouse Data' page via the '_Create new warehouse data source_' button. Data can be uploaded manually via the AWS console (which can be accessed through the Control Panel) or you can write to it programmatically using [an integrated development environment (IDE) such as RStudio, Visual Studio Code or JupyterLab](../../tools/#integrated-development-environments-ide) - [see this section](#how-do-i-readwrite-data-from-an-s3-bucket) for more details.

If your data contains anything that could be considered personal information, you must follow guidance from the data protection team which can be found on [the intranet].

## How do I read/write data from an s3 bucket?

**Python**: You can read/write directly from S3 using a variety of tools such as pandas, boto3, aws wrangler. However, to get the best representation of the column types in the resulting Pandas dataframe(s), you may wish to use [mojap-arrow-pd-parser].

**R**: Whilst initially the recommended package was [botor], you are also encouraged to try out [Rs3tools] a community-maintained, R-native version of S3tools that removes some of the complexity around using Python.

## How do I query a database on the Platform?

Databases on the AP use Amazon Athena which allow you to query data using SQL. You shouldn't need to know about Athena in detail to query databases on the AP, but if you are interested you may wish to [read more about it]. There are three ways you can query data (there is more detail on all three of these in [`Data` section of this guidance](../index.md)):

**The Amazon Athena workbench**: If you [log into the AWS console] and click Services -> Athena, you'll see the Athena workbench. This is good for testing your queries.

**Create a Derived Table**: You can also use [Create a Derived Table](../../tools/create-a-derived-table/) to run SQL statements to query Athena.

If you get an error like:

```
assumed-role/... is not authorized to perform: glue:GetDatabases
```

you'll need to [request database access].

**Python**: To run queries and/or read data into a pandas DataFrame, use [`pydbtools`]. Remember to install the latest version!

**R**: There is currently no single recommended package for querying databases in R. There is [`dbtools`] which should work on the "old" platform. [`Rdbtools`] should work on the "new" platform. This package is maintained by the analytical platform user community.

## What should I use to process my data?

Please refer to [the tools and services page](../../tools/)

## I am running into memory issues using Python/R, what should I do?

You should do as much data manipulation in Athena/SQL as you possibly can, before reading into your analytical tool of choice. You should consider filtering out unnecessary rows or columns, or aggregating results if appropriate. The function `create_temp_table` in `pydbtools` is particularly useful for helping with this.

If the data is stored in your own S3 bucket, you may wish to create your own Athena database.

## How do I create my own Athena database?

**Athena workbench/Python/R**: You can run `CREATE DATABASE` and `CREATE TABLE AS SELECT` (CTAS) queries to create your own database and tables from data you have in S3. There are more details in this guidance or you can use what is provided by [AWS]. When running CTAS queries a key thing to remember is to specify the location (s3 bucket and path) of the data. [here is a nice example of setting up your own database]. The tutorial is in python but the SQL can be ran from any tool on the AP.

**Create a Derived Table**: When you create and run an SQL script with [Create a Derived Table](../../tools/create-a-derived-table/) it will automatically build your database and table. See the user guidance for more information.

<!-- External links -->

[denormalized]: https://en.wikipedia.org/wiki/Denormalization#:~:text=Denormalization%20is%20a%20strategy%20used,data%20or%20by%20grouping%20data.
[data discovery tool]: https://data-discovery-tool.analytical-platform.service.justice.gov.uk/  
[create-a-derived-table repository]: https://github.com/moj-analytical-services/create-a-derived-table
[#ask-data-engineering]: https://moj.enterprise.slack.com/archives/C8X3PP1TN
[#ask-data-modelling]: https://moj.enterprise.slack.com/archives/C03J21VFHQ9
[database access repository]: https://github.com/moj-analytical-services/data-engineering-database-access?tab=readme-ov-file#data-engineering-database-access
[#analytical-platform-support]: https://app.slack.com/client/T02DYEB3A/C4PF7QAJZ
[GitHub]: https://github.com/ministryofjustice/data-platform-support/issues/new/choose
[the intranet]: https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/
[mojap-arrow-pd-parser]: https://github.com/moj-analytical-services/mojap-arrow-pd-parser
[botor]: https://github.com/daroczig/botor
[Rs3tools]: https://github.com/moj-analytical-services/Rs3tools?tab=readme-ov-file#rs3tools
[read more about it]: https://aws.amazon.com/athena/
[log into the AWS console]: https://aws.services.analytical-platform.service.justice.gov.uk
[request database access]: https://github.com/moj-analytical-services/data-engineering-database-access#standard-database-access
[`pydbtools`]: https://github.com/moj-analytical-services/pydbtools
[`dbtools`]: https://github.com/moj-analytical-services/dbtools
[`Rdbtools`]: https://github.com/moj-analytical-services/Rdbtools
[AWS]: https://docs.aws.amazon.com/athena/latest/ug/language-reference.html
[here is a nice example of setting up your own database]: https://github.com/moj-analytical-services/mojap-aws-tools-demo/blob/main/creating_and_maintaining_database_tables_in_athena.ipynb
