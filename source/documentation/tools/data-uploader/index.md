Instructions for users

![](Aspose.Words.97c294da-8b7c-4219-91f8-260b7d2b9b38.001.png) [Why use the Uploader?](#_page0_x56.41_y291.16)

- [Authentication/Accounts](#_page0_x56.41_y405.98)
  - [Uploader flowchart ](#_page0_x56.41_y472.84)![](Aspose.Words.97c294da-8b7c-4219-91f8-260b7d2b9b38.002.png) [Front page](#_page1_x56.41_y214.10)
    - [Troubleshooting front page](#_page1_x56.41_y259.52)
    - [Step 1 of 4: Data Governance Requirements ](#_page1_x56.41_y441.20)![](Aspose.Words.97c294da-8b7c-4219-91f8-260b7d2b9b38.003.png) [Step 2 of 4: Choose Database](#_page1_x56.41_y494.27)
      - [Troubleshooting step 1](#_page1_x56.41_y581.53)
      - [Step 3 of 4: Choose Table](#_page1_x56.41_y684.11)
        - [Troubleshooting step 2 ](#_page2_x56.41_y74.78)![](Aspose.Words.97c294da-8b7c-4219-91f8-260b7d2b9b38.004.png) [Step 4 of 4: Check your inputs before uploading your data](#_page2_x56.41_y192.16)
          - [Troubleshooting step 4](#_page2_x56.41_y265.13)
        - [Upload complete](#_page2_x56.41_y349.34)

**Why use the Uploader?**

The Uploader is aimed at colleagues who have data not already on the MoJ Analytical Platform and wish to upload them there to be able to apply Analytical Platform tools, such as Athena. Only tables created from this tool can be added to from this tool.

The Uploader is intended to be a simple user interface for uploading data to an AWS S3 bucket on the MoJ Analytical Platform. It removes the requirement for colleagues to be familiar with the more technical AWS interface, and enables automated validation of data storage standards and schemas. 

**Authentication/Accounts**

This uploader uses single sign on (SSO) authentication provided by Auth0. Open a pull request from a new branch to add your email to the [user list](https://github.com/ministryofjustice/analytical-platform-uploader/blob/main/application/users/uploader_users.yaml) to gain access. A member of the team will approve the pull request, and after a few hours login should work.

**Uploader flowchart**

Data is stored in the S3 bucket in an SQL like structure with one or more databases at the top level, each of which may contain one or more data tables. If the database or data table already exists it will be available to choose in a drop down list, if not it must be created.

When subsequent new data files are added to a data table they will be stored as separate partitions of that data table, and any schema changes will be represented in the final table as a union of every partition.  **Note**: the existing permissions infrastructure means that you can add to ANY table created by the uploader. Please check that the table selected for upload is correct so that time consuming rollbacks are not required.

Automated validation is applied to the data pre upload to check the basics - there are checks that column names exist and are in the character set [A-Za-z0-9\_].

![](Aspose.Words.97c294da-8b7c-4219-91f8-260b7d2b9b38.005.jpeg)

**Front page**

Go to the [uploader front page ](https://data-eng-uploader-dev.apps.live.cloud-platform.service.justice.gov.uk/)and if the data meets the criteria click on :start\_now: **Troubleshooting front page**



|**Problem** |**Solution**|
| - | - |
|data file is a bit larger than 5 GB|<p>chop the data into multiple files and upload one at a time </p><p>re max file upload see docs/blogs [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/upload-objects.html), [here (option 3)](https://dev.to/jsangilve/uploading-files-to-s3-with-serveless-4ai1) and [here](https://sookocheff.com/post/api/uploading-large-payloads-through-api-gateway/#:~:text=API%20Gateway%20supports%20a%20reasonable,to%20allow%20uploads%20through%20S3)</p>|
|data file is very much larger than 5 GB|Uploader tool is currently impractical; upload via AWS console. Future Uploader may allow multi-part upload to 5 TB. |
|data is not in one of the 3 supported formats (.csv, .json, .jsonl)|convert it; for example if is .xlsx you can easily convert to .csv |
|uploading data violates [data governance ](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/)requirements|![](Aspose.Words.97c294da-8b7c-4219-91f8-260b7d2b9b38.006.png) **STOP!** you may not upload these data|
|do not have access to Analytical Platform|work through the steps to get an account [here](https://user-guidance.services.alpha.mojanalytics.xyz/get-started.html#get-started)|
|do not have access to the required database|request access [here](https://github.com/moj-analytical-services/data-engineering-database-access)|
|I want to replace existing data on the Analytical Platform|this is not possible with the Uploader. Consider this action may conflict with reproducibility principles.|
|I want to upload multiple files|this is currently not possible via the Uploader|

**Step 1 of 4: Data Governance Requirements**

It is your responsibility to complete any relevant [data governance ](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/)requirements before proceeding to upload data to the Analytical Platform.

**Step 2 of 4: Choose Database**

If your data is not part of an existing database select the option to create a new database, and specify the new database name. Permitted characters include lower case alphanumeric characters and underscore {a-z, 0-9, \_*}.* Note that new database names will be automatically prefixed with “data\_eng\_uploader\_<env>\_”, where <env> is either “dev”, “preprod” or “prod”. Otherwise, choose the existing database from the drop down menu.

**Troubleshooting step 1**



|**Problem**|**Solution**|
| - | - |
|database is not listed in the drop down menu|only databases created via the Uploader will be accessible and a newly created database may take up to 24 hours to appear|
|I want to change the name of an existing database|you cannot do this via Uploader; names may only be changed by someone with admin rights and doing so may violate reproducibility principles|
**Step 3 of 4: Choose Table**

If you have created a new database at step 2 the only option is now to create a new data table. Permitted characters include lower case alphanumeric characters and underscore {a-z, 0-9, \_}. If you are adding to an existing database there will be options to create a new data table or add to an existing data table. 

**Note**: the existing permissions infrastructure means that you can add to ANY table created by the uploader. Please check that the table selected for upload is correct so that time consuming rollbacks are not required.

**Troubleshooting step 2**



|**Problem**|**Solution**|
| - | - |
|data table is not listed in the drop down menu|only data tables created via the Uploader will be accessible and a newly created data table may take up to 24 hours to appear|
|there is no option to select an existing data table|reconsider your input to step 2, click “Back” at the top of the screen|
|I want to change the name of an existing data table|you cannot do this via Uploader; names may only be changed by someone with admin rights and doing so may violate reproducibility principles|
**Step 4 of 4: Check your inputs before uploading your data**

Double check your inputs to the previous three steps, in particular check you are happy with any new database and data table names as you will not be able to change these easily after uploading. If all is OK proceed with :choose\_file: and :upload\_data:. Otherwise click on the **Back** navigation button near the top of the screen to return to previous steps and amend your inputs. 

**Troubleshooting step 4**



|**Problem**|**Solution**|
| - | - |
|error pop-up “data is larger than 5GB”|see [Troubleshooting front page ](#_page1_x56.41_y259.52) above|
|error pop-up “data is not CSV, JSON or JSONL”|see [Troubleshooting front page ](#_page1_x56.41_y259.52) above|

**Upload complete**

It can take up to 24 hours for newly created database, data table and newly uploaded data to appear on the Analytical Platform. If you have created a new database the next step is to request access to it from the Analytical Platform; instructions to do so may be found [here](https://github.com/moj-analytical-services/data-engineering-database-access).