# About the Analytical Platform

The Analytical Platform is a data analysis environment, providing modern tools and key datasets for MoJ analysts.

## Modern data tools and services

The Analytical Platform provides access to recent versions of open–source analytical software, such as RStudio and JupyterLab, allowing analysts to work in the way that suits them best.

Analysts can freely install packages from CRAN and PyPI, enabling them to utilise advanced analytical tools and techniques, including text mining, predictive analytics and data visualisation. They can also make use of the latest cloud data services, such as Amazon Athena, Glue and Redshift, generally offering scalability and a managed service at commodity pay-as-you-go prices.

Interactive apps and web pages can also be built and deployed by analysts, to communicate analysis and insight to decision–makers.

## Centralised data

Data is ideally brought onto the Analytical Platform in an automated way. The Data Engineering team set up a pipeline that takes raw data from operational systems and converts it to data structures and excerpts that are convenient for use by analysts. Analysts can also upload data to Analytical Platform from other sources and share them with other analysts, subject to normal data protection processes.

Data files are held in Amazon S3 and are available for analysts to load into their code, or run SQL queries directly using Amazon Athena.

Data governance is achieved with a clear process for getting approval to put data on the Analytical Platform for a given use and with fine-grained access controls. The centralization of data storage, sharing and usage on the Analytical Platform allows the department to more easily manage and track compliance.

## Reproducible analysis

Reproducibility is essential for producing high-quality, fully-accountable analysis. It facilitates peer review during production, makes it possible to go back over the methodology if it is called into question, and allows the analysis to be easily built on in the future. Conversely, analysis that is not reproducible is a poor foundation for any decision-making or future work.

The Analytical Platform gives analysts the tools to develop reproducible analytical pipelines (RAPs) to automate time–consuming and repetitive tasks, allowing them to focus on interpreting the results.

Reproducible analytical pipelines are achieved on the Analytical Platform by ensuring that:

* data sets are versioned - snapshots of the data are taken when they are imported into the Analytical Platform with automated pipelines
* code is versioned in GitHub
* system libraries are standardized - a standardized virtual machine running R Studio/Jupyter, or code running in an explicitly defined Dockerfile

GitHub provides a single location for all of our code -- this enables analysts to collaborate more effectively, share knowledge, do peer review and produce high–quality reproducible analysis.

## Secure and well-engineered environment

The Analytical Platform is built in a cloud–based ecosystem that is easy to access remotely from all MoJ IT systems. It provides analysts with access to powerful computational resources that can be scaled to meet demand. This allows analysts to quickly and easily work with big data and perform complex analytical tasks.

The Analytical Platform is designed for data at classified as OFFICIAL and has successfully gained assurance for significant datasets marked OFFICIAL-SENSITIVE. It follows NCSC Cloud Security Principles, implementing features such as:

* two-factor authentication for user sign-in
* encryption of data at rest and in transit
* fine-grained access control
* extensive tracking of user behaviour, user privilege requests/changes and data flows
* multiple levels of isolation between users and system components
  
Resilience and high availability means analysts can depend on the Analytical Platform to store their work and data, and to complete time–sensitive and business–critical projects.

## Extent of the platform

The Analytical Platform does a lot, but data is a big subject and the Analytical Platform doesn't try to do everything. The following are currently out of scope.

### Production apps at scale

Apps on the Analytical Platform should be restricted to private prototypes or should only be used by a small number of staff users (for example, less than 50). In particular, they should not be used for critical or official line of business purposes.

A key benefit of the Analytical Platform is that analysts and data scientists have all the tools to be creative and experimental with interactive dashboards and apps in a safe sandbox environment. In addition, simple apps for a few staff – for example, for searching through data, are fine. You should bear the following points in mind when developing an app.

The Analytical Platform's app deployment system is not designed for production and is subject to change. We're looking to add security scanning, auto-scalability and dev deployments, so there could be occasional service issues and outages. You should therefore assume that apps will be available only 95% of the time.

The Analaytical Platform is not supported outside of office hours. This is not suitable for many web services that are available 24 hours a day.

Analysts are experts in the data aspects of a web service, and should let other specialists tackle the challenges along the delivery path to production-grade software. Running a production service needs support, patching dependencies, adjusting it to changing user and business needs, and offering support, often outside office hours. Making a service good enough to run at scale [involves](https://www.gov.uk/service-manual/agile-delivery/how-the-beta-phase-works) everything from accessibility, user research and design patterns to performance metrics. Before you invest in building that, you need the confidence that comes of doing an [alpha phase](https://www.gov.uk/service-manual/agile-delivery/how-the-alpha-phase-works), iterating a variety of prototypes with experts like a user researcher and designer. Bearing this in mind, analysts should use Analytical Platform as an environment to rapidly prototype or provide non-critical tools, for use with a restricted pool of staff users, and if successful, work with an MoJ Digital & Technology service team to take it further.

### Management information (MI)

MI is data that is collected and used by a service team to monitor and manage their service day to day. Typically, a business analyst does ad-hoc queries or sets up KPI dashboards, using point-and-click business intelligence (BI) software. Whilst this has considerable overlap with the Analytical Platform, in areas such as data storage, it does not currently provide point-and-click BI software for run queries and generate dashboards. This is because the Analytical Platform's current focus is on analyst users, who perform more complex analysis and require high-quality outputs for national statistics and policy formation. This is best supported by using code and ensuring it is reproducible.

In addition, MI is something that nearly every team in the department needs to do, and is likely to be closely coupled with the service's systems and business needs. It is not therefore anticipated that BI software will be directly integrated into the Analytical Platform. However, data on the Analytical Platform can be accessed using secure internet APIs, making it accessible to BI software (although not BI software that is restricted to internal networks).

### Real-time data

The Analytical Platform provides access to a tool called Airflow, which can schedule data flows and processing as frequently as every few minutes. However, as you move towards ongoing data processing like this you start to benefit from data streaming technology to provide real-time results, cope with disturbances in the flow rate and manage processing in small batches.

Technically, there is a clear route to enabling data streaming on the Analytical Platform using Apache Kafka or managed cloud services, which we can explore when the need arises.

### Pure data archival

Data often needs to be retained safely for long periods for possible use in the future. The Analytical Platform offers an assured data storage location, with durability, backups, security and access controls, however:

* Amazon S3 does not provide an ndex and search facility
* AMazon S3 is not the cheapest storage option, however, it is possible to set up custom bucket policies to archive data to S3-IA or Glacier.

SaaS alternatives, typified by SharePoint or Google Drive, may suit pure archival needs better.

## Who is the Analytical Platform for?

The Analytical Platform is primarily for analysts in the Data and Analytical Services Directorate (DASD) in the Ministry of Justice. We also have users from CICA, HMCTS, HMPPS, LAA and OPG. Access for other justice organizations is considered. You can contact us at [analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk) to discuss this.

