# Querying databases from the AP

We have developed some simple packages to allow you to query our databases using R and Python on the Analytical Platform. You can use these packages to execute SQL queries on Athena databases, bringing the results into your environment as a DataFrame to do further analysis:

## R - dbtools

Allows you to access Athena databases from the Analytical Platform using a [reticulate](https://rstudio.github.io/reticulate/articles/package.html) wrapper around pydbtools. The [README](https://github.com/moj-analytical-services/dbtools/blob/master/README.md) in the [dbtools](https://github.com/moj-analytical-services/dbtools/) repository gives details on how to install and use the package with R. This package is maintained by the analytical platform user community.

## R - Rdbtools

Allows you to access Athena databases from the Analytical Platform using an extension of the [noctua](https://github.com/DyfanJones/noctua) R package. The [README](https://github.com/moj-analytical-services/Rdbtools) provides details. This package is maintained by the analytical platform user community.

## Python - pydbtools

Allows you to access Athena databases from the Analytical Platform using the [awswrangler](https://aws-sdk-pandas.readthedocs.io/en/stable/index.html#) python package, and adding features such as temp table creation. The [README](https://github.com/moj-analytical-services/pydbtools/blob/master/README.md) in the [pydbtools](https://github.com/moj-analytical-services/pydbtools/) repository gives details on how to install and use the package with Python. This package is maintained by the data engineering team.
