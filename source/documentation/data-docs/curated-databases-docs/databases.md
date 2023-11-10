# Databases

The data engineering team curate and maintain databases on the Analytical Platform that can be made accessible to users. All of our current databases are deployed and accessible using Amazon Athena. AP users can query these databases via the Amazon Athena SQL workbench (see the "Accessing Amazon Athena" section of the docs on how to access it). Databases can also be queried in Python using [pydbtools](https://github.com/moj-analytical-services/pydbtools#pydbtools). They can be queried in R using [dbtools](https://github.com/moj-analytical-services/dbtools#dbtools) or [Rdbtools](https://github.com/moj-analytical-services/Rdbtools), though note the latter is maintained by the analytical platform user community and is therefore not supported by the data engineering team.

To see what databases are available and how to request access, see the [README](https://github.com/moj-analytical-services/data-engineering-database-access/blob/master/README.md) in the [data-engineering-database-access](https://github.com/moj-analytical-services/data-engineering-database-access) repository on GitHub. For each database, take careful note of any guidance documents to ensure you understand how to use the data correctly. Most curated databases on the AP use one of two data models.

1. Snapshot database models attach specific points in time to each record. Queries should specify the same snapshot literal for all data.
2. Temporal database models attach a start and end timestamp to each record indicating the period of its validity with respect to the source database.

> Note, you must be a member of the [moj-analytical-services](https://github.com/moj-analytical-services) GitHub organisation to access the repository.

To find out about the metadata of the curated databases (without making a database access request), you can use the [data discovery tool](../data-documentation).

## User-maintained databases

In addition to curated data sources provided by the Data Engineering team, Platform users may wish to use the same infrastructure to create their own databases. While this requires slightly more maintenance, it gives you access to vastly more processing power for manipulating data than that available through R and Python on the Platform.

Databases are created by writing data in a well-defined schema to an S3 location, and providing a register of the metadata to an AWS service. Access is controlled using the permissions of the S3 location of the underlying data. There is guidance on helper tools for creating your own Amazon Athena database [here](https://github.com/moj-analytical-services/mojap-aws-tools-demo/#tutorials).


## Using `mojap_*_timestamp` filters

In order to enable reproducible data analysis, some curated data sources on the Analytical Platform employ a temporal record-keeping system that preserves prior states of the data. To do this it simply labels every record from the source system with the following columns. These columns are created on the Platform - they do not exist in the source databases:

* `mojap_start_datetime` - The time at which extraction code found this record and loaded it on to the Platform.
* `mojap_end_datetime` - The time at which extraction code found this record to have been edited and replaced it with a newer version on the Platform.
* `mojap_current_record` or `mojap_latest_record` - A boolean label for whether this record (on the Platform) is the most recent version.

`mojap_end_datetime` has the same value as the `mojap_start_datetime`  of the record that succeeded it. Where a record is the most recent version, `mojap_end_datetime` takes a placeholder value of `2999-01-01`. These times are UTC/GMT all year round (as is the timezone on all Platform instances).

In this way, as records are edited in the source database, they are recorded on the Platform without overwriting historical versions of the record, enabling analysis to be run reproducibly even as records are modified in the source systems. Note that the Platform typically extracts data from source systems shortly after midnight each day. Therefore it will only record table states found at that time - record states in source systems are only uploaded if they were present during an extraction. The Platform does not record every edit to a source database.

**All queries on curated Platform data must filter for the correct temporal table state.**

Otherwise you will duplicate records. For Platform curated data sources the unique key of a record becomes `{source_db_uk AND (mojap_start_datetime OR mojap_end_datetime)}`. In almost all cases, you should use a specific timestamp in a filter of the form:

    ... mojap_start_datetime <= timestamp'YYYY-MM-DD'
    AND mojap_end_datetime > timestamp'YYYY-MM-DD'

Don't be tempted to use the SQL `BETWEEN` construct - it is inclusive of both timestamps and therefore could fail to return the correct results.

`mojap_current_record` or `mojap_latest_record` should only be used for keeping scheduled data products up-to-date, as they do not facilitate reproducible analysis.

All three of the temporal record columns are strictly not-null in the Platform data model.


## Joining temporal-schema tables

When joining tables and using `mojap_*_datetime` columns you must be careful whether you filter the query using the `WHERE` clause, or the `JOIN` condition.
Note that in any (in)equality test, SQL engines will evaluate `NULL` values as False*. This means when filtering on any table join other than inner joins, there is a possibility of unintentionally dropping the unmatched records due to filtering for a `mojap_*_datetime` table state in the wrong place. See below for some specimen examples of how to apply these filters correctly.

In the following, read `<X.state_filter>` as shorthand for `X.mojap_start_datetime <= timestamp'YYYY-MM-DD' AND X.mojap_start_datetime > timestamp'YYYY-MM-DD'`. If you are producing dynamic data products and need live data, read `X.mojap_current_record` or `X.mojap_latest_record` - whichever is used in the data source.

### Subquery solution

The most fail-proof solution (albeit ugly) is to use subqueries to explicitly filter the tables before they are invoked in the main query.

    SELECT <…>
    FROM (select * from table_A where <state_filter>) AS A
    <any> JOIN (select * from table_B where <state_filter>) AS B
        on A.key = B.key

For complex queries it might be worth checking to see if this has a performance penalty compared to the alternative solutions below.


### LEFT JOIN
The preserved 'left side' table can be filtered in the `WHERE` clause, but the other table must be filtered in the `ON` condition.

    SELECT <…>
    FROM table_A AS A
    LEFT JOIN table_B AS B
        ON A.key = B.key
        AND <B.state_filter>
    WHERE <A.state_filter>


Alternatively, you can explicitly handle the `NULL` pitfall. If you are unfamiliar with the difference in how SQL engines handle a `WHERE` and `ON` filter, comparing these two options might help you understand what is happening. This query is also easier to edit to return only the unmatched records from table A. 

    SELECT <…>
    FROM table_A AS A
    LEFT JOIN table_B AS B
        ON A.key = B.key
    WHERE <A.state_filter>
        AND (<B.state_filter> OR B.mojap_start_datetime is null)


### RIGHT JOIN
Just like the left join, but with the tables reversed (obviously).

    SELECT <…>
    FROM table_A AS A
    RIGHT JOIN table_B AS B
        ON A.key = B.key
        AND <A.state_filter>
    WHERE <B.state_filter>

    -- Alternatively
    SELECT <…>
    FROM table_A AS A
    RIGHT JOIN table_B AS B
        ON A.key = B.key
    WHERE <B.state_filter>
        AND (<A.state_filter> OR A.mojap_start_datetime is null)


### INNER JOIN
Because no unmatched records are included in the results of an inner join, it does not matter where the state filter is. Note that by putting both state filters into the `WHERE` clause, *any* join type results in an inner join, due to unmatched records being dropped.

    SELECT <…>
    FROM table_A AS A
    INNER JOIN table_B AS B
        ON A.key = B.key
    WHERE <A.state_filter> 
        AND <B.state_filter>

    -- Equivalently
    SELECT <…>
    FROM table_A AS A
    INNER JOIN table_B AS B
        ON A.key = B.key
        AND <A.state_filter> 
        AND <B.state_filter>

*SQL engines can often be configured to treat `NULL` as a literal value, but it is unusual for this to be useful.
