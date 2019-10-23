# About the Analytical Platform

## What is the Analytical Platform?

The Analytical Platform is a cloud–based system that provides a range of services, tools and resources to analysts across MoJ.

The Analytical Platform:

*   provides access to the latest versions of open–source analytical software, such as RStudio and JupyterLab, allowing analysts to work in the way that suits them best
*   allows analysts to freely install packages from CRAN and PyPI, enabling them to utilise advanced analytical tools and techniques, including text mining, predictive analytics and data visualisation
*   uses Amazon S3 and Athena to provide a single location for all of our data, including a growing set of curated data, and GitHub to provide a single location for all of our code -- this enables analysts to collaborate more effectively, share knowledge and produce high–quality reproducible analysis
*   allows analysts to build and deploy interactive apps and web pages that can be used to communicate analysis and insight to decision–makers
*   gives analysts the tools to develop reproducible analytical pipelines (RAPs) to automate time–consuming and repetitive tasks, allowing them to focus on interpreting the results
*   is built in a cloud–based ecosystem that is easy to access remotely from all MoJ IT systems and provides analysts with access to powerful computational resources that can be scaled to meet demand -- this allows analysts to quickly and easily work with big data and perform complex analytical tasks
*   is secure, resilient and has high availability -- this means analysts can depend on it to store their work and data, and to complete time–sensitive and business–critical projects

## What can I use the Analytical Platform for?

## How does the Analytical Platform work? 

The Analytical Platform consists of several different services and tools:

<div style="height:0px;">&nbsp;</div>
Service/tool                                                                                       | Description
---                                                                                                |---
[Control panel](https://cpanel-master.services.alpha.mojanalytics.xyz)                             | The control panel provides a gateway to access analytical tools, including RStudio and JupyterLab, and allows you to manage your access to data in Amazon S3.
[Airflow](https://airflow.services.alpha.mojanalytics.xyz)                                         | Airflow is a tool used to schedule and monitor processing pipelines.
[Kibana](https://kibana.services.alpha.mojanalytics.xyz)                                           | Kibana allows you to search and query the logs of deployed apps.
[Concourse](https://concourse.services.alpha.mojanalytics.xyz)                                     | Concourse is a continuous integration tool used to build, test and deploy apps.
[RStudio](https://cpanel-master.services.alpha.mojanalytics.xyz/#Analytical%20tools)               | RStudio is an integrated development environment for R.
[JupyterLab](https://cpanel-master.services.alpha.mojanalytics.xyz/#Analytical%20tools)            | JupyterLab is an interface that allows you to work with interactive notebooks, text editors and terminals in a number of different languages, including Python.
[Amazon Web Services (AWS)](https://aws.services.alpha.mojanalytics.xyz)                           | AWS is a cloud computing platform that provides a large number of different services. The Analytical Platform itself is hosted on AWS. We also use Amazon S3 to store data and Amazon Athena to run database queries.  
[GitHub](https://github.com/moj-analytical-services)                                               | GitHub is an online platform used to store version-controlled code. GitHub allows you to collaborate easily on shared projects and to review and quality assure the code of others.
<div style="height:0px;">&nbsp;</div>

The Analytical Platform is also used to host apps that can be shared with customers across MoJ and beyond.

### Typical workflow (how do things work together)

A diagram might be useful!

*   Upload data to the AP (if not already there)
*   Create a GitHub repository and clone
*   Access data from S3 or using Athena
*   Use analytical tools to perform analysis and produce outputs and products, including apps

### Security

How is the Analytical Platform secured?

### Data retention

#### Amazon S3

* Files stored in Amazon S3 are retained indefinitely until they are deleted
* Files stored in Amazon S3 are backed up automatically
* Once files are deleted from Amazon S3, they are deleted permanently along with all backups and cannot be restored unless the bucket is versioned. Versioning is disabled by default

#### Home directory

* Files stored in users' home directories are retained indefinitely until they are deleted
* Files stored in users' home directories are backed up to Amazon S3 automatically
* Previous versions of files stored in users' home directories are also backed up to Amazon S3
* Once files are deleted from a user's home directory, the backup is retained for a further 90 days and can be restored
* To request that a file be restored or to access a previous version of a file, email [analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk)

## Location

 All data on the Analytical Platform is stored and processed within the EU.