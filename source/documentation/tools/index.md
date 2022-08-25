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

### [Data Uploader](data-uploader)
A web application to upload data to the MoJ Analytical Platform in a standardised way.

### [Create a Derived Table](create-a-derived-table)
A tool for creating persistent derived tables in Athena

### Python packages

The data engineering team maintain the following python packages:

* [pydbtools](https://github.com/moj-analytical-services/pydbtools)
* [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser)
* [mojap-metadata](https://github.com/moj-analytical-services/mojap-metadata)
* [dataengineeringutils3](https://github.com/moj-analytical-services/dataengineeringutils3)

### R packages

The data engineering team maintain the following R package:

#### [dbtools](https://github.com/moj-analytical-services/dbtools)
A package for accessing Athena databases from the Analytical Platform.

The Analytical Platform community maintain the following R packages, which avoid the need for using Python in R projects:

#### [Rdbtools](https://github.com/moj-analytical-services/Rdbtools)
A native R package for accessing Athena databases from the Analytical Platform.

#### [Rs3tools](https://github.com/moj-analytical-services/Rs3tools)
A native R package that is used to access AWS S3 from the Analytical Platform, which is mainly compatible with the legacy package [s3tools](https://github.com/moj-analytical-services/s3tools).