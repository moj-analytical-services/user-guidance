# RStudio

For general guidance in using RStudio, see the [RStudio documentation](https://docs.rstudio.com/).

## Resourcing options

RStudio runs with a standard set of resources. You can request an option with more powerful computing resources (2 CPUs with 24GB of RAM) for your environment if you need it. This includes situations where you’re working with very large or very complex datasets. If you're working with normal sized datasets,
make sure you've checked for [RStudio memory issues](#rstudio-memory-issues) first, which you can troubleshoot to solve problems.

To request increased resourcing, send a message in [#ask-analytical-platform on Slack](https://moj.enterprise.slack.com/archives/C4PF7QAJZ) with:

* the email address for your Analytical Platform account
* the tooling you're using

### RStudio memory issues

RStudio crashes when it runs out of memory. This is because memory is a finite resource, and it's not easy to predict memory usage or exact availability. But if your data is of order of a couple of gigabytes or more, then simply putting it all into a dataframe, or doing processing on it, may mean you run out of memory. For more about memory capacity in the Analytical Platform, and how to work with larger datasets, see the [memory limits](/annexes.html#memory-limits) section.

If RStudio crashes on startup because the memory is full, you can fix it by [clearing your RStudio session](#clearing-your-rstudio-session).

Once RStudio is running again, you can get a better understanding of what takes up memory by using the [pryr](https://rdrr.io/cran/pryr/man/mem_used.html) package. To free up a bit of memory, for example when a variable points to a big dataframe, you can instead assign something a null to the variable, and then run [`gc()`](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/gc). To free up all the user memory you can click on the 'broom' to [clear the environment](https://community.rstudio.com/t/i-want-to-do-a-complete-wipe-down-and-reset-of-my-r-rstudio/6712/4).

An alternative is to use [Airflow](https://user-guidance.analytical-platform.service.justice.gov.uk/tools/airflow/concepts/#why-use-airflow) and run your R job as an Airflow task on a high-memory node.

## Clearing your RStudio session

The RStudio session is the short term 'state' of RStudio, including:

* which project and files are open (displayed in the RStudio interface)
* console and terminal history
* the global environment – R variables that have been set and are held in memory

The session is persisted between restarts of RStudio, to make it easier for you to pick up where you left off. However you can clear it to solve a number of problems, including if the memory is full.

To clear the RStudio session:

1. Close RStudio, if it is open in any window (because it continually saves its session to disk).

2. Open the control panel, navigate to Analytical tool, click [resetting your home directory](https://controlpanel.services.analytical-platform.service.justice.gov.uk/reset-user-home/).

3. Select the __Restart__ button for RStudio.

    ![RStudio's "Restart" button in Control Panel](images/tools/restart_rstudio.png)

4. In the control panel, select __Open__ for RStudio. It may take between one and five minutes before RStudio is available. You may need to refresh your browser for the tool to load.


## GitHub Copilot

Starting from release 4.6.1, we have included GitHub's [CLI](https://cli.github.com/) and [Copilot CLI](https://github.com/features/copilot/cli).

To request a GitHub Copilot license, [follow the guidance](https://github.com/ministryofjustice/.github/blob/main/docs/github-copilot-guidance.md#github-copilot-guidance).


To authenticate with GitHub open a terminal session, run the command below and follow the instructions:

```bash
gh auth login --git-protocol ssh --hostname github.com --skip-ssh-key --web
```

Once authenticated, you can launch GitHub Copilot by running `copilot`.

For more information on using GitHub Copilot CLI, please refer to GitHub's [documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli).
