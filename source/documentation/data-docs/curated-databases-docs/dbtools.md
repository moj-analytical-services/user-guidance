# Querying databases from the AP

The Data Engineering Team have developed some simple packages to allow you to query our databases using R and Python on the Analytical Platform. `pydbtools` is a python module, while `dbtools` is an R package that uses `pydbtools` under the hood. You can use these packages to execute SQL queries on Athena databases, bringing the results into your environment as a DataFrame to do further analysis. While these are the only "officially" supported packages, there is also the community built [Rdbtools](https://github.com/moj-analytical-services/Rdbtools) which has additional functionality. It can be used with the understanding that if the package requires fixing or updating, it is the responsibility of those using the package to do so.

## R - dbtools

The [README](https://github.com/moj-analytical-services/dbtools/blob/master/README.md) in the [dbtools](https://github.com/moj-analytical-services/dbtools/) repository gives details on how to install and use the package with R. This package is maintained by the data engineering team.

## R - Rdbtools

The [README](https://github.com/moj-analytical-services/Rdbtools) provides details. This package is maintained by the analytical platform user community.

## Python - pydbtools

The [README](https://github.com/moj-analytical-services/pydbtools/blob/master/README.md) in the [pydbtools](https://github.com/moj-analytical-services/pydbtools/) repository gives details on how to install and use the package with Python. This package is maintained by the data engineering team.
