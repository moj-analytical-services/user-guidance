# Migrating to `botor`

The new version of RStudio on the Analytical Platform uses `botor` to access
our Amazon S3 data storage, replacing
[`s3tools`](https://github.com/moj-analytical-services/s3tools).
This guidance gives some hints on how to get going with `botor` and migrate
code that uses `s3tools`.

This guidance assumes you have experience with `renv`. If you require a recap
or guidance, please see either the
[renv documentation from the platform guidance](https://user-guidance.analytical-platform.service.justice.gov.uk/tools/package-management.html#renv) or the
[official renv documentation](https://rstudio.github.io/renv/articles/renv.html).

> As an alternative to trying Botor, you can also try [Rs3tools](https://github.com/moj-analytical-services/Rs3tools),
> a community maintained, R-native, s3tools compatible library.


## Table of Contents
* [Installation](#installation)
* [Using botor](#usage)
    * [Reading data](#reading-data)
    * [Writing data](#writing-data)
    * [Other useful functions](#other-useful-functions)
* [Migrating from s3tools](#migrating-from-s3tools)
    * [Replacement functions](#replacement-functions)
        * [`read_using`](#read-using)
        * [`s3_path_to_full_df`](#s3-path-to-full-df)
        * [`s3_path_to_preview_df`](#s3-path-to-preview-df)
        * [`download_file_from_s3`](#download-file-from-s3)
        * [`write_df_to_csv_in_s3`](#write-df-to-csv-in-s3)
        * [`write_df_to_table_in_s3`](#write-df-to-table-in-s3)
        * [`write_file_to_s3`](#write-file-to-s3)
        * [`list_files_in_buckets`](#list-files-in-buckets)
    * [botor examples and comparisons](#botor-examples)

## Installation

Using Analytical Tools [rstudio 4.1.7] Rstudio 4.0.5 or later:

```r
# Make sure the latest package versions are used
options(repos = "https://cloud.r-project.org/")
# install renv if it doesn't exist on your system
if(!"renv" %in% installed.packages()[, "Package"]) install.packages("renv")
# Remove bare = TRUE if you'd like to move your existing packages over to
# renv. This is not a good idea if you're migrating from s3tools as
# renv will attempt to install that library.
renv::init(bare = TRUE)
# Tell renv to use Python and set up a virtual environment.
# If you get an error here, remove the python path argument and
# manually select the version of python you require.
renv::use_python(python='/usr/bin/python3')
# Install reticulate so we can make calls to Python libraries, required by
# botor
renv::install('reticulate')
# Install the Python library, boto3, used by botor to access S3
reticulate::py_install('boto3')
# Install botor itself
renv::install('botor')
```

If you get an error

```
Error in main_process_python_info() :
  function 'Rcpp_precious_remove' not provided by package 'Rcpp'
```

then install a later version of Rcpp using

```r
renv::install('Rcpp@1.0.7')
```

and restart your R session.

On earlier test versions it's not quite that simple:

First open your project, and in the **console** run

```r
# install renv if it doesn't exist on your system
if(!"renv" %in% installed.packages()[, "Package"]) install.packages("renv")
# Initialise the renv environment. Remove bare = TRUE if you'd like to move
# your existing packages over to renv, but keep it set to TRUE if you're
# already using botor, dbtools or reticulate otherwise it will point to the
# wrong or a non-existent Python.
renv::init(bare = TRUE)
```

Then in the **terminal** run

```bash
python3 -m venv renv/venv --without-pip --system-site-packages
```

to create a Python virtual environment.

Finally, in the RStudio console run the remaining lines:

```r
renv::use_python('renv/venv/bin/python')
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

If this process goes wrong run

```r
renv::deactivate()
```

in the console and

```bash
rm -rf renv renv.lock .Rprofile requirements.txt
```

in the terminal, restart your R session, and start again.

You should now be able to use `library(botor)` as usual, and `renv::snapshot()`
to lock the R and Python library versions for recreation by collaborators or
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
df <- botor::s3_read("s3://alpha-mybucket/my_data.csv", read.csv)
# for a tibble,
t <- botor::s3_read("s3://alpha-mybucket/my_data.csv", readr::read_csv)
# and for a data.table
dt <- botor::s3_read("s3://alpha-mybucket/my_data.csv", data.table::fread)
```

Other formats can be handled in a similar fashion.

```r
sas_data <- botor::s3_read("s3://alpha-mybucket/my_data.sas7bdat", 
                           haven::read_sas)
feather_data <- botor::s3_read("s3://alpha-mybucket/my_data.feather",
                               arrow::read_feather)
json_data <- botor::s3_read('s3://botor/example-data/mtcars.json', 
                            jsonlite::fromJSON)
```

See `?botor::s3_read` for additional options.

`openxlsx::read.xlsx` will only open
files with the `.xlsx` suffix but `s3_read` uses a temporary file without
a suffix. To get around this either use `readxl::read_excel` or run the
following for `openxlsx`

```r
s3_read_xlsx <- function(s3_path, ...) {
    temp_loc <- tempfile(fileext=".xlsx")
    botor::s3_download_file(s3_path, temp_loc)
    wb <- openxlsx::read.xlsx(temp_loc, ...)
    unlink(temp_loc)
    return(wb)
}
s3_read_xlsx("s3://alpha-mybucket/my_data.xlsx")
```

For large data files there's a handy option to uncompress compressed files.

```r
df <- botor::s3_read("s3://alpha-mybucket/my_data.csv.gz", 
                     read.csv, extract = "gzip")
```

To download a file to the local filesystem run

```r
botor::s3_download_file("s3://alpha-mybucket/my_data.csv", 
                        "my_local_data.csv")
```

### Writing data

Similarly writing to S3 is handled by the [`s3_write`](https://daroczig.github.io/botor/reference/s3_download_file.html)
function. This takes an R object, a write function with `file` as a parameter
specifying the path to the data, and a full S3 path as
parameters. For example,

```r
botor::s3_write(df, readr::write_csv, 
                "s3://alpha-mybucket/my_data.csv")
botor::s3_write(df, haven::write_sas, 
                "s3://alpha-mybucket/my_data.sas7bdat")
botor::s3_write(df, openxlsx::write.xlsx, 
                "s3://alpha-mybucket/my_data.xlsx")
```

This won't work for functions such as `arrow::write_feather` that use an
alternative name for the `file` parameter.

```r
s3_write_feather <- function(df, s3_path, ...) {
    temp_loc <- tempfile(fileext=".feather")
    arrow::write_feather(df, temp_loc, ...)
    botor::s3_upload_file(temp_loc, s3_path)
    unlink(temp_loc)
}
s3_write_feather(df, "s3://alpha-mybucket/my_data.feather")
```

Data can also be compressed before writing.

```r
botor::s3_write(df, "s3://alpha-mybucket/my_data.csv.gz", 
                readr::write_csv, compress = "gzip")
```

To upload a file from the local filesystem run

```r
botor::s3_upload_file("my_local_data.csv", 
                      "s3://alpha-mybucket/my_data.csv")
```

### Other useful functions

[`s3_ls`](https://daroczig.github.io/botor/reference/s3_ls.html) lists the
objects matching an S3 path prefix, though the full bucket name must be
present.

```r
# List all the objects in a bucket
botor::s3_ls("s3://alpha-mybucket")
# List all the objects in the bucket's data directory
botor::s3_ls("s3://alpha-mybucket/data/")
# List all the objects in the bucket's data directory beginning with p
botor::s3_ls("s3://alpha-mybucket/data/p")
# Won't work
botor::s3_ls("s3://alpha-mybu")
```

This returns a `data.frame`, the `uri` column is probably the most useful
as it contains paths that can be read by `s3_read`.

[`s3_exists`](https://daroczig.github.io/botor/reference/s3_exists.html)
checks if an object exists, which is useful as `s3_write` will overwrite an
object regardless.

```r
if (!botor::s3_exists("s3://alpha-mybucket/my_data.csv")) {
    botor::s3_write(df, "s3://alpha-mybucket/my_data.csv", 
                    readr::write_csv)
}
```

For further information consult the
[botor documentation](https://daroczig.github.io/botor/).

_Note:_ To turn off the debugging warnings found within the `botor` library,
please use the following:

```r
logger::log_threshold('WARN', namespace = 'botor')
```

## Migrating from `s3tools`

### Replacement functions

This section contains functions that can be used within legacy code to
replace `s3tools` calls. All these functions need `botor` and its
dependencies installed, please see [Installation](#installation) for guidance.

#### `read_using`

```r
read_using <- function(FUN, s3_path, ...) {
  # trim s3:// if included by the user
  s3_path <- paste0("s3://", gsub('^s3://', "", s3_path))
  # find fileext
  file_ext <- paste0('.', tolower(tools::file_ext(s3_path)))
  # download file to tempfile()
  tmp <- botor::s3_download_file(s3_path,
                                 tempfile(fileext = file_ext),
                                 force = TRUE)
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
  s3_path <- paste0('s3://', gsub('^s3://', "", s3_path))
  # fileexts accepted by s3_read
  accepted_direct_fileext <- c('csv' = read.csv,
                               'json' = jsonlite::fromJSON,
                               'jsonl' = jsonlite::stream_in,
                               'rds' = readRDS,
                               'sas7bdat' = haven::read_sas,
                               'sav' = haven::read_spss,
                               'dta' = haven::read_stata)
  # specify all other accepted filetypes
  excel_filepaths <- c('xlsx', 'xls', 'xlsm')
  accepted_fileext <- c(names(accepted_direct_fileext), excel_filepaths)
  fileext <- tolower(tools::file_ext(s3_path))
  # error if invalid filepath is entered
  if(!grepl(paste0('(?i)', accepted_fileext, collapse = "|"), fileext)) {
    stop(paste0("Invalid filetype entered. Please confirm that your file",
                " extension is one of the following: ",
                paste0(accepted_fileext, collapse = ', '), ". \n ",
                "Alternatively, use botor directly to read in your file."))
  }
  # if we are using a function accepted by s3_read, then use that to parse
  # the data
  if(grepl(paste0('(?i)', names(accepted_direct_fileext), collapse = "|"),
           fileext)) {
    # read from s3 using our designated method
    tryCatch({
      botor::s3_read(s3_path, fun = accepted_direct_fileext[[tolower(fileext)]])
    },
    error = function(cond){
      stop("\nError, file cannot be parsed. \nYou either don't have access to this bucket, or are using an invalid s3_path argument (the s3_path you've entered needs correcting).")
    })

  } else {
    tryCatch({
      read_using(FUN = readxl::read_excel, s3_path = s3_path, ...)
    },
    error = function(cond){
      stop("\nError, file cannot be parsed. \nYou either don't have access to this bucket, or are using an invalid s3_path argument (the s3_path you've entered needs correcting).")
    })

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

#### `s3_path_to_preview_df`

The library `stringr` needs to be installed.

```r
s3_path_to_preview_df = function(s3_path, ...) {
  s3_path <- stringr::str_replace(s3_path, "s3://", "")
  split_path <- stringr::str_split(s3_path, "/")[[1]]
  bucket <- split_path[1]
  key <- stringr::str_c(split_path[-1], collapse="/")
  fext <- tolower(tools::file_ext(key))
  if (!(fext %in% c("csv", "tsv"))) {
    message(stringr::str_glue("Preview not supported for {fext} files"))
    NULL
  } else {
    tryCatch(
      {
        client <- botor::botor()$client("s3")
        obj <- client$get_object(Bucket = bucket, Key = key,
                                 Range = "bytes=0-12000")
        obj$Body$read()$decode() %>%
          textConnection() %>%
          read.csv() %>%
          head(n = 5)
      },
      error = function(c) {
        message("Could not read ", s3_path)
        stop(c)
      }
    )
  }
}
```

##### Examples

```r
s3_path_to_preview_df('alpha-mybucket/my_data.csv')
```

#### `download_file_from_s3`

```r
download_file_from_s3 <- function(s3_path, local_path, overwrite = FALSE) {
  # trim s3:// if included by the user and add it back in where required
  s3_path <- paste0("s3://", gsub('^s3://', "", s3_path))
  if (!(file.exists(local_path)) || overwrite) {
    local_path_folders <- stringr::str_extract(local_path, ".*[\\\\/]+")
    if(!is.na(local_path)) {
      dir.create(local_path_folders, showWarnings = FALSE, recursive = TRUE)
    }
    # download file
    tryCatch({
      # download file to tempfile()
      botor::s3_download_file(s3_path,
                              local_path,
                              force = overwrite)
    },
    error = function(cond){
      stop("\nError, file cannot be found. \nYou either don't have access to this bucket, or are using an invalid s3_path argument (file does not exist).")
    })



  } else {
    stop(paste0("The file already exists locally and you didn't specify",
                " overwrite=TRUE"))
  }
}
```

##### Examples

```r
download_file_from_s3("alpha-everyone/mtcars_boto.csv",
                      "local_folder/mtcars_boto.csv", overwrite = TRUE)
```

#### `write_df_to_csv_in_s3`

```r
write_df_to_csv_in_s3 <- function(df, s3_path, overwrite = FALSE,
                                  multipart = "unused", ...) {
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

#### `write_df_to_table_in_s3`

```r
write_df_to_table_in_s3 <- function(df, s3_path, overwrite = FALSE,
                                  multipart = "unused", ...) {
  # add errors
  if(!any(grepl('data.frame', class(df)))) {
    stop("df entered isn't a valid dataframe object")
  }
  if(tolower(tools::file_ext(s3_path)) != 'csv') {
    stop("s3_path entered is either not a csv or is missing the .csv suffix")
  }
  # trim s3:// if included by the user - removed so we can supply both
  # alpha-... and s3://alpha - and then add again
  s3_path <- paste0("s3://", gsub('^s3://', "", s3_path))
  if(!overwrite & botor::s3_exists(s3_path)) {
    stop("s3_path entered already exists and overwrite is FALSE")
  }
  # write csv
  botor::s3_write(df, fun = write.table, uri = s3_path, ...)
}
```

##### Examples

```r
write_df_to_table_in_s3(
    df = mtcars,
    s3_path = "alpha-everyone/mtcars_boto.csv"
)
write_df_to_table_in_s3(
    df = mtcars,
    s3_path = "alpha-everyone/mtcars_boto.csv",
    row.names = FALSE
)
```

#### `write_file_to_s3`

```r
write_file_to_s3 <- function(local_file_path, s3_path, overwrite=FALSE,
                             multipart = "unused") {
  # ensure s3:// is present if not already
  s3_path <- paste0("s3://", gsub("^s3://", "", s3_path))
  if (overwrite || !(botor::s3_exists(s3_path))) {
    tryCatch(
      botor::s3_upload_file(local_file_path, s3_path),
      error = function(c) {
        message(paste0("Could not upload ", local_file_path, " to ", s3_path),
                appendLF = TRUE)
        stop(c, appendLF = TRUE)
      }
    )

  } else {
    stop("File already exists and you haven't set overwrite = TRUE, stopping")
  }
}
```

##### Examples

```r
write_file_to_s3("my_local_data.csv", "s3://alpha-mybucket/my_data.csv")
```

#### `list_files_in_buckets`

The libraries `dplyr` and `purrr` need to be installed.

```r
list_files_in_buckets <- function(bucket_filter = NULL, prefix = NULL,
                                  path_only = FALSE, max = "unused") {
  historic_column_names <- c(
    "key" = "key",
    "last_modified" = "lastmodified",
    "size" = "size",
    "bucket_name" = "bucket",
    "path" = "path"
  )

  if (is.null(bucket_filter)) {
    stop(paste0("You must provide one or more buckets e.g. ",
                "accessible_files_df('alpha-everyone')  This function will ",
                "list their contents"))
  }
  if(!is.character(bucket_filter)) {
    stop("Supplied bucket_filter is not of class: character")
  }
  if(!is.character(prefix)&!is.null(prefix)) {
    stop("Supplied prefix is not of class: character")
  }
  list_files_in_bucket <- function(bucket) {
    # trim s3:// if included by the user - removed so we can supply both
    # alpha-... and s3://alpha-...
    bucket <- gsub('^s3://', "", bucket)
    cols_to_keep <- c("key","last_modified","size","bucket_name")
    path_prefix <- (paste0('s3://', bucket, "/", prefix))
    list <- botor::s3_ls(path_prefix)
    if (is.null(list)) {
      warning(path_prefix, ' matches 0 files')
      return(list)
    }
    list <- list[,cols_to_keep]
    list["path"] <- paste(list$bucket_name, list$key, sep = '/')
    if(is.null(prefix)) {
      return(list)
    } else {
      return(list[grepl(prefix, list$key, ignore.case = TRUE),])
    }
  }
  file_list <- dplyr::bind_rows(purrr::map(bucket_filter,
                                           list_files_in_bucket))
  if(is.numeric(max)) file_list <- head(file_list, max)
  # apply some finishing touches so it aligns with s3tools version
  colnames(file_list) <- stringr::str_replace_all(colnames(file_list), historic_column_names)
  file_list[["filename"]] = dplyr::coalesce(stringr::str_extract(file_list$key, "[^\\/]+$"), stringr::str_replace_all(file_list$key, "\\\\/", ""))

  if (path_only) return(file_list$path)
  file_list
}
```

##### Examples

```r

# Type in the full string you watch to match...
list_files_in_buckets(bucket_filter = "alpha-everyone",
                      prefix = 'iris.csv')
# Or just the initial part of the string...
list_files_in_buckets(bucket_filter = "alpha-everyone",
                      prefix = 'iris')
```


### `botor` examples

Some of the replacement functions above are somewhat verbose to maintain
compatibility with `s3tools`, so you may prefer to convert your code to
use `botor` directly. This section attempts to provide `botor` equivalents
for each of the examples on the
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
    dplyr::filter(grepl("iris",uri))

## All excel files containing 'iris';
s3tools::list_files_in_buckets('alpha-everyone') %>%
    dplyr::filter(grepl("iris*.xls",path))
# Using botor
botor::s3_ls('s3://alpha-everyone') %>%
    dplyr::filter(grepl("iris*.xls",uri))
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
# With botor check if an S3 object already exists with s3_exists
if (!botor::s3_exists(
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
# s3_write will always overwrite an existing object
if (!botor::s3_exists("s3://alpha-everyone/delete/iris.csv") {
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
