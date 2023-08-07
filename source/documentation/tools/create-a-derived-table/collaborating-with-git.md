# Collaborating with Git

If you're working on a data model as part of a team you can take inspiration from the [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) to effectively collaborate and develop your data model. The following is a recommendation, so feel free to use another approach if there's one that suits your team better.

- Start with a main branch for your team. Because there is already a `main` branch in the repository, we suggest you create a branch from the `main` branch and name it something like `project-name-main` or `team-name-main`.
- Next Analyst 1 is working on `table_a`, while Analyst 2 is working on `table_b`.
  - Analyst 1 should create a branch off `project-name-main` called `a1/model-a-development`, prefixing the branch name with their initials and a slash `a1/`.
  - Analyst 2 should create a branch off `project-name-main` called `a2/model-b-development`, prefixing the branch name with their initials and a slash `a2/`.
- When they have completed the development of their respective models, each analyst should raise a pull request for their respective branches and set the base branch to `project-name-main`.
- The analysts, or someone else in the team, can then review the pull request and quality assure the work.
- When a pull request has been merged into `project-name-main`, keep other feature branches like `a2/model-b-development` up to date by merging `project-name-main` into it. You can do this using the terminal or in the pull request itself where you will see a button at the bottom of the pull request page that says `Update branch`. If you do use the pull request to update the branch, you'll need to run `git pull` locally. When the data model is complete and all changes have been merged into `project-name-main`, you can request review from the data modelling team who will check it over before it gets merged into `main`.

## Creating branches

First make sure you're on the `main` branch by running the following in terminal:

```
git status
```

If you're not, run:

```
git checkout main
```

```
git pull
```

Next create your `project-name-main` branch (don't forget to update the project name in the command) by running:

```
git checkout -b <project-name-main>
```

From the `project-name-main` branch, create your development branch by running:

```
git checkout -b <a1/model-a-development>
```

replacing `a1` with your initals.


## Updating your branch with main

When working on your models it is likely that your branch will get out of date with the main branch. To update you branch with the latest changes from main open a terminal and run the following:

Check your working tree, commit/push any changes if required

```
git status
```

Switch to the main branch and collect the latest changes, if any

```
git switch main
git fetch
git pull
```

Switch back to your branch and merge in the changes from main

```
git switch <your_branch>
git merge main -m "update branch with main"
```

At this point you may have merge conflicts that need to be resolved; please see [GitHub resolve merge conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github). If required, ask for help on the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) slack channel.

