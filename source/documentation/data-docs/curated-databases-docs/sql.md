# SQL quickguide

__SQL__ (pronounced 'S-Q-L' or 'sequel') is a programming language used to access and manipulate databases. There are several versions of SQL that share a common framework but can have different syntax and functionality. The version of SQL used by [Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) is based on [Presto 0.217](https://prestodb.io/docs/0.217/index.html).

This guide will cover some basic concepts to get you going, but if you're looking for something more in depth, take a look at the SQL Training repo [here](https://github.com/moj-analytical-services/sql_training).

## Database structure

A database is a collection of structured data that consists of one or more tables. Tables consist of a number of rows and columns. A single row is called a record, entity or object. A single column is called a field or attribute.

in SQL, to refer to a table called `table_1` in a database called `database_1`, we write `database_1.table_1`.

Databases in Amazon Athena work in a slightly different way to other relational database systems. Databases and tables simply contain metadata that define schemas for underlying source data stored in S3. The metadata tells Athena where the source data is stored and how it is structured. Consequently, when you submit a query to Athena, it runs on the underlying source data. The superposition of a database structure makes it quick and easy to perform such queries.

## Data types

SQL supports several different data types. You can find out about those supported by Presto [here](https://prestodb.github.io/docs/current/language/types.html).

The format and use of most of these data types will be familiar to users of other versions of SQL. The way dates, times and timestamps (datetimes) are specified can be slightly different.

### `DATE`

Dates are written in the format `DATE 'YYYY-MM-DD'`.

### `TIME`

Times are written in the format `TIME 'HH:MM:SS.SSS'`. You can also specify a timezone using `TIME HH:MM:SS.SSS <TIMEZONE>`. A list of timezones can be found [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

### `TIMESTAMP`

Timestamps are the equivalent of datetimes in other versions of SQL. Timestamps are written in the format `TIMESTAMP 'YYYY-MM-DD HH:MM:SS.SSS`. As for times, you can specify a timezone in the same way.

## Commands

### `SELECT`

The `SELECT` statement is used to retrieve data from one or more tables or views in a database.

The following code retrieves `column1, column2, ...` from a table called `table_name` in a database called `database_name`.

```
SELECT column1, column2, ...
FROM database_name.table_name;
```

The following code retrieves all columns from a table called `table_name` in a database called `database_name`.

```
SELECT *
FROM database_name.table_name;
```

### `SELECT DISTINCT`

The `SELECT DISTINCT` statement returns only one copy of each set of duplicate rows. It only looks at values in the selected columns when identifying duplicate rows.

The following code retrieves all columns from a table called `table_name` in a database called `database_name` and returns only one copy of each set of duplicate rows.

```
SELECT DISTINCT *
FROM database_name.table_name;
```

If there are no duplicate rows, `SELECT` is equivalent to `SELECT DISTINCT`.

### `AS`

The `AS` operator is used give aliases, or temporary names, to tables and columns.

Table aliases are used to:

*   make code more concise and easy to follow when working with tables with long names; and
*   differentiate between fields with the same name in two or more different tables.

Column aliases are used to:

*   give columns more readable names in the result set; and
*   assign names to computed columns.

If an alias contains spaces, it must be contained within double quotation marks or square brackets.

### `WHERE`

The `WHERE` clause is used to filter records based on a condition. Operators can be used to specify a condition:

<div style="height:1px;font-size:1px;">&nbsp;</div>

Operator                | Description
------------------------|--------------------------
`=`                     | Equal to
`<>`                    | Not equal to
`>`                     | Greater than
`<`                     | Less than
`>=`                    | Greater than or equal to
`<=`                    | Less than or equal to
`[NOT] IN`              | (Not) in a specified list
`IS [NOT] NULL`         | (Not) null
`BETWEEN`               | Between two values, inclusive of the start and end values
`IS [NOT] DISTINCT FROM`| See [here](https://prestodb.github.io/docs/current/functions/comparison.html#is-distinct-from-and-is-not-distinct-from)
`IN`                    | In a list of the form `(value1, value2, ...)`

<div style="height:1px;font-size:1px;">&nbsp;</div>

You can filter records based on more than one condition using the boolean operators `AND` and `OR`. Conditions can also be negated using the `NOT` operator.

### `LIMIT`

The `LIMIT` clause restricts the number of rows in the result set. The rows in the result set will be arbitrary unless the query contains an `ORDER BY` clause.

The following code retrieves all columns from a table called `table_name` in a database called `database_name` but restricts the output to 10 rows.

```
SELECT *
FROM database_name.table_name
LIMIT 10;
```

### `ORDER BY`

The `ORDER BY` statement is used to sort the outputs of a query. You can sort using multiple columns by separating the names of the columns with a comma. For example, `ORDER BY column1, column2, column3` would sort a query output first by `column1`, then by `column2` and finally by `column3`.

By default, `ORDER BY` sorts in ascending order. To sort in descending order, insert the keyword `DESC` after the column name. You can also explicitly sort in ascending order by inserting the keyword `ASC` after the column name. For example, `ORDER BY column1 ASC, column2 DESC` would sort a query output first by `column1` in ascending order and then by `column2` in descending order.

```
SELECT column1,
       column2,
       column3
FROM database_name.table_name
ORDER BY column1 ASC, column2 DESC;
```

### `GROUP BY`

The `GROUP BY` statement is used to group the results of a query output and is often used with summary functions:

*   `MAX`
*   `MIN`
*   `SUM`
*   `COUNT`
*   `AVG`

### `JOIN`

There are five different types of join:

*   `[INNER] JOIN` returns all records that have matching values in both tables to be joined.
*   `LEFT [OUTER] JOIN` returns all records from the left table and records from the right table with matching values.
*   `RIGHT [OUTER] JOIN` returns all records from the right table and records from the left table with matching values.
*   `FULL [OUTER] JOIN` returns all records from both tables regardless of whether they have matching values or not.
*   `CROSS JOIN` returns the cartesian product of both tables, i.e., each record from the left table is matched with each record from the right table.

All of these join statements, apart from `CROSS JOIN` require you to specify the column(s) on which to join using the `ON` statement.

As an example, the following code selects all columns from `table_1` (which has the alias `t1`) and joins them to all columns from `table_2` (which has the alias `t2`) where `column1` in `table_1` matches `column1` in `table_2`:

```
SELECT t1.*,
       t2.*
FROM database_name.table_1 t1
INNER JOIN database_name.table_2 t2 ON t1.column1 = t2.column1;
```

### `CREATE VIEW`

A view is the output of a stored query that can be accessed by a name in a similar way to a table. It may be useful to create a view if you often run the same query.

When you select a view, the underlying query is rerun, so you will always see an output based on the most up-to-date data.

To create a view, we use the `CREATE [OR REPLACE] VIEW AS` statement. For example, the following code creates a view called `view_1` that selects all columns from a table called `table_name` in a database called `database_name`:

```
CREATE OR REPLACE VIEW view_1 AS
SELECT *
FROM database_name.table_name;
```

Here, `OR REPLACE` updates the view if it already exists and creates it if not. If `OR REPLACE` is not included but the view already exists, the query will result in an error.

### `DROP VIEW`

To delete a view, we use the `DROP VIEW` statement. For example, the following code deletes a view called `view_1` from a database called `database_1`:

```
DROP VIEW database_1.view_1;
```

Including `IF EXISTS` supresses an error if the view does not exist.

### `CREATE TABLE`

To create, edit or delete tables in Athena you need to have additional read/write permissions. If you require access to this functionality, please contact the Analytical Platform team.

#### Creating a table from existing data

To create a table in a database from existing data, we use the `CREATE TABLE [IF NOT EXISTS]` statement. The following code creates a new table called `table_1` that selects two columns from a table called `table_name` in a database called `database_name`:

```
CREATE TABLE IF NOT EXISTS table_1 AS
SELECT column1, column2
FROM database_name.table_name;
```

Including `IF NOT EXISTS` ensures that we only create a table when one does not already exist. If we did not include this but a table did already exist, the query would result in an error.

This table will be stored permanently in the database and will not be updated, even if the underlying data used in the `CREATE TABLE` query changes.

#### Creating a new table

To create a new table, we also use the `CREATE TABLE` statement. Here we must specify the names of the columns in the new table and their data types.

### `INSERT INTO`

To insert data into a table we use the `INSERT INTO` statement. We can insert a single line at a time, multiple lines at a time or can insert data using a query on existing tables.

### `ALTER TABLE`

We can add, remove and modify columns in an existing table using the `ALTER TABLE` statement.

### `DROP TABLE`

To delete a table, we use the `DROP TABLE [IF EXISTS]` statement. For example, the following code deletes a table called `table_1` from a database called `database_1`:

```
DROP TABLE IF EXISTS database_1.table_1;
```

Including `IF EXISTS` supresses an error if the table does not exist.

You should always check carefully before deleting a table and should never delete a table that you have not created yourself.

## Functions

SQL supports hundreds of functions, a full list of which can be found in the [Presto documentation](https://prestodb.github.io/docs/current/functions.html).
