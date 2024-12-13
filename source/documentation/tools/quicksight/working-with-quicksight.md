# Working with QuickSight

## Finding datasets

Datasets are available via the `Athena` data source in QuickSight: 

>Datasets > New Dataset (top right) > Athena > New Athena data source.

When adding a new dataset via Athena you'll be prompted for a `Data source name`. 
This is just a descriptive name for the new data source tile for **you** in **your** QuickSight interface.

Here's [the advice from aws] about naming your Data source:
> _This name displays on the Amazon QuickSight list of existing data sources, which is at the bottom of the 'Create a Dataset' view. 
Use a name that makes it easy to distinguish your data sources from other similar data sources._

Unless specified elsewhere for your data, use the default `Athena workgroup`.

Data will be in the default Catalog (`AwsDataCatalog`), and you should only see Databases that your user has access to via the Database Access Repo.

Adding a dataset in this way enables you to add a single table at a time.

You'll be asked if you want to 'Import to [SPICE] for quicker analytics'.  
This imports the data into memory, rather than querying the data where it lives in S3. Whether to use SPICE or directly query the data is a judgement call, and will likely come down to: 
- how complex the analysis is
- the size, format and structure of the underlying data
- how likely users are to drill down into the dashboards
- user tolerance for load times while making changes to dashboards


## External QuickSight resources
- [aws resources]
- [aws example analysis] (_dataset requires file upload_)

## Publishing Dashboards

## Sharing Dashboards

<!-- External links -->

[the advice from aws]: https://docs.aws.amazon.com/quicksight/latest/user/create-a-data-source.html
[SPICE]: https://docs.aws.amazon.com/quicksight/latest/user/managing-spice-capacity.html
[aws resources]: https://aws.amazon.com/quicksight/resources/
[aws example analysis]: https://docs.aws.amazon.com/quicksight/latest/user/example-analysis.html