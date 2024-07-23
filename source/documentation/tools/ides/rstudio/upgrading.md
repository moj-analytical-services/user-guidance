# Upgrading RStudio

When moving between RStudio releases there are some differences that require either user intervention or caution.

## Why should I upgrade?

Upgrading to the latest version of RStudio has a number of benefits, including a new version of R and improved package management options.

## 2.2.6 to 3.0.12

Key Points:

- Conda has been replaced with Renv for package management
- [RStudio 1.4](https://rstudio.com/products/rstudio/#rstudio-server)
- [R version 4.0.3](https://cran.r-project.org/doc/manuals/r-release/NEWS.html)

Conda has now been removed. You will need to install packages using Renv. See [package management](package-management.html)

### Preparation

- Please unidle your RStudio if it is currently idled
- Select RStudio 3.0.12 from the drop down and click yes on the prompt to install

### Notable Packages

#### `dbtools`

`dbtools` (i.e. the R wrapper for `pydbtools`) is the data engineering maintained package for accessing Athena databases from R. It requires a little setup:

- Call `renv::use_python()`

      This will create a virtualenv for your project, which should be stored in the folder renv/python/virtualenvs/renv-python-3.8.5/, and associate reticulate with that virtualenv.

- Install `pydbtools` into that environment

     You can either do that with `reticulate::py_install("pydbtools")`, or if you prefer the terminal, you can activate that virtualenv with the command renv/python/virtualenvs/renv-python-3.8.5/bin/activate.

- Install dbtools using `remotes::install_github("moj-analytical-services/dbtools")`
