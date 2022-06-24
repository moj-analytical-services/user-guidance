# Tools

The MoJ Analytical Platform comes with various tools including:

### [Control panel](control-panel.html) 
The main entry point to the Analytical Platform
### [RStudio](rstudio)
A development environment for writing R code and R Shiny apps

### [JupyterLab](jupyterlab) 
A development environment for writing Python code

### [Airflow](airflow) 
A tool for scheduling and monitoring workflows

### [Data Discovery](../data/curated-databases/data-documentation)
The data engineering team maintain a number of databases on the Analytical Platform (curated databases). The best way to find out about these is using the data discovery tool

### Data Uploader
Under construction

### Create a Derived Table
Implements a tool called dbt, for creating persistent derived tables in Athena. Visit the [Create a Derived Table repo](https://github.com/moj-analytical-services/create-a-derived-table) to see progress, or sign up for testing on the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) Slack channel.

### Python packages

The data engineering team maintain the following python packages:

* [pydbtools](https://github.com/moj-analytical-services/pydbtools)
* [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser)
* [mojap-metadata](https://github.com/moj-analytical-services/mojap-metadata)
* [dataengineeringutils3](https://github.com/moj-analytical-services/dataengineeringutils3)

### R packages

The data engineering team maintain the following R package:

#### [dbtools](https://github.com/moj-analytical-services/dbtools)
A package that is used to run SQL queries configured for the Analytical Platform. This package is a [reticulated](https://rstudio.github.io/reticulate/) wrapper around [pydbtools](https://github.com/moj-analytical-services/pydbtools) which uses AWS Wrangler's Athena module but adds additional functionality (like Jinja templating, creating temporary tables) and alters some configuration to our specification.

The Analytical Platform community maintain the following R packages, which avoid the need for using Python in R projects:

#### [Rdbtools](https://github.com/moj-analytical-services/Rdbtools)
A native R package extending [noctua](https://dyfanjones.github.io/noctua/index.html) that is used to run SQL queries configured for the Analytical Platform. Access is provided through the R database interface [DBI](https://dbi.r-dbi.org/), and so works with the standard database functions used in R. It also works with [dbplyr](https://dbplyr.tidyverse.org/), which is an extention of dplyr allowing you to use familiar tidyverse functions on data in Athena itself (reducing the need for large data pre-processing steps in R, and without having to learn SQL). In addition, this package extends the methods defined in the noctua package to allow users easy access to a safe temporary database for intermediate processing steps.

#### [Rs3tools](https://github.com/moj-analytical-services/Rs3tools)
A native R package that is used to access AWS S3 from the Analytical Platform. It aims to be as compatible as possible with the legacy package [s3tools](https://github.com/moj-analytical-services/s3tools).