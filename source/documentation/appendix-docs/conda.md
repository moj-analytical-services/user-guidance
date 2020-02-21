# Package management

## Introduction

A key element of ensuring analysis is reproducible is maintaining a record of the versions of packages used to produce said analysis. There are a number of package management tools available for both R and Python. Within the MoJ we recommend primarily using [Conda](#Conda) for both languages.

## R

### Packrat

Packrat is the most well-known package management tool for R. There's more information about it here: https://rstudio.github.io/packrat/

It has some significant downsides. It can be quite temperamental, and difficult to debug when things go wrong - in the earlier days of the Analytical Platform, the majority of support issues related to getting Packrat working. Furthermore, CRAN mirrors do not provide linux compiled binaries for packages. This means a long wait when doing `install.packages` both in an RStudio session and when running a Docker build for a `shiny` application.

### Renv

[Renv](https://rstudio.github.io/renv/articles/renv.html) is a newer package billed as "Packrat 2.0". This has a number of improvements over Packrat, in the speed of download and reduction of issues of 00LOCK files that often plague Packrat. However, it is still not able to deal with OS-level dependencies, so Conda is still preferred.

## Conda

Conda is a unified package management system for both R and Python. `conda` supports managing both Python and R dependencies in a single `environment`. It can make sure all of these libraries are compatible with each other.

A key example within Analytical Services: both `dbtools` and `s3tools` rely on Python packages through the `reticulate` R-to-Python bridge. `packrat` only handles R dependencies; this means that `packrat` is not enough to reproducibly and reliably manage all of your application's dependencies.

### Installing Packages

If you need to find a package name you can use the [anaconda search](https://anaconda.org/search) to find the name. Run `conda install PACKAGENAME` in the Terminal tab to install it. For more advanced usage have a look at the [conda cheat sheet](https://conda.io/projects/conda/en/latest/user-guide/cheatsheet.html).

Most packages on CRAN (around 95%) are available through `conda`. They have the same name as
the CRAN package name with an additional `r-` prefix. This is to avoid clashes
with Python packages with the same name.

#### Examples

##### Installing a package:

| `install.packages` (in R-Console) | `conda install` (in Terminal) |
| --------------------------------- | ----------------------------- |
| `install.packages('Rcpp')`        | `conda install r-Rcpp`        |

![install package gif here](images/conda/conda_install_rcpp.gif)

##### Installing a specific version of a package
| `install.packages`                                                                                               | conda install                   |
| ---------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `require(devtools)`</br> `install_version("ggplot2", version = "2.2.1", repos = "http://cran.us.r-project.org")` | `conda install r-ggplot2=2.2.1` |

![Specific version gif here](images/conda/conda_install_specific_version.gif)

### Python

You can also use Conda to install Python packages for use in R through `reticulate`. Python packages do not require a prefix and can simply be installed using their
name.

#### Examples

##### Install a package

In the terminal run: `conda install numpy`. You can now access in your R session:
```r
library(reticulate)
np <- import("numpy")
np$arange(15)
```

![insert np_from-conda.gif](images/conda/np_from_conda.gif)

### Operating System Packages

Even if you want to continue using `packrat` or `renv` to manage your R packages, you can use conda to resolve operating system dependencies like libxml2.

#### Examples

##### Installing a package that relies on OS dependency

Suppose you want to install the R package `bigIntegerAlgos` but it fails because
it depends on a system level library called `gmp`. Switch to the terminal and
use `conda` to install it. Then switch back to the R console and try to use
`install.packages` again.

![insert conda_install_with_os_dep_v2](images/conda/conda_install_with_os_dep_v2.gif)

## Environment Management

You can use conda to make a snapshot of the environment you are using.

### Reset your _Environment_ to default

Recommended before starting a new project. Will ensure that no unused
dependencies are exported when you export an `environment.yml` for this project.

```bash
conda env export -n base| grep -v "^prefix: " > /tmp/base.yml && conda env update --prune -n rstudio -f /tmp/base.yml && rm /tmp/base.yml
```

### Exporting your _Environment_

This is similar to making a `packrat.lock` file, it catalogues all of the
dependencies installed in your environment so that another user can restore a
working environment for your application. Check this `environment.yml` file into
your git repository.

```bash
conda env export | grep -v "^prefix: " > environment.yml
```

### Making your R Studio Environment match an `environment.yml`

When checking out a project that has an `environment.yml` do this to install any
packages required by the project that you don't have in your working
environment.

```bash
conda env update -f environment.yml --prune
```


## Shiny
To use conda in shiny applications, you will need to use a different dockerfile to deploy the app. The [conda branch of the rshiny-template](https://github.com/moj-analytical-services/rshiny-template/tree/conda) has an appropriate dockerfile for this purpose. This is also necessary if you wish to use Python in your Shiny application, including using `dbtools` for accessing Athena databases.

## Platform limitations

There are a number of limitations and pitfalls to conda management to be aware of.

### R package  versions on conda

While Anaconda hosts most R packages on CRAN, some R packages on Anaconda only have binaries built for certain versions, and don't have a version for `R 3.5.1` as is currently used on the Analytical Platform. You can identify the available versions by inspecting the first few characters of the Build part of the filename - for example, **r351**h96ca727.

If there isn't an appropriate build for a package, attempting to `conda install` that package will result in conda attempting to match the environment to the superior (or inferior) version of R, asking if you want to install/upgrade/downgrade a long list of packages in the process. Instead, you should install the package locally via `install.packages()` or `remotes::install_github()`. For Shiny apps, you can add an `install.packages()` step to the Dockerfile to install additional packages not covered by the conda environment.yml, like so:
```bash
RUN R -e "install.packages('waffle', repos = 'https://cinc.rud.is')"
```

### Environments
- Usually when using Conda, it makes sense to have one environment per project,
but because we are using the Open Source version of R Studio, there is only a
single Conda environment available. This means having to be careful to make sure packages don't pollute your environment from another project. The [Environment Management section](#environment-management) explains how to manage your environments.
