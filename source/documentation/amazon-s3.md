# Amazon S3

## What is Amazon S3?

[Amazon S3](https://aws.amazon.com/s3/) is a web-based cloud storage platform. It is one of the primary file storage locations on the Analytical Platform, alongside individual users' home directories.

You should use your home directory to store working copies of code and analytical outputs. Where possible, you should store all data and final analytical outputs in Amazon S3, and final code in GitHub to facilitate collaboration.

Data stored in Amazon S3 can be seamlessly integrated with other AWS services such as Amazon Athena and Amazon Glue.

## Working with Amazon S3 buckets

### Types of buckets

Amazon S3 buckets are separated into two categories on the Analytical Platform:

*   warehouse data sources
*   app data sources

Warehouse data sources are suitable for storing files in all cases, except where the files need to be accessed by a webapp. In this case, files should be stored in an app data source.

### Create a new bucket

Standard users can currently only create new warehouse data sources in the Analytical Platform control panel. You cannot create new buckets directly in the Amazon S3 console.

To create a new warehouse data source:

1.  Go to the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).
2.  Select the __Warehouse data__ tab.
3.  Select __Create a new warehouse data source__.
4.  Enter a name for the warehouse data source -- this must be prefixed with '-alpha'.
5.  Select __Create__.

When you create a new warehouse data source, only you will initially have access. As an admin of the data source, you will be able to add and remove other users from the data access group as required. Further information on managing data access groups can be found [here](#manage-access-to-a-bucket).

### Access levels

Every bucket has three access levels:

*   Read only
*   Read/write
*   Admin -- this provides read/write access and allows the user to add and remove other users from the bucket's data access group

### Request access to a bucket

To gain access to a bucket (warehouse data source or app data source), you must be added to the relevant data access group.

If you know an admin of the bucket you require access to, you should ask them to add you to the data access group.

If you do not know any of the admins of the bucket you require access to, you can ask the Analytical Platform team to add you to the data access group on the [#ap_admin_request](https://asdslack.slack.com/messages/CBLAGCQG6/) Slack channel or by [email](mailto:analytical_platform@digital.justice.gov.uk).

When requesting access to a bucket, you should specify the name of the bucket and the level of access you require. You should only request access to data that you have a genuine business need to access and should only request the lowest level of access required for you to complete your work. You may be required to demonstrate the business need for you to access a bucket if requested by a bucket admin or an information asset owner (IAO).

### Manage access to a bucket

Bucket admins can currently only manage access to warehouse data sources in the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz/). You cannot manage access to buckets directly in the Amazon S3 console.

To manage access to a warehouse data source:

1.  Go to the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).
2.  Select the __Warehouse data__ tab.
3.  Select the name of the warehouse data source you want to manage.

To add a new user to the data access group:

1.  Type the user's GitHub username into the input field labelled __Grant access to this data to other users__.
2.  Select the user from the drop-down list.
3.  Select __Grant access__.

To edit the access level of a user:

1.  Select __Edit access level__ next to the name of the user.
2.  Select the checkbox next to the access level you wish to grant the user.
3.  Select __Save__.

To remove a user from the data access group:

1.  Select __Edit access level__ next to the name of the user.
2.  Select __Revoke access__.

## Upload files to Amazon S3

You can upload files to Amazon S3 from your local computer or from RStudio or JupyterLab.

When uploading files to Amazon S3, you should ensure that you follow all necessary [information governance](#information-governance) procedures. In particular, you must complete a data movement form when moving any data onto the Analytical Platform.

### Amazon S3 Console

You can use the Amazon S3 Console to upload files from your local computer (for example, personal or shared storage on DOM1 or Quantum) only.

To upload files using the Amazon S3 Console:

1.  Log in to the [AWS Management Console](https://http://aws.services.alpha.mojanalytics.xyz) using your Analytical Platform account.
2.  Select __Services__ from the menu bar.
3.  Select __S3__ from the drop down menu.
4.  Select the bucket and folder you want to upload files to.
5.  Select __Upload__.
6.  Select __Add files__ or drag and drop the files you want to upload.
7.  Select __Upload__ -- you do not need to complete steps 2, 3 or 4.

You can also directly navigate to a bucket in the AWS S3 Console by selecting __Open on AWS__ in the Analytical Platform control panel.

### RStudio

You can upload files in RStudio on the Analytical Platform to Amazon S3 using the `s3tools` package.

`s3tools` should be preinstalled for all users of the Analytical Platform. If you find that `s3tools` is not installed, you can install it by running the following code:

```{r install-s3-tools, eval=FALSE}
install.packages('remotes')
library(remotes)
remotes::install_github('moj-analytical-services/s3tools')
```

`s3tools` contains three functions for uploading files to Amazon S3:

*   `write_file_to_s3`
*   `write_df_to_csv_in_s3`
*   `write_df_to_table_in_s3`

You can find out more about how to use these functions on [GitHub](https://github.com/moj-analytical-services/s3tools) or by using the help operator in RStudio (for example, `?s3tools::write_file_to_s3`).

### JupyterLab

You can upload files in JupyterLab on the Analytical Platform to Amazon S3 using the `boto3` package.

You can install `boto3` by running the following code in a terminal:

```
pip install boto3
```

To upload a file to Amazon S3, use the following code:

```
import boto3

s3 = boto3.resource('s3')
s3.object('bucket_name', 'key').put(Body=object)
```

If you receive an `ImportError`, try restarting your kernel, so that Python recognises your `boto3` installation.

Here, you should substitute `'bucket_name'` with the name of the bucket, `'key'` with the path of the object in Amazon S3 and `object` with the object you want to upload.

You can find more information in the [package documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Object.put).

## Download or read files from Amazon S3

### Amazon S3 Console

You can use the Amazon S3 Console to download files to your local computer (for example, personal or shared storage on DOM1 or Quantum) only.

To download a file using the Amazon S3 Console:

1.  Log in to the [AWS Management Console](https://http://aws.services.alpha.mojanalytics.xyz) using your Analytical Platform account.
2.  Select __Services__ from the menu bar.
3.  Select __S3__ from the drop down menu.
4.  Select the file you want to download.
5.  Select __Download__ or __Download as__ as appropriate.

You can also directly navigate to a bucket in the AWS S3 Console by selecting __Open on AWS__ in the Analytical Platform control panel.

### RStudio

You can download or read files in RStudio on the Analytical Platform from Amazon S3 using the `s3tools` or `s3browser` packages.

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

### JupyterLab

#### `pandas`

You can use any of the `pandas` read functions (for example, `read_csv` or `read_json`) to download data directly from Amazon S3. This requires that you have installed the `s3fs` package. To install the `s3fs` package, run the following code in a terminal:

```
pip install s3fs
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
