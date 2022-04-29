# Tools

## RStudio and JupyterLab

Analytical Platform comes with tools including:

* RStudio - a development environment for writing R code and R Shiny apps
* JupyterLab - see [JupyterLab section](./jupyterlab.html)
* Airflow - see [Airflow section](./airflow.html)

## Managing your analytical tools

Tools on Analytical Platform include RStudio, JupyterLab and Airflow sandbox. To use these, each user must 'start' their own copy of the software. This gives them the benefit of reserved memory space (compared to the more common shared R Studio Server), and some control over the version of R that is running.

To manage your tools:

1. Go the Analytical Platform [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
2. Select the __Analytical tools__ tab.

Use the buttons shown against each tool to manage your copy of the tool:

* "Deploy" - The tool is not yet deployed - this is the initial state. You need to "Deploy" to be able to use the tool for the first time. It sets you up with the latest version and starts it. This may few minutes.
* "Open" - The tool is either "Idled" (configured but not running) or "Ready" (running). If your RStudio, JupyterLab or Airflow instance is inactive on a Tuesday evening it will be idled. Press "Open" to navigate to the tool in your browser, and if it is not running it will start it (run or "unidle" it). Starting a tool usually takes about 30 seconds, but occasionally will take a few minutes.
* "Restart" - Often problems with the tool can be solved by restarting the software on the server.
* "Upgrade" - Another release of the tool is available. Occasionally new versions of R Studio are made available on the Analytical Platform. In this case all users will be given the opportunity to upgrade on the control panel. New versions provide new features and bugfixes to the tool. In addition, there some releases come with improvements to the way RStudio is containerized and integrated with Analytical Platform. You should aim to upgrade when it is offered, although just in case it causes minor incompatibilities with your R code, you should not do it in the days just before you have a critical release of your work. When pressed, the status will change to 'Deploying' and then 'Upgraded'. The __Upgrade__ button will no longer be visible (until another version becomes available).

### RShiny

To use conda in RShiny applications, you will need to use a different `Dockerfile` to deploy the app. The [conda branch of the rshiny-template](https://github.com/moj-analytical-services/rshiny-template/tree/conda) has an appropriate `Dockerfile` for this purpose. This is also necessary if you wish to use Python in your Shiny application, including using `dbtools` for accessing Amazon Athena databases.

### Analytical Platform limitations

There are a number of limitations and pitfalls to conda management to be aware of.

## R package versions on Conda

While Anaconda hosts most of the R packages available on CRAN (the Comprehensive R Archive Network), some R packages on Anaconda only have binaries built for certain versions of R. You can identify the available versions by inspecting the first few characters of the Build part of the filename on its page on anaconda.org, like so:

![](images/conda/anaconda_R_version_number_example.PNG)

Alternatively, if you use `conda search PACKAGENAME`, you can look in the Field column:

![](images/conda/conda_search_R_version_number_example.PNG)

If there isn't an appropriate build for a package, attempting to `conda install` that package will result in conda attempting to match the environment to the superior (or inferior) version of R, asking if you want to install/upgrade/downgrade a long list of packages in the process.

Instead, you should install the package locally via `install.packages()` or `remotes::install_github()`. For RShiny apps, you can add an `install.packages()` step to the `Dockerfile` to install additional packages not covered by the conda environment.yml, like so:

```bash
RUN R -e "install.packages('waffle', repos = 'https://cinc.rud.is')"
```
