# Getting started
The first thing you'll need to work with Create a Derived Table is standard database access. If you don't have that already, follow the [guidance on how to make changes to the standard database access project file](https://github.com/moj-analytical-services/data-engineering-database-access#standard-database-access) in the Data Engineering Database Access repo.
The `mojap_derived_tables` directory is where you'll find the dbt project with all the resources you'll be contributing to like `models`, `seeds`, and `tests`. This service should be used for creating tables with well defined use cases, like to serve a performance metric, publication, or MI report. This is because the dbt project (`mojap_derived_tables`) is a shared space and so knowing where to put your work in the broader structure of the project is key. The primary consideration is understanding which domain the table you want to create belongs to. A domain is a logical grouping of databases. A domain may be 'prisons', or 'HR' for example, but it could be more or less granular if appropriate. The secondary consideration is whether the table you are creating belongs in an existing database. If those considerations aren't easy to answer, reach out to the [data modelling team](https://asdslack.slack.com/archives/C03J21VFHQ9), who will be able to advise you.

## Getting access to your tables
You won't automatically get access to the tables you create. Access to derived tables is granted at the domain level. This means you will need to know in which domain you will be creating derived tables before you start working. If you don't know which domain is the right one, get in touch with the [data modelling team](https://asdslack.slack.com/archives/C03J21VFHQ9) who will be able to advise you.
Once that's done, you'll need to setup a Data Engineering Database Access project access file. To learn how to do that, follow the [Access to curated databases](https://github.com/moj-analytical-services/data-engineering-database-access#access-to-curated-databases) guidance in the Data Engineering Database Access repo. Your project file should include the domain and source databases you want access to. A list of already available domains can be found in the [database access resources for Create a Derived Table](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main/database_access/create_a_derived_table). If you're creating a new database and there isn't a relevant domain for it to go in, get in touch at the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel and we'll set one up for you.
A typical project access file might look like:
```
project_id: Probation Team 1 Derived Tables

review_date: 2022-10-20
approver_position: >=G7 of Probation Team 1 Derived Tables
approver_email: approver.name@justice.gov.uk
alternative_approver_emails:
  - alternative.approver-name@justice.gov.uk

resources:
  - create_a_derived_table/probation
  - delius_prod/full
  - oasys_prod/full

users:
  - alpha_user_name_a
  - alpha_user_name_b
  - alpha_user_name_c

business_case: >
  To create derived tables for Probation Team 1.
```
Note that you will need access to any database whose tables your tables are derived from. To create derived tables from tables that aren't available in Data Engineering Database Access, you'll need the owner of those tables to give you access to the S3 bucket where the data is stored.

## Setting up your working environment
### R Studio
The first thing you’ll need to do is clone the repository and setup Python virtual environment. To do this, run the following command:
```
git clone git@github.com:moj-analytical-services/create-a-derived-table.git
```
then `cd` into the root of the repository and then run:
```
python3 -m venv venv
```
```
source venv/bin/activate
```
```
git checkout -b <your-branch-name-here>
```
```
pip install --upgrade pip
```
```
pip install -r requirements.txt
```
Set the following environment variable in your Bash profile:
```
echo "export DBT_PROFILES_DIR=../.dbt/" >> ~/.bash_profile
```
Then source your Bash profile by running:
```
source ~/.bash_profile
```
You'll need to be in the dbt project to run dbt commands. This is the `mojap_derived_tables` directory:
```
cd mojap_derived_tables
```
Then to check an active connection, run:
```
dbt debug
```
If that's successful, to install dbt packages, run:
```
dbt deps
```
You're now ready to get dbt-ing!

### JupyterLab
We're working to get Create a Derived Table up and running with JupyterLab, please bear with us.