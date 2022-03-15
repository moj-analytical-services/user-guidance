# Amazon S3

## What is Amazon S3?

[Amazon S3](https://aws.amazon.com/s3/) is a web-based cloud storage platform. It is one of the primary file storage locations on the Analytical Platform, alongside individual users' home directories.

You should use your home directory to store working copies of code and analytical outputs. Where possible, you should store all data and final analytical outputs in Amazon S3, and final code in GitHub to facilitate collaboration.

Data stored in Amazon S3 can be seamlessly integrated with other AWS services such as Amazon Athena and Amazon Glue.

## Working with Amazon S3 buckets

### Types of buckets

Amazon S3 buckets are separated into two categories on the Analytical Platform.

#### Warehouse data sources

Warehouse data sources are used to store data that is accessed by code you run yourself, for example, in RStudio or JupyterLab. You can create warehouse data sources yourself and can provide access to other users you need to collaborate with.

#### Webapp data sources

Webapp data sources are used to store data that is accessed by code run by the Analytical Platform, for example by deployed apps or by Airflow pipelines. You cannot create webapp data sources yourself – you must ask the Analytical Platform team to create one on your behalf.

If you request that a webapp data source is created when setting up a new app, the app will automatically be given read-only access. You will also be given admin access to the bucket and can provide access to other users you need to collaborate with.

The Data Engineering team also manage some buckets that are not shown in the control panel and that are not available to standard users. These buckets are used to store incoming raw data, which may be processed or fed into curated data pipelines. For more information, contact the Data Engineering team on the [#ask-data-engineering](https://app.slack.com/client/T1PU1AP6D/C8X3PP1TN) Slack channel.

You can view the data sources you have access to in the control panel.

### Create a new warehouse data source

You can only create new warehouse data sources in the Analytical Platform control panel. You cannot create new buckets directly in the Amazon S3 console.

To create a new warehouse data source:

1.  Go to the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz/).
2.  Select the __Warehouse data__ tab.
3.  Select __Create new warehouse data source__.
4.  Enter a name for the warehouse data source -- this must be prefixed with 'alpha-'.
5.  Select __Create data source__.

When you create a new warehouse data source, only you will initially have access. As an admin of the data source, you will be able to add and remove other users from the data access group as required. Further information on managing data access groups can be found [here](#manage-access-to-a-bucket).

### Data access levels

Every bucket has three data access levels:

*   Read only
*   Read/write
*   Admin -- this provides read/write access and allows the user to add and remove other users from the bucket's data access group

### Path specific access

As well as choosing an access level, you can also restrict a user's access to specific paths in a bucket by entering each path on a new line in the 'Paths' textarea field when adding the user to a data access group. For example:

    /folder-one
    /folder-two

This would give the user access to only `/folder-one` and `/folder-two` in the bucket and nothing else.

If you leave this field blank, the user will be able to access everything in the bucket.

### Request access to a bucket

To gain access to a bucket (warehouse data source or webapp data source), you must be added to the relevant data access group.

If you know an admin of the bucket you require access to, you should ask them to add you to the data access group.

If you do not know any of the admins of the bucket you require access to, you can ask the Analytical Platform team to add you to the data access group on the [#analytical_platform](https://asdslack.slack.com/archives/C4PF7QAJZ) Slack channel or by email ([analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk)).

When requesting access to a bucket, you should specify the name of the bucket and the level of access you require. You should only request access to data that you have a genuine business need to access and should only request the lowest level of access required for you to complete your work. You may be required to demonstrate the business need for you to access a bucket if requested by a bucket admin or an information asset owner (IAO).

### Manage access to a bucket

Bucket admins can manage access to warehouse data sources and webapp data sources in the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz//). You cannot manage access to buckets directly in the Amazon S3 console.

To manage access to a data source:

1.  Go to the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz/).
2.  Select the __Warehouse data__ tab or the __Webapp data__ tab, as relevant.
3.  Select the name of the data source you want to manage.

To add a new user to the data access group:

1.  Type the user's GitHub username into the input field labelled __Grant access to this data to other users__.
2.  Select the user from the drop-down list.
3.  Select the required data access level.
4.  Either leave the 'Paths' field blank or enter a list of paths to provide restricted access, as described in the section above.
5.  Select __Grant access__.

To edit the access level of a user:

1.  Select __Edit access level__ next to the name of the user.
2.  Select required data access level.
3.  Either leave the 'Paths' field blank or enter a list of paths to provide restricted access, as described in the section above.
4.  Select __Save__.

To remove a user from the data access group:

1.  Select __Edit access level__ next to the name of the user.
2.  Select __Revoke access__.

## Upload files to Amazon S3

You can upload files to Amazon S3 from your local computer or from RStudio or JupyterLab.

When uploading files to Amazon S3, you should ensure that you follow all necessary [information governance](../../information-governance.html) procedures. In particular, you must complete a data movement form when moving any data onto the Analytical Platform.

### Amazon S3 Console

You can use the Amazon S3 Console to upload files from your local computer (for example, personal or shared storage on DOM1 or Quantum) only.

To upload files using the Amazon S3 Console:

1.  Log in to the [AWS Management Console](https://aws.services.alpha.mojanalytics.xyz) using your Analytical Platform account.
2.  Select __Services__ from the menu bar.
3.  Select __S3__ from the drop down menu.
4.  Select the bucket and folder you want to upload files to.
5.  Select __Upload__.
6.  Select __Add files__ or drag and drop the files you want to upload.
7.  Select __Upload__ -- you do not need to complete steps 2, 3 or 4.

You can also directly navigate to a bucket in the AWS S3 Console by selecting __Open on AWS__ in the Analytical Platform control panel.

### RStudio

#### `s3tools`

s3tools is set to be deprecated alongside the launch of RStudio v4.0.5 on the platform. If you are starting a new project, we'd advise using [Rs3tools](https://github.com/moj-analytical-services/Rs3tools) or [botor](../../appendix/botor.html) for anything involving buckets on the platform.

You can upload files in RStudio on the Analytical Platform to Amazon S3 using the `s3tools` package.

`s3tools` should be preinstalled for all users of the Analytical Platform. If you find that `s3tools` is not installed, you can install it by running the following code in a terminal:

```
conda install -c moj-analytical-services r-s3tools
```

This will then allow you to activate it in future with the standard `library(s3tools)` command.

`s3tools` contains three functions for uploading files to Amazon S3:

*   `write_file_to_s3`
*   `write_df_to_csv_in_s3`
*   `write_df_to_table_in_s3`

You can find out more about how to use these functions on [GitHub](https://github.com/moj-analytical-services/s3tools) or by using the help operator in RStudio (for example, `?s3tools::write_file_to_s3`). Note, that when writing a file to S3 using S3 tools, the pattern used should be `write_file_to_s3('file', 'bucket/file')` as the file writer will default to a name of NA if no other name is supplied.

#### `botor`

`botor` will replace `s3tools` on newer versions of RStudio which use `renv` for managing environments. If your project isn’t yet set up to use renv, before you start installing packages, you need to enable for your project in RStudio. You do this by navigating to the Tools menu and going through the following steps:

Tools -> Project options -> Environments and click on the tick box “Use renv with this project” then press OK.

It requires the Python package `boto3` and will be installed by running the following code:

```{r install-botor-write, eval=FALSE}
renv::init(bare = TRUE) # remove bare = TRUE if you'd like to move your existing packages over to renv
renv::use_python()
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

`botor` contains two functions for downloading or reading files from Amazon S3:

* `s3_upload_file`
* `s3_write`

For example, to write a dataframe to csv, run the following code:

```{r botor-read-example}
library(botor)
s3_write(your_df, write.csv, "s3://your_bucket/your_key.csv")
```

You can find out more about how to use these and other functions in the [Migrating to botor](../../appendix/botor.html#migrating-to-botor) appendix, the [botor documentation](https://daroczig.github.io/botor/reference/index.html) or by using the help operator in RStudio (for example, `?botor::s3_write`).

### JupyterLab

#### `mojap-arrow-pd-parser`

Snappily named `mojap-arrow-pd-parser` provides easy csv, jsonl and parquet file writers. To install in terminal:

```bash
pip install arrow-pd-parser
```

To write a dataframe (df) to a csv file in s3:

```python
from arrow_pd_parser import writer
writer.write(df, "s3://bucket_name/file.csv")
```

`mojap-arrow-pd-parser` infers the file type from the extension, so for example `writer.write(df, "s3://bucket_name/file.snappy.parquet")` would write a (snappy compressed) parquet file without need for specifying the file type.

The package also has a lot of other functionality including specifying data types when writing (or reading). More details can be found in the package [README](https://github.com/moj-analytical-services/mojap-arrow-pd-parser#mojap-arrow-pd-parser).

#### `boto3`

You can upload files in JupyterLab on the Analytical Platform to Amazon S3 using the `boto3` package.

You can install `boto3` by running the following code in a terminal:

```
pip install boto3
```

To upload a file to Amazon S3, use the following code:

```
import boto3

s3 = boto3.resource('s3')
s3.Object('bucket_name', 'key').put(Body=object)
```

If you receive an `ImportError`, try restarting your kernel, so that Python recognises your `boto3` installation.

Here, you should substitute `'bucket_name'` with the name of the bucket, `'key'` with the path of the object in Amazon S3 and `object` with the object you want to upload.

You can find more information in the [package documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Object.put).

## Download or read files from Amazon S3

### Amazon S3 Console

You can use the Amazon S3 Console to download files to your local computer (for example, personal or shared storage on DOM1 or Quantum) only.

To download a file using the Amazon S3 Console:

1.  Log in to the [AWS Management Console](https://aws.services.alpha.mojanalytics.xyz) using your Analytical Platform account.
2.  Select __Services__ from the menu bar.
3.  Select __S3__ from the drop down menu.
4.  Select the file you want to download.
5.  Select __Download__ or __Download as__ as appropriate.

You can also directly navigate to a bucket in the AWS S3 Console by selecting __Open on AWS__ in the Analytical Platform control panel.

### RStudio

You can download or read files in RStudio on the Analytical Platform from Amazon S3 using the `s3tools`, `s3browser`, or , for newer versions of RStudio, `botor` packages.

#### `s3tools`

`s3tools` should be preinstalled for all users of the Analytical Platform. If you find that `s3tools` is not installed, you can install it by running the following code:

```{r install-s3-tools-2, eval=FALSE}
install.packages('remotes')
library(remotes)
remotes::install_github('moj-analytical-services/s3tools')
```

`s3tools` contains four functions for downloading or reading files from Amazon S3:

*   `download_file_from_s3`
*   `s3_path_to_df`
*   `s3_path_to_full_df`
*   `s3_path_to_preview_df`

You can find out more about how to use these functions on [GitHub](https://github.com/moj-analytical-services/s3tools) or by using the help operator in RStudio (for example, `?s3tools::download_file_from_s3`).

#### `s3browser`

`s3browser` provides a user interface within R that allows you to browse files you have access to in Amazon S3.

You can install `s3browser` by running the following code:

```{r install-s3-browser, eval=FALSE}
install.packages('remotes')
library(remotes)
remotes::install_github('moj-analytical-services/s3browser')
```

To open the browser, run:

```{r run-s3browser, eval=FALSE}
s3browser::file_explorer_s3()
```
You can find out more about how to use `s3browser` on [GitHub](https://github.com/moj-analytical-services/s3browser).

#### `botor`

`botor` will replace `s3tools` on newer versions of RStudio which use `renv` for managing environments. If your project isn't yet set up to use `renv`, before you start installing packages, you need to enable for your project in RStudio. You do this by navigating to the Tools menu and going through the following steps:

Tools -> Project options -> Environments and click on the tick box “Use renv with this project” then press OK.

It requires the Python package `boto3` and will be installed by running the following code:

```{r install-botor-read, eval=FALSE}
renv::init()
renv::use_python()
renv::install('reticulate')
reticulate::py_install('boto3')
renv::install('botor')
```

`botor` contains two functions for downloading or reading files from Amazon S3:

* `s3_download_file`
* `s3_read`

For example, to read a dataframe to csv, run the following code:

```{r botor-read-example}
library(botor)
your_df <- s3_read(read.csv, "s3://your_bucket/your_key.csv")
```

You can find out more about how to use these and other functions in the [Migrating to botor](../../appendix/botor.html#migrating-to-botor) appendix, the [botor documentation](https://daroczig.github.io/botor/reference/index.html) or by using the help operator in RStudio (for example, `?botor::s3_write`).

### JupyterLab


#### `mojap-arrow-pd-parser`

`mojap-arrow-pd-parser` provides easy csv, jsonl and parquet file readers. To install in terminal:

```bash
pip install arrow-pd-parser
```

To read a csv file from s3:

```python
from arrow_pd_parser import reader
reader.read("s3://bucket_name/file.csv")
```

`mojap-arrow-pd-parser` infers the file type from the extension, so for example `reader.read("s3://bucket_name/file.parquet")` would read a parquet file without need for specifying the file type.

The package also has a lot of other functionality including specifying data types when reading (or writing). More details can be found in the package [README](https://github.com/moj-analytical-services/mojap-arrow-pd-parser#mojap-arrow-pd-parser).

#### `pandas`

You can use any of the `pandas` read functions (for example, `read_csv` or `read_json`) to download data directly from Amazon S3. This requires that you have installed the `pandas` and `s3fs` packages. To install these, run the following code in a terminal:

```
python -m pip install pandas s3fs
```

As an example, to read a CSV, you should run the following code:

```
import pandas as pd
pd.read_csv('s3://bucket_name/key')
```

Here, you should substitute `bucket_name` with the name of the bucket and `key` with the path of the object in Amazon S3.

#### `boto3`

You can also download or read objects using the `boto3` package.

You can install `boto3` by running the following code in a terminal:

```
pip install boto3
```

To download a file from Amazon S3, you should use the following code:

```
import boto3

s3 = boto3.resource('s3')
s3.Object('bucket_name', 'key').download_file('local_path')
```

If you receive an `ImportError`, try restarting your kernel, so that Python recognises your `boto3` installation.

Here, you should substitute `'bucket_name'` with the name of the bucket, `'key'` with the path of the object in Amazon S3 and `local_path` with the local path where you would like to save the downloaded file.

You can find more information in the [package documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Object.download_file).

#### `AWS Data Wrangler`

You can also use `AWS Wrangler` to work with data stored in Amazon S3.

More information can be found in the [product documentation](https://aws-data-wrangler.readthedocs.io/en/stable/tutorials/003%20-%20Amazon%20S3.html).
