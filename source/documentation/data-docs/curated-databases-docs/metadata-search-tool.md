# Metadata search tool

## Overview

The metadata search tool scans repositories in the [MoJ Analytical Services](https://github.com/moj-analytical-services/) GitHub organisation for metadata files that follow a specific [schema](https://raw.githubusercontent.com/moj-analytical-services/etl_manager/master/etl_manager/specs/table_schema.json). The tool contains metadata for all the curated databases.

![The metadata search tool](images/curated-databases/metadata-search-tool-1.png)

The tool displays the following information:

*   Column info:
    +   Column name
    +   Column description
    +   Column data type
*   Table info:
    +   Table name
    +   Table description
    +   Table location
    +   Table data format
    +   Table metadata location
*   Database info:
    +   Database name
    +   Database description
    +   Database location
    +   Database metadata location
*   Access to the data:
    +   Data owners
    +   Data users
*   Example code:
    +   Sample SQL code
    +   Sample R code

You can search for metadata based on the names or descriptions of columns, tables or databases.

## Accessing the tool

You can access the metadata search tool at [metadata-vis.apps.alpha.mojanalytics.xyz](https://metadata-vis.apps.alpha.mojanalytics.xyz).

To access the tool, you must sign in using an email link or one-time passcode. To request access, contact the Analytical Platform team on the [#ap_admin_request](https://asdslack.slack.com/messages/CBLAGCQG6/) Slack channel or at [analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk).
