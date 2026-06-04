# Testing

## Table of Contents

- [Introduction](#Introduction)
    - [Purpose of testing](#Purpose-of-testing)
    - [Types of testing](#Types-of-testing)
    - [How to use this guide](#How-to-use-this-guide)
- [Testing in Create a Derived Table](#Testing-in-Create-a-Derived-Table)
    - [Nullability](#Nullability)
    - [Uniqueness](#Uniqueness)
    - [Data type](#Data-type)
    - [Data format](#Data-format)
    - [Accepted values](#Accepted-values)
    - [Combinations of values](#Combinations-of-values)
    - [Free text](#Free-text)
    - [Completeness](#Completeness)
    - [Row count (single table)](#Row-count)
    - [Data freshness](#Data-freshness)
    - [Relationships](#Relationships)
    - [Custom dbt tests](#Custom-dbt-tests)
    - [Row counts (across tables)](#Row-counts)
    - [Unit tests](#Unit-tests)
    - [dbt audit_helper](#dbt-audit_helper)
    - [Performance testing](#Performance-testing)
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

### Purpose of testing

Testing is a fundamental part of Analytics Engineering.  It provides confidence that data models, transformations, and metrics are accurate, reliable, and fit for purpose.  By validating business logic, data quality, and relationships between datasets, testing helps detect errors early, prevents regressions when code changes are made, and ensures consistency across environments and downstream reporting.  Effective testing reduces the risk of incorrect insights driving decisions, improves trust in data products, and enables teams to develop and deploy changes more quickly and safely.

### Types of testing

Most testing is functional, i.e. it aims to test whether the code is meeting requirements, and transforming the data as expected.  Functional testing focuses on inputs and outputs, and expected behaviour.  Functional testing includes things such as testing that a primary key column does not contain nulls, or testing that a percentage value is always between 0 and 100.

Some testing is non-functional, i.e. it aims to test whether the code is working well.  Non-functional testing includes things such as testing that **dbt** model builds complete within a certain time period, or that unauthorised users cannot access sensitive data.  Much of the non-functional testing within **Create a Derived Table** is handled by Data Engineers, but performance testing is something that Analytics Engineers should be aware of.  (Long-running models may need changes to their SQL to reduce the build time, and large volumes of data may need to use chunking.)

### How to use this guide

All domains and projects are different, so this guidance is **not intended to be definitive or prescriptive**.  It is intended to improve awareness of the types of testing available, and to act as a starting point when deciding which testing is appropriate in a specific instance.

The guidance is split into three main sections:

- [Types of testing](#Types-of-testing) - Provides information on the types of testing available (e.g. checking nullability and uniqueness).  It may be useful to developers wishing to gain an understanding of the types of testing that are available, and those wanting to learn how to implement a specific type of test.
- [Testing strategies](#Testing-strategies) - Provides information on which types of testing are appropriate in different scenarioes (e.g. testing a macro versus a model, or testing a staging model versus an intermediate model).  It may be useful to developers who have identified their testing use case, and would like to understand which types of testing might be appropriate.
- [Testing resources and standards](#Testing-resources-and-standards) - Contains links to **dbt** testing resources, and wider information on testing techniques and standards.

## Testing in Create a Derived Table

The table below provides a summary of the different types of testing that are avilable.  They are split according to their scope:

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

**Setup:**  

- The test is specified in the model details in the `schema.yml` file.
- By default, the severity is set to `error`.  (If the test fails, any downstream model builds will be skipped.)
- The severity can be set to `warn` by optionally adding `config` with `severity: warn`.  (If the test fails, the downstream models will be built.)

```
models:
  - name: my_model
    columns:
      - name: my_column
        data_tests:
          - not_null
              config:
                severity: warn
```

**Executing:** Running a `dbt build` or `dbt test` command for the corresponding model.  **dbt** creates an SQL query to execute the test, after the model is materialised.

**On failure:** 

- If the test severity is set to `error`, the model will be materialised, but a failing test will cause an error and downstream models will be skipped.
- If the test severity is set to `warn`, the model will be materialised and any downstream build can continue.

**Example usage:** In the example shown below, column `case_id` in the `cases` model must not contain any nulls.  The severity is set to `error` (this is the default value, and does not need to be specified using `config`.)  If any nulls are present, the model will be materialised, but the build will error.

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

**Setup:**  

- The test is specified in the model details in the `schema.yml` file.
- By default, the severity is set to `error`.  (If the test fails, any downstream model builds will be skipped.)
- The severity can be set to `warn` by optionally adding `config` with `severity: warn`.  (If the test fails, the downstream models will be built.)

```
models:
  - name: my_model
    columns:
      - name: my_column
        data_tests:
          - unique
              config:
                severity: warn
```

**Executing:** Running a `dbt build` or `dbt test` command for the corresponding model.  **dbt** creates an SQL query to execute the test, after the model is materialised.

**On failure:** 

- If the test severity is set to `error`, the model will be materialised, but a failing test will cause an error and downstream models will be skipped.
- If the test severity is set to `warn`, the model will be materialised and any downstream build can continue.

**Example usage:** In the example shown below, column `case_id` in the `cases` model must not contain any duplicates.  Adding `config` with `severity: warn` sets the severity to `warn`.  (This overrides the default severity of `error`.)  If any duplicates are present, the model will be materialised, the build will not error, and any downstream models will be built.

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

It is not always possible, or desirable, to execute every possible type of test in all circumstances.  The suitability of different types of testing depends on a number of factors, including:

- The layer that a model belongs to.  Different testing might be appropriate in staging compared to intermediate.
- The scope of the testing.  A single new model might require different testing to a new macro, or an entire new project.
- Whether new code is being created, or existing code modified.
- The volume of the data to be processed.

### Testing types by layer

The different **dbt** layers have different purposes, and carry out different types of data transformation.  This means that different types of testing are more appropriate to some layers than others.  The following table aims to summarise whether the different types of testing are suitable for use in the different layers.

**Note: This is not definitive or prescriptive, and should be used only as a starting point for planning testing.  So testing labelled as "recommended" is not compulsory, but it is strongly suggested that this type of testing is considered.  And testing labelled as "less recommended" should not be excluded from consideration, but is potentially less appropriate than other types of testing.**

| Scope of testing | Type of test | Staging | Intermediate | Datamart | Notes |
|:-----------------|:-------------|:-------:|:------------:|:--------:|:------|
| Single model | [Nullability](#Nullability) | 🟢<br>recommended | 🟢<br>recommended | 🟢<br>recommended | Missing values will cause problems, so nullability should be checked whenever a column is mandatory.  **Note:** A column can legitimately be nullable in one layer and not nullable in another layer. |
|              | [Uniqueness](#Uniqueness) | 🟢<br>recommended | 🟢<br>recommended | 🟢<br>recommended | Invalid duplicate rows will cause problems, so this should be checked in multiple places: staging (in line with the grain of the curated data); intermediate (where the grain might change); datamarts (where uniqueness of primary keys is vital for the dimensional model). |
|              | [Data type](#Data-type) | 🟢<br>recommended | 🟡<br>consider | 🟡<br>consider | If columns are cast to the required data type in the staging layer, this should be tested in that layer.  Data types should be tested downstream as required, e.g. if a date is extracted from a timestamp.  |
|              | [Data format](#Data-format) | 🟢<br>recommended | 🟡<br>consider | 🟡<br>consider | If data formats are standardised in the staging layer, this should be tested in that layer.  Formats should be tested downstream as required, e.g. if a new column as added in intermediate layer. |
|              | [Accepted values](#Accepted-values) | 🟢<br>recommended | 🟡<br>consider | 🟡<br>consider |  |
|              | [Combinations of values](#Combinations-of-values) | 🔴<br>less recommended | 🟡<br>consider | 🟡<br>consider |  |
|              | [Completeness](#Completeness) | 🟢<br>recommended | 🟡<br>consider | 🟢<br>recommended |  |
|              | [Free text](#Free-text) |  | | | |
|              | [Row count](#Row-count) | 🟢<br>recommended | 🟢<br>recommended |  🟢<br>recommended | |
|              | [Data freshness](#Data-freshness) |  🟢<br>recommended | 🔴<br>less recommended | 🟢<br>recommended | |
| Multiple models | [Relationships](#Relationships) | 🟡<br>consider | 🔴<br>less recommended | 🟢<br>recommended | |
|                 | [Custom dbt tests](#Custom-dbt-tests) | 🔴<br>less recommended | 🟡<br>consider | 🟡<br>consider | |
|                 | [Row counts](#Row-counts) | 🟢<br>recommended | 🟢<br>recommended | 🟢<br>recommended | |
| Macros       | [Unit tests](#Unit-tests) | tbc | | | | |
| Data reconciliation | [dbt audit_helper](#dbt-audit_helper) | 🟡<br>consider | 🟡<br>consider | 🟡<br>consider | |
| Non-functional testing | [Performance testing](#Performance-testing) | 🟡<br>consider | 🟡<br>consider | 🟡<br>consider | Should be considered for any model that will have to be modified (e.g. through SQL tuning or chunking) due to a long build time or timing out. |

### Use cases

To help developers decide which types of testing to use in different scenarios, a number of different use cases are outlined below.  These are not prescriptive lists of testing that must be carried out - there will always be differences between domains and projects that make this difficult - but rather a list of options that should be considered for inclusion.

### Creating a staging model

### Creating an intermediate model

### Creating a datamarts model

### Creating a macro

### Adding a column to an existing dimensional model

**Scenario:** A new column needs to be added to an existing dimensional model.  The column is present in the curated data, so the **dbt** models in the staging, intermediate and datamarts layers all need to be updated to include this additional column.  All other columns should remain unchanged.

**Testing to consider:**  

## Testing resources and standards

### dbt documentation

**dbt labs** provide reference material on testing:

- [Testing overview](https://docs.getdbt.com/docs/build/data-tests?version=2.0&name=Fusion)
- [The **data_tests** property](https://docs.getdbt.com/reference/resource-properties/data-tests?version=2.0&name=Fusion), which is used for the 4 built-in data tests (unique, not null, relationships and accepted values).
- [Custom generic tests][custom tests](https://docs.getdbt.com/best-practices/writing-custom-generic-tests?version=2.0&name=Fusion) (defined using SQL).
- [The **dbt_utils** package](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/).
- [Freshness](https://docs.getdbt.com/reference/resource-properties/freshness?version=2.0&name=Fusion)

### Other resources

[dbt Tests Hub](https://www.elementary-data.com/dbt-test-hub) - a website aimed at helping **dbt** developers identify suitable testing tools.

## Out of scope

Some types of testing are outside the scope of this document.  These are listed below, along with the reason for their exclusion.

- **dbt constraints** - These are not compatible with Athena.
