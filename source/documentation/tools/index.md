# Tools and services

The Analytical (AP) provides a range of tools, services and packages. This page describes the core tools and services that comprise the platform, as well as additional packages you can use to perform data analysis.

Note that we only provides support for third-party tools and services for features directly involving the Analytical Platform, such as bespoke configurations. For any other support with third-party tools and services, see the vendor's documentation; we have provided links where possible.

## Core tools and services

### [Airflow](airflow)
A tool for scheduling and monitoring workflows.

### [Control Panel](control-panel.html)
Main entry point to the Analytical Platform. Allows you to configure tools and view their status.

### [Create a Derived Table](create-a-derived-table)
A tool for creating persistent derived tables in Athena.

### [RStudio](rstudio)
Development environment for writing R code and R Shiny apps. For more information, see the [RStudio documentation](https://docs.posit.co/ide/user/).

### [JupyterLab](jupyterlab)
Development environment for writing Python code. For more information, see the [JupyterLab documentation](https://jupyterlab.readthedocs.io/en/latest/).

### [Visual Studio Code](visual-studio-code)
General purpose code editor. For more information, see the [Visual Studio Code documentation](https://code.visualstudio.com/docs).

### [Data Discovery](../data/curated-databases/data-documentation)
Allows you to browse the databases that are available on the Analytical Platform.

### [Data Uploader](data-uploader)
Web application for uploading data (.csv, .json, .jsonl) to the Analytical Platform in a standardised way.

### [Data Extractor](https://github.com/ministryofjustice/data-engineering-data-extractor)

Extracts data from applications, services or microservices to the Analytical Platform in a standardised way.

### [GitHub](https://github.com/)

Online hosting platform for git. Git is a distributed version control system that allows you to track changes in files, while GitHub hosts the Analytical Platform's code.

### [Register my data](https://github.com/ministryofjustice/register-my-data)

Moves data from microservices into the Analytical Platform's [curated databases](../data/curated-databases) in a standardised way.

### [Ingestion](ingestion)
An SFTP based service that allows users to ingest data into their Analytical Platform data warehouse.

## Python packages

The Data Engineering team maintain Python packages that help with data manipulation. The following are the packages we consider the most useful for doing so:

### [athena_tools](https://github.com/moj-analytical-services/athena_tools)
Provides a simple way to create small persisting ad hoc databases. Currently in Alpha.

### [dataengineeringutils3](https://github.com/moj-analytical-services/dataengineeringutils3)
Collection of useful utilities for interacting with AWS.

### [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser)
Ensures type conformance when reading with arrow or pandas.

### [mojap-aws-tools-demo](https://github.com/moj-analytical-services/mojap-aws-tools-demo)
Contains helpful guides on how to use the Python packages listed in this section. You can also ask for help with these in the **#ask-data-engineering** Slack channel on the **Justice Digital workspace**.

### [mojap-metadata](https://github.com/moj-analytical-services/mojap-metadata)
Defined metadata that interacts with other packages (including arrow-pd-parser) to ensure type conformance, as well as schema converters.

### [pydbtools](https://github.com/moj-analytical-services/pydbtools)
Queries MoJAP athena databases with features such as temp table creation.

### [splink](https://github.com/moj-analytical-services/splink)
Provides the ability to link datasets at scale. Splink is the matching engine behind the linked data on the Analytical Platform. This package is maintained by the Internal Data Linking team, support is offered via the **#ask-data-linking** Slack channel.

## R packages

The following native R packages remove the need for using Python in R projects.

### [dbtools](https://github.com/moj-analytical-services/dbtools)
Allows you to access databases from the Analytical Platform. The Data Engineering team maintains this package.

### [Rdbtools](https://github.com/moj-analytical-services/Rdbtools)
Allows you to access Athena databases from the Analytical Platform. The Analytical Platform community maintain this package.

### [Rs3tools](https://github.com/moj-analytical-services/Rs3tools)
Allows you to access AWS S3 from the Analytical Platform, which is mainly compatible with the legacy package [s3tools](https://github.com/moj-analytical-services/s3tools). The Analytical Platform community maintain this package.
