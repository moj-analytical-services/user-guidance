# Databases

The data engineering team curate and maintain databases on the Analytical Platform that can be made accessible to users. All of our current databases are deployed and accessible using Amazon Athena. AP users can query these databases via the Athena SQL workbench (see the "Accessing Amazon Athena" section of the docs on how to access it), and in R and Python using [dbtools](https://github.com/moj-analytical-services/dbtools#dbtools) and [pydbtools](https://github.com/moj-analytical-services/pydbtools#pydbtools) respectively.

To see what databases are available and how to request access, see the [README](https://github.com/moj-analytical-services/data-engineering-database-access/blob/master/README.md) in the [data-engineering-database-access](https://github.com/moj-analytical-services/data-engineering-database-access) repository on GitHub. For each database, take careful note of any guidance documents to ensure you understand how to use the data correctly. Most curated databases on the AP use one of two data models.

1. Snapshot database models attach specific points in time to each record. Queries should specify the same snapshot literal for all data.
2. Temporal database models attach a start and end timestamp to each record indicating the period of its validity with respect to the source database.

> Note, you must be a member of the [moj-analytical-services](https://github.com/moj-analytical-services) GitHub organisation to access the repository.

To find out about the metadata of the curated databases (without making a database access request), you can use the [data discovery tool](../data-documentation).

## User-maintained databases

In addition to curated data sources provided by the Data Engineering team, AP users may wish to use the same infrastructure to create their own databases. While this requires slightly more maintenance, it gives you access to vastly more processing power for manipulating data than that available through R and Python on the AP.

Databases are created by writing data in a well-defined schema to an S3 location, and providing a register of the metadata to an AWS service. Access is controlled using the permissions of the S3 location of the underlying data. There is guidance on helper tools for creating your own Athena database [here](https://github.com/moj-analytical-services/mojap-aws-tools-demo/#tutorials).
