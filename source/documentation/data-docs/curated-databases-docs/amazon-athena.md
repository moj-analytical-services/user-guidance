# Amazon Athena

>   Amazon Athena is an interactive query service that makes it easy to analyze data directly in Amazon Simple Storage Service (Amazon S3) using standard SQL. With a few actions in the AWS Management Console, you can point Athena at your data stored in Amazon S3 and begin using standard SQL to run ad-hoc queries and get results in seconds.
>
> Source: [AWS](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)

## Accessing Amazon Athena

You can access the AWS console at [aws.services.alpha.mojanalytics.xyz](https://aws.services.alpha.mojanalytics.xyz). You may need to login with GitHub and go through two-factor authentication.

To access Athena, select __Services__, then __Athena__.

![](../../../images/curated-databases/access-athena-2.png)

This will bring you to the Athena query editor. Here, you can:

*   access and create databases and tables
*   access and modify views
*   write, run and save queries
*   view and download query outputs to your local computer

![](../../../images/curated-databases/access-athena-3.png)

## Previewing tables and views

In many cases, it may be useful to preview a table or view to get a better understanding of its structure and contents.

To preview a table or view, select a database using the dropdown menu and find the object you want to preview either directly from the list or using the __Filter table and views...__ search bar.

You can view the name and type of each column in a table or view by selecting the blue arrow to the left of the object name.

To run a query to preview a table or view, select the three dots (⋮) to the right of the object name and select __Preview table__. This will run the following query that selects all columns from the table or view and returns 10 rows from the output:

```
SELECT *
FROM database_name.table_or_view_name
LIMIT 10;
```

## Working with views

You can update and delete views using the code described in the [SQL](./sql) section, however, you can also take advantage of the Athena UI.


### Modify and delete a view

To modify a view, select the three dots (⋮) to the right of the view name and select __Show/edit query__.

To delete a view, select the three dots (⋮) to the right of the view name and select __Delete view__.

![](../../../images/curated-databases/athena-create-3.png)

## Working with tables

You can create, update and delete tables using the code in the [SQL](./sql) section, however, you must also specify the storage format and location of the table in S3.

You can also use the Athena UI. In particular, the Athena UI allows you to create tables directly from data stored in S3 or by using the AWS Glue Crawler. This guidance does not cover use of the AWS Glue Crawler.

### Create a table

#### Using code

If using code to create a table in Athena, you must also specify the storage format and location of the table in S3.

If creating a table from existing data, you can specify this information using the `WITH` statement.

```
CREATE TABLE IF NOT EXISTS database_1.table_1
    WITH (format = 'format', external_location = 'location') AS
SELECT *
FROM database_name.table_name;
```

Here, `format` can be any of the following:

*   `ORC`
*   `PARQUET`
*   `AVRO`
*   `JSON`
*   `TEXTFILE`

If `format` is not specified, `PARQUET` is used by default.

Additionally, `location` is the S3 path where you would like to store the table, for example, `s3://alpha-everyone`.

There are several other parameters that you can specify. Information on these parameters can be found in the [Athena documentation](https://docs.aws.amazon.com/athena/latest/ug/create-table-as.html).

If you are creating a new table, you can specify the storage format using the `STORED AS` statement and the storage location using the `LOCATION` statement.

```
CREATE TABLE IF NOT EXISTS table_1 AS (
    column_name1 column_type1,
    column_name2 column_type2,
    ...
)
STORED AS 'format'
LOCATION 'location';
```

Here, `format` and `location` are the same as above.

#### Using the Athena UI

Selecting __Create table__ in the database window brings up a menu list with the following options:

*   __Create table__
    +   From S3 bucket data
    +   from AWS Glue Crawler
*   __SQL templates__
    +   CREATE TABLE
    +   CREATE TABLE AS SELECT

![](../../../images/curated-databases/athena-create-1.png)

Selecting __CREATE TABLE__ or __CREATE TABLE AS SELECT__ generates an example query that you can edit to create a new table. These example queries are of the same form as those described in the previous section.

Selecting __from S3 bucket data__ will open a new window that guides you through four steps to create a new table from data in S3:

1. Select which database to store your table in, input a name for your table and input the S3 path to the data from which you want to make the table. The S3 path should be of the form `s3://bucket/folder/`.
2. Select the format of the input data. You may also have to complete additional fields depending on the format of the input data.
3. Input the name and data type of each column in the table. When adding a large number of columns, it may be easier to use the __Bulk add columns__ option.
4. Select whether you want to partition the data in the table. This step is optional.

### Delete a table

To delete a table using the Athena UI, select the three dots (⋮) next to the name of the table you want to delete and select __Delete table__.

## Run a query

To create and run a new query:

1.  Select the plus (+) tab above the editor window.
2.  Write your code in the editor window (or copy and paste from another editor).
3.  Select __Run query__.

Progress information, including the estimated time elapsed will be displayed in the results window while the query is being processed.

Once the query has been completed, the output will be displayed in the results window.

You can save a query (not including the resulting output) by selecting __Save as__ and entering a name and description. Saved queries are available from the __Saved Queries__ tab in the Athena toolbar.

You can also create tables from queries by selecting __Create__ and entering a name. Tables that you create will be visible in the database window at the left of the page.

## Download query outputs

When you have run a query, you can download the output to your local computer as a CSV file.

To download the output, select the page icon above the results table.

![](../../../images/curated-databases/athena-create-4.png)

## SQL resources

You might find the [SQL Training repository](https://github.com/moj-analytical-services/sql_training) useful. This training is for using SQL (Athena) with the Analytical Platform.
