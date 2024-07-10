# Annexes

## Memory limits

All the software running on the Analytical Platform has its memory controlled. Each running software container has a 'requested' amount and 'limit' available. Here's an explanation of the key terms:

* 'memory' is needed for your app and code, but the limiting factor is usually the data that you 'load into memory'. Data is in memory if it is assigned to a variable, which includes a data frame.
* a 'container' is for one user's instance of a tool (e.g. Sandra's R Studio or Bob's Jupyter) or app (e.g. the PQ Shiny App or the KPIs Web App).
* 'Requested memory' is the amount the container is guaranteed. It is reserved for it.
* 'Limit' is the maximum amount of memory it can consume, if it is available. Your container is competing for this memory with other containers on the server it happens to be running on. If you try to use more than is available or more than the Limit then your container will be restarted.

e.g. Sandra runs her code in R Studio, which loads 8GB of data into a data frame, and she sees in Grafana that this takes 10GB of memory. This is above the minimum of 5GB, and because the servers aren't too busy the extra 5GB are available. Later the server that her R Studio container is running on happens to get full and when she tries to do something that needs another 1GB memory (i.e. total 11GB) she finds that R Studio restarts, interrupting her work for a few minutes. She restarts her code, but because her R Studio now happens to be running on a different server that is less busy, she finds she can run her code and use 11GB fine.

You can monitor your memory usage using [Grafana](https://grafana.services.alpha.mojanalytics.xyz/login) (there is also a link from the Control Panel). To display your tool's usage:

1. Select the "Home" menu, then select the "Kubernetes / Pods" Dashboard
2. In the "Namespace" box start typing your GitHub username then select it e.g. "user-davidread"
3. In the "Pod" box select the tools - R Studio or Jupyter. It only shows ones which have been running recently.
4. The "Memory Usage" shows a timeline. Compare your current usage: "Current: r-studio-server" with the corresponding "Requested" and "Limit" values.
5. You may wish to adjust the time period shown, for example to "Last 5 minutes", by clicking on the clock icon in the top-right corner.

![](images/annexes/ram-usage.png)

Current memory limits:

<div style="height:0px;font-size:0px;">&nbsp;</div>
| Container type | Requested | Limit    |
| -------------- | --------- | -------- |
| R Studio | 12 GB | 12 GB |
| Jupyter | 12 GB | 12 GB |
| App | 100 MB | 8 GB |
<div style="height:0px;font-size:0px;">&nbsp;</div>

From November 2022 all tools (RStudio and Jupyter) are allocated with `requests` and `limits` set to the same value.

You can work on a dataset that is bigger than your memory by reading in a bit of the data at a time and writing results back to disk as you go. If you're working on big data then consider taking advantage of tech like Amazon Athena or Apache Spark, which are available through the Analytical Platform too.

We are open to increasing the maximum memory, so let us know if you need more, to help us justify the additional cost.

See also the [RStudio memory issues](tools/rstudio/index.html#rstudio-memory-issues) section.

## Benefits of GitHub

Github is a central place to store our analytical projects - particularly those which are built primarily in code.

**Github keeps track of who wrote what, when, why they wrote it, why we can trust its correctness, and which version of the code was run to produce an analytical result.**

This is useful if you're work on your own, but the benefits are greatest when you're working in a team.

Here is some more details of what Git offers:

- It provides a single, unambigous master version of a project.  No more `model_final.r`, `model_finalv2_final.r`. etc.

- It enables you and collaborators to work on the same project and files *concurrently*, resolving conflicts if you edit the same parts of the same files, whilst keeping track of who made what edits and when.

- It enables work in progress to be shared with team members, without compromising the master version. You never get confused between what's not yet final, and what's trusted, quality assured code.  The work in progress can be seemlessly merged into the master version when it's ready.

- It provides a history of all previous versions of the projects, which can be meaningfully tagged, and reverted to (undo points).   e.g. we may wish to revert to the exact code that was tagged ‘model run 2015Q1’.

- It reduces the likelihood of code being lost in messy file systems, such as on DOM1. Files sits within defined project 'repositories', with all code accessible from this location.

- It provides an extremely powerful search function.  The ability to search all code written by Ministry of Justice analysts in milliseconds.  Or all code written by anyone, for that matter.

- It enables an easier, more robust, more enjoyable approach to quality assurance.  In particular, it offers the potential to continuously quality assure a project as it's built, rather than QA being an activity that's only done once the work is complete.  For example, all additions to the codebase can be reviewed and accepted by a peer before being integrated into the master version.

- It includes productivity tools like Github issues (essentially a tagged to-do list), and a trello style workflow (Github projects), with automation.

- Git stores a huge amount of meta data about *why* changes were made and by whom.  This dramatically reduces the danger of code becoming a 'black box'.  The to-do list is automatically linked to the implementation - e.g. The issue of 'improve number formatting' is automatically linked to the specific changes in the code that fixed the number formatting.

- It makes it much easier to build reusable components, and make parts of our code open source (available to the public).  For example, we use R code written by statisticians around the world that's been put on Github, and we know that people across government have been using some of our R code.  We can collaborate easily with other government deparments and anyone else for that matter.

- It makes it easier to ask for help with your work, particularly with colleagues who are working remotely.  You can hyperlink and comment on specific lines of code.

- You can write rich, searchable documentation - e.g. this user guide is hosted on Github!

Finally, we have chosed git specifically because it seems to be by far the most popular version control system - see [here](https://insights.stackoverflow.com/survey/2017#work-version-control) and [here](https://trends.google.co.uk/trends/explore?date=all&q=tfs,svn,mercurial,git)


## Reproducible Analytical Pipelines

The Reproducible Analytical Pipeline (RAP) is an alternative production methodology for automating the bulk of steps involved in creating a statistical report, interactive dashboard, or other analytical product. At its heart it involves replacing manual tasks with code, and usually includes:

* Organising repeated code chunks into functions that have been peer reviewed with associated unit tests, and ideally also organised into packages with relevant documentation and automated testing.
* Wrangling datasets into a tidy format, i.e. one variable per column, and one record per row, to faciliate analysis with vectorized functions.
* Managing dependencies inside virtual environments to facilitate reproducibility, using tools such as `renv` for R or `venv` for Python.
* Using functions from public packages where relevant functions exist for the task at hand, rather than writing new ones with similar functionality. Where this is not the case and new functions would benefit others, they are contributed to other packages or added to a new package.

Packages developed within MoJ and hosted on GitHub designed to address tasks analysts commonly face in creating RAPs, such as the [`mojrap`](https://github.com/moj-analytical-services/mojrap) R package, will facilitate the creation of new RAPs when adopted more widely and contributed to. This will also promote the harmonisation of coding approaches across teams and reduce the duplication of similar functions.

For more information on RAPs, please see the following: [RAP Manual](https://moj-analytical-services.github.io/rap-manual/), [RAP Companion](https://ukgovdatascience.github.io/rap_companion/), or [this blog post](https://dataingovernment.blog.gov.uk/2017/03/27/reproducible-analytical-pipeline/). Real life examples of RAPs created by MoJ analysts can be found on the [DASD Automation Team's website](https://moj-analytical-services.github.io/automation-team/).

To engage further with the MoJ RAP community, please contact Aidan Mews to join the RAP publication group team on MS Teams, or join the [#rap](https://app.slack.com/client/T1PU1AP6D/C02DSC3Q4P6) channel on Slack.

### Step by step - logging into the platform for the first time

Your welcome email will direct you to the platform [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).

#### Step 1: Log into Github to identify yourself to the Analytical Platform

![](images/2fa/github.gif)

If you're already logged into Github, you will not see the 'Sign in to GitHub to continue to Analytics platform' screen.

#### You're now done

## Infrastructure Migration - step by step instructions

1. Before upgrading make sure that you and your teams have pushed everything to GitHub or saved to s3 as the home directories will be wiped
2. We will ask for your GitHub username so we can enable the upgrade on our end
3. Once we do that, when you log in again to the AP, you will see the following message: ‘You are now eligible to upgrade. Please click here’
4. The URL link for the AP will change, so as soon as you upgrade make sure you save the link
5. The Control Panel is not changing at all, so once you are on the Tools page just choose what version of Tool you want to deploy
6.Once you deploy the tool, you will have to reconnect to Github by setting up your SSH keys again for each tool, following the [user guidance](https://user-guidance.analytical-platform.service.justice.gov.uk/github.html#content)
7. You are now done
