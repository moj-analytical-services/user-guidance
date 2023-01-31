# Install packages from GitHub

### R packages

When the visibility of a repository containing an R package is set to internal or private, you need to authenticate to GitHub to access it from R. Otherwise, you will get a 404 error.

The `remotes` package and the `renv` package allow you to install R packages using the same SSH credentials you use to close repositories from GitHub.

To install a package from an internal or private repository using `remotes`, you can use the following code:

```r
remotes::install_git("git@github.com:moj-analytical-services/repository-name.git")
```

Alternatively, if you are using `renv`, you can use the following code:

```r
renv::install("git@github.com:moj-analytical-services/repository-name.git")
```

In both cases, you should replace `repository-name` with the name of your repository.

You can use the same approach to install packages from any other public repository.
