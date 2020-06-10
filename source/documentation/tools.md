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

## Package management

A key element of ensuring analysis is reproducible is maintaining a record of the versions of packages used to produce said analysis.

There are a number of tools available for both R and Python to support package management.

For R:

* [**conda**](#conda) - Recommended for R in Analytical Platform. (Conda is only provided on AP with RStudio images which have R 3.5.1 and later. So if you have the older RStudio with R 3.4 then you'll need to use Packrat instead.)
* [**packrat**](#packrat) - not recommended for R, but remains an option.

For Python:

* [**venv** and **pip**](#venv-and-pip) - Recommended for Python in Analytical Platform, because it's easier, more reliable and has a much bigger community than conda.
* [**conda environment**](#conda) installing packages with just **conda** - not recommended, but it might help for the occasional package whose C extension doesn't install well with pip (perhaps the pip package isn't the newer 'wheel' type, or it doesn't have a binary suitable for our distribution)
* [**conda environment**](#conda) installing packages with **conda** and **pip** - not recommended, but gives you the broadest range of package install options. However conda and pip don't play well together - use at your own risk!

**Note on support:** the Analytical Platform team does not offer support on the topic of packaging. DASD users are encouraged to use their #r, #conda and #python Slack channels to support each other, or ask your line manager about training. Of course, if there is something broken with the platform itself, or something unique about the platform that prevents you from installing a library, then of course do raise it with the team in the normal ways.

## Conda

When exploring this section, you may also find the [slides](https://github.com/moj-analytical-services/coffee-and-coding-public/blob/master/2019-10-30%20Conda/conda.pdf) from the Coffee and Coding session on conda useful.

Conda is a unified package management system that supports managing both Python and R dependencies in a single `environment`. It can make sure all of these libraries are compatible with each other. Conda is available for both RStudio and JupyterLab on the Analytical Platform, though note that RStudio and JupyterLab have separate environments so dependencies won't be shared between the applications.

A key example within Analytical Services where conda is useful: both `dbtools` and `s3tools` rely on Python packages through the `reticulate` R-to-Python bridge. `packrat` only handles R dependencies; this means that `packrat` is not enough to reproducibly and reliably manage all of your application's dependencies.

### Installing Packages

the Anaconda organisation has its own repository of packages hosted on [https://anaconda.org](https://anaconda.org). If you need to find a package name you can use the [anaconda search](https://anaconda.org/search) to find the package name.

To install a package through conda, run the command `conda install PACKAGENAME` in the Terminal tab. This is recommended over using `install.packages()` as the package will be installed into the conda environment in a way that can be repeated when replicating the analysis - see [Environment management](#Environment-management) section for more.

Most (around 95%) R packages on CRAN are available through conda. They have the same name as the CRAN package name with an additional `r-` prefix. This is to avoid clashes with Python packages with the same name.

#### Examples

The following tables show conda commands and their base R analogues.

Installing a package:

<div style="height:0px;font-size:0px;">&nbsp;</div>
| `install.packages` (in R-Console) | `conda install` (in Terminal) |
| --------------------------------- | ----------------------------- |
| `install.packages('Rcpp')`        | `conda install r-Rcpp`        |
<div style="height:0px;font-size:0px;">&nbsp;</div>


![](images/conda/conda_install_rcpp.gif)


Installing a specific version of a package

<div style="height:0px;font-size:0px;">&nbsp;</div>

| `install.packages`                                                                                               | conda install                   |
| ---------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `require(devtools)`</br> `install_version("ggplot2", version = "2.2.1", repos = "http://cran.us.r-project.org")` | `conda install r-ggplot2=2.2.1` |
<div style="height:0px;font-size:0px;">&nbsp;</div>

![Specific version gif here](images/conda/conda_install_specific_version.gif)

You can also use conda to install Python packages, for use in R through the `reticulate` package. Python packages do not require a prefix and can simply be installed using theirname.

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

#### Reset your _Environment_ to default

This is recommended to run before starting a new project. This will ensure that no unused dependencies are exported when you export an `environment.yml` for this project.

```bash
conda env export -n base| grep -v "^prefix: " > /tmp/base.yml && conda env update --prune -n rstudio -f /tmp/base.yml && rm /tmp/base.yml
```

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

## Packrat

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

A [Python virtual environment](https://docs.python.org/3/tutorial/venv.html) (or `venv`, for short) is a directory you can install a particular python executable and python packages into, away from your machine's default ones. Typically each project/repo you work on should have a different venv, and then you never have to deal with conflicting requirements between projects. When you 'activate' a particular venv, then when you run `python` or `pip`, then it will work with the venv's python executale and python packages.

### Basic usage

Create a venv for your project, called 'venv':

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
(venv) $ python -c 'import pandas; print(pandas); print("It worked")'
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
    python -m ipykernel install --user --name="venv" --display-name="My project (Python3)"

```

And your project has analytical scripts that run in a terminal you could add:

```markdown
## Run scripts

To run the python scripts, you'll need to activate the virtual env first:

    cd myproject
    . venv/bin/activate
    python myscript.py
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
    python -m ipykernel install --user --name="venvname" --display-name="My project (Python3)"
    ```

4. In Jupyter, open your notebook and then select this new kernel by its pretty name in the top right hand corner. It might take a little time/refreshes for it to show up.

To resume work on this after working on another project:

1. Activate the environment:
   ```bash
   cd myproject
   source venv/bin/activate
   ```
   to activate the venv in terminal, which enables you to use the installed packages and install more packages to there.
2. Open the notebook - it’s remembered which kernel you wanted to use for this notebook and you can carry on working with the packages available.

Note: *Once you have associated the kernel with the venv you dont need to recreate/update it*. Any packages that are installed to the venv via pip after the kernel is established are immediately available to the kernel.
