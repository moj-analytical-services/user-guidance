# Overview

The Analytical Platform (AP) is a data analysis platform made up of tools, packages and datasets for creating applications that utilise data within the Ministry of Justice (MoJ). The AP provides development environments in both Python (JupyterLab) and R (RStudio), allowing you multiple ways to query, analyse and model data.

This site provides instructions on how to configure and use the AP.

## Intended users

Primarily intended for data analysts in the Data and Analytical Services Directorate, the Analytical Platform also hosts users from:
-   Criminal Injury Claims (CICA)
-   HM Courts & Tribunals Service (HMCTS)
-   HM Prison and Probation Service (HMPPS)
-   Legal Aid Agency (LAA)
-   Office of the Public Guardian (OPG)

We can also host other MoJ organisations. [Contact us][contact] to discuss your options.

### Knowledge requirements

The Analytical Platform incorporates a variety of technical tools and concepts. While our community provide basic training materials on how to use some of these, to use the platform, as a minimum we recommend you have working knowledge of the following:

- Amazon Athena and S3: to create, manipulate and query data
- GitHub and GitHub actions: to manage your application code
- Python or R: to develop applications on the Analytical Platform
- SQL: to query and transform data

## Benefits

In additional to Python and R compatibility, benefits of using the Analytical Platform include:

- **modern data tools and services**:
  - the ability to freely install packages from CRAN and PyPI to perform advanced analytical techniques, such as text mining, predictive analytics and data visualisation
  - compatiblity with current cloud data services, such as Amazon Athena, Glue and Redshift, offering scalability and a managed service at commodity pay-as-you-go prices
- **centralised data**:
  - our Data Engineering team converts raw data from operational systems into structures and excerpts
  - we hold data files in Amazon S3 for ease of use, to load into your code or run SQL queries directly using Amazon Athena
  - users can also upload data to the AP from other sources and share them with granular access controls, subject to normal data protection processes; for more information, see [Information governance][information-governance.md]
- **reproducible analysis**: the AP provides tools to develop reproducible analytical pipelines (RAPs) to automate time–consuming and repetitive tasks, allowing you to focus on interpreting the results with the following elements:
  - when datasets are imported into the AP, snapshots of them are taken and versioned
  - standardised system libraries in GitHub
  - a standardised virtual machine that can run R Studio or Jupyter, or code running in an explicitly defined Dockerfile
- **secure environments**: we host the Analytical Platform in a cloud-based ecosystem that is easy to access remotely from all MoJ IT systems. Designed for data at security classifications OFFICIAL and OFFICIAL-SENSITIVE, we follow NCSC Cloud Security Principles, implementing features such as:
  - two-factor authentication
  - data encryption at rest and in transit
  - granular access control
  - extensive tracking of user behaviour, user privilege requests/changes and data flows
  - multiple isolation levels between users and system components
  - resilience and high availability to provide optimal performance and uptime

> **Note**: The Analytical Platform does not currently provide the following:
- production apps at scale
- management information
- real-time data; however, the Airflow tool can schedule data processing as frequently as every few minutes
- pure data archival: Amazon S3, which the AP uses for data storage, does not offer index or search facilities
  - we can set up a custom bucket policy to archive data to S3-IA or Glacier but recommend exploring SaaS alternatives, such as SharePoint or Google Drive

[contact]: mailto:analytical_platform@digital.justice.gov.uk
