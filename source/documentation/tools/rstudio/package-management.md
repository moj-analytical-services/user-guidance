# R package management

There are multiple package managers available for RStudio depending on the version you are using:

- renv
- Conda
- packrat

## Why use a package manager?

This enables analysts to maintain a reproducible workflow by including a snapshot of all packages used within a project saved within the project files themselves that can be loaded and installed with a single consistent and reproducible method.

This means that if you create some code one day, you (or another analyst who comes after you) should be able to pick it up several years later and run it without any difficulty - even if the packages used have themselves changed in the meantime.

For Rstudio there is the added imperative to use a package manager (usually renv) because the analytical platform will remove installed packages when the docker image is restarted (which occurs automatically, roughly once a week).

## Renv

[Renv](https://rstudio.github.io/renv/articles/renv.html) is the current standard for Rstudio on the Analytical Platform as it provides simpler package management than Conda or packrat which were previously recommended.

The basic renv commands are:

<div style="height:0px;font-size:0px;">&nbsp;</div>
| Command | Description |
|------------------|---------------------------------------------|
| `renv::init()`      | first time a project is created |
| `renv::install()`   | install new packages |
| `renv::snapshot()`  | save a description of packages to renv.lock |
| `renv::restore()`   | install packages to match renv.lock |
<div style="height:0px;font-size:0px;">&nbsp;</div>

The following gives an overview of these basic renv commands.
For more details check out the Coffee and Coding [video](https://web.microsoftstream.com/video/3ec54ac3-473c-4268-9d54-9f7096338824) and [slides](https://github.com/moj-analytical-services/Coffee-and-Coding/tree/master/2022-05-04%20Introduction%20to%20renv%20package%20management), or for a full guide to installing packages, workflow and installing custom packages please see the [introduction to renv website](https://rstudio.github.io/renv/articles/renv.html).

### Getting started with renv

If you are using version 4 or greater of R on the analytical platform then renv should work straightaway.
The only other things to note if you've not used renv before are:

 + The first time you use renv, you may be asked to consent to some changes it makes to the way packages are installed - please select yes to this.
 + If you previously used a different package management system (like Conda or packrat) remove any configuration files for these systems from your R files first.

### Starting a new project with renv or adding renv to an existing project

Basic commands to follow to install packages for renv are:

```r
# install renv (if not already installed)
install.packages("renv")

# If you are starting a fresh repository, run this:
renv::init(bare = TRUE)

# or if you are starting a fresh repository but would like to move your existing packages over to renv:
renv::init()
```

Then ensure you have committed and pushed the relevant files (.Rprofile, renv.lock, and renv/activate.R) to your github repository.
These should be the only files which git suggests you commit - you **should not** commit the whole contents of the renv folder created when initialising a project.

Now you are ready to work on your project!

### Working on a renv project

You can work on your project as normal now, but when you install new packages and want to save the state of your package environment you must "snapshot" your packages.

For instance, if you wanted to install `dplyr` and then update your package environment then the process would be:

```r
# install a package (the default is the latest available)
renv::install("dplyr")
# or install a specific version of a package
renv::install("dplyr@0.8.5")

# snapshot your project
renv::snapshot()

# don’t forget to commit
# renv.lock!
```

You can use `renv::install` or `install.packages` - renv will intercept any calls to `install.packages` and runs `renv::install` under the hood anyway.

### Picking up a renv project

If you pick up someone else's project from github who has been using renv then simply run `renv::restore()` to update your local package environment so it matches the renv.lock file.

```r
# clone the project into
# Rstudio

# grab the packages
renv::restore()
```

Any time you pull a commit where the renv.lock file has changed, you will need to `renv::restore()` in order to make sure your package enviroment matches to the new renv.lock file.
You will also have to do this if you change branches in your repository to one with a different renv.lock file.

### Using renv with python

If you are installing the recommended package for accessing data from s3, `botor`, you will need to do the following:

```R
renv::use_python() # at the prompt, choose to use python3
renv::install('reticulate')
```
Restart the session (Ctrl+Alt+F10 on a windows machine). And then:

```r
reticulate::py_install('boto3')
renv::install('botor')
```

See the [Renv Python documentation](https://rstudio.github.io/renv/articles/python.html) for further guidance.

To activate Python integration within renv, type

```text
renv::use_python()
```

### Common pitfalls with renv

<div style="height:0px;font-size:0px;">&nbsp;</div>
|     Situation    |     Why/What happens?    |
|---|---|
|     Packages   disappearing    |     You aren’t using renv!    |
|     Forgetting to `renv::snapshot()`    |     This won’t affect you running your   code, but anyone picking it up later will be out of sync. You can use `renv::status()` to check if packages and renv.lock match        |
|     Switching branches    |     If different package requirements in   branches then must remember to `renv::restore()`   when switching between them – otherwise library reflects the previous branch    |
|     Initialising renv   outside a project    |     renv will ask you not to do this – do not   use `force   = TRUE`!    |
|     Stuck on old CRAN/MRAN    |     Packages (or versions) you know exist   won’t appear using install functions. Run `options(repos   = "https://cloud.r-project.org/")`    |
<div style="height:0px;font-size:0px;">&nbsp;</div>

### renv tips and tricks

<div style="height:0px;font-size:0px;">&nbsp;</div>
|     Situation    |     Solution    |
|---|---|
|     Got into a total mess?    |     Start again! Run `renv::deactivate()` and then delete the renv.lock file and the renv/ folder   |
|     Add a package from github    |   Use `renv::install("username/packagename")` or for a private package `renv::install("git@github.com:username/packagename.git")` |
|     Upgrade all packages to latest    |   Run `renv::update()` or `renv::update("packagename")` for specific package. Always check that upgrading packages does not break your code before pushing to github for other users. |
|     Update renv itself    |     `renv::upgrade()`. Useful if renv gains new functionality that you want to use.    |
|     _Error in file(filename, "r", encoding = encoding) : cannot open the connection_    |     Oops, you've accidentally installed renv in your home directory 🏠 ! Delete [all of the files created by renv](https://rstudio.github.io/renv/articles/renv.html#infrastructure) from your home directory and retry.    |
|     _cannot open file 'renv/activate.R': No such file or directory_    |     Renv was installed incorrectly in the project. If you go to Tools > Project Options > Environments and tick use renv with this project that will force it to install renv, which will hopefully fix the problems.    |
<div style="height:0px;font-size:0px;">&nbsp;</div>


### Troubleshooting when upgrading to R>4.4.0

If you encounter difficulties upgrading older RStudio projects that use R4.1.x and R4.2.x to the latest releases of RStudio that use R4.4.0 and above, try following these steps (helpfully provided by an AP user):


1. You may need to reinstall `renv`. You can install it in the R console with:
    
    ```r
    install.packages("renv")
    ```

    If you encounter issues installing `renv`, please try [resetting your home directory](/tools/rstudio/#clearing-your-rstudio-session), restarting your deployment and then retry.

    You can find more guidance about working with renv [above](#renv).

2. Ensure that you have the latest CRAN set in your RStudio environment. Depending on the source you want to use for package management, in the R console run either:

    ```r
    options(repos = c(CRAN = "https://packagemanager.rstudio.com/cran/__linux__/jammy/latest"))
    ```
    or

    ```r
    options(repos = c(CRAN ="https://p3m.dev/cran/linux/jammy/latest"))
    ```

3. In the R console try to restore your project:

    ```r
    renv::restore()
    ```

4. If running `renv::restore()` throws errors:
    - Identify the package causing error and find the latest version of that on CRAN
    - Run `renv::install("thatpackage@latest_version")`
    - Run `renv::record("that_package")` - this will update the version in your renv.lock file
    - Run `renv::restore()` again and repeat the process for all packages that throw errors
    - Finally run `renv::snapshot()` - this will save details of all package versions in your renv.lock file

Remember to commit and push your changes when you have finished upgrading your project.

More general troubleshooting advice for using `renv` can be found [above](#common-pitfalls-with-renv).

You may find further assistance with R specific issues in the [#r slack channel](https://moj.enterprise.slack.com/archives/C1PUCG719).


## Conda

**NB Use of `conda` is now considered outdated for Rstudio on the Analytical Platform.**

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
