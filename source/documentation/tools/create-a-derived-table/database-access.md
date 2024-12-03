# Database Access

To access databases via the AP, you must have an AP account. [There is a quickstart guide in the docs.](https://user-guidance.analytical-platform.service.justice.gov.uk/get-started.html#quickstart-guide)

To get access to AP data, users must use the [data-engineering-database-access](https://github.com/moj-analytical-services/data-engineering-database-access) service. [Database resources](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/database_access) define access for databases, and these are assigned to users via [project files](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/project_access).

Some standard assets, like lookups, are accessible to all users. [There is a list of standard assets.](https://github.com/moj-analytical-services/data-engineering-database-access/blob/f4f433c5363a8a2d591c53913ee3bbdfe70b6f99/project_access/standard-database-access.yaml)
For example, to gain access to [nomis addresses](https://github.com/moj-analytical-services/data-engineering-database-access/tree/f4f433c5363a8a2d591c53913ee3bbdfe70b6f99/database_access/nomis/addresses), a user should be assigned it [via a project](https://github.com/moj-analytical-services/data-engineering-database-access/blob/f4f433c5363a8a2d591c53913ee3bbdfe70b6f99/project_access/nomis_dbt.yaml#L18)

## Standard database access

The first thing you'll need to work with Create a Derived Table is an [Analytical Platform account](https://user-guidance.analytical-platform.service.justice.gov.uk/get-started.html#2-analytical-platform-account) with standard database access. If you don't have that already, follow the [guidance on how to make changes to the standard database access project file](https://github.com/moj-analytical-services/data-engineering-database-access#standard-database-access) in the Data Engineering Database Access repo.

## Your Data Engineering Database Access project access file

As well as standard datbase access, you'll need a project access file that's specific to your (or your team's) work. This will give you access to the source databases used to derive tables as well as the derived tables themselves. Access to derived tables is granted at the domain level, this means you will need to know which domain you will be creating derived tables in before you start working. Your project file should include the source databases and domain(s) that you'll use to derive your tables from, and the domain(s) that your tables will go in. A list of already available domains can be found in the [database access resources for Create a Derived Table](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/database_access/create_a_derived_table). If you don't know already, you can learn how to set up a project access file by following the guidance on [access to curated databases](https://github.com/moj-analytical-services/data-engineering-database-access#access-to-curated-databases) in the Data Engineering Database Access repo.

A typical project access file might look like:

```
project_id: Analytical Team 1 Derived Tables

review_date: 2022-10-20
approver_position: >=G7 of Analytical Team 1 Derived Tables
approver_email: approver.name@justice.gov.uk
alternative_approver_emails:
  - alternative.approver-name@justice.gov.uk

resources:
  - create_a_derived_table/domain_a
  - create_a_derived_table/domain_b
  - source_database_a/full
  - source_database_b/full

users:
  - alpha_user_name_a
  - alpha_user_name_b
  - alpha_user_name_c

business_case: >
  To create derived tables for Analytical Team 1.
```
