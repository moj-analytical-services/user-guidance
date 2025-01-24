# Amazon S3

## What is Amazon S3?

[Amazon S3](https://aws.amazon.com/s3/) is a web-based cloud storage platform. It is one of the primary file storage locations on the Analytical Platform, alongside individual users' home directories.

When working in [Analytical Platform IDE tools](../../tools/#integrated-development-environments-ide), you should use your home directory to store working copies of code and analytical outputs. Where possible, you should store all data and final analytical outputs in Amazon S3, and final code in GitHub to facilitate collaboration.

Data stored in Amazon S3 can be seamlessly integrated with other AWS services such as Amazon Athena and Amazon Glue.

## Working with Amazon S3 buckets

There are 2 parts to an S3 bucket: the bucket itself, and the bucket keys (similar to a file path). For example, data might be stored in a `moj_ap_project_output` bucket, and the files you are working on are in the `project_output/latest/` 'folder' within the bucket (matching the `/project_output/latest/*` key pattern).

Amazon S3 buckets are separated into two categories on the Analytical Platform.

#### Warehouse data sources

Warehouse data sources are used to store data that is accessed by code you run yourself, for example, in RStudio or JupyterLab. You can [create warehouse data sources](#create-a-new-warehouse-data-source) yourself and can provide access to other users you need to collaborate with.

#### Webapp data sources

Webapp data sources are used to store data that is accessed by code run by the Analytical Platform, for example by deployed apps or by Airflow pipelines. You cannot create webapp data sources yourself – you must ask the Analytical Platform team to create one on your behalf.

If you request that a webapp data source is created when setting up a new app, the app will automatically be given read-only access. You will also be given admin access to the bucket and can provide access to other users you need to collaborate with.

The Data Engineering team also manage some buckets that are not shown in the Control Panel and that are not available to standard users. These buckets are used to store incoming raw data, which may be processed or fed into curated data pipelines. For more information, contact the Data Engineering team on the [#ask-data-engineering](https://app.slack.com/client/T1PU1AP6D/C8X3PP1TN) Slack channel.

You can view the data sources you have access to in the Control Panel **Warehouse data** tab.

### Create a new warehouse data source

You can only create new warehouse data sources in the Analytical Platform Control Panel. You cannot create new buckets directly in the Amazon S3 console.

To create a new warehouse data source:

1.  Go to the Analytical Platform [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
2.  Select the **Warehouse data** tab.
3.  Select **Create new warehouse data source**.
4.  Enter a name for the warehouse data source -- this must be prefixed with 'alpha-'.
5.  Select **Create data source**.

When you create a new warehouse data source, only you will initially have access. As an admin of the data source, you will be able to add and remove other users from the data access group as required. Further information on managing data access groups can be found [here](#manage-access-to-a-bucket).

### Data access levels

Every bucket has three data access levels:

- Read only
- Read/write
- Admin
  - this provides read/write access and allows the user to add and remove other users from the bucket's data access group

### Path-specific access

As well as choosing an access level, you can also restrict a user's access to specific paths in a bucket by entering each path on a new line in the 'Paths' textarea field when adding the user to a data access group, taking care not to leave an empty new line after the last path. For example:

    /folder-one
    /folder-two

This would give the user access to only `/folder-one` and `/folder-two` in the bucket and nothing else.

If you leave this field blank, the user will be able to access everything in the bucket.

### Request access to a bucket

To gain access to a bucket (warehouse data source or webapp data source), you must be added to the relevant data access group.

If you know an admin of the bucket you require access to, you should ask them to add you to the data access group.

If you do not know any of the admins of the bucket you require access to, you can find a list of the GitHub usernames of all bucket admins on the Warehouse Data page of Control Panel (scroll down the page), or contact the Analytical Platform team via [Slack](https://app.slack.com/client/T02DYEB3A/C4PF7QAJZ), [GitHub](https://github.com/ministryofjustice/data-platform-support/issues/new/choose) or email ([analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk)).

If all bucket admins are unavailable (e.g. have left the MoJ), the Analytical Platform team will be able to grant you access to the datasource if the request is approved by your line manager.

When requesting access to a bucket, you should specify the name of the bucket and the level of access you require. You should only request access to data that you have a genuine business need to access and should only request the lowest level of access required for you to complete your work. You may be required to demonstrate the business need for you to access a bucket if requested by a bucket admin or an information asset owner (IAO).

### Manage access to a bucket

Bucket admins can manage access to warehouse data sources and webapp data sources in the Analytical Platform [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/). You cannot manage access to buckets directly in the Amazon S3 console.

To manage access to a data source:

1.  Go to the Analytical Platform [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
2.  Select the **Warehouse data** tab or the **Webapp data** tab, as relevant.
3.  Select the name of the data source you want to manage.

To add a new user to the data access group (users must already be members of the Analytical Platform):

1.  Type the user's GitHub username into the input field labelled **Grant access to this data to other users**.
2.  Select the user from the drop-down list.
3.  Select the required data access level.
4.  Either leave the 'Paths' field blank or enter a list of paths to provide restricted access, as described in the section above.
5.  Select **Grant access**.

To edit the access level of a user:

1.  Select **Edit access level** next to the name of the user.
2.  Select required data access level.
3.  Either leave the 'Paths' field blank or enter a list of paths to provide restricted access, as described in the section above.
4.  Select **Save**.

To remove a user from the data access group:

1.  Select **Edit access level** next to the name of the user.
2.  Select **Revoke access**.

## Interacting with Amazon S3 via the Analytical Platform

You can upload files to Amazon S3 from your local computer or download files from Amazon S3 to your local computer using below tools

- Amazon S3 console
- RStudio
- JupyterLab

When _uploading_ files to Amazon S3, you should ensure that you follow all necessary [information governance](../../information-governance.html) procedures. In particular, **you must complete a data movement form when moving any data onto the Analytical Platform**.

_Downloading_ the data from Amazon S3 to your local machine is also considered as data movement and therefore needs to be managed as such in accordance with the necessary [information governance](../../information-governance.html) procedures, particularly for Personal Identifiable Information (PII).

### Your options

This section presents a comparison of the various tools available for accessing Amazon S3 on each platform; further details on setup and usage are given below.

#### AWS Console

The AWS S3 Console is a browser-based GUI tool. You can use the Amazon S3 console to view an overview of an object. The object overview in the console provides all the essential information for an object in one place.

For further details, see the [guide](#amazon-s3-console) further down the page.

#### RStudio

There are two main options for interacting with files stored in AWS S3 buckets on the Analytical Platform via RStudio: `Rs3tools` and `botor`. Either of these options works well on the Analytical Platform, and you should pick whichever best suits your use-case.

`Rs3tools` is an R-native community-developed MoJ project which consists of a set of helper tools to access Amazon S3 buckets on the Analytical Platform.

The installation process for `botor` takes longer as it requires a Python environment (`botor` is a wrapper around Python's `boto3` library). However, it contains a larger range of functionality.

Generally, we recommend using `Rs3tools` unless there is a specific need for the additional functionality in `botor`.

You may also see mentions of another tool, `s3tools`. `s3tools` is now deprecated and has been replaced by `Rs3tools`.More information is available in this [ADR Record](https://silver-dollop-30c6a355.pages.github.io/documentation/30-architecture/40-architecture-decision-records/104-ADR104-replacing-s3tools.html#adr104-replacing-s3tools-with-botor)

Most of the original functionality is available via `Rs3tools`, so this is a good replacement if you are looking to update older code that relied on the `s3tools` package. If you need the additional functionality available in `botor`, we have published [a guide to migration](../../appendix/botor.html#migrating-to-botor).

In addition, an RStudio plugin, `s3browser` is available if you only want to browse your files.

For further details, see the relevant sections for [`Rs3tools`](#rs3tools), [`botor`](#botor) and [`s3browser`](#s3browser).

#### JupyterLab / VSCode

The main options for interacting with files stored in AWS S3 buckets on the Analytical Platform via JupyterLab and VSCode include:

- [`polars`](https://docs.pola.rs/)
- [`pandas`](https://pandas.pydata.org/docs/)
- [`awswrangler`](https://pypi.org/project/awswrangler/)
- [`mojap-arrow-pd-parser`](https://github.com/moj-analytical-services/mojap-arrow-pd-parser?tab=readme-ov-file#mojap-arrow-pd-parser)
[`awswrangler`](https://pypi.org/project/awswrangler/)
- [`boto3`](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

### Installation and usage

#### Amazon S3 Console

You can use the Amazon S3 Console to upload/download files from/to your local computer (for example, personal or shared storage on DOM1 or Quantum) only.

To upload files using the Amazon S3 Console:

1.  Log in to the AWS Management Console using your Analytical Platform account via the link at the bottom of the [Analytical Platform Control Panel Tools page](https://controlpanel.services.analytical-platform.service.justice.gov.uk/tools/)
2.  Select **Services** from the menu bar.
3.  Select **S3** from the drop down menu.
4.  Select the bucket and folder you want to upload files to.
5.  Select **Upload**.
6.  Select **Add files** or drag and drop the files you want to upload.
7.  Select **Upload**.

Downloading a file using the Amazon S3 Console follows a similar process:

1.  Follow steps 1-3 from the list above.
2.  Navigate to the bucket and select the file you want to download.
3.  Select **Download** or **Download as** as appropriate.

You can also directly navigate to a bucket in the AWS S3 Console by selecting **Open on AWS** in the Analytical Platform Control Panel.

#### RStudio

##### Rs3tools

To install `Rs3tools` follow the guidance on their [homepage](https://github.com/moj-analytical-services/Rs3tools#installation).

To upload files using `Rs3Tools`

Writing files to S3

```r
Rs3tools::write_file_to_s3("my_downloaded_file.csv", "alpha-everyone/delete/my_downloaded_file.csv", overwrite=TRUE)  # if file already exists, you recieve an error. overwrite=True enables it to overwrite the file
```

Writing a dataframe to S3 in csv format

```r
Rs3tools::write_df_to_csv_in_s3(dataframe_name, "alpha-everyone/delete/iris.csv", overwrite =TRUE)
```

Downloading a file from S3 using `Rs3Tools`

```r
Rs3tools::download_file_from_s3("alpha-everyone/s3tools_tests/iris_base.csv", "my_downloaded_file.csv", overwrite =TRUE)
```

##### botor

You will need to use the package manager `renv` to install `botor`.
To get started with `renv`, see our guidance on the [RStudio package management page](../tools/package-management.html#renv).

Then, go ahead with the `botor` installation (this is slightly different from the guidance on [`botor`'s website](https://daroczig.github.io/botor/#installation) as we use the `renv` package manager):

```r
renv::use_python()    ## at the prompt, choose to use python3
renv::install('reticulate')
```

Restart the session (Ctrl+Alt+F10 on a Windows machine). And then:

```r
reticulate::py_install('boto3')
renv::install('botor')
```

botor contains two functions for downloading or reading files from Amazon S3:

```r
s3_upload_file
s3_write
```

For example, to write a dataframe to csv, run the following code:

```r
library(botor)
s3_write(your_df, write.csv, "s3://your_bucket/your_key.csv")
```

To read files, use one of the following:

```r
s3_download_file
s3_read
```

And use as follows:

```r
library(botor)
your_df <- s3_read(read.csv, "s3://your_bucket/your_key.csv")
```

You can find out more about how to use these and other functions in the [Migrating to botor](../../appendix/botor.html#migrating-to-botor) appendix, the [botor documentation](https://daroczig.github.io/botor/reference/index.html) or by using the help operator in RStudio (for example, `?botor::s3_write`).

#### s3browser

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

### JupyterLab and VSCode (python)

You can read/write directly from s3 using a variety of tools: [awswrangler](https://pypi.org/project/awswrangler/#quick-start), [polars](https://docs.pola.rs/), [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html), [pandas](https://pandas.pydata.org/docs/user_guide/index.html), or [mojap-arrow-pd-parser](https://github.com/moj-analytical-services/mojap-arrow-pd-parser?tab=readme-ov-file#mojap-arrow-pd-parser)

#### `AWS Data Wrangler`

You can also use [`awswrangler`](https://pypi.org/project/awswrangler/#quick-start) to work with data stored in Amazon S3.

To install AWS Wrangler, run the following code in a terminal:

```sh
python -m pip install awswrangler
```

To read a CSV file from S3 using AWS Wrangler:

```py
import awswrangler as wr

# Retrieving the data directly from Amazon S3
df = wr.s3.read_csv("s3://bucket/dataset/", dataset=True)
```

More information can be found in the [product documentation](https://aws-data-wrangler.readthedocs.io/en/stable/tutorials/003%20-%20Amazon%20S3.html).

#### `boto3`

You can also download or read objects using the [`boto3`](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html) package.

You can install `boto3` by running the following code in a terminal:

```bash
python -m pip install boto3
```

To [download a file from Amazon S3](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-example-download-file.html#downloading-files), you should use the following code:

```python
import boto3

s3_client = boto3.client('s3')
s3_client.download_file('bucket_name', 'key', 'local_path')
```

If you receive an `ImportError`, try restarting your kernel, so that Python recognises your `boto3` installation.

Here, you should substitute `'bucket_name'` with the name of the bucket, `'key'` with the path of the object in Amazon S3 and `local_path` with the local path where you would like to save the downloaded file.

To upload a file to Amazon S3, you should use the following code:

```python
#Upload sample contents to s3
s3_client = boto3.client('s3')

data = b'This is the content of the file uploaded from python boto3'
file_name = 'your_file_name.txt'

response = s3_client.put_object(Bucket=your_bucket_name, Body=data, Key=file_name)
print(f"AWS response code for uploading file is {(response['ResponseMetadata']['HTTPStatusCode'])}")
```

You can find more information in the [package documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Object.download_file).

#### `polars`

[`polars`](https://docs.pola.rs/) is a fast DataFrame library implemented in Rust and can be used to read/write data from/to Amazon S3. To install polars and s3fs, run the following code in a terminal:

```bash
python -m pip install polars s3fs
```

To read a CSV file from S3 using polars (see [reading from Cloud storage](https://docs.pola.rs/user-guide/io/cloud-storage/) in the docs):

```py
import polars as pl

source = "s3://bucket/*.csv"

df = pl.read_csv(source)
```

To [write a DataFrame to S3](https://docs.pola.rs/user-guide/io/cloud-storage/#writing-to-cloud-storage#writing-to-cloud-storage):

```py
import polars as pl
import s3fs

df = pl.DataFrame({
    "foo": ["a", "b", "c", "d", "d"],
    "bar": [1, 2, 3, 4, 5],
})

fs = s3fs.S3FileSystem()
destination = "s3://bucket/my_file.parquet"

# write parquet
with fs.open(destination, mode='wb') as f:
    df.write_parquet(f)
```

#### `pandas`

You can use any of the `pandas` read functions (for example, `read_csv` or `read_json`) to download data directly from Amazon S3. This requires that you have installed the `pandas` and `s3fs` packages. To install these, run the following code in a terminal:

```bash
python -m pip install pandas s3fs
```

As an example, to read a CSV, you should run the following code:

```py
import pandas as pd
pd.read_csv('s3://bucket_name/key')
```

Here, you should substitute `bucket_name` with the name of the bucket and `key` with the path of the object in Amazon S3.

#### `mojap-arrow-pd-parser`

`mojap-arrow-pd-parser` provides easy csv, jsonl and parquet file readers. To install in terminal:

```bash
pip install arrow-pd-parser
```

To read/write a csv file from s3:

```python
from arrow_pd_parser import reader, writer

# Specifying the reader Both reader statements are equivalent and call the same readers under the hood
df1 = reader.read("s3://bucket_name/data/all_types.csv", file_format="csv")
df2 = reader.csv.read("s3://bucket_name/data/all_types.csv")

# You can also pass the reader args to the reader as kwargs
df3 = reader.csv.read("s3://bucket_name/data/all_types.csv", nrows = 2)
# The writer API has the same functionality
writer.write(df1, file_format="parquet")
writer.parquet.write(df1)
```

`mojap-arrow-pd-parser` infers the file type from the extension, so for example `reader.read("s3://bucket_name/file.parquet")` would read a parquet file without need for specifying the file type.

The package also has a lot of other functionality including specifying data types when reading (or writing). More details can be found in the package [README](https://github.com/moj-analytical-services/mojap-arrow-pd-parser#mojap-arrow-pd-parser).
