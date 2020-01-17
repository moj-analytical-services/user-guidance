# Databases

There are currently five curated databases available on the Analytical Platform:

1.  [CREST](#crest)
2.  [HOCAS](#hocas)
3.  [NOMIS](#nomis)
4.  [TAR](#tar)
5.  [XHIBIT](#xhibit)

Information about these databases is given below.

## Access permissions

To access all curated databases on the Analytical Platform, you __must__ have completed the baseline personnel security standard (BPSS).

For each database, there are up to three different access levels:

*   __Basic:__ Access to aggregated and derived data only
*   __Standard:__ Access to individual--level data with all personal information removed, redacted or masked.
*   __Full:__ Access to individual--level data, including all personal information

### Data access requests

To request access to a curated database, you must submit a [data access request](https://forms.office.com/Pages/ResponsePage.aspx?id=KEeHxuZx_kGp4S6MNndq2I8ebMaq5PFBoMAkkhrMYHBUODRaN1ZWVlhRUVMxQ0VIRVQ1MlRLRkM4NS4u).

The form requires you to provide the following information. You may not need to complete all fields depending on your responses.

<div style="height:1px;font-size:1px;">&nbsp;</div>

Field                                    | Details
-----------------------------------------|-----------------------------------------
Name                                     |
Email address                            |
Approver name                            | The approver should be in your line management chain and should be at least a Band A.
Approver email address                   |
Which database do you require access to? | CREST, HOCAS, NOMIS, TAR or XHIBIT.
What level of access do you require?     | Basic, Standard or Full.
Why do you require standard access?      | You should state why you require access to individual-level data.
Why do you require full access?          | You should state why you require access to individual-level data and data that contains personal information.

<div style="height:1px;font-size:1px;">&nbsp;</div>

## Metadata

To find out about the metadata of the curated databases, you can use the [metadata search tool](../metadata-search-tool).

## CREST

CREST is the Crown Court database (soon to be superseeded by [XHIBIT](#xhibit)). It holds data on pending and completed Crown Court cases. These are trial, sentence and appeal cases. We create and maintain a copy of the raw relational database system and also create calculated tables for analytical purposes.

CREST consists of two databases:

*   `crest_v1`: The main database that holds the relational database and derived tables.
*   `crest_lookups_v1`: A database containing a table of lookups maintained by DASD that has useful categories and measures.

If you need access to this table you will need to submit a [data access request](#data-access-requests). When submitting a request, you will need select the level of access you require:

*   __Basic:__ Access to the derived tables (`flatfile` and `all_offence_disp`) that are used for most analytical and statistical purposes as well as the full `crest_lookups_v1` database.

*   __Standard:__ Basic level access plus access to the full database (`crest_v1`), except for tables that contain personal information, such as names and addresses, e.g., `crest_v1.subject`.

*   __Full:__ Access to both databases and all tables, including tables that contain personal information.

For any queries, please contact [Karik Isichei](mailto:karik.isichei@digital.justice.gov.uk).

## HOCAS

This section of the guidance is currently under development.

Existing guidance on the HOCAS database is avaiable [here](https://github.com/moj-analytical-services/airflow-hocas-to-athena/blob/master/README.md).

For any queries, please contact [Karik Isichei](mailto:karik.isichei@digital.justice.gov.uk).

## NOMIS

This section of the guidance is currently under development.

For any queries, please contact [Adam Booker](mailto:adam.booker@digital.justice.gov.uk).

## TAR

This section of the guidance is currently under development.

## XHIBIT

This section of the guidance is currently under development.
