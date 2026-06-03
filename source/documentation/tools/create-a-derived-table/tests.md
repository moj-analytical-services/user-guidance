# Testing

## Introduction

## Types of testing

<table>
  <tr>
    <th align="left">Scope of testing</th>
    <th align="left">Type of test</th>
    <th align="left">Example usage</th>
  </tr>
  <tr>
    <td rowspan="8">Single model</td>
    <td><a href="#Nullability">Nullability</a></td>
    <td><strong>Primary key</strong> column is not nullable.</td>
  </tr>
  <tr>
    <td><a href="#Uniqueness">Uniqueness</a></td>
    <td><strong>Primary key</strong> column should contain only unique values.</td>
  </tr>
  <tr>
    <td><a href="#Data-type">Data type</a></td>
    <td>Dates should have a data type of <strong>date</strong>, not a <strong>varchar</strong>.</td>
  </tr>
  <tr>
    <td><a href="#Data-format">Data format</a></td>
    <td>Dates should be formatted <strong>ccyy-mm-dd</strong>.</td>
  </tr>
  <tr>
    <td><a href="#Accepted-values">Accepted values</a></td>
    <td>Years should be in the range 2016-2026.</td>
  </tr>
  <tr>
    <td><a href="#Combinations-of-values">Combinations of values</a></td>
    <td>When <strong>col_a</strong> is null, <strong>col_b</strong> must not be null.</td>
  </tr>
  <tr>
    <td><a href="#Completeness">Completeness</a></td>
    <td>Maximum 1% of rows are null.</td>
  </tr>
  <tr>
    <td><a href="#Free-text">Free text</a></td>
    <td>Identify free text columns, which might accidentally expose personally identifiable information.</td>
  </tr>
  <tr>
    <td rowspan="2">Multiple models</td>
    <td><a href="#Testing-relationships">Relationships</a></td>
    <td><strong>Foreign key</strong> column to <strong>table_a</strong> should be present at least once in the <strong>primary key</strong> column in <strong>table_b</strong>.</td>
  </tr>
  <tr>
    <td><a href="#Custom-dbt-tests">Custom dbt tests</a></td>
    <td>When <strong>column_1</strong> in <strong>model_a</strong> = "ABC", <strong>column_3</strong> in <strong>model_b</strong> must be >= 1.</td>
  </tr>
</table>

## Testing a single model

### Nullability

### Uniqueness

### Data type

### Data format

### Accepted values

List

Range

### Completeness

% or absolute

### Free text

Avoid revealing PII

### Combinations of values

## Testing multiple models

### Relationships

### Custom dbt tests







# Original content --------------------------------------------------------------------

# Tests

Tests are assertions you make about your models and other resources (e.g. sources, seeds and snapshots). You can do things like test whether a column contains nulls or only unique values, compare row counts between tables, or check all of the records in a child table have a corresponding record in a parent table. dbt ships with some [tests](https://docs.getdbt.com/reference/resource-properties/tests) you can use but there many more out there in packages like [dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/), so do checkout dbt's package hub for what's available.

For more information on tests, see [dbt's tests documentation](https://docs.getdbt.com/docs/building-a-dbt-project/tests).

## Available tests

There is an ecosystem of packages containing helpful macros and tests you can use, see [dbt package hub](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/). If you need a package adding to the dbt project, update the [`packages.yml`](./mojap_derived_tables/packages.yml) file then rerun `dbt deps`.

## Custom generic tests

A test is really just a SQL query that returns rows that meet a certain criteria. If the number of returned rows is not zero, then the test fails. When you know that, you'll soon realise that it's not too difficult to write your own tests. Tests you write yourself are called custom generic tests and are writen in special macros; read the [dbt guidance on how to write custom generic tests](https://docs.getdbt.com/guides/legacy/writing-custom-generic-tests) to find out more. There are some requirements specific to Create a Derived Table that you must follow when writing custom generic tests. They must live subdirectory named after the team, project, or database they relate to in the [`./mojap_derived_tables/tests/generic/`](./mojap_derived_tables/tests/generic/) directory and should follow a naming convention where the subdirectory and test name are separated by double underscores, for example `team_name__test_name`. This is so that ownership of the test is clear and so that the filename is unique.

```
├── mojap_derived_tables
  ├── dbt_project.yml
  └── tests
      └── generic
          ├── prison_safety_and_security  # team name
              ├── prison_safety_and_security__test_name.sql
              ...
          ├── other_project_name  # project name
              ├── other_project_name__test_name.sql
              ...
          ├── other_database_name  # database name
              ├── other_database_name__test_name.sql
              ...
          ...
```

## Singular tests

Singular tests should not be used and they will not be run in the production environment.

## Configuring tests

Defining tests for your resources is done within the property file for that resource under the `tests` property. See the example below.

```
version: 2

models:
  - name: <model_a>
    tests:
      - dbt_utils.equal_rowcount:
          compare_model: <model_b>
    columns:
      - name: <column_a>
        tests:
          - not_null
          - dbt_utils.not_constant
```
