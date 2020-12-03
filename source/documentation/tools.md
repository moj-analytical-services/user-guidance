# RStudio and JupyterLab

Analytical Platform comes with tools including:

* RStudio - a development environment for writing R code and R Shiny apps
* JupyterLab - a development environment for writing Python code including Python notebooks
* Airflow - see [Airflow section](../airflow.html)

## Managing your analytical tools

Tools on Analytical Platform include RStudio, JupyterLab and Airflow sandbox. To use these, each user must 'start' their own copy of the software. This gives them the benefit of reserved memory space (compared to the more common shared R Studio Server), and some control over the version of R that is running.

To manage your tools:

1. Go the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2. Select the __Analytical tools__ tab.

Use the buttons shown against each tool to manage your copy of the tool:

* "Deploy" - The tool is not yet deployed - this is the initial state. You need to "Deploy" to be able to use the tool for the first time. It sets you up with the latest version and starts it. This may few minutes.
* "Open" - The tool is either "Idled" (configured but not running) or "Ready" (running). If your RStudio, JupyterLab or Airflow instance is inactive on a Tuesday evening it will be idled. Press "Open" to navigate to the tool in your browser, and if it is not running it will start it (run or "unidle" it). Starting a tool usually takes about 30 seconds, but occasionally will take a few minutes.
* "Restart" - Often problems with the tool can be solved by restarting the software on the server.
* "Upgrade" - Another release of the tool is available. Occasionally new versions of R Studio are made available on the Analytical Platform. In this case all users will be given the opportunity to upgrade on the control panel. New versions provide new features and bugfixes to the tool. In addition, there some releases come with improvements to the way RStudio is containerized and integrated with Analytical Platform. You should aim to upgrade when it is offered, although just in case it causes minor incompatibilities with your R code, you should not do it in the days just before you have a critical release of your work. When pressed, the status will change to 'Deploying' and then 'Upgraded'. The __Upgrade__ button will no longer be visible (until another version becomes available).

## Using RStudio

For general guidance in using RStudio, see the [RStudio documentation](https://docs.rstudio.com/).

### RStudio memory issues

RStudio crashes when it runs out of memory. This is because memory is a finite resource, and it's not easy to predict memory usage or exact availability. But if your data is of order of a couple of gigabytes or more, then simply putting it all into a dataframe, or doing processing on it, may mean you run out of memory. For more about memory capacity in the Analytical Platform, and how to work with larger datasets, see the [memory limits](annexes.html#memory-limits) section.

To find out if you have hit the memory limit, you can check [Grafana](https://grafana.services.alpha.mojanalytics.xyz/login). For guidance in using it, see the [memory limits](annexes.html#memory-limits) section.

If RStudio crashes on startup, and you've identified from Grafana that it is because the memory is full, then you can fix it by [clearing your RStudio session](#clearing-your-rstudio-session).

Once RStudio is running again, you can get a better understanding of what takes up memory by using the [pryr](https://rdrr.io/cran/pryr/man/mem_used.html) package. To free up a bit of memory, for example when a variable points to a big dataframe, you can instead assign something a null to the variable, and then run [`gc()`](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/gc). To free up all the user memory you can click on the 'broom' to [clear the environment](https://community.rstudio.com/t/i-want-to-do-a-complete-wipe-down-and-reset-of-my-r-rstudio/6712/4).

### Clearing your RStudio session

The RStudio session is the short term 'state' of RStudio, including:

* which project and files are open (displayed in the RStudio interface)
* console and terminal history
* the global environment – R variables that have been set and are held in memory

The session is persisted between restarts of RStudio, to make it easier for you to pick up where you left off. However you can clear it to solve a number of problems, including if the memory is full.

To clear the RStudio session:

1. Close RStudio, if it is open in any window (because it continually saves its session to disk).

2. Open JupyterLab.

3. In JupyterLab, open a Terminal and run:

    ```bash
    rm -rf ~/.rstudio.bak; mv ~/.rstudio/ ~/.rstudio.bak
    ```

4. In the control panel, select the __Restart__ button for RStudio.

    ![RStudio's "Restart" button in Control Panel](images/tools/restart_rstudio.png)

5. In the control panel, select __Open__ for RStudio. It may take between one and five minutes before RStudio is available. You may need to refresh your browser for the tool to load.

## Package management

A key element of ensuring analysis is reproducible is maintaining a record of the versions of packages used to produce said analysis.

There are a number of tools available for both R and Python to support package management.

For R:

* [**conda**](#conda) - Recommended for R in Analytical Platform. (Conda is only provided on AP with RStudio images which have R 3.5.1 and later. So if you have the older RStudio with R 3.4 then you'll need to use Packrat instead.)
* [**packrat**](#packrat) - not recommended for R, but remains an option.

For Python:

* [**venv** and **pip**](#venv-and-pip) - Recommended for Python in Analytical Platform, because it's easier, more reliable and has a much bigger community than conda. **NOTE:** To use pip with venv, you may need to delete the `.bash_aliases` file (`rm .bash_aliases`) in your home directory.
* [**conda environment**](#conda) installing packages with just **conda** - not recommended, but it might help for the occasional package whose C extension doesn't install well with pip (perhaps the pip package isn't the newer 'wheel' type, or it doesn't have a binary suitable for our distribution)
* [**conda environment**](#conda) installing packages with **conda** and **pip** - not recommended, but gives you the broadest range of package install options. However conda and pip don't play well together - use at your own risk!

**Note on support:** the Analytical Platform team does not offer support on the topic of packaging. DASD users are encouraged to use their #r, #conda and #python Slack channels to support each other, or ask your line manager about training. Of course, if there is something broken with the platform itself, or something unique about the platform that prevents you from installing a library, then of course do raise it with the team in the normal ways.

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

### RShiny

To use conda in RShiny applications, you will need to use a different `Dockerfile` to deploy the app. The [conda branch of the rshiny-template](https://github.com/moj-analytical-services/rshiny-template/tree/conda) has an appropriate `Dockerfile` for this purpose. This is also necessary if you wish to use Python in your Shiny application, including using `dbtools` for accessing Amazon Athena databases.

### Analytical Platform limitations

There are a number of limitations and pitfalls to conda management to be aware of.

#### R package versions on conda

While Anaconda hosts most of the R packages available on CRAN (the Comprehensive R Archive Network), some R packages on Anaconda only have binaries built for certain versions of R. You can identify the available versions by inspecting the first few characters of the Build part of the filename on its page on anaconda.org, like so:

![](images/conda/anaconda_R_version_number_example.PNG)

Alternatively, if you use `conda search PACKAGENAME`, you can look in the Field column:

![](images/conda/conda_search_R_version_number_example.PNG)

If there isn't an appropriate build for a package, attempting to `conda install` that package will result in conda attempting to match the environment to the superior (or inferior) version of R, asking if you want to install/upgrade/downgrade a long list of packages in the process.

Instead, you should install the package locally via `install.packages()` or `remotes::install_github()`. For RShiny apps, you can add an `install.packages()` step to the `Dockerfile` to install additional packages not covered by the conda environment.yml, like so:

```bash
RUN R -e "install.packages('waffle', repos = 'https://cinc.rud.is')"
```

### JupyterLab

See: <https://github.com/RobinL/cheatsheets_etc/blob/master/jupyter_conda.md>

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

### Renv

[Renv](https://rstudio.github.io/renv/articles/renv.html) is a newer package billed as "Packrat 2.0". This has a number of improvements over Packrat, in the speed of download and reduction of issues of 00LOCK files that often plague Packrat. However, it is still not able to deal with OS-level dependencies, so conda is still preferred.

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

## Run notebooks

In Jupyter, before you can successfully run the notebook, you'll need to select the Jupyter kernel for this project. If it doesn't appear in the drop-down list, run this in a terminal:

    . myproject/venv/bin/activate
    python3 -m ipykernel install --user --name="venv" --display-name="My project (Python3)"

```

And your project has analytical scripts that run in a terminal you could add:

```markdown
## Run scripts

To run the python scripts, you'll need to activate the virtual env first:

    cd myproject
    . venv/bin/activate
    python3 myscript.py
```

### Using a venv in Jupyter

Jupyter won't use your venv, and the packages installed into it, unless you do the following set-up:

1. In the terminal, activate your venv:

    ```bash
    cd myproject
    source venv/bin/activate
    ```

2. Install the module ipykernel within this venv (for creating/managing kernels for ipython which is what Jupyter sits on top of):

    ```bash
    pip3 install ipykernel
    ```

3. Create a Jupyter kernel which is configured to use your venv. (Change the display name to match your project name):

    ```bash
    python3 -m ipykernel install --user --name="venvname" --display-name="My project (Python3)"
    ```

4. In Jupyter, open your notebook and then select this new kernel by its pretty name in the top right hand corner. It might take a little time/refreshes for it to show up.

To resume work on this after working on another project:

1. Activate the environment:

   ```bash
   cd myproject
   source venv/bin/activate
   ```

   Now you've activated this terminal with your venv, things you run on the command-line will default to using your venv for python packages, rather than the system's packages. That's useful if you run 'python', run python scripts or 'pip install' more packages.

2. Open the notebook - it’s remembered which kernel you wanted to use for this notebook and you can carry on working with the packages available.

Note: *Once you have associated the kernel with the venv you dont need to recreate/update it*. Any packages that are installed to the venv via pip after the kernel is established are immediately available to the kernel.

### Using pipenv in Jupyter

pipenv is another environment manager for Python. In general, please refer to their [basic guidance](https://pipenv-fork.readthedocs.io/en/latest/basics.html).

Set-up for a project results in the creation of `Pipfile` and `Pipfile.lock` in the root directory of your project folder.

The instructions for someone to install the packages specified in Pipefile/Pipefile.lock, are as follows (you don't create a venv yourself, nor is it necessary to 'activate' the pipenv environment):

```bash
cd myproject
pipenv install
```

To use the pipenv in Jupyter, compared to [using a venv in Jupyter](using-a-venv-in-jupyter), the syntax of creating the kernel is simply adjusted to:

```bash
pipenv install ipykernel
python3 -m ipykernel install --user --name="pipenv-name" --display-name="My project (Python3)"
```

And then select the kernel in Jupyter as [normal](using-a-venv-in-jupyter).
