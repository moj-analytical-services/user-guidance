# dbt-athena Upgrade Guidance

We are in the process of migrating from our in-house maintained fork of the `dbt-athena` adapter to the community maintained fork [dbt-athena-community](https://pypi.org/project/dbt-athena-community/) [recommended by dbt](https://docs.getdbt.com/reference/warehouse-setups/athena-setup). The guidance below details how you can test your models using the `dbt-athena-community` adapter. If you have any issues please get in touch via the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel.

## Table of Contents

- [Test set up](#test-set-up)
- [Test `prod` models](#test-prod-models)
- [Test `dev` models](#test-dev-models)
- [Insert external_location](#insert-external-location)
- [Updating your branch with DMT-236/dbt-athena-upgrade-main](#updating-your-branch-with-dmt-236dbt-athena-upgrade-main)
- [Change in creating models](#change-in-creating-models)
    - [New config block for .sql files](#new-config-block-for-sql-files)
- [What changed for seeds?](#what-changed-for-seeds)
- [Helpful commands](#helpful-commands)
- [Resources](#resources)
- [License](#license)


## Test set up

We have created a branch called [`DMT-236/dbt-athena-upgrade-main`](https://github.com/moj-analytical-services/create-a-derived-table/tree/DMT-236/dbt-athena-upgrade-main) which contains all the latest models, sources, seeds, macros from the `main` branch (that is everything that exists in `prod`) and all the required upgrades. The main upgrades which you need to be aware of are:

- `dbt-athena-community` 1.5.0.
- `dbt-core` 1.5.0.
- macro `generate_s3_location.sql` to support our S3 file path Hive style naming convention.
- script `scripts/insert_external_location_config.py` to insert the required `external_location` configuration at the top of every model `.sql` file.

To set up for testing you will need to checkout this branch and rerun all the requirements files to update your local `venv` with the correct versions. In Terminal in the root directory run the following to pull the latest from `main`, switch to `DMT-236/dbt-athena-upgrade-main` and install requirements:

```
git switch main
git fetch
git pull
git switch DMT-236/dbt-athena-upgrade-main
pip install --upgrade pip
pip install -r requirements.txt
pip install -r requirements-lint.txt
```

After running `git switch DMT-236/dbt-athena-upgrade-main` you should get the following output, which informs you that a new local copy has been created which is tracking the remote copy. 

```
branch 'DMT-236/dbt-athena-upgrade-main' set up to track 'origin/DMT-236/dbt-athena-upgrade-main'.
Switched to a new branch 'DMT-236/dbt-athena-upgrade-main'
```

[Full evironment set up guidance here.](/tools/create-a-derived-table/instructions/#setting-up-a-python-virtual-environment)


## Test `prod` models

To test your `prod` models you need to create your own branch off the `DMT-236/dbt-athena-upgrade-main` branch, deploy your models in `dev` and run your `dbt` tests. You can also run equality tests in Athena to compare tables from `prod` created using the old `dbt-athena` adapter to the tables you have just created in `dev` using `dbt-athena-community` adapter. 

To explicitly create a new branch off `DMT-236/dbt-athena-upgrade-main` run the following:

```
git checkout -b <new-branch-name> DMT-236/dbt-athena-upgrade-main
```

Now cd into the `mojap_derived_tables` directory to run `dbt` commands as usual. 

All your `prod` models will have had the `external_location` parameter inserted into a config block at the top of each `.sql` file and will look similar to this:

```
{{ config(
  external_location=generate_s3_location()
) }}
```
The `external_location` parameter is set by the macro `generate_s3_location()` which is invoked at run time. This combines information from the schema name with the names from the repo directory structure to create the desired S3 location in the form:

```
s3://<bucket_name>/<env_name>/<table_type>/domain_name=<domain_name>/database_name=db_name/table_name=<tb_name>
```

Once we are happy that `prod` models are deploying as expected using the upgrades we will merge the branch `DMT-236/dbt-athena-upgrade-main` in to `main`.


## Test `dev` models

Once you have completed testing of your `prod` models you may wish to continue testing with your `dev` models. To do this you will need to create another branch off `DMT-236/dbt-athena-upgrade-main` (see instructions above) and then merge into this from your feature branch. For example, I have some `dev` models on a branch called `my-feature-branch` so:

```
git checkout -b new-test-branch DMT-236/dbt-athena-upgrade-main
git fetch origin my-feature-branch
git pull origin my-feature-branch
git merge origin/my-feature-branch
```

This creates a new branch `new-test-branch` off `DMT-236/dbt-athena-upgrade-main` branch and then collects the changes from `my-feature-branch` and merges these in to `new-test-branch`. After the first command check you are on the `new-test-branch` before proceeding.

⚠️ WARNING ⚠️

Your `dev` models will not have the `external_location` parameter set, which is required to store the output model in the correct location. See instructions in the next section.

## Insert `external_location`

To make this as painless as possible we have prepared a script `insert_external_location_config.py` which you can run locally to automatically insert the required line or full config into your `.sql` files. The script must be run from the root directory and requires user input to determine the path to the files that you wish to run it on.

In Terminal, in the root directory run

```
python scripts/insert_external_location_config.py
```

You will be prompted to enter the path to the directory containing the files you wish to apply the script to. Type your input starting with the domain directory name and continuing to whichever subdirectory you require and hit `Enter`:

```
Enter path to directory, starting with domain directory: <domain_name>/<database_name>
```

If you are copy/pasting be careful not to introduce leading or trailing spaces. 

The next prompt shows the full file path you have selected and asks you to confirm by typing "Y":

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

## Updating your branch with `DMT-236/dbt-athena-upgrade-main`

While we are testing we may make changes to the `DMT-236/dbt-athena-upgrade-main` branch which you will need to merge into your branches. Whilst on the branch you want to update with the latest from `DMT-236/dbt-athena-upgrade-main` run:

```
git fetch origin DMT-236/dbt-athena-upgrade-main
git pull origin DMT-236/dbt-athena-upgrade-main
git merge origin/DMT-236/dbt-athena-upgrade-main
```


At this point you may have merge conflicts that need to be resolved; please see [GitHub resolve merge conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github). If required, ask for help on the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) slack channel.




## What changed for seeds?

Seeds are lookup tables easily created from a `.csv` file. Put the `.csv` in the [`./mojap_derived_tables/seeds/`](./mojap_derived_tables/seeds/) directory and follow the same directory structure requirements and naming conventions as for models. As with marts models, your seeds should have property files that have the same filename as the seed. Seeds can be accessed by anyone with standard database access and so must not contain sensitive data. Generally, seeds shouldn't contain more than 1000 rows, they don't contain complex data types, and they don't change very often. You can deploy a seed with more than 1000 rows, but it's not reccomended and it will take quite a long time to build.

⚠️ Seeds must not contain sensitive data. ⚠️

Note- with dbt-athena community adapter seeds get created in mojap-derived-tables/seeds/domain_<env_dbt>/table_name/ s3 location instead of Dev/Prod split s3 path. So there is no Dev or prod folder based segregaion anymore for seeds.

There is no change for Data modelling team as this change is only related to how new adapter writes seeds in s3 location.
<br />

## Helpful commands

As previously mentioned, the `mojap_derived_tables` dbt project is a shared space and so when deploying your models and other resources you'll want to make use of the [_node selection syntax_](https://docs.getdbt.com/reference/node-selection/syntax) so you don't end up running everyone else's. Don't worry if you do, it will just take a long time to run and then the deployed resources will eventually be deleted. You should cancel the execution with `ctrl+c` or `ctrl+z` and save yourself some time.

To select a single model or seed, add the following to your dbt command:

```
--select database_name__model_name
```

or a number of models by running:

```
--select database_name__model_1_name database_name__model_2_name
```

To select a full directory of models, add the following to your dbt command:

```
--select models/.../path/to/my/models/
```

As you develop and run your models you'll generate a lot of logs and run artefacts. This can become unwieldy and messy so it's helpful to clear them out from time to time. To remove run artefacts from previous invocations of dbt, run:

```
dbt clean
```

To check your SQL and YAML is syntactically correct, run:

```
dbt compile --select models/.../path/to/my/models/
```

To deploy your models, run:

```
dbt run --select models/.../path/to/my/models/
```

To deploy your seeds, run:

```
dbt seed --select seeds/.../path/to/my/seeds/
```

Don't forget that if your models depend on your seeds, you'll need to deploy your seeds before your models.

To run tests on models with tests defined, run:

```
dbt test --select models/.../path/to/my/models/
```

## Resources

- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

<br />

## License

Unless stated otherwise, the codebase is released under the [MIT License](https://github.com/ministryofjustice/analytical-platform-data-engineering/blob/develop/LICENSE.md). This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/) and available under the terms of the [Open Government 3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.