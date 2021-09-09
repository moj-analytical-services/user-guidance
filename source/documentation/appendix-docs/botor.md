# Migrating to `botor`

The new version of RStudio on the Analytical Platform uses `botor` to access
our Amazon S3 data storage, replacing [`s3tools`](https://github.com/moj-analytical-services/s3tools). 
This guidance gives some hints on how to get going with `botor` and migrate 
code that uses `s3tools`.

## Installation

Eventually this will be as easy as running
```{r install-botor-migr, eval=FALSE}
renv::init()
renv::use_python()
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```
but on the current test version it's not quite that simple. 

First open your project, and then in the terminal run
```
python3 -m venv venv --without-pip --system-site-packages
```
Then in the RStudio console run
```{r install-botor-test-migr, eval=FALSE}
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

