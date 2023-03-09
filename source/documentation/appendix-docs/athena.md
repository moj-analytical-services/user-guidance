# Athena workgroup upgrade

## Background

On 28th April Athena workgroups will be upgraded to [Athena engine version 3](https://docs.aws.amazon.com/athena/latest/ug/engine-versions-reference-0003.html) due to a requirement from Amazon Web Services (AWS). The default workgroup that all Analytical Platform (AP) users currently use is set to version 2. Version 3 comes with a number of improvements but also some [breaking changes](https://docs.aws.amazon.com/athena/latest/ug/engine-versions-reference-0003.html#engine-versions-reference-0003-breaking-changes) that could impact analytical projects that run SQL queries using Athena.

## How do I prepare for the new version?

We have created a new testing workgroup (`test-athena-v3`) that uses Athena engine version 3 which is available to all AP users that have [standard database access](https://github.com/moj-analytical-services/data-engineering-database-access#data-engineering-database-access). You can and should use this new workgroup to test any impact upgrading to the new version may have on your existing work. You can find guidance below on how to use this new workgroup in your projects.

## How do I use the testing workgroup?

### AWS Console

In the AP control panel navigate to the bottom and click on the AWS resources link:

![](images/athena-workgroup-upgrade/aws-services-link.png)

In the AWS console search for Athena and click on the result. In the query editor, find the workgroup dropdown in the top right corner of the page and select `test-athena-v3`.

![](images/athena-workgroup-upgrade/athena-query-editor.png)

Queries you run in the query editor will now use the upgraded engine.

### Python

For python based projects that make use of `pydbtools` or `awswrangler` to query Athena you can set an environment variable to switch which workgroup your queries use by default. To implement this environment variable you would run the following in your terminal:

```
export WR_WORKGROUP=test-athena-v3
```

You can also set this environment variable in your python script but you must do so before you import `pydbtools` and / or `awswrangler` e.g.

```python
import os

os.environ["WR_WORKGROUP"] = "test-athena-v3"

import awswrangler
import pydbtools as pydb
```

If for any reason you need to set the workgroup once either of these modules have been imported then you can either:

* set the workgroup using the `awswrangler` config

```python
import awswrangler as wr

wr.config.workgroup = "test-athena-v3"
```

* explicitly set the workgroup in the function call

```python
import pydbtools as pydb

df = pydb.read_sql_query(
    "SELECT * FROM database.table",
    workgroup="test-athena-v3",
)
```

### R

If you are using `dbtools` to query Athena then you must set an environment variable to use the new workgroup. This environment variable must be set before the `dbtools` library is first called. One way of making sure this happens is by setting the environment variable in your `.Rprofile` file in your directory as follows:

```r
Sys.setenv(WR_WORKGROUP="test-athena-v3")
```

If you are using `Rdbtools` then the environment variable you need to set is slightly different:

```r
Sys.setenv(AWS_ATHENA_WORK_GROUP="test-athena-v3")
```

### Airflow

If your code is running as part of an airflow pipeline then you can set the appropriate environment variable (see R / Python sections above) in the KubernetesPodOperator for your task:

```python
tasks["my-task"] = KubernetesPodOperator(
    ...,
    env_vars={
        ...,
        "WR_WORKGROUP": "test-athena-v3",  # for python
        "AWS_ATHENA_WORK_GROUP": "test-athena-v3",  # for R
        ...,
        },
)
```

## How can I check if my queries are running on the correct version?

One way of checking that you are using the updated workgroup is to run this simple SQL statement:

```sql
SELECT contains_sequence(ARRAY [1,2,3,4,5,6], ARRAY[1,2]) AS test;
```

`contains_sequence` is new and the query will fail on version 2 but will return a result when using version 3.

## What if I’m using create-a-derived-table for my work?

Please check the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) slack channel for announcements related to work on upgrading to version 3. Further comms will be sent out at a later date.

## What should I do if I get stuck?

Please post a question on the [#ask-data-engineering](https://mojdt.slack.com/archives/C8X3PP1TN) slack channel and hopefully someone can help you with your questions.

## Where can I find out more about Athena engine version 3?

Please have a look at the official AWS documentation which can be found [here](https://docs.aws.amazon.com/athena/latest/ug/engine-versions-reference-0003.html).
