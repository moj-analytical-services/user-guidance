# What is Create a Derived Table?

Create a Derived Table is a service that brings dbt, Git, and data access controls together to allow you to deploy tables from data available on the Analytical Platform; straight to Athena, in a reproducible way, and with scheduled table updates. All you’ll need to do is submit the SQL to derive your tables along with a few configuration files in a GitHub Pull Request. 

## What can it be used for?

Although it has *derived* in its name, Create a Derived Table can be used to create both *derived* and *processed* data and tables. 

## WHat are the terms I should get familiar with?

One term to familiarise yourself with is a *data model*. A data model is used within Create a Derived Table to denote an SQL file that contains a transformation logic applied to your raw data to create new tables or views. Multiple data models (SQL files) often are used to produce the final dataset. In essence, a data modal is a step in a data processing pipeline.

Often Analytics Engineers and users of Create a Derived Table will also refer to dimensional modelling; however, this is generally specific to *derived* tables so if you are using Create a Derived Table for creating *processed* data tables you probably don't need to know about dimensional modelling.

## What coding language does it use?

dbt is at the core of Create a Derived Table and it's packed full of features for transforming data using SQL so you'll need to get familiar with certain bits of dbt syntax. To learn more about dbt, take a look at [their documentation](https://docs.getdbt.com/docs/introduction). Some of the basics about working with dbt are covered below, but you can also sign up and work through [dbt's own training courses](https://courses.getdbt.com/collections) for free. The training uses their own user interface instead of Create a Derived Table but it's still relevant here.

We’re still in beta so we'd love to get some of you using Create a Derived Table to get your feedback to help guide data modelling best practice in the Ministry of Justice and make sure we can continue to improve the user experience.
