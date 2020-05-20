# R Studio and JupyterLab

Analytical Platform comes with tools including:

* R Studio - a development environment for writing R code and RShiny apps
* JupyterLab - a development environment for writing Python code including Python notebooks
* Airflow - see [Airflow section](../airflow.html)

## Managing your analytical tools

### Deploy analytical tools

Before using RStudio, JupyterLab and Airflow, you must first deploy (start) them.

To deploy RStudio, JupyterLab and Airflow on the Analytical Platform, you should complete the following steps:

1. Go the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2. Select the __Analytical tools__ tab.
3. Select the __Deploy__ buttons next to RStudio, JupyterLab and Airflow.

It may take a few minutes for the tools to deploy.

### Open analytical tools

To open RStudio, JupyterLab or Airflow:

1. Go the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2. Select the __Analytical tools__ tab.
3. Select the __Open__ button to the right of the tool's name.

### Restart analytical tools

If your RStudio, JupyterLab or Airflow is not working as expected, it may help to restart it.

To restart RStudio, JupyterLab or Airflow:

1. Go the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2. Select the __Analytical tools__ tab.
3. Select the __Restart__ button to the right of the tool's name.

### Unidle analytical tools

If your RStudio, JupyterLab or Airflow instance is inactive for an extended period of time (for example, overnight) it will be idled.

1. Go the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2. Select the __Analytical tools__ tab.
3. Select the __Open__ button to the right of the tool's name.

Unidling usually only takes a few seconds, however, it can take up to several minutes.

### Upgrade analytical tools

Occasionally new versions of R Studio are made available on the Analytical Platform. In this case all users will be given the opportunity to upgrade on the control panel. New versions provide new features and bugfixes to the tool. In addition, there some releases come with improvements to the way RStudio is containerized and integrated with Analytical Platform. You should aim to upgrade when it is offered, although just in case it causes minor incompatibilities with your R code, you should not do it in the days just before you have a critical release of your work.

1. Go the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2. Select the __Analytical tools__ tab.
3. Select the __Upgrade__ button to the right of the tool's name.
4. The status will change to 'Deploying' and then 'Upgraded'. The __Upgrade__ button will no longer be visible (until another version becomes available).


## Package management

A key element of ensuring analysis is reproducible is maintaining a record of the versions of packages used to produce said analysis.

There are a number of tools available for both R and Python to support package management.

For R:

* **conda** - Recommended for R in Analytical Platform. (Conda is only provided on AP with RStudio images which have R 3.5.1 and later. So if you have the older RStudio with R 3.4 then you'll need to use Packrat instead.)
* **packrat** - not recommended for R, but remains an option.

For Python:

* **venv** and **pip** - Recommended for Python in Analytical Platform, because it's easier and more reliable than conda.
* **conda environment** installing packages with just **conda** - can help when you have a package package with a C extension that pip struggles with compiling or installing the binaries
* **conda environment** installing packages with **conda** and **pip** - gives you the broadest range of package install options. However conda and pip don't play wonderfully together, so can be annoying - not recommended.

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

```
conda env export -n base| grep -v "^prefix: " > /tmp/base.yml && conda env update --prune -n rstudio -f /tmp/base.yml && rm /tmp/base.yml
```

#### Exporting your _Environment_

This is similar to making a `packrat.lock` file, it catalogues all of the
dependencies installed in your environment so that another user can restore a
working environment for your application. Check this `environment.yml` file into
your git repository.

```
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

### Renv

[Renv](https://rstudio.github.io/renv/articles/renv.html) is a newer package billed as "Packrat 2.0". This has a number of improvements over Packrat, in the speed of download and reduction of issues of 00LOCK files that often plague Packrat. However, it is still not able to deal with OS-level dependencies, so conda is still preferred.

## venv and pip

When you want to use venv with Jupyter you also have to create a Jupyter kernel that links your Jupyter notebook instance to the virtual environment you created, i.e. telling it 'whenever I want to run a python command divert it through this python copy which is my virtual environment rather than the base one'.

When you run `source venvname/bin/activate` in the terminal it is only making that diversion for other things that go on in the terminal (or in an IDE like VSCode it picks this cue up too), so you need to do another step in Jupyter.

So say I’m starting a new project I need to do this:

1. Create a virtual environment in the project folder: (terminal)

    ```bash
    python3 -m venv venvname
    ```

2. Activate the environment in the terminal to divert any terminal commands (e.g. pip installs): (terminal)

    ```bash
    source venvname/bin/activate
    ```

3. Install the module ipykernel within this venv (for creating/managing kernels for ipython which is what jupyter sits on top of): terminal (with venv activated)

    ```bash
    pip3 install ipykernel
    ```
   (before this step `pip3 list` should show almost none if any packages; after it will have about 10 as this has quite a few deps)
4. Create a kernel attached to this virtual environment so Jupyter knows it exists: terminal (with venv activated)

    ```bash
    python3 -m ipykernel install --user --name="venvname" --display-name="Prettier Name to Display (Python3)"
    ```
   **NB:** It’s important here to call ipykernel as a module through python3 rather than by itself; this is how I most often broke my kernels. I think this is because at the start the only things the terminal knows how to redirect through the venv is python commands (it, uh, coopts the symlink to your python interpreter…or something technical-sounding like that) so if you call ipykernel separately it’ll be trying to connect through your normal python interpreter that doesn’t know about your lovely venv packages.
5. Open your notebook and then select this kernel by its pretty name in the top right hand corner. It might take a little time/refreshes for it to show up.
6. Do your work and install any packages you need using pip in the terminal with your venv active.

To resume work on this after working on another project:

1. Navigate to the project folder and do:
   ```bash
   source venvname/bin/activate
   ```
   to activate the venv in terminal, which enables you to use the installed packages and install more packages to there.
2. Open the notebook - it’s remembered which kernel you wanted to use for this notebook and you can carry on working with the packages available.

The `myvenv` folder should not be added into git. You should add `venv/` to your .gitignore to avoid this.

You should write a `requirements.txt` (called this by tradition not necessity), so that other users know what packages are needed. i.e. the next user just needs to:

1. Open the project folder. Create your own fresh env by calling venv as a module as in (1) in the first post.
2. Activate the new environment
3. Install packages using:
   ```pip3 install -r requirements.txt```
4. Create a Kernel attached to this venv (using step (4) from first post).

Tips:

* *Once you have associated the kernel with the venv you dont need to recreate/update it*. Any packages that are installed to the venv via pip after the kernel is established also carry through and are available to the kernel (thats why I find it useful to picture the kernel as a dude diverting traffic)

* To clear up doubt about `python` vs `python3` and `pip` vs `pip3`, it's best to be in the habit of specifying the `3` in these commands, just in case you find yourself on a machine (like in MacOS) which still defaults to Python 2 versions, which is not really used any more at MoJ.
