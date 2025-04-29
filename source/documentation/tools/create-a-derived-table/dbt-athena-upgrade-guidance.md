# dbt-athena Upgrade Guidance

We have now fully migrated to using [dbt-athena](https://pypi.org/project/dbt-athena-community/) [recommended by dbt](https://docs.getdbt.com/reference/warehouse-setups/athena-setup) as our interface with AWS. The guidance below details how you can properly test your models during software updates to the `dbt-athena-community` adapter. If you have any issues please get in touch via the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel.

## Table of contents

- [Test set up](#test-set-up)
- [Test `prod` models](#test-prod-models)
- [Test `dev` models](#test-dev-models)
- [Update your branch with the `dbt-athena` upgrade](#update-your-branch-with-the-dbt-athena-upgrade)
- [S3 location change for `seeds`](#s3-location-change-for-seeds)
- [License](#license)

## Test set up

We have created a branch called [`dbt-athena-upgrade-194`](https://github.com/moj-analytical-services/create-a-derived-table/tree/dbt-athena-upgrade-194) which contains all the latest models, sources, seeds, macros from the `main` branch as of the start of the update process (that is everything that exists in `prod`) and all the required upgrades. The main upgrades which you need to be aware of are:

- `dbt-athena-community` 1.9.3.
- `dbt-core` 1.9.4.
- `dbt-adapters` 1.14.8

To set up for testing you will need to checkout this branch, uninstall the old adapter and rerun the requirements files to update your local `venv` with the correct versions. In Terminal (with your `venv` active) in the root directory run the following to pull the latest from `main`, switch to `dbt-athena-upgrade-194` and update your `venv`:

```
git switch main
git fetch
git pull
git switch dbt-athena-upgrade-194
```

Next, install the new requirements files.

```
pip install -r requirements.txt
pip install -r requirements-lint.txt
```

To check you have the correct set up list your local environment packages with

```
pip list --local
```

and check the list output for `dbt-core 1.9.3`, `dbt-athena-community 1.9.4` and `dbt-adapters 1.14.8`

[Full evironment set up guidance here.](/tools/create-a-derived-table/instructions/#setting-up-a-python-virtual-environment)

## Test `prod` models

To test your `prod` models you need to create your own branch off the `dbt-athena-upgrade-194` branch, deploy your models in `dev`, run your `dbt` tests and lint. You can also manually run equality tests in Athena to compare tables from `prod` created using the old `dbt-athena` adapter to the tables you have just created in `dev` using `dbt-athena-community` adapter.

To explicitly create a new branch off `dbt-athena-upgrade-194` run the following:

```
git checkout -b <new-branch-name> dbt-athena-upgrade-194
```

All your `prod` models have the `external_location` parameter inserted into a config block at the top of each `.sql` file (see the [Insert external_location](#insert-external-location) section for more details).

As a consequence all `prod` models are already deployed into `dev` by the `deploy-dev` workflow. However, for robustness, we would still like you to test your `prod` models by deploying them yourselves; `cd` into the `mojap_derived_tables` directory to run `dbt` commands as usual.

If you have any issues due to redeploying please delete your `dev` models and try again, see [Delete dev models instructions](/tools/create-a-derived-table/troubleshooting#delete-dev-models-instructions).

Once you have deployed your models please run your tests and lint.

Please keep us up to date with your progress in the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel. When all users are happy that `prod` models are deploying as expected using the upgrades we will merge the branch `dbt-athena-upgrade-194` into `main`.

## Test `dev` models

Once you have completed testing of your `prod` models you may wish to continue testing with your `dev` models. To do this you will need to create another branch off `dbt-athena-upgrade-194` ([see instructions above](#test-prod-models)) and then merge into this from your feature branch. For example, I have some `dev` models on a branch called `my-feature-branch` so:

```
git checkout -b new-test-branch dbt-athena-upgrade-194
git fetch origin my-feature-branch
git pull origin my-feature-branch
git merge origin/my-feature-branch
```

This creates a new branch `new-test-branch` off `dbt-athena-upgrade-194` branch and then collects the changes from `my-feature-branch` and merges these in to `new-test-branch`. After the first command check you are on the `new-test-branch` before proceeding.

Once you have created a branch from the upgrade, you may then run dev deployments of any models you own/work on to test that you are able to deploy them successfully, as before, with the command:

```
dbt build --select ./path/to/your/model
```

Which will then run any models and tests associated with them at the path selected.

## Update your feature branch with the `dbt-athena` upgrades during testing

While we are testing we may make changes to the `dbt-athena-upgrade-194` branch which you will then need to merge into your branches. Whilst on the branch you want to update with the latest from `dbt-athena-upgrade-194` run:

```
git fetch origin dbt-athena-upgrade-194
git pull origin dbt-athena-upgrade-194
git merge origin/dbt-athena-upgrade-194
```

At this point you may have merge conflicts that need to be resolved; please see [GitHub resolve merge conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github). If required, ask for help on the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) slack channel.

## Working with the current version after testing.

To work with the previous version, simply change back to main, and re-install the requirements file there.

```
git switch main
pip install -r requirements.txt
```

## License

Unless stated otherwise, the codebase is released under the [MIT License](https://github.com/ministryofjustice/analytical-platform-data-engineering/blob/develop/LICENSE.md). This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/) and available under the terms of the [Open Government 3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
