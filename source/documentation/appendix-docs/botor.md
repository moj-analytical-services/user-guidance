# Migrating to `botor`

The new version of RStudio on the Analytical Platform uses `botor` to access
our Amazon S3 data storage, replacing [`s3tools`](https://github.com/moj-analytical-services/s3tools). 
This guidance gives some hints on how to get going with `botor` and migrate 
code that uses `s3tools`.

## Installation

Eventually this will be as easy as running

```r
renv::init()
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
renv::init()
renv::use_python('venv/bin/python')
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

You can now use `library(botor)` as usual, and `renv::snapshot()` to 
lock the R and Python library versions for recreation by collaborators or
within a deployment.

For more on `renv` see [the documentation](https://rstudio.github.io/renv/articles/renv.html), 
particularly on [Using Python with renv](https://rstudio.github.io/renv/articles/python.html). 
The [reticulate documentation](https://rstudio.github.io/reticulate/) is also likely to be useful.

## Usage
### Reading data

Reading from S3 is handled by the [`s3_read`](https://daroczig.github.io/botor/reference/s3_read.html)
function. This takes a full S3 path and a read function as parameters. For example,
to read a csv file run

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
s3_write(df, "s3://alpha-mybucket/my_data.csv", readr::write_csv)
s3_write(df, "s3://alpha-mybucket/my_data.feather", feather::write_feather)
s3_write(df, "s3://alpha-mybucket/my_data.sas7bdat", haven::write_sas)
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

## Migrating from `s3tools`

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
botor::s3_ls('s3://alpha-everyone')

## You can list files in more than one bucket:
s3tools::list_files_in_buckets(c('alpha-everyone', 'alpha-dash'))
# botor only accepts one bucket as an argument
purrr::map(c('s3://alpha-everyone', 's3://alpha-dash'), botor::s3_ls) %>%
    dplyr::bind_rows()

## You can filter by prefix, to return only files in a folder
s3tools::list_files_in_buckets('alpha-everyone', prefix='s3tools_tests')
botor::s3_ls('s3://alpha-everyone/s3tools_tests')

## The 'prefix' argument is used to filter results to any path that begins 
## with the prefix. 
s3tools::list_files_in_buckets('alpha-everyone', prefix='s3tools_tests', 
                               path_only = TRUE)
botor::s3_ls('s3://alpha-everyone/s3tools_tests')$uri

## For more complex filters, you can always filter down the dataframe using 
## standard R code:
library(dplyr)

## All files containing the string 'iris'
s3tools::list_files_in_buckets('alpha-everyone') %>% 
    dplyr::filter(grepl("iris",path)) # Use a regular expression
botor::s3_ls('s3://alpha-everyone') %>% 
    dplyr::filter(grepl("iris",path))

## All excel files containing 'iris';
s3tools::list_files_in_buckets('alpha-everyone') %>% 
    dplyr::filter(grepl("iris*.xls",path)) 
botor::s3_ls('s3://alpha-everyone') %>% 
    dplyr::filter(grepl("iris*.xls",path)) 
```

### Reading files
#### `csv` files

```r
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/folder1/iris_folder1_1.csv")
df <- botor::s3_read(
    "s3://alpha-everyone/s3tools_tests/folder1/iris_folder1_1.csv",
    read.csv)
```

Previewing the first few rows of a file is more complicated, it's not 
directly supported by `botor`.

```r
df <- s3tools::s3_path_to_preview_df(
    "alpha-moj-analytics-scratch/my_folder/10mb_random.csv")

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
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.xlsx",
                readxl::read_excel)

# Uses haven if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.sav")  
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.sav",
                     haven::read_sav)

# Uses haven if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.dta")  
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.dta",
                     haven::read_dta)

# Uses haven if installed, otherwise errors
df <- s3tools::s3_path_to_full_df(
    "alpha-everyone/s3tools_tests/iris_base.sas7bdat")  
df <- botor::s3_read("s3://alpha-everyone/s3tools_tests/iris_base.sas7bdat",
                     haven::read_sas)

df <- s3tools::read_using(
    FUN=readr::read_csv, path = "alpha-everyone/s3tools_tests/iris_base.csv")
df <- s3_read("s3://alpha-everyone/s3tools_tests/iris_base.csv",
              readr::read_csv)
```

### Downloading files

`botor` will not check whether it's overwriting files, so that will have to
be handled.

```r
df <- s3tools::download_file_from_s3(
    "alpha-everyone/s3tools_tests/iris_base.csv", "my_downloaded_file.csv")

if (!file.exists("my_downloaded_file.csv")) {
    df <- botor::s3_download_file(
        "s3://alpha-everyone/s3tools_tests/iris_base.csv",
        "my_downloaded_file.csv"
    )
} else {
    stop("my_downloaded_file.csv already exists.")
}
```

When an `overwrite` flag would be set to `TRUE` a `botor` function can be
used normally.

```r
# By default, if the file already exists you will receive an error.  
# To override:
df <- s3tools::download_file_from_s3(
    "alpha-everyone/s3tools_tests/iris_base.csv", 
    "my_downloaded_file.csv",
    overwrite =TRUE
)
df <- botor::s3_download_file(
    "s3://alpha-everyone/s3tools_tests/iris_base.csv", 
    "my_downloaded_file.csv"
)
```

### Writing data to S3
#### Writing files to S3

```r
s3tools::write_file_to_s3("my_downloaded_file.csv", 
                          "alpha-everyone/delete/my_downloaded_file.csv")

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
                          overwrite =TRUE)
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




