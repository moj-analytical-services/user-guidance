# Tools

The MoJ Analytical Platform comes with various tools including:

### [Control panel](control-panel.html)
The main entry point to the Analytical Platform.

### [RStudio](rstudio)
A development environment for writing R code and R Shiny apps.

### [JupyterLab](jupyterlab)
A development environment for writing Python code.

### [Data Discovery](../data/curated-databases/data-documentation)
The data engineering team maintain a number of databases on the Analytical Platform (curated databases). The best way to find out about these is using the data discovery tool.

### [Upload File Data](data-uploader)
A web application to upload data (.csv, .json, .jsonl) to the MoJ Analytical Platform in a standardised way.

### [Upload Microservices Data](https://dsdmoj.atlassian.net/wiki/external/4218552361/NjgzYjgzY2Q5ZTQ0NDJlMzg0YTYwYjY5M2Y4YmU5ZTI?atlOrigin=eyJpIjoiMmJhNWUwMTM2NDlhNGVkYjg1NzE1ZGNhYWY5YjM2ZWUiLCJwIjoiYyJ9)

Tools for uploading and refreshing data from microservices to the MoJ Analytical Platform in a standardised way:

- [data-engineering-data-extractor](https://github.com/ministryofjustice/data-engineering-data-extractor) extracts data from applications/services/microservices
- [register-my-data](https://github.com/ministryofjustice/register-my-data) moves the data into the AP [curated databases](../data/curated-databases)

### [Airflow](airflow)
A tool for scheduling and monitoring workflows.

### [Create a Derived Table](create-a-derived-table)
A tool for creating persistent derived tables in Athena.

### Python packages

The data engineering team maintain a number of python packages to help with data manipulation, as well as interfacing with data using our preferred services. The following python packages are those we consider the most useful:

#### [pydbtools](https://github.com/moj-analytical-services/pydbtools)
Standard package for querying MoJAP athena databases with useful features including temp table creation.

#### [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser)
Useful package for ensuring type conformance when reading with arrow or pandas.

#### [mojap-metadata](https://github.com/moj-analytical-services/mojap-metadata)
MoJAP defined metadata that interacts with other packages (inc arrow-pd-parser) for ensuring type conformance as well as a number of schema converters.

#### [dataengineeringutils3](https://github.com/moj-analytical-services/dataengineeringutils3)
A collection of useful utilities for interacting with AWS

#### [athena_tools](https://github.com/moj-analytical-services/athena_tools)
User friendly way of making small persisting ad hoc databases. In it's alpha release, please report all problems!

#### [mojap-aws-tools-demo](https://github.com/moj-analytical-services/mojap-aws-tools-demo)
A repo containing some helpful guides on how to use some of the above packages. You can also ask for help with these on #ask-data-engineering.

### R packages

The data engineering team maintain the following R package:

#### [dbtools](https://github.com/moj-analytical-services/dbtools)
A package for accessing Athena databases from the Analytical Platform.

The Analytical Platform community maintain the following R packages, which avoid the need for using Python in R projects:

#### [Rdbtools](https://github.com/moj-analytical-services/Rdbtools)
A native R package for accessing Athena databases from the Analytical Platform.

#### [Rs3tools](https://github.com/moj-analytical-services/Rs3tools)
A native R package that is used to access AWS S3 from the Analytical Platform, which is mainly compatible with the legacy package [s3tools](https://github.com/moj-analytical-services/s3tools).
