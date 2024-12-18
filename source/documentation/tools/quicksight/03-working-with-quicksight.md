# Working with QuickSight

## Adding a dataset

Datasets are available via the `Athena` data source in QuickSight:

> Datasets > New Dataset (top right) > Athena > New Athena data source.

When adding a new dataset via Athena you'll be prompted for a `Data source name`.
This is just a descriptive name for the new data source tile for **you** in **your** QuickSight interface.

Here's [the advice from AWS] about naming your Data source:

> _This name displays on the Amazon QuickSight list of existing data sources, which is at the bottom of the 'Create a Dataset' view.
> Use a name that makes it easy to distinguish your data sources from other similar data sources._

Unless specified elsewhere for your data, use the default `Athena workgroup`.

Data will be in the default Catalog (`AwsDataCatalog`), and you should only see Databases that your user has access to via the Database Access Repo.

Adding a dataset in this way enables you to add a single table at a time.

You'll be asked if you want to 'Import to [SPICE] for quicker analytics'.
This imports the data into memory, rather than querying the data where it lives in S3. Whether to use SPICE or directly query the data is a judgement call, and will likely come down to:

- how complex the analysis is
- the size, format and structure of the underlying data
- how likely users are to drill down into the dashboards
- user tolerance for load times while making changes to dashboards

## Publishing Dashboards

- To create a dashboard, you'll need to publish it from an analysis. 
[The AWS QuickSight documentation] has details around the publishing flow.

## Sharing Dashboards

>**⚠️ Important ⚠️**
> 
>Users who have access to the dashboard can also see the data used in the associated analysis.

[Published dashboards](#publishing-dashboards) can be shared with anyone who already has a QuickSight user. 
Dashoards can be shared as-is, or they can be shared on a schedule via email, as an attachment or a link to the dashboard.

From [the AWS documentation on sharing dashboards]:

"By default, dashboards in Amazon QuickSight aren't shared with anyone and are only accessible to the owner.
However, after you publish a dashboard, you can share it with other users or groups in your QuickSight account. 
You can also choose to share the dashboard with everyone in your QuickSight account and make the dashboard visible on the QuickSight homepage for all users in your account. 
Additionally, you can copy a link to the dashboard to share with others who have access to it."

<!-- External links -->

[the advice from AWS]: https://docs.aws.amazon.com/quicksight/latest/user/create-a-data-source.html
[SPICE]: https://docs.aws.amazon.com/quicksight/latest/user/managing-spice-capacity.html
[AWS resources]: https://aws.amazon.com/quicksight/resources/
[AWS example analysis]: https://docs.aws.amazon.com/quicksight/latest/user/example-analysis.html
[The AWS QuickSight documentation]: https://docs.aws.amazon.com/quicksight/latest/user/creating-a-dashboard.html
[the AWS documentation on sharing dashboards]: https://docs.aws.amazon.com/quicksight/latest/user/sharing-a-dashboard.html