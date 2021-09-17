# Migrating to `botor`

The new version of RStudio on the Analytical Platform uses `botor` to access
our Amazon S3 data storage, replacing [`s3tools`](https://github.com/moj-analytical-services/s3tools). 
This guidance gives some hints on how to get going with `botor` and migrate 
code that uses `s3tools`.

This guidance assumes you have experience with `renv`. If you require a recap or guidance, please see either the [renv documentation from the platform guidance](https://github.com/moj-analytical-services/user-guidance/blob/dd896e73ed5be0dc42b9b38cd20e1e49e7cde560/source/documentation/tools/package-management.md#renv) or the [official renv documentation](https://rstudio.github.io/renv/articles/renv.html).

# Table of Contents
* [Installation](#installation)
* [Using botor](#usage)
  * [Reading data](#reading-data)
  * [Writing data](#writing-data)
  * [Other useful functions](#other-useful-functions)
* [Migrating from s3tools](#migrating-from-s3tools)
  * [read_using](#read_using)
  * [s3_path_to_full_df](#s3_path_to_full_df)
  * [write_df_to_csv_in_s3](#write_df_to_csv_in_s3)
  * [botor examples and comparisons](#botor-examples)

## Installation

_Eventually_ this will be achieved by running

```r
if(!"renv" %in% installed.packages()[, "Package"]) install.packages("renv") # install renv if it doesn't exist on your system
renv::init(bare = TRUE)
renv::use_python()
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

but on the current test version it's not quite that simple. 

First open your project, and in the **console** run

```r
if(!"renv" %in% installed.packages()[, "Package"]) install.packages("renv") # install renv if it doesn't exist on your system
renv::init(bare = TRUE)
```

Then in the **terminal** run

```bash
python3 -m venv renv/venv --without-pip --system-site-packages
```

Finally, in the RStudio console run the remaining lines:

```r
renv::use_python('renv/venv/bin/python')
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

You should now be able to use `library(botor)` as usual, and `renv::snapshot()` to 
lock the R and Python library versions for recreation by collaborators or
within a deployment.

For more on `renv` see [the documentation](https://rstudio.github.io/renv/articles/renv.html), 
particularly on [Using Python with renv](https://rstudio.github.io/renv/articles/python.html). 
The [reticulate documentation](https://rstudio.github.io/reticulate/) is also likely to be useful.

## Usage
### Reading data

Reading from S3 is handled by the [`s3_read`](https://daroczig.github.io/botor/reference/s3_read.html)
function. This takes a full S3 path, which must include the prefix `s3://`,
 and a read function as parameters. For example, to read a csv file run

```r
# For a dataframe,
df <- s3_read("s3://alpha-mybucket/my_data.csv", read.csv)
# for a tibble,
t <- s3_read("s3://alpha-mybucket/my_data.csv", readr::read_csv)
# and for a data.table
dt <- s3_read("s3://alpha-mybucket/my_data.csv", data.table::fread)
```

Other formats can be handled in a similar fashion.

```r
sas_data <- s3_read("s3://alpha-mybucket/my_data.sas7bdat", haven::read_sas)
feather_data <- s3_read("s3://alpha-mybucket/my_data.feather", 
                        feather::read_feather)
json_data <- s3_read('s3://botor/example-data/mtcars.json', jsonlite::fromJSON)
```

See `?botor::s3_read` for additional options.

`openxlsx::read.xlsx` will only open
files with the `.xlsx` suffix but `s3_read` uses a temporary file without
a suffix. To get around this either use `readxl::read_excel` or run the following for `openxlsx`

```r
temp_loc <- tempfile(fileext=".xlsx")
s3_download_file("s3://alpha-mybucket/my_data.xlsx", temp_loc)
wb <- openxlsx::read.xlsx(temp_loc)
unlink(temp_loc)
```

For large data files there's a handy option to uncompress compressed files.

```r
df <- s3_read("s3://alpha-mybucket/my_data.csv.gz", read.csv, 
              extract = "gzip")
```

To download a file to the local filesystem run

```r
s3_download_file("s3://alpha-mybucket/my_data.csv", "my_local_data.csv")
```

### Writing data

Similarly writing to S3 is handled by the [`s3_write`](https://daroczig.github.io/botor/reference/s3_download_file.html)
function. This takes an R object, a write function, and a full S3 path as
parameters. For example,

```r
s3_write(df, readr::write_csv, "s3://alpha-mybucket/my_data.csv")
s3_write(df, feather::write_feather, "s3://alpha-mybucket/my_data.feather")
s3_write(df, haven::write_sas, "s3://alpha-mybucket/my_data.sas7bdat")
s3_write(df, openxlsx::write.xlsx, "s3://alpha-mybucket/my_data.xlsx")
```

Data can also be compressed before writing.

```r
s3_write(df, "s3://alpha-mybucket/my_data.csv.gz", readr::write_csv,
         compress = "gzip")
```

To upload a file from the local filesystem run

```r
s3_upload_file("my_local_data.csv", "s3://alpha-mybucket/my_data.csv")
```

### Other useful functions

[`s3_ls`](https://daroczig.github.io/botor/reference/s3_ls.html) lists the 
objects matching an S3 path prefix, though the full bucket name must be 
present.

```r
# List all the objects in a bucket
s3_ls("s3://alpha-mybucket")
# List all the objects in the bucket's data directory
s3_ls("s3://alpha-mybucket/data/")
# List all the objects in the bucket's data directory beginning with p
s3_ls("s3://alpha-mybucket/data/p")
# Won't work
s3_ls("s3://alpha-mybu")
```

This returns a `data.frame`, the `uri` column is probably the most useful
as it contains paths that can be read by `s3_read`.

[`s3_exists`](https://daroczig.github.io/botor/reference/s3_exists.html)
checks if an object exists, which is useful as `s3_write` will overwrite an 
object regardless.

```r
if (!s3_exists("s3://alpha-mybucket/my_data.csv")) {
    s3_write(df, "s3://alpha-mybucket/my_data.csv", readr::write_csv)
}
```

For further information consult the 
[botor documentation](https://daroczig.github.io/botor/).

_Note:_ To turn off the debugging warnings found within the `botor` library, 
please use the following:
```r
library(logger)
log_threshold(WARN, namespace = 'botor')
```

_Warning:_ `botor` does not currently support refreshing credentials, most 
likely due to a limitation with using `boto3` through `reticulate` You may get
an error message

```
Error in py_call_impl(callable, dots$args, dots$keywords) : 
  RuntimeError: Credentials were refreshed, but the refreshed credentials are still expired.
```

In this event you will need to restart your R session; in RStudio this is
the red "off" button in the top right.

## Migrating from `s3tools`

### Replacement functions

This section contains functions that can be used within legacy code to 
replace `s3tools` calls.

#### `read_using`

```r
read_using <- function(FUN, s3_path, overwrite = TRUE, ...) {
  # trim s3:// if included by the user
  s3_path <- gsub('^s3://', "", s3_path)
  # find fileext
  file_ext <- paste0('.', tools::file_ext(s3_path))
  # download file to tempfile()
  tmp <- botor::s3_download_file(paste0('s3://', s3_path), 
                                 tempfile(fileext = file_ext), 
                                 force = overwrite)
  FUN(tmp, ...)
}
```

##### Examples

```r
read_using(
  FUN = openxlsx::read.xlsx,
  s3_path = 's3://alpha-my_bucket/my_data.xlsx',
  startRow = 1,
  sheet = 2
)

read_using(FUN=readxl::read_excel, s3_path="alpha-test-team/mpg.xlsx")
```

#### `s3_path_to_full_df`

```r
# if you are using a file with .gz, .bz or .xz extension, please use
# botor::s3_read directly
s3_path_to_full_df <- function(s3_path, ...) {
  # trim s3:// if included by the user
  s3_path <- gsub('^s3://', "", s3_path,)
  # fileexts accepted by s3_read
  accepted_direct_fileext <- c('csv' = read.csv, 
                               'json' = jsonlite::fromJSON,
                               'jsonl' = jsonlite::stream_in,
                               'rds' = readRDS,
                               'sas7bdat' = haven::read_sas,
                               'sav' = haven::read_sav,
                               'dta' = haven::read_dta)
  # specify all other accepted filetypes
  excel_filepaths <- c('xlsx', 'xls', 'xlsm')
  accepted_fileext <- c(names(accepted_direct_fileext), excel_filepaths)
  fileext <- tools::file_ext(s3_path)
  # error if invalid filepath is entered
  if(!grepl(paste0('(?i)', accepted_fileext, collapse = "|"), fileext)) {
    stop(paste0("Invalid filetype entered. Please confirm that your file",
                " extension is one of the following: ", 
                paste0(accepted_fileext, collapse = ', '), ". \n ",
                "Alternatively, use botor directly to read in your file."))
  }
  # if we are using a function accepted by s3_read, then use that to parse 
  # the data
  s3_path <- paste0('s3://',s3_path)
  if(grepl(paste0('(?i)', names(accepted_direct_fileext), collapse = "|"), 
           fileext)) {
    # read from s3 using our designated method
    botor::s3_read(s3_path, 
                   fun = accepted_direct_fileext[[tolower(fileext)]])
  } else {
    read_using(FUN = readxl::read_excel, s3_path = s3_path, ...)
  }
}
```

##### Examples

```r
s3_path_to_full_df('s3://alpha-everyone/mtcars_boto.csv')
s3_path_to_full_df(
    "alpha-everyone/my_excel_workbook.xlsx"), 
    sheet = 2)
s3_path_to_full_df(
    "alpha-everyone/folder1/test.xlsm"), 
    sheet = 1)
```

#### `write_df_to_csv_in_s3`

```r
write_df_to_csv_in_s3 <- function(df, s3_path, overwrite = FALSE, ...) { 
  # add errors
  if(!any(grepl('data.frame', class(df)))) {
    stop("df entered isn't a valid dataframe object")
  }
  if(tools::file_ext(s3_path) != 'csv') {
    stop("s3_path entered is either not a csv or is missing the .csv suffix")
  }
  # trim s3:// if included by the user - removed so we can supply both 
  # alpha-... and s3://alpha - and then add again
  s3_path <- paste0("s3://", gsub('^s3://', "", s3_path))
  if(!overwrite & botor::s3_exists(s3_path)) {
    stop("s3_path entered already exists and overwrite is FALSE")
  }
  # write csv
  botor::s3_write(df, fun = write.csv, uri = s3_path, ...)
}
```

##### Examples

```r
write_df_to_csv_in_s3(
    df = mtcars, 
    s3_path = "alpha-everyone/mtcars_boto.csv"
)
write_df_to_csv_in_s3(
    df = mtcars, 
    s3_path = "alpha-everyone/mtcars_boto.csv", 
    row.names = FALSE
)
```

### `botor` examples

This section will attempt to provide `botor` equivalents for each of the
examples on the 
[`s3tools` homepage](https://github.com/moj-analytical-services/s3tools), 
which will hopefully help with converting existing code.

### Which buckets do I have access to?

```r
s3tools::accessible_buckets()
```

There is no obvious way to achieve this with `botor`,
[s3_list_buckets](https://daroczig.github.io/botor/reference/s3_list_buckets.html)
is the closest, listing all buckets in the organisation. 

### What files do I have access to?

```r
## List all the files in the alpha-everyone bucket
s3tools::list_files_in_buckets('alpha-everyone')
# Using botor, note the s3:// must be present
botor::s3_ls('s3://alpha-everyone')

## You can list files in more than one bucket:
s3tools::list_files_in_buckets(c('alpha-everyone', 'alpha-dash'))
# botor only accepts one bucket as an argument
purrr::map(c('s3://alpha-everyone', 's3://alpha-dash'), botor::s3_ls) %>%
    dplyr::bind_rows()

## You can filter by prefix, to return only files in a folder
s3tools::list_files_in_buckets('alpha-everyone', prefix='s3tools_tests')
# Using botor the bucket and prefix are joined
botor::s3_ls('s3://alpha-everyone/s3tools_tests')

## The 'prefix' argument is used to filter results to any path that begins 
## with the prefix. 
s3tools::list_files_in_buckets('alpha-everyone', prefix='s3tools_tests', 
                               path_only = TRUE)
# Using botor select the uri column from the resulting data frame
botor::s3_ls('s3://alpha-everyone/s3tools_tests')$uri

## For more complex filters, you can always filter down the dataframe using 
## standard R code:
library(dplyr)

## All files containing the string 'iris'
s3tools::list_files_in_buckets('alpha-everyone') %>% 
    dplyr::filter(grepl("iris",path)) # Use a regular expression
# Using botor
botor::s3_ls('s3://alpha-everyone') %>% 
    dplyr::filter(grepl("iris",path))

## All excel files containing 'iris';
s3tools::list_files_in_buckets('alpha-everyone') %>% 
    dplyr::filter(grepl("iris*.xls",path)) 
# Using botor
botor::s3_ls('s3://alpha-everyone') %>% 
    dplyr::filter(grepl("iris*.xls",path)) 
```

### Reading files
#### `csv` files

```r
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/folder1/iris_folder1_1.csv")
# Use s3_read in botor to specify the read function
df <- botor::s3_read(
    "s3://alpha-everyone/s3tools_tests/folder1/iris_folder1_1.csv",
    read.csv)
```

Previewing the first few rows of a file is more complicated, it's not 
directly supported by `botor`.

```r
df <- s3tools::s3_path_to_preview_df(
    "alpha-moj-analytics-scratch/my_folder/10mb_random.csv")
# botor() returns a cached boto3 client, which can be used in the same
# way as using Python's boto3 library via reticulate 
client <- botor::botor()$client("s3")
obj <- client$get_object(
    Bucket = "alpha-moj-analytics-scratch", 
    Key = "my_folder/10mb_random.csv",
    Range = "bytes=0-12000")
df <- obj$Body$read()$decode() %>%
    textConnection() %>%
    read.csv() %>%
    head(n = 5)
```

#### Other file types

```r
# Uses readxl if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.xlsx")  
# Use s3_read in botor to specify the read function
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.xlsx",
                readxl::read_excel)

# Uses haven if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.sav")  
# Use s3_read in botor to specify the read function
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.sav",
                     haven::read_sav)

# Uses haven if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.dta")  
# Use s3_read in botor to specify the read function
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.dta",
                     haven::read_dta)

# Uses haven if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.sas7bdat")  
# Use s3_read in botor to specify the read function
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.sas7bdat",
                     haven::read_sas)

df <- s3tools::read_using(
    FUN=readr::read_csv, path = "alpha-everyone/s3tools_tests/iris_base.csv")
df <- s3_read("s3://alpha-everyone/s3tools_tests/iris_base.csv",
              readr::read_csv)
```

### Downloading files

`botor` will default to not checking whether it's overwriting files.

```r
df <- s3tools::download_file_from_s3(
    "alpha-everyone/s3tools_tests/iris_base.csv", "my_downloaded_file.csv")
# force is the same as overwrite in s3tools::download_file_from_s3, set to
# TRUE by default
botor::s3_download_file(
    "s3://alpha-everyone/s3tools_tests/iris_base.csv",
    "my_downloaded_file.csv", force = FALSE
    )

# By default, if the file already exists you will receive an error.  
# To override:
df <- s3tools::download_file_from_s3(
    "alpha-everyone/s3tools_tests/iris_base.csv", 
    "my_downloaded_file.csv",
    overwrite = TRUE
)
# No need to change the default behaviour
df <- botor::s3_download_file(
    "s3://alpha-everyone/s3tools_tests/iris_base.csv", 
    "my_downloaded_file.csv"
)
```

### Writing data to S3
#### Writing files to S3

`botor` will not check if files written to S3 already exist.

```r
s3tools::write_file_to_s3("my_downloaded_file.csv", 
                          "alpha-everyone/delete/my_downloaded_file.csv")
# With botor check if an S3 object already exists with s3_file_exists
if (!botor::s3_file_exists(
        "s3://alpha-everyone/delete/my_downloaded_file.csv") {
    botor::s3_upload_file(
        "my_downloaded_file.csv", 
        "s3://alpha-everyone/delete/my_downloaded_file.csv"
    ) 
} else {
    stop("s3://alpha-everyone/delete/my_downloaded_file.csv exists")
}

# By default, if the file already exists you will receive an error.  
# To override:
s3tools::write_file_to_s3("my_downloaded_file.csv", 
                          "alpha-everyone/delete/my_downloaded_file.csv", 
                          overwrite = TRUE)
# s3_upload_file will always overwrite an existing object 
botor::s3_upload_file("my_downloaded_file.csv", 
                      "s3://alpha-everyone/delete/my_downloaded_file.csv")
```

#### Writing a dataframe to s3 in csv format

```r
s3tools::write_df_to_csv_in_s3(iris, "alpha-everyone/delete/iris.csv")

if (!botor::s3_file_exists("s3://alpha-everyone/delete/iris.csv") {
    botor::s3_write(iris, "s3://alpha-everyone/delete/iris.csv", write.csv)
} else {
    stop("s3://alpha-everyone/delete/iris.csv already exists")
}

# By default, if the file already exists you will receive an error.  
# To override:
s3tools::write_df_to_csv_in_s3(iris, "alpha-everyone/delete/iris.csv", 
                               overwrite =TRUE)
botor::s3_write(iris, "s3://alpha-everyone/delete/iris.csv", write.csv)
```




