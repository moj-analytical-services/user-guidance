# Testing

## Table of Contents

- [Introduction](#Introduction)
- [Types of testing](#Types-of-testing)
- [Testing strategies](#Testing-strategies)
- [Testing resources and standards](#Testing-resources-and-standards)
- [Out of scope](#Out-of-scope)

**Look at adding:**

- Error reporting / dashboard; thresholds
- Tracking errors over time
- Custom tests using data dictionaries (ask Quin)
- Model contracts - schema consistency
- Investigate [this](https://github.com/dbt-labs/dbt-utils#generic-tests)
- Investigate [this](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/people/grievance_conduct_and_performance_diagnostic/entity_diagnostics)
- Investigate [this](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/people/grievance_conduct_and_performance_diagnostic/entity_diagnostics) and [this](https://github.com/moj-analytical-services/create-a-derived-table/blob/main/corporate_property_cafm_data_migration_tables/macros/generic/property/tests/cafm_data_dictionary_mappings.sql)
- Investigate [this](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/staging/stg_corporate_epm/source_integration)
- [dbt contracts](https://docs.getdbt.com/reference/resource-configs/contract?version=1.10)
- Example of unit testing before dbt unit testing was a thing: [here](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/tests/transform_table/unit/models/join_scd2)
- Diagnostic database used in people: [here](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/people/people_diagnostics)
- (Neil) dbt_utils.unpivot to quickly calculate % missingness in dimension attributes: [here](https://github.com/moj-analytical-services/create-a-derived-table/commit/768516e66509c66d540895714a56173c080a930f)
- Unit test for SCD2 macro: [here](https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models/people/people_diagnostics/macro_unit_testing)
- store test results used for seperate project "https://github.com/moj-analytical-services/create-a-derived-table/blob/main/hmpps_electronic_monitoring_data_tables/macros/utils/store_all_test_results.sql" which requires "store_test_results = "a_table_name_here" in model definition
- exclude unit tests from running during every build command - https://github.com/moj-analytical-services/create-a-derived-table/blob/main/.github/workflows/data-hub-template-workflow.yml#L245C11-L246C46
- ... then we have a standalone unit test step which only runs in dev - https://github.com/moj-analytical-services/create-a-derived-table/blob/main/.github/workflows/data-hub-template-workflow.yml#L211-L215
- Accepted values check to check source when column is pipe delemited/multiple values - https://github.com/moj-analytical-services/create-a-derived-table/blob/main/mojap_derived_tables/tests/generic/corporate/accepted_pipe_delimited_values.sql 


## Introduction

Testing is a fundamental part of Analytics Engineering.  It provides confidence that data models, transformations, and metrics are accurate, reliable, and fit for purpose.  By validating business logic, data quality, and relationships between datasets, testing helps detect errors early, prevents regressions when code changes are made, and ensures consistency across environments and downstream reporting.  Effective testing reduces the risk of incorrect insights driving decisions, improves trust in data products, and enables teams to develop and deploy changes more quickly and safely.

Most testing is functional, i.e. it aims to test whether the code is meeting requirements, and transforming the data as expected.  Functional testing focuses on inputs and outputs, and expected behaviour.  Functional testing includes things such as testing that a primary key column does not contain nulls, or testing that a percentage value is always between 0 and 100.

Some testing is non-functional, i.e. it aims to test whether the code is working well.  Non-functional testing includes things such as testing that dbt model builds complete within a certain time period, or that unauthorised users cannot access sensitive data.  Much of the non-functional testing within **Create a Derived Table** is handled by Data Engineers, but performance testing is something that Analytics Engineers should be aware of.  (Long-running models may need changes to their SQL to reduce the build time, and large volumes of data may need to use chunking.)

The testing materials in this page are split into three main sections:

- [Types of testing](#Types-of-testing) - This section provides information on the types of testing tools or strategies available (e.g. checking nullability and uniqueness).  It may be useful to developers wishing to gain an understanding of the types of testing that are available, or to understand how to use a specific type of test.
- [Testing strategies](#Testing-strategies) - This section aims to provide information on which types of testing are appropriate in different scenarioes (e.g. testing a macro versus a model).  It may be useful to developers who have identified their testing use case, and would like to understand which types of testing are appropriate.
- A guide to some of the types of testing that are applicable in certain scenarios, such as adding a single model to a datamarts layer, or creating a new macro.
- [Testing resources and standards](#Testing-resources-and-standards) - links to **dbt** testing resources, and wider information on testing techniques and standards.

## Types of testing

The table below provides a summary of the different types of testing that can be considered.  They are split according to their scope:

- **Single model** - Testing the data within a single **dbt** model.
- **Multiple models** - Testing data across multiple **dbt** models, including relationships.
- **Macros** - Specific techniques for testing **dbt** macros.
- **Data reconciliation** - Testing for differences in data across models.
- **Non-functional testing** - Testing non-functional aspects of **dbt** models, especially performance.

| Scope of testing | Type of test | Example usage |
|:-----------------|:-------------|:--------------|
| Single model | [Nullability](#Nullability) | **Primary key** column is not nullable. |
|              | [Uniqueness](#Uniqueness) | **Primary key** column should contain only unique values. |
|              | [Data type](#Data-type) | A year should have a data type of `integer`, not `varchar`. |
|              | [Data format](#Data-format) | Dates should be formatted `ccyy-mm-dd`. |
|              | [Accepted values](#Accepted-values) | Years should be in the range 2016-2026. |
|              | [Combinations of values](#Combinations-of-values) | When `col_a` is null, `col_b` must be not null. |
|              | [Completeness](#Completeness) | Maximum 1% of rows in a column are null. |
|              | [Free text](#Free-text) | Identify free text columns, which might accidentally expose personally identifiable information. |
|              | [Row count](#Row-count) | Row count should not be zero. |
|              | [Data freshness](#Data-freshness) | Data should have been updated within the last 7 days. |
| Multiple models | [Relationships](#Relationships) | **Foreign key** in `model_a` should be present at least once in **primary_key** in `model_b`. |
|                 | [Custom dbt tests](#Custom-dbt-tests) | When `model_a.column_1` = "ABC", `model_b.column_3` must be > 0. |
|                 | [Row counts](#Row-counts) | Row counts of two models should match. |
| Macros       | [Unit tests](#Unit-tests) | tbc |
| Data reconciliation | [dbt audit_helper](#dbt-audit_helper) | Regression testing, to check that the data in development is the same as the production data. |
| Non-functional testing | [Performance testing](#Performance-testing) | Where data volumes may prevent timely delivery of data, compare before and after build times to assess the impact of performance tuning the SQL or using data chunking. |

### Nullability

**Test:** A column does not contain nulls.

**Tools:** Generic **dbt** data test.

**Database support:** Supported by all databases that **dbt** supports.

**Athena compatible:** Yes

**Executed by:** Running a `dbt build` or `dbt test` command.  Executed by **dbt** as an SQL query after the model is materialised.

**On failure:** If the test severity is set to `error`, the model will be materialised, but a failing test will cause an error and downstream models will be skipped.  If the test severity is set to `warn`, the model will be materialised and any downstream build can continue.  **Note:** `error` is the default, and does not need to be specified.

**Setup:**  The test is specified in the model details in the `schema.yml` file.  

**Example usage:** In the example shown below, column `case_id` in the `cases` model must not contain any nulls.  If any nulls are present, the model will be materialised, but the build will error.

```
models:
  - name: cases
    columns:
      - name: case_id
        data_tests:
          - not_null
```

### Uniqueness

**Test:** A column does not contain duplicate values.  (Nulls are ignored.)

**Tools:** Generic **dbt** data test.

**Database support:** Supported by all databases that **dbt** supports.

**Athena compatible:** Yes

**Executed by:** Running a `dbt build` or `dbt test` command.  Executed by **dbt** as an SQL query after the model is materialised.

**On failure:** If the test severity is set to `error`, the model will be materialised, but a failing test will cause an error and downstream models will be skipped.  If the test severity is set to `warn`, the model will be materialised and any downstream build can continue.  **Note:** `error` is the default, and does not need to be specified.

**Setup:**  The test is specified in the model details in the `schema.yml` file.  

**Example usage:** In the example shown below, column `case_id` in the `cases` model must not contain any duplicates.  If any duplicates are present, the model will be materialised, the build will not error, and any downstream models will be built.

```
models:
  - name: cases
    columns:
      - name: case_id
        data_tests:
          - unique
              config:
                severity: warn
```

### Data type

### Data format

### Accepted values

Range 
List
Dictionary

### Combinations of values

### Completeness

### Free text

### Row count

### Data freshness

### Relationships

### Custom dbt tests

### Row counts

### dbt audit_helper

### Performance testing

## Testing strategies

### Different testing approaches

The type of testing performed depends on a number of factors, including:

- The layer that a model belongs to.  Different testing might be appropriate in staging compared to intermediate.
- The cope of the testing.  A single new model might require different testing to a new macro, or an entire new project.
- Whether new code is being created, or existing code modified.
- The volume of the data to be processed.

To help developers decide which types of testing to use in different scenarios, a number of different use cases are outlined below.  These are not prescriptive lists of testing that must be carried out - there will always be differences between domains and projects that make this difficult - but rather a list of options that should be considered for inclusion.

### Use cases

Staging	- Clean and standardise source data	- not_null, unique, accepted_values, source freshness, basic relationships
Intermediate - Apply joins, filters, calculations, deduplication, business rules - Custom singular tests, row-count checks, reconciliation checks, relationship tests, logic/unit tests
Datamart / marts - Produce final business-facing facts, dimensions, reports, metrics - Primary key tests, metric validation, referential integrity, accepted values, regression/parity tests

### Creating a staging model

### Creating an intermediate model

### Creating a datamarts model

### Creating a macro

### Adding a column to an existing model

**Scenario:** A new column needs to be added to an existing model.  No other changes should be made to the model.  The values in all other columns should remain unchanged.

**Testing to consider:**  
Nullability - Consider whether the new column should be nullable.
Uniqueness - Consider whether the new column should only contain unique values.
Data type and data format - If the model is in the staging layer, consider testing the data type and format.
Accepted values - If the model is in the staging layer, it is often appropriate to test for unexpected values.  This is especially if any data cleansing takes place in this layer.  For example, the expected values are 'Y' and 'N'.  Values of 'y', 'yes' and 'Yes' are changed to 'Y', and values of 'n', 'no' and 'No' are changed to 'N' in this layer, so testing for the expected values would be appropriate.
Combinations of values
Completeness
Free text
Row count
Data freshness
Relationships
Custom dbt tests
Row counts
Unit tests
dbt audit_helper


## Testing resources and standards

### dbt documentation

**dbt labs** provide reference material on testing:

- [Testing overview](https://docs.getdbt.com/docs/build/data-tests?version=2.0&name=Fusion)
- [The **data_tests** property](https://docs.getdbt.com/reference/resource-properties/data-tests?version=2.0&name=Fusion), which is used for the 4 built-in data tests (unique, not null, relationships and accepted values).
- [Custom data tests][custom tests](https://docs.getdbt.com/best-practices/writing-custom-generic-tests?version=2.0&name=Fusion) (defined using SQL).
- [The **dbt_utils** package](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/).
- [Freshness](https://docs.getdbt.com/reference/resource-properties/freshness?version=2.0&name=Fusion)

### Other resources

[dbt Tests Hub](https://www.elementary-data.com/dbt-test-hub) - a website aimed at helping **dbt** developers identify suitable testing tools.

## Out of scope

Some types of testing are outside the scope of this document.  These are listed below, along with the reason for their exclusion.

- **dbt constraints** - These are not compatible with Athena.

<br>
<br>

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
