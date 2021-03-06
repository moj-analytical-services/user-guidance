# Package Management

There are multiple package managers available for RStudio, JupyterLab & Airflow depending on the version you are using:

- renv
- Conda
- packrat

Conda is the current standard on the Analytical Platform, this is soon to be replaced with renv for simpler package management.

## Conda

When exploring this section, you may also find the [slides](https://github.com/moj-analytical-services/coffee-and-coding-public/blob/master/2019-10-30%20Conda/conda.pdf) from the Coffee and Coding session on conda useful.

Conda is a unified package management system that supports managing both Python and R dependencies in a single `environment`. It can make sure all of these libraries are compatible with each other. Conda is available for both RStudio and JupyterLab on the Analytical Platform, though note that RStudio and JupyterLab have separate environments so dependencies won't be shared between the applications.

A key example within Analytical Services where conda is useful: both `dbtools` and `s3tools` rely on Python packages through the `reticulate` R-to-Python bridge. `packrat` only handles R dependencies; this means that `packrat` is not enough to reproducibly and reliably manage all of your application's dependencies.

### Installing Packages

The Anaconda organisation has its own repository of packages hosted on [https://anaconda.org](https://anaconda.org). If you need to find a package name you can use the [anaconda search](https://anaconda.org/search) to find the package name.

To install a package through conda, run the command `conda install PACKAGENAME` in the Terminal tab. This is recommended over using `install.packages()` as the package will be installed into the conda environment in a way that can be repeated when replicating the analysis - see [Environment management](#Environment-management) section for more.

Most (around 95%) R packages on CRAN are available through conda. They have the same name as the CRAN package name with an additional `r-` prefix. This is to avoid clashes with Python packages with the same name.

#### Example

In the terminal run: `conda install numpy`. You can now access in your R session:

```r
library(reticulate)
np <- import("numpy")
np$arange(15)
```

![insert np_from-conda.gif](images/conda/np_from_conda.gif)

#### Comparison with install.packages()

The following tables show conda commands and their base R analogues.

Installing a package:

<div style="height:0px;font-size:0px;">&nbsp;</div>
| `install.packages` (in R-Console) | `conda install` (in Terminal) |
| --------------------------------- | ----------------------------- |
| `install.packages('Rcpp')`        | `conda install r-Rcpp`        |
<div style="height:0px;font-size:0px;">&nbsp;</div>

![](images/conda/conda_install_rcpp.gif)

#### Installing a specific version of a package

<div style="height:0px;font-size:0px;">&nbsp;</div>

| `install.packages`                                                                                               | conda install                   |
| ---------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `require(devtools)`</br> `install_version("ggplot2", version = "2.2.1", repos = "http://cran.us.r-project.org")` | `conda install r-ggplot2=2.2.1` |
<div style="height:0px;font-size:0px;">&nbsp;</div>

![Specific version gif here](images/conda/conda_install_specific_version.gif)

You can also use conda to install Python packages, for use in R through the `reticulate` package. Python packages do not require a prefix and can simply be installed using theirname.

### Operating System Packages

Even if you want to continue using `packrat` or `renv` to manage your R packages,  some packages have operating system-level dependencies, which can't be handled by `packrat`/`renv` themselves. You can use conda to resolve these operating system dependencies, such as libxml2.

#### Examples

##### Installing a package that relies on OS dependency

Suppose you want to install the R package `bigIntegerAlgos`, but it fails because it depends on a system level library called `gmp`. To resolve this, switch to the terminal and use conda to install it. Then switch back to the R console and try to use `install.packages` again.

![](images/conda/conda_install_with_os_dep_v2.gif)

### Environment Management

You can use conda to make a snapshot of the environment you are using, so others can reproduce your results using the same versions of your code.

Note: usually when using conda, it makes sense to have one environment per project,
but because we are using the Open Source version of R Studio, there is only a
single conda environment available. This means having to be careful to make sure packages don't pollute your environment from another project. The following commands can be used to manage your environments.

#### Reset your conda environment to default

This will delete packages that you have installed in your `rstudio` conda environment, leaving only the base packages:

```bash
conda env export -n base| grep -v "^prefix: " > /tmp/base.yml && conda env create --force -n rstudio -f /tmp/base.yml && rm /tmp/base.yml
```

It is recommended to do this before starting a new project, to ensure that no unused dependencies are exported when you export an `environment.yml` for this project.

#### Hard reset of your conda environment

This will completely delete your `rstudio` conda environment, and recreate it with the base packages:

1. Deleting all the files in the environment. For example, to clear the `rstudio` conda environment (which is the default one):

    ```bash
    rm -rf ~/.conda/envs/rstudio
    ```

    You might get errors about `Directory not empty` or `Device or resource busy` but usually these can be ignored - the bulk of these packages will be gone.

2. In Control Panel, for R Studio, select the "Restart" button

It can be useful to do this if you have tried to [reset your conda environment to default](#reset-your-conda-environment-to-default) and are still having problems.

#### Exporting your _Environment_

This is similar to making a `packrat.lock` file, it catalogues all of the
dependencies installed in your environment so that another user can restore a
working environment for your application. Check this `environment.yml` file into
your git repository.

```bash
conda env export | grep -v "^prefix: " > environment.yml
```

#### Making your R Studio Environment match an `environment.yml`

When checking out a project that has an `environment.yml`, run the below command to install any packages required by the project that you don't have in your working environment.

```bash
conda env update -f environment.yml --prune
```

### Conda tips

#### Conda version

When you run conda (In R Studio at least) it says:

```bash
==> WARNING: A newer version of conda exists. <==
  current version: 4.7.5
  latest version: 4.8.3

Please update conda by running

    $ conda update -n base conda
```

Please ignore this warning - this can only be done centrally by Analytical Platform team.

If you try to upgrade conda yourself, it will fail:

```bash
EnvironmentNotWritableError: The current user does not have write permissions to the target environment.
  environment location: /opt/conda
```

This is because conda is installed into the read-only part of the docker image. Users can only edit things in /home/$USER.

### Package installed with a different R version - when using conda

Typical error output:

```bash
> conda install ggplot2
...
Error : package ‘tibble’ was installed by an R version with different internals; it needs to be reinstalled for use with this R version
```

It's saying that this package, which is a dependency of the one you're installing, was installed with an R version you used to have.

To fix this, wipe your installed packages and reinstall them from your environment.yml.

```bash
# reset your conda environment
conda env export -n base| grep -v "^prefix: " > /tmp/base.yml && conda env update --prune -n rstudio -f /tmp/base.yml && rm /tmp/base.yml
# reinstall packages
conda env update -f environment.yml --prune
```

## Renv

[Renv](https://rstudio.github.io/renv/articles/renv.html) is a newer package management solution for RStudio.

For a full guide to installing packages, workflow and installing custom pacakges (e.g. S3tools) please see the [introduction to renv](https://rstudio.github.io/renv/articles/renv.html).

Unless a project has been abled for renv, files in RStudio 1.4 will be installed to a temporary directory.

### Migrating Existing Projects

For projects that currently use Conda or Packrat it is relatively simple to migrate to using renv

* Enable renv on the project
* [Consent to using Renv](https://rstudio.github.io/renv/reference/consent.html) `renv::consent()`
* Remove any existing Conda or packrat configuration from your R files

## Using R Renv with Python Venv

See the [Renv Python documentation](https://rstudio.github.io/renv/articles/python.html) for further guidance.

To use Renv with Python venv, type

```text
renv::use_python()
```

## Packrat

**NB Use of `packrat` is deprecated on the Analytical Platform - the guidance below is for information only because legacy projects may still use `packrat`.**

Packrat is the most well-known package management tool for R. There's more information about it here: <https://rstudio.github.io/packrat/>

It has some significant downsides. It can be quite temperamental, and difficult to debug when things go wrong - in the earlier days of the Analytical Platform, the majority of support issues related to getting Packrat working.

Furthermore, the Analytical Platform version of RStudio runs on a Linux virtual machine, and CRAN mirrors do not provide Linux compiled binaries for packages. This means that packages need to be compiled on the Analytical Platform every time they're installed, which can take a long time. This means a long wait when doing `install.packages` both in an RStudio session, and when running a Docker build for an RShiny application.

### Packrat usage

To use packrat, ensure that it is enabled for your project in RStudio: select __Tools__ > __Project Options...__ > __Packrat__ > __Use packrat with this project__.

When packrat is enabled, run `packrat::snapshot()` to generate a list of packages used in the project, their sources and their current versions.

You may also wish to run `packrat::clean()` to remove unused packages from the list.

The list is stored in a file called `packrat/packrat.lock`. You must ensure that you have committed this file to GitHub before deploying your app.

## R's install.packages()

**NB Only use this method for playing - use Conda for project work.**

You can install R packages from the R Console:

```R
install.packages("ggplot2")
```

This will find the latest version of the package in CRAN and install it in: `~/R/library`.

However this method is pretty basic. Refer to the tips in the following sections.

### Package version incompatible with R version

Often if you try to install the latest version of a package, it will require a more recent version of R than you have:

```bash
> install.packages("text2vec")
Installing package into ‘/home/davidread/R/library’
(as ‘lib’ is unspecified)
Warning in install.packages :
  package ‘text2vec’ is not available (for R version 3.5.1)
```

There are a few options to avoid this:

Solution 1: AP may have a newer version of RStudio tool which might have the version of R needed. To upgrade, see: [Managing your analytical tools](managing-your-analytical-tools)

Solution 2: Use [conda](#conda) - it's recommended for use with Analytical Platform in general. It works out which version is compatible with your R version (make sure you run this in the Terminal):

```bash
conda install r-text2vec
```

Solution 3: Specify a version that is compatible with your R version. e.g. at https://www.rdocumentation.org/packages/text2vec look at the "depends" field for the R version it requires. Change the version (drop-down at the top) to go back to see how it changes for older releases. You can see that text2vec 6.0 requires R (>= 3.6.0), but text2vec 5.1 requires only R (>= 3.2.0).

```R
devtools::install_version('text2vec', version='0.5.1')
```

### Package installed with a different R version - when using install.packages()

Typical error output

```R
> install.packages("ggplot2")
...
Error : package ‘tibble’ was installed by an R version with different internals; it needs to be reinstalled for use with this R version
```

It's saying that this package, which is a dependency of the one you're installing, was installed with an R version you used to have.

Solution 1 - You might fix this by installing the package it names:

```R
> install.packages('tibble')
```

However you may have to do this for a lot of packages.

Solution 2 - Wipe your packages and reinstall them.

It begs the question of what you have installed. Although you can [get a list](https://www.r-bloggers.com/list-of-user-installed-r-packages-and-their-versions/) it's often unmanageably long, including all the little dependencies of what you actually installed in the first place. Best use conda next time!

But you can get rid of all the installed packages (use the terminal):

```bash
rm -rf ~/R/library/*
```

### "Broken" packages (typically `r-pillar`)

When installing packages (e.g. during a concourse build of a webapp) you may see an error like this:

```bash
$ conda env export -n base grep -v ""prefix: " > /tmp/base.yml &
 conda env update --prune -n rstudio -f /tmp/base.yml && rm /tmp/base.yml

Collecting package metadata (repodata.json): done
Solving environment: failed
ResolvePackageNotFound:
    - r-pillar=1.4.2=h6115d3f_O
```

This happens when a package on conda is marked as _broken_. r-pillar seems to suffer this frequently.

To fix this there are a couple of things you can try:

1. Remove `r-pillar` (or the offending package) from environment.yml. `r-pillar` is provided by the base conda environment and chances are that the user doesn't need it in their app, so it can be safely removed.

2. Update the version of `r-pillar` to the [latest one](https://anaconda.org/conda-forge/r-pillar/files) on conda-forge.

## venv and pip

### Intro to pip, PyPI and virtual environments

[pip](https://pip.pypa.io/en/stable/) is a terminal command used to install and upgrade Python packages.

[PyPI](https://pypi.org) is the main Python package repository. It's 'official', but that doesn't mean a lot - like most of these open source package repositories, a poor quality or even malicious package can easily be uploaded there, so do your diligence when picking them.

A [Python virtual environment](https://docs.python.org/3/tutorial/venv.html) (or `venv`, for short) is a directory you can install a particular python executable and python packages into, away from your machine's default ones. Typically each project/repo you work on should have a different venv, and then you never have to deal with conflicting requirements between projects. When you 'activate' a particular venv, then when you run `python` or `pip`, then it will work with that venv's python executable and python packages.

### Basic usage

**NOTE:** You may need to delete the `.bash_aliases` file (`rm .bash_aliases`) from your home directory for pip to work properly within a virtual environment.

Create a venv for your project, called 'venv' (make sure you run this in the Terminal):

```bash
cd myproject
python3 -m venv venv
```

(You'll probably want to add 'venv' to you .gitignore file, because this shouldn't be added to your git repo.)

When you work with your project's packages in a terminal, you'll want to 'activate' your venv:

```bash
. venv/bin/activate
```

You'll notice the prompt changes to show that the venv is activated: `(venv) jovyan@jupyter-lab-davidread-ju-6966d9b9b4-7zvsk:~/myproject$`

With the venv activated you can install some packages using pip3:

```bash
(venv) $ pip3 install pandas
```

Tip: Use `pip3` instead of `pip`, because Analytical Platform has setup `pip` to always install to `~/.local/`. Bear with us while we fix this.

The packages will get installed to your venv, in `venv/lib/python3.7/site-packages/`.

You can see what packages are installed using 'pip freeze':

```bash
(venv) $ pip3 freeze
numpy==1.18.4
pandas==1.0.4
python-dateutil==2.8.1
pytz==2020.1
six==1.15.0
```

With the venv activated, if you run some python script from the terminal, the package will be available to it. e.g.

```bash
(venv) $ python3 -c 'import pandas; print(pandas); print("It worked")'
<module 'pandas' from '/home/jovyan/myproject/venv/lib/python3.7/site-packages/pandas/__init__.py'>
It worked
```

In JupyterLab, to be able to use the venv's packages (instead of the system packages), see [Using a venv in Jupyter](#using-a-venv-in-jupyter)

When you commit your code, to ensure reproducibility, you should also commit an up-to-date record of what packages you've installed. The simplest way is to do:

```bash
(venv) $ pip3 freeze >requirements.txt
(venv) $ git add requirements.txt
```

You should also add to your README file the instructions for using requirements.txt - see the following section.

### Using a project that has a requirements.txt

If a project has a 'requirements.txt' then you should install that into a venv.

A project's README file is the traditional place to communicate usage of a requirements.txt. Because of that, this section is provided in markdown format so it can be copied into your project's README, and tailored as necessary:

```markdown
## Setup

Before you can run this project, you need some files setup in your home dir, using the terminal:

    # create a virtual environment
    cd myproject
    python3 -m venv venv

    # install the python packages required
    . venv/bin/activate
    pip3 install -r requirements.txt
