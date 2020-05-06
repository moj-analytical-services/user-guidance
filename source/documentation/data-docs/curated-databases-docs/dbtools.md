# `dbtools`

`dbtools` is a simple package available for R and Python that allows you to query databases using Amazon Athena and obtain the S3 path of the query output.

## R

### Installation

Before installing `dbtools`, you first need to install and load `devtools` (or `remotes`) using the following code:

```
install.packages("devtools")
library(devtools)
```

You should also ensure that the following dependencies are installed and loaded:

* `boto3` (Python, preinstalled)
* `data.table` (R, version 1.11.8 or above)
* `python` (System, preinstalled)
* `readr` (R, preinstalled)
* `reticulate` ( R )
* `s3tools` (R, preinstalled)

For more information on installing packages, see Appendix \@ref(installing-packages).

To install the latest version of `dbtools`, run the following code:

```
devtools::install_github("moj_analytical_services/dbtools")
library(dbtools)
```

### Functions

`dbtools` contains two functions:

* `read_sql`
* `get_athena_query_response`

#### `read_sql`

`read_sql` submits a query to Amazon Athena and returns the output of the query as a tibble, dataframe or data.table. A tibble is returned by default, however, you can select another option using the `return_df_as` argument.

You can read more about the function by running the following code in R:

```
help?dbtools::read_sql
```

#### `get_athena_query_response`

`get_athena_query_response` submits a query to Athena but does not directly return the output. Instead, it returns a list that contains the S3 path of the output and query metadata.

You can then read the output into RStudio using `s3tools` and the read method of your choice. When using `s3tools` you should remove `s3://` from the S3 path.

You can read more about the function by running the following code in R:

```
help?dbtools::get_athena_query_response
```

### Examples

The [README](https://github.com/moj-analytical-services/dbtools/blob/master/README.md) in the `dbtools` repository on GitHub provides several examples of how to use each function.

The README also contains information on the conversion of metadata, including data types, when reading from Athena into a tibble, dataframe or data.table.

## Python

### Installation

Before installing `pydbtools`, ensure that the following dependencies are installed and loaded:

* `boto3` (Python, preinstalled)
* `gluejobutils` (Python)
* `numpy` (Python, preinstalled)
* `pandas` (Python, preinstalled)
* `s3fs` (Python)

For more information on installing packages, see Appendix \@ref(installing-packages).

### Functions

`pydbtools` contains two functions:

* `read_sql`
* `get_athena_query_response`

#### `read_sql`

`read_sql` submits a query to Amazon Athena and returns the output of the query as a pandas dataframe.

#### `get_athena_query_response`

`get_athena_query_response` submits a query to Athena but does not directly return the output. Instead, it returns a dictionary that contains the S3 path of the output and query metadata.

You can then read the output directly into Python using `pd.read_csv`. When using `pd.read_csv` you should replace `s3://` with `s3a://` in the S3 path.

### Examples

The [README](https://github.com/moj-analytical-services/pydbtools/blob/master/README.md) in the `pydbtools` repository on GitHub provides several examples of how to use each function.

The README also contains information on the conversion of metadata, including data types, when reading from Athena into a pandas dataframe.
