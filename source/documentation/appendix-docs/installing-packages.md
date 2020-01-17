# Installing packages

## R

To install a package in R from CRAN, use:

```
install.packages("<package_name>")
```

To install a package in R from GitHub, you first need to install and load `devtools` (or `remotes`):

```
install.packages("devtools")
library(devtools)
```

Then, install the package using:

```
devtools::install_github("<repository_name>")
```

## Python

To install a Python package, run the following in  terminal:

```
pip install <package_name>
```

## Conda

If you are using conda, you can install R, Python and operating system packages by running the following in a terminal:

```
conda install <package_name>
```

You can still install R packages using the methods described above.

For further information, see the [conda package management](../conda) section of the main Analytical Platform guidance.
