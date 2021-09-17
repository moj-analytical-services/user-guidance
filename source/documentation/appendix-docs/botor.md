# Migrating to `botor`

The new version of RStudio on the Analytical Platform uses `botor` to access
our Amazon S3 data storage, replacing 
[`s3tools`](https://github.com/moj-analytical-services/s3tools). 
This guidance gives some hints on how to get going with `botor` and migrate 
code that uses `s3tools`.

## Installation

Eventually this will be achieved by running

```r
# remove bare = TRUE if you'd like to move your existing packages over to renv
renv::init(bare = TRUE) 
renv::use_python()
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

but on the current test version it's not quite that simple. 

First open your project, and then in the terminal run

```bash
python3 -m venv venv --without-pip --system-site-packages
```

Then in the RStudio console run

```r
# remove bare = TRUE if you'd like to move your existing packages over to renv,
# keep it set to TRUE if you're already using botor, dbtools or reticulate 
# otherwise it will point to the wrong or a non-existent Python
renv::init(bare = TRUE)
renv::use_python('venv/bin/python')
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

You can now use `library(botor)` as usual, and `renv::snapshot()` to 
lock the R and Python library versions for recreation by collaborators or
within a deployment.

For more on `renv` see 
[the documentation](https://rstudio.github.io/renv/articles/renv.html), 
particularly on 
[Using Python with renv](https://rstudio.github.io/renv/articles/python.html). 
The [reticulate documentation](https://rstudio.github.io/reticulate/) is also 
likely to be useful.

## Usage
### Reading data

Reading from S3 is handled by the 
[`s3_read`](https://daroczig.github.io/botor/reference/s3_read.html)
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

Additional arguments to the read function can be added to the end of the
parameters.

```r
t <- s3_read("s3://alpha-mybucket/my_data.csv", readr::read_csv, sheet = 2)
```

Other formats can be handled in a similar fashion.

```r
sas_data <- s3_read("s3://alpha-mybucket/my_data.sas7bdat", haven::read_sas)
feather_data <- s3_read("s3://alpha-mybucket/my_data.feather", 
                        feather::read_feather)
```

`openxlsx::read.xlsx` will only open
files with the `.xlsx` suffix but `s3_read` uses a temporary file without
a suffix. To get around this either use `readxl::read_excel` or run

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

Similarly writing to S3 is handled by the 
[`s3_write`](https://daroczig.github.io/botor/reference/s3_download_file.html)
function. This takes an R object, a write function with a parameter named 
`file`, and a full S3 path as parameters. For example,

```r
s3_write(df, readr::write_csv, "s3://alpha-mybucket/my_data.csv")
s3_write(df, haven::write_sas, "s3://alpha-mybucket/my_data.sas7bdat")
s3_write(df, openxlsx::write.xlsx, "s3://alpha-mybucket/my_data.xlsx")
```

Additional arguments to the write function can be added to the end of the
parameters.

```r
s3_write(df, readr::write_csv, "s3://alpha-mybucket/my_data.csv", na = "")
```

Some write functions, such as `feather::write_feather`, use a different name 
for their file location. In this case run

```r
temp_loc <- tempfile(fileext = "feather")
feather::write_feather(df, temp_loc)
s3_upload_file(temp_loc, "s3://alpha-mybucket/my_data.feather")
unlink(temp_loc)
```

Data can also be compressed before writing.

```r
s3_write(df, "s3://alpha-mybucket/my_data.csv.gz", readr::write_csv,
         compress = "gzip")
```

To upload a file to the local filesystem run

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

_Warning:_ `botor` does not currently support refreshing credentials, due to a 
limitation with using `boto3` through `reticulate`. You may get an error 
message

```
Python `RuntimeError`: Credentials were refreshed, but the refreshed credentials are still expired.
```

In this event you will need to restart your R session; in RStudio this is
the red "off" button in the top right.

## Migrating from `s3tools`

### Replacement functions

This section contains functions that can be used within legacy code to 
replace `s3tools` calls.

#### `read_using`

```r
# updated read_using function
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
  if(grepl(paste0('(?i)', names(accepted_direct_fileext), collapse = "|"), 
           fileext)) {
    # read from s3 using our designated method
    botor::s3_read(paste0('s3://',s3_path), 
                   fun = accepted_direct_fileext[[tolower(fileext)]], ...)
  } else {
    read_using(FUN = readxl::read_excel, s3_path = s3_path, ...)
  }
}
```

##### Examples

```r
s3_path_to_full_df('s3://alpha-hmpps-covid-data-processing/HMPPS-deaths.csv')
s3_path_to_full_df(
    paste0("alpha-hmpps-covid-data-processing/",
           "covid19infectionsurveydatasets20210521.xlsx"), 
    sheet = 2)
s3_path_to_full_df(
    paste0("alpha-hmpps-covid-data-processing/", 
           "capacity-reports/COVID-19CapacityImpact-20200427.xlsm"), 
    sheet = 1)
```

#### `write_df_to_csv_in_s3`

`botor` uses multipart uploads automatically.

```r
write_df_to_csv_in_s3 <- function(df, s3_path, overwrite = FALSE, 
                                  multipart = "unused", ...) { 
  # add errors
  if(!any(grepl('data.frame', df %>% class()))) {
    stop("df entered isn't a valid dataframe object")
  }
  if(tools::file_ext(s3_path) != 'csv') {
    stop("s3_path entered is either not a csv or is missing the .csv suffix")
  }
  # trim s3:// if included by the user - removed so we can supply both 
  # alpha-... and s3://alpha - and then add again
  s3_path <- paste0("s3://", gsub('^s3://', "", s3_path))
  if(!overwrite & s3_exists(s3_path)) {
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
    s3_path = "alpha-hmpps-covid-data-processing/mtcars_boto.csv"
)
write_df_to_csv_in_s3(
    df = mtcars, 
    s3_path = "alpha-hmpps-covid-data-processing/mtcars_boto.csv", 
    row.names = FALSE
)
```

#### `list_files_in_buckets`

```r
list_files_in_buckets <- function(bucket_filter = NULL, prefix = NULL,
                                  path_only = FALSE, max = "unused") {
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
  file_list <- dplyr::bind_rows(purrr::map(bucket_filter, list_files_in_bucket))
  if (path_only) return(file_list$path)
  file_list
}
```

##### Examples

```r
list_files_in_buckets(bucket_filter = "alpha-hmpps-covid-data-processing", 
                      prefix = 'BASS.csv')
list_files_in_buckets(bucket_filter = "alpha-hmpps-covid-data-processing", 
                      prefix = 'deaths')
# Type in the full string you watch to match...
list_files_in_buckets(bucket_filter = "alpha-hmpps-covid-data-processing", 
                      prefix = 'deaths/fatalities') 
# or prefix works using a partial match, so a shorter string will now work
list_files_in_buckets(bucket_filter = "alpha-hmpps-covid-data-processing",
                      prefix = 'fat') 
```

### `botor` examples

This section will attempt to provide `botor` equivalents for each of the
examples on the 
[`s3tools` homepage](https://github.com/moj-analytical-services/s3tools), 
which will hopefully help with converting existing code.

#### Which buckets do I have access to?

```r
s3tools::accessible_buckets()
```

There is no obvious way to achieve this with `botor`,
[s3_list_buckets](https://daroczig.github.io/botor/reference/s3_list_buckets.html)
is the closest, listing all buckets in the organisation. 

#### What files do I have access to?

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

#### Reading files
##### `csv` files

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

##### Other file types

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
# Use s3_read in botor to specify the read function
df <- s3_read("s3://alpha-everyone/s3tools_tests/iris_base.csv",
              readr::read_csv)
```

#### Downloading files

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

#### Writing data to S3
##### Writing files to S3

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

##### Writing a dataframe to s3 in csv format

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




