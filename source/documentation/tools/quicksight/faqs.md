# Frequently Asked Questions

## How do I know if I should be able to see a particular table/database/domain in QuickSight?

Databases and Tables should be available via the `Athena` data source in QuickSight provided that:

- your Analytical Platform `alpha_user` has access to the data via [the data-engineering-database-access GitHub repository]
- the data is within one of [the `mojap-derived-table` domains] in Create a Derived Table

## Can I share the dashboards that I create?

### For consumers

### For collaborators / editor

## I’m already a user of another version of QuickSight on the AP, what should I do if:

### I can do all of my work on the new QuickSight (all of my tables are create-a-derived-table tables)

Export dashboards from other versions of QuickSight

Import dashboards into QuickSight via Control Panel

### I can’t do all of my work on the new QuickSight (some / all of my tables are outside create-a-derived-table)

## When should I use SPICE?

Importing a dataset into [SPICE] imports the data into memory, rather than querying the data where it lives in S3. Whether to use SPICE or directly query the data is a judgement call, and will likely come down to:

- how complex the analysis is
- the size, format and structure of the underlying data
- how likely users are to drill down into the dashboards
- user tolerance for load times while making changes to dashboards

## What should I do if I encounter an error while using QuickSight?

Check [the Troubleshooting guide](/tools/quicksight/troubleshooting), and [raise a support request] if you're unable to resolve your issue there.

## How can I optimize the performance of my QuickSight dashboards?

- see [this issue in the troubleshooting guide](/tools/quicksight/troubleshooting.html#issue-slow-dashboard-performance)

<!-- External links -->

[the `mojap-derived-table` domains]: https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models
[the data-engineering-database-access GitHub repository]: https://github.com/moj-analytical-services/data-engineering-database-access/?tab=readme-ov-file#access-to-curated-databases
[SPICE]: https://docs.aws.amazon.com/quicksight/latest/user/managing-spice-capacity.html
[Raise a support request]: https://github.com/ministryofjustice/data-platform-support/issues/new/choose
