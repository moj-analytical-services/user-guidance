# Overview

The Analytical Platform (AP) is a data analysis platform made up of tools, packages and datasets for creating applications that utilise data within the Ministry of Justice (MoJ). The Analytical Platform provides development environments allowing you to query, analyse and model data in a way which is secure, reproducible and scalable.

![overview of analytical platform](images/overview/analytical-platform.excalidraw.png)

This site provides instructions on how to configure and use the Analytical Platform.

## Intended users

Primarily intended for Data Analysts and Data Scientists in the Data and Analysis Directorates, the Analytical Platform also hosts users from:
- Criminal Injury Claims (CICA)
- HM Courts & Tribunals Service (HMCTS)
- HM Prison and Probation Service (HMPPS)
- Legal Aid Agency (LAA)
- Office of the Public Guardian (OPG)

If you would like to use the Analytical Platform please contact us via the relevant [support](https://github.com/ministryofjustice/data-platform-support/issues/new/choose) route. 

### Knowledge requirements

The Analytical Platform incorporates a variety of technical tools and concepts. To use the platform, as a minimum we recommend you have a working knowledge of the following:

- Amazon Athena and S3 - to create, manipulate and query data
- GitHub and GitHub Actions - to manage your application code
- Python or R - to develop applications on the Analytical Platform
- SQL - to query and transform data

## Benefits of Using the Analytical Platform 

In additional to Python and R compatibility, benefits of using the Analytical Platform include:

### Modern Data Tools and Services

- the ability to freely install packages from CRAN and PyPI to perform advanced analytical techniques, such as text mining, predictive analytics and data visualisation
- compatibility with current cloud data services, such as Amazon Athena, Glue and Redshift, offering scalability and a managed service

### Centralised Data

- our Data Engineering team converts raw data from operational systems into structures and excerpts
- we hold data files in Amazon S3 for ease of use, to load into your code or run SQL queries directly using Amazon Athena
- users can also upload data to the Analytial Platform from other sources and share them with granular access controls, subject to normal data protection processes; for more information, see [Information governance](https://user-guidance.analytical-platform.service.justice.gov.uk/information-governance.html)

### Reproducible Analysis

The Analytical Platform provides tools to develop reproducible analytical pipelines (RAnalytical Platforms) to automate time–consuming and repetitive tasks, allowing you to focus on interpreting the results with the following elements:
- when datasets are imported into the Analytical Platform, snapshots of them are taken and versioned
- standardised system libraries in GitHub
- a standardised virtual machine that can run RStudio, Visual Studio Code or Jupyter, or code running in an explicitly defined Dockerfile

### Secure Environments

The Analytical Platform in hosted in a cloud-based ecosystem that is easy to access remotely from all MoJ IT systems. Designed for data at security classifications OFFICIAL and OFFICIAL-SENSITIVE, we follow NCSC Cloud Security Principles, implementing features such as:
- two-factor authentication
- data encryption at rest and in transit
- granular access control
- extensive tracking of user behaviour, user privilege requests/changes and data flows
- multiple isolation levels between users and system components
- resilience and high availability to provide optimal performance and uptime

### Out of Scope Offerings of the Analytical Platform 

The Analytical Platform does not _currently_ provide the following:
- production Analytical Platforms at scale
- management information
- real-time data; however, the Airflow tool can schedule data processing as frequently as every few minutes
- pure data archival: Amazon S3, which the Analytical Platform uses for data storage, does not offer index or search facilities
- we can set up a custom bucket policy to archive data to S3-IA or Glacier but recommend exploring SaaS alternatives, such as SharePoint or Google Drive

If you would like to raise a feature request this can be done [here](https://github.com/ministryofjustice/data-platform/issues/new/choose).
