# dbt-athena Upgrade Guidance

We are in the process of migrating from our in-house maintained fork of the `dbt-athena` adapter to the community maintained fork [dbt-athena-community](https://pypi.org/project/dbt-athena-community/) [recommended by dbt](https://docs.getdbt.com/reference/warehouse-setups/athena-setup). The guidance below details how you can test your models using the `dbt-athena-community` adapter. If you have any issues please get in touch via the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel.

## Table of contents

- [Test set up](#test-set-up)
- [Test `prod` models](#test-prod-models)
- [Test `dev` models](#test-dev-models)
- [Insert external_location](#insert-external-location)
- [SQLFluff linting changes](#sqlfluff-linting-changes)
- [Update your branch with the `dbt-athena` upgrade](#update-your-branch-with-the-dbt-athena-upgrade)
- [S3 location change for `seeds`](#s3-location-change-for-seeds)
- [License](#license)


## Test set up

We have created a branch called [`DMT-236/dbt-athena-upgrade-main`](https://github.com/moj-analytical-services/create-a-derived-table/tree/DMT-236/dbt-athena-upgrade-main) which contains all the latest models, sources, seeds, macros from the `main` branch (that is everything that exists in `prod`) and all the required upgrades. The main upgrades which you need to be aware of are:

- `dbt-athena-community` 1.5.0.
- `dbt-core` 1.5.0.
- macro `generate_s3_location.sql` to support our S3 file path Hive style naming convention.
- script `scripts/insert_external_location_config.py` to insert the required `external_location` configuration at the top of every model `.sql` file.
- running `sqlfluff` with the `--ignore=templating` option.
- `seeds` S3 location has changed (this does not effect any references to `seeds`)

To set up for testing you will need to checkout this branch, uninstall the old adapater and rerun the requirements files to update your local `venv` with the correct versions. In Terminal (with your `venv` active) in the root directory run the following to pull the latest from `main`, switch to `DMT-236/dbt-athena-upgrade-main` and update your `venv`:

```
git switch main
git fetch
git pull
git switch DMT-236/dbt-athena-upgrade-main
```

At this point you can refresh the Git tab in the RStudio Environments panel (top right) to check you have switched to this branch. Next uninstall the old adapter:

```
pip install --upgrade pip
pip uninstall dbt-athena-adapter
```

Here you will be asked to type "Y" to proceed with the uninstall; do so and continue to install requirements:

```
pip install -r requirements.txt
pip install -r requirements-lint.txt
```

To check you have the correct set up list your local environment packages with

```
pip list --local
```

and check the list output for `dbt-core 1.5.0`, `dbt-athena-community 1.5.0` and __not__ `dbt-athena-adapter 1.0.1` (or any other version of it). If you still have the latter try to uninstall it again; if both old and new adapters are installed there will be conflicts.


[Full evironment set up guidance here.](/tools/create-a-derived-table/instructions/#setting-up-a-python-virtual-environment)


## Test `prod` models

To test your `prod` models you need to create your own branch off the `DMT-236/dbt-athena-upgrade-main` branch, deploy your models in `dev`, run your `dbt` tests and lint. You can also manually run equality tests in Athena to compare tables from `prod` created using the old `dbt-athena` adapter to the tables you have just created in `dev` using `dbt-athena-community` adapter. 

To explicitly create a new branch off `DMT-236/dbt-athena-upgrade-main` run the following:

```
git checkout -b <new-branch-name> DMT-236/dbt-athena-upgrade-main
```

All your `prod` models have the `external_location` parameter inserted into a config block at the top of each `.sql` file (see the [Insert external_location](#insert-external-location) section for more details).

As a consequence all `prod` models are already deployed into `dev` by the `deploy-dev` workflow. However, for robustness, we would still like you to test your `prod` models by deploying them yourselves; `cd` into the `mojap_derived_tables` directory to run `dbt` commands as usual. 

If you have any issues due to redeploying please delete your `dev` models and try again, see [Delete dev models instructions](/tools/create-a-derived-table/troubleshooting#delete-dev-models-instructions).

Once you have deployed your models please run your tests and lint.

⚠️ See the section below on [SQLFluff linting changes](#sqlfluff-linting-changes) ⚠️

Please keep us up to date with your progress in the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel. When all users are happy that `prod` models are deploying as expected using the upgrades we will merge the branch `DMT-236/dbt-athena-upgrade-main` into `main`.


## Test `dev` models

Once you have completed testing of your `prod` models you may wish to continue testing with your `dev` models. To do this you will need to create another branch off `DMT-236/dbt-athena-upgrade-main` ([see instructions above](#test-prod-models)) and then merge into this from your feature branch. For example, I have some `dev` models on a branch called `my-feature-branch` so:

```
git checkout -b new-test-branch DMT-236/dbt-athena-upgrade-main
git fetch origin my-feature-branch
git pull origin my-feature-branch
git merge origin/my-feature-branch
```

This creates a new branch `new-test-branch` off `DMT-236/dbt-athena-upgrade-main` branch and then collects the changes from `my-feature-branch` and merges these in to `new-test-branch`. After the first command check you are on the `new-test-branch` before proceeding.

⚠️ __WARNING__ ⚠️

Your `dev` models will not have the `external_location` parameter set, which is required to store the output model in the correct location. See instructions in the [Insert external_location](#insert-external-location) section to insert the `external_location` and then cd into the `mojap_derived_tables` directory to run `dbt` commands as usual. Once you have deployed your models run tests and lint. See the section below on [SQLFluff linting changes](#sqlfluff-linting-changes).


## Insert `external_location`

The `external_location` parameter is set by the macro `generate_s3_location` which is invoked at run time. This combines information from the schema name with the names from the repo directory structure to create the desired S3 location in the form:

```
s3://<bucket_name>/<env_name>/<table_type>/domain_name=<domain_name>/database_name=db_name/table_name=<tb_name>
```

To make this as painless as possible we have prepared a script `insert_external_location_config.py` which you can run locally to automatically insert the required line or full config into your `.sql` files. The script must be run from the root directory and requires user input to determine the path to the files that you wish to run it on.

In Terminal, in the root directory run

```
python scripts/insert_external_location_config.py
```

You will be prompted to enter the path to the directory containing the files you wish to apply the script to. Type your input starting with the domain directory name and continuing to whichever subdirectory you require (note there is no tab auto complete available) and hit `Enter`:

```
Enter path to directory, starting with domain directory: <domain_name>/<database_name>
```

If you are copy/pasting be careful not to introduce leading or trailing spaces. 

The next prompt shows the full file path you have selected and asks you to confirm by typing "Y" (any other input will exit the program):

```
Path selected: 'mojap_derived_tables/models/<domain_name>/<database_name>'

Continue with selected path? Enter Y/n: Y
```

The final prompt shows the number of files selected and their paths and asks you to confirm by typing "Y":

```
Files selected: 
mojap_derived_tables/models/<domain_name>/<database_name>/<database_name__table_name_0>.sql

mojap_derived_tables/models/<domain_name>/<database_name>/<database_name__table_name_1>.sql

mojap_derived_tables/models/<domain_name>/<database_name>/<database_name__table_name_3>.sql

Number of files selected:  3
Continue with selected files? Enter Y/n: Y
```

Upon entering "Y" the script starts to scan the files and make the required changes. There are three possibilities:

```
Scanning files...

Config block exists but no external location set for file: 
mojap_derived_tables/models/<domain_name>/<database_name>/<database_name__table_name_0>.sql
Inserting external_location line into existing config block...

External location not set and no config block for file: 
mojap_derived_tables/models/<domain_name>/<database_name>/<database_name__table_name_1>.sql
Inserting config block...

External location set correctly in config block - nothing to do for file:
mojap_derived_tables/models/<domain_name>/<database_name>/<database_name__table_name_3>.sql
```

Once inserted the config block will look similar to this, but may include additional parameters that you have set previously:

```
{{ config(
  external_location=generate_s3_location()
) }}
```

Note that if there was no existing config block it is inserted at the top of the file, displacing (but not overwriting) any existing comments or code. Files are automatically saved once the changes are applied.


## SQLFluff linting changes

As you may be aware we have had issues with SQLFluff being unable to cope with complex Jinja templating mostly in macros. The new `generate_s3_location.sql` macro is no exception and is added to the `sqlfluffignore` file so that it is skipped during linting. However, since all models now reference this macro SQLfluff throws the `Undefined jinja template variable` error. We cannot add all models to `sqlfluffignore`, hence to circumvent the perceived error please use the `--ignore=templating` option when running SQLFluff lint or fix, thus:

```
sqlfluff lint --ignore=templating path/to/files/to/lint

sqlfluff fix --ignore=templating path/to/files/to/lint/and/fix
```



## Update your branch with the `dbt-athena` upgrade

As mentioned above we have created a branch containing all the upgrades called `DMT-236/dbt-athena-upgrade-main`. While we are testing we may make changes to the `DMT-236/dbt-athena-upgrade-main` branch which you will then need to merge into your branches. Whilst on the branch you want to update with the latest from `DMT-236/dbt-athena-upgrade-main` run:

```
git fetch origin DMT-236/dbt-athena-upgrade-main
git pull origin DMT-236/dbt-athena-upgrade-main
git merge origin/DMT-236/dbt-athena-upgrade-main
```


At this point you may have merge conflicts that need to be resolved; please see [GitHub resolve merge conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github). If required, ask for help on the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) slack channel.


## S3 location change for `seeds`

Previously the `seed` S3 location was split between the `dev` and `prod` environments and followed the same Hive style path naming convention as for models. It was not straightforward to preserve this feature with the `dbt-athena-community` adapter and since `seeds` change little it was not a priority. 

The __old__ directory structure for the `mojap-derived-tables` bucket is as below, with the `seed` directory appearing under both `prod` and `dev` directories. Note the database name is suffixed with `_dev_dbt` under the `dev` directory:

```
├── mojap_derived_tables
  ├── dev/
      ├── models/
      ├── run_artefacts/
      └── seeds/
          ├── domain_name=domain_one/
              ├── database_name=db_one_dev_dbt/
                  ├── table_name=tb_one
                  ...
              ...
          ...
  ├── prod/
      ├── models/
      ├── run_artefacts/
      └── seeds/
          ├── domain_name=domain_one/
              ├── database_name=db_one/
                  ├── table_name=tb_one
                  ...
              ...
          ...
```

The __new__ directory structure has a single `seeds` directory at the same level as the `prod` and `dev` directories. A `seed` created on a `dev` run will appear under its database name suffixed with `_dev_dbt`, as before, but the Hive path naming convention is not upheld. Instead we use the naming option `schema_table` provided by `dbt-athena-community` which is simply `<database_name>/<table_name>`

```
├── mojap_derived_tables
  ├── dev/
  ├── prod/
  └── seeds/
      ├── database_one_dev_dbt/
          ├── table_one/
          ...
      ├── database_one/
          ├── table_one/
          ...
      ...
```

The changes to the S3 location should not have any impact on users, unless they have specifically referenced a `seed` by its S3 location. References in `create-a-derived-table` using the `ref` function will be unaffected as this uses   Athena to reference the Glue Catalogue Registration, in the form `<database_name.table_name>`. The catalogue registrations will be updated with the new S3 locations automatically.

## License

Unless stated otherwise, the codebase is released under the [MIT License](https://github.com/ministryofjustice/analytical-platform-data-engineering/blob/develop/LICENSE.md). This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/) and available under the terms of the [Open Government 3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
