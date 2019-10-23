# Conda

## What is Conda?

Conda is a package, dependency and environment management system developed and maintained by Anaconda. It can be used to quickly install and update packages and their dependencies. It can also be used to create, export and load environments that can be easily shared with others.

## What are the advantages of using Conda?

Conda has several advantages:

* packages are pre-compiled for Linux – this means that R packages can be installed faster in RStudio or when deploying an RShiny app
* it can manage packages and dependencies across multiple languages at once – for example, it can be used to manage packages in projects that use both R and Python
* it can be used to install and manage system libraries and their dependencies

## How do I access Conda?

Conda is installed for all users running R 3.5.1 or higher.

You will be running this version or higher if you have deployed or redeployed RStudio since 7 March 2019.

You can check your version of R by running the following code in the RStudio console:

```r
`R.Version()$version.string`
```

If you are running a lower version of R and would like to be upgraded, contact the Analytical Platform team.

## Environments

> A Conda environment is a directory that contains a specific collection of Conda packages that you have installed. For example, you may have one environment with NumPy 1.7 and its dependencies, and another environment with NumPy 1.6 for legacy testing. If you change one environment, your other environments are not affected.
>
> Source: [conda.io](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html)

### RStudio

Because the Analytical Platform uses an open-source version of RStudio, only one Conda environment is available. This means you must be careful when switching between projects.

#### Reset an environment

You should reset your environment whenever you start a new project or switch to a new project in RStudio. Before resetting your environment, you should make sure that you have [exported](#Export-an-environment) the environment for your current project.

To reset an environment, run the following code in a terminal:

```bash
conda env export -n base| grep -v "^prefix: " > /tmp/base.yml && \\
conda env update --prune -n rstudio -f /tmp/base.yml && \\
rm /tmp/base.yml
```

#### Export an environment

Exporting an environment will generate a file called `environment.yml` in your project directory. This is similar to a `packrat.lock` file and contains information about all the packages installed in your current environment. You should push this file to GitHub so other users can reproduce your environment when working on a project.

To export an environment, run the following code in a terminal:

```bash
conda env export | grep -v "^prefix: " > environment.yml
```

#### Load an environment

To load an environment from an `environment.yml` file, run the following code in a terminal:

```bash
conda env update -f environment.yml --prune
```

This will match your environment to the `environment.yml` file.

### JupyterLab

When working in JupyterLab, you can create multiple environments for different project that you can easily change between without having to export, reset and load environments each time.

#### View a list of environments

To view a list of environments, run the following code in a terminal:

```bash
conda env list
```

This will return a list similar to the following:

```bash
conda environments:
rstudio               /home/jovyan/.conda/envs/rstudio
base                  /opt/conda
testenv           \*   /opt/conda/envs/testenv
```

Here, `*` indicates the environment that is currently activated.

#### Create a new environment

To create a new environment, run the following code in a terminal:

```bash
conda create -n ENVNAME
```

Here, you should replace `ENVNAME` with the name of the new environment you want to create.

#### Change environment

To change to a different environment, run the following code in a terminal:

```bash
conda activate ENVNAME
```

Here, you should replace `ENVNAME` with the name of the environment you want to change to.

#### Remove an environment

To remove an environment, run the following code in a terminal:

```bash
conda remove -n ENVNAME --all
```

Here, you should replace `ENVNAME` with the name of the environment you want to remove.

You should not remove either the `base` or `rstudio` environments. You should be careful when removing any other environments, as they cannot be recovered.

## Packages

You can use Conda to install packages for a number of different languages, including R and Python, as well as system libraries. Many packages for R and Python, including almost all major packages, are available through Conda.

Anaconda itself maintains thousands of packages for both [R](https://docs.anaconda.com/anaconda/packages/r-language-pkg-docs/) and [Python](https://docs.anaconda.com/anaconda/packages/py3.7_linux-64/). A large number of additional packages are also built and maintained by the community, for example, by [conda-forge](https://conda-forge.org/).

Most R packages in Conda have names of the form `r-PACKAGENAME`, where `PACKAGENAME` is the name of the package on CRAN or MRAN. Although almost all R packages from CRAN or MRAN are available through, some may not be.

You can search for available packages on [anaconda.com](https://anaconda.com) or by running the following code in a terminal:

```bash
conda search -f PACKAGENAME
```

Here, you should replace `PACKAGENAME` with the name of the package you want to search for.

### Install a package with default options

#### Conda

To install a package using Conda, run the following code in a terminal:

```bash
conda install PACKAGENAME
```

Here, you should replace `PACKAGENAME` with the name of the package you want to install.

#### R

If an R package you want to install is not available through Conda, you can install it by running the following code in R:

```r
install.packages('PACKAGENAME')
```

Here, you should replace `PACKAGENAME` with the name of the package you want to install.

#### pip

If a Python package you want to install is not available through Conda, you can install it using pip.

To use pip within a Conda environment, you must first install it by running the following code in a terminal:

```bash
conda install pip
```

You can then install packages within the Conda environment by running the following code in a terminal:

```bash
pip install PACKAGENAME
```

Here, you should replace `PACKAGENAME` is the name of the package you want to install.

### Install a specific version of a package

#### Conda

To install a specific version of a package using Conda, run the following code in a terminal:

```bash
conda install PACKAGENAME=X.Y.Z
```

Here, you should replace `PACKAGENAME` with the name of the package you want to install and `X.Y.Z` with the version of the package you want to install.

#### R

If a specific version of an R package you want to install is not available through Conda, you can install by running the following code in R:

```r
remotes::install_version('PACKAGENAME', version = 'X.Y.Z')
```

Here, you should replace `PACKAGENAME` with the name of the package you want to install and `X.Y.Z` with the version of the package you want to install.

#### pip

If a specific version of a Python package you want to install is not available through Conda, you can install it using pip.

To use pip within a Conda environment, you must first install it by running the following code in a terminal:

```bash
conda install pip
```

You can then install specific versions of packages within the Conda environment by running the following code in a terminal:

```bash
pip install PACKAGENAME==X.Y.Z
```

Here, you should replace `PACKAGENAME` with the name of the package you want to install and `X.Y.Z` with the version of the package you want to install.

### View installed packages

To view all packages installed in your current environment, run the following code in a terminal:

```bash
conda list
```

### Examples

### Install a Python package and access it in R

In this example, we will demonstrate how to install the Python package `numpy`.

To install `numpy` using Conda, run the following code in a terminal:

```bash
conda install numpy
```

This package can now be accessed within R. For example:

```r
library(reticulate)
np <- reticulate::import('numpy')
np$arange(10)
```

### Install a system library required by an R package

Suppose you want to install the R package `bigIntegerAlgos` using `install.packages` but it fails because
it depends on a system library called `gmp`, which is not installed.

To install this system library, run the following code in a terminal:

```bash
conda install gmp
```

You would now be able to install the R package using `install.packages`.

## Further information

The Conda [website](https://conda.io/en/latest/) provides comprehensive documentation on Conda. The Conda [cheat sheet](https://conda.io/projects/conda/en/latest/_downloads/1f5ecf5a87b1c1a8aaf5a7ab8a7a0ff7/conda-cheatsheet.pdf) also provides a useful quick reference.
