# Manage dependencies using Conda

## Unified package management for both R and Python

### Faster builds

CRAN[^what_is_cran] mirrors do not provide linux[^linux_note] compiled binaries
for packages. This means a long wait when doing `install.packages` both in an R
Studio session and when running a Docker build for a `shiny` application.

### Cross Language

Both `dbtools` and `s3tools` rely on Python packages through the `reticulate` R
to Python bridge. `packrat` only handles R dependencies, this means that
`packrat` is not enough to reproducibly and reliably manage all of your
application's dependencies.

`conda` supports managing both Python and R dependencies in a single
`environment`. It can make sure all of these libraries are compatible with each
other.

## Installing Packages

If you need to find a package name you can use the [anaconda search] to find the
name. Run `conda install PACKAGENAME` in the `Terminal` tab to install it. For
more advanced usage have a look at the [conda cheat sheet].

### R

Most CRAN (around 95%) are available through `conda`, they have the same name as
the CRAN package name with an additional `r-` prefix. This is to avoid clashes
with Python packages with the same name.

#### Examples:

##### Install a package

| `install.packages` (in R-Console) | `conda install` (in Terminal) |
| --------------------------------- | ----------------------------- |
| `install.packages('Rcpp')`        | `conda install r-Rcpp`        |

![](images/conda/conda_install_rcpp.gif)

##### Install a specific version of a package

| `install.packages`                                                                                              | conda install                   |
| --------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `require(devtools)`<br> `install_version("ggplot2", version = "2.2.1", repos = "http://cran.us.r-project.org")` | `conda install r-ggplot2=2.2.1` |

![](images/conda/conda_install_specific_version.gif)

### Python

Python packages do not require a prefix and can simply be installed using their
name.

#### Examples

##### Install a package

In the terminal run: `conda install numpy`

which you can now access in your R session

```r
library(reticulate)
np <- import("numpy")
np$arange(15)
```

![](images/conda/np_from_conda.gif)

### Operating System Packages

Even if you want to continue using `packrat` to manage your R packages you can
use conda to resolve operating system dependencies like libxml2.

#### Examples

##### Installing a package that relies on OS dependency

Suppose you want to install the R package `bigIntegerAlgos` but it fails because
it depends on a system level library called `gmp`. Switch to the terminal and
use `conda` to install it. Then switch back to the R console and try to use
`install.packages` again.

![](images/conda/conda_install_with_os_dep_v2.gif)

## Platform limitations

Usually when using Conda, it makes sense to have one environment per project,
but because we are using the Open Source version of R Studio, there is only a
single Conda environment available.

This means having to be careful to make sure packages don't pollute your
environment from another project. The
[following section](#environment-management) explains how to manage your
environments.

## Environment Management

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

[packrat]: https://rstudio.github.io/packrat/
[anaconda search]: https://anaconda.org/search
[conda cheat sheet]:
  https://conda.io/projects/conda/en/latest/user-guide/cheatsheet.html

[^linux_note]:

  Linux (Debian) is the environment that applications in the Analytical Platform
  run on.

[^what_is_cran]:

  The "Comprehensive R Archive Network" (CRAN) is a collection of sites which
  carry identical material, consisting of the R distribution(s), the contributed
  packages and binaries.
  