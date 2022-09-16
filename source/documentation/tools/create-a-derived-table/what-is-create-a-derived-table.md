# Create a Derived Table

Read on to find out more or get in touch at the [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9) channel.

## What is Create a Derived Table?
It's a service to allow you to deploy tables derived from data available on the Analytical Platform straight to Athena in a reproducible way and define a schedule for those tables to be updated on. All you’ll need to do is submit the SQL to derive your table along with a few configuration files in a GitHub PR. To make this happen we’re using some software called dbt which is packed full of features for transforming data using SQL. You don't need to worry about how it works under the hood but you will need to get familiar with certain bits of syntax. To learn more, take a look at [dbt's documentation](https://docs.getdbt.com/docs/introduction). We’re still in beta so would love to get some of you using Create a Derived Table to get your feedback and to be able to integrate it with our existing infrastructure that much better.

Some of the basics about working with dbt are covered below, but you can also sign up and work through [dbt's own training courses](https://courses.getdbt.com/collections) for free.