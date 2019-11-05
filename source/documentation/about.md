# About the Analytical Platform

The Analytical Platform is a data analysis environment, providing modern tools and key datasets for MoJ analysts.

## Modern data tools and services

The Analytical Platform (AP) provides access to recent versions of open–source analytical software, such as RStudio and JupyterLab, allowing analysts to work in the way that suits them best.

Analysts can freely install packages from CRAN and PyPI, enabling them to utilise advanced analytical tools and techniques, including text mining, predictive analytics and data visualisation. They can also make use of the latest cloud data services, such as Amazon Athena, Glue and Redshift, generally offering scalability and a managed service at commodity pay-as-you-go prices.

Interactive apps and web pages can also be built and deployed by analysts, to communicate analysis and insight to decision–makers.

## Centralised data

Data is brought onto the Analytical Platform ideally in an automated way. The Data Engineering team set up a pipeline that takes raw data from operational systems, and converts it to data structures and excerpts that are convenient for use by analysts. Analysts can also upload data to AP from other sources and share them with other analysts, subject to normal data protection processes.

Data files are held in Amazon S3 and are available for analysts to load into their code, or run SQL queries directly using Amazon Athena.

Data governance is achieved with a clear process for getting approval to put data on the platform for a given use, and fine-grained access controls. AP's centralization of data storage, sharing and usage allows the department to more easily manage and track compliance.

## Reproducible analysis

'Reproducibility' is essential for producing high quality, fully accountable analysis. It facilitates peer-review during production, makes it possible to go back over the method if it is called into question and allows the analysis to be easily built on in the future. Conversely, unreproducible analysis is a poor foundation for any decision-making or future work.

AP gives analysts the tools to develop reproducible analytical pipelines (RAPs) to automate time–consuming and repetitive tasks, allowing them to focus on interpreting the results.

Reproducible analytical pipelines are achieved in AP with three elements:

* datasets are versioned - snapshots of the data are taken when imported into AP with automated pipelines
* code is versioned - in GitHub
* system libraries are standardized - a standardized virtual machine running R Studio/Jupyter, or code running in an explicitly defined Dockerfile

GitHub provides a single location for all of our code -- this enables analysts to collaborate more effectively, share knowledge, do peer review and produce high–quality reproducible analysis

## Secure and well-engineered environment

AP is built in a cloud–based ecosystem that is easy to access remotely from all MoJ IT systems. It provides analysts with access to powerful computational resources that can be scaled to meet demand -- this allows analysts to quickly and easily work with big data and perform complex analytical tasks.

AP is designed for data at security classification OFFICIAL and has successfully gained assurance for significant datasets marked OFFICIAL-SENSITIVE. It follows NCSC Cloud Security Principles, implementing features such as:

* 2 factor authentication for user sign-in
* encryption of data at rest and in transit
* fine-grained access control
* extensive tracking of user behaviour, user privilege requests/changes and data flows
* multiple levels of isolation between users and system components
  
Resilience and high availability means analysts can depend on AP to store their work and data, and to complete time–sensitive and business–critical projects.

## Extent of the platform

AP does a lot, but data is a big subject and AP doesn't try to do everything. These things are currently outside scope:

### Production apps at scale

Apps on AP should be restricted to private prototypes or used by a small number of staff users (e.g. less than 50). In particular they should not be used for critical or official line of business uses.

A key benefit of AP is that analysts and data scientists have all the tools to be creative and experimental with interactive dashboards and apps, in a safe sandbox environment. In addition, simple apps for a few staff e.g. for searching through data are fine. And whilst AP's tools like RStudio and Jupyter can be relied upon:

* AP's app deployment system is not designed for production and subject to change. We're looking to add security scanning, auto-scalability, dev deployments, so expect occasional turbulence. Please assume apps will be available only 95% of the time.
* AP offers no support outside office hours, which is not suitable for many web services that are available 24h.
* Analysts are experts in the data aspects of a web service, and should let other specialists tackle the challenges along the delivery path to production-grade software. Running a production service needs support, patching dependencies, adjusting it to changing user and business needs, and offering support, often outside office hours. Making a service good enough to run at scale [involves](https://www.gov.uk/service-manual/agile-delivery/how-the-beta-phase-works) everything from accessibility, user research and design patterns to performance metrics. Before you invest in building that, you need the confidence that comes of doing an [alpha phase](https://www.gov.uk/service-manual/agile-delivery/how-the-alpha-phase-works), iterating a variety of prototypes with experts like a user researcher and designer. So analysts should use AP as an environment to rapidly prototype or provide non-critical tools, for use with a restricted pool of staff users, and if successful, work with an MoJ Digital & Technology service team to take it further.

### MI (Management Information)

MI is data that is collected and used by a service team to monitor and manage their service day-to-day. Typically a business analyst does ad-hoc queries or sets up KPI dashboards, using point-and-click BI (Business Intelligence) software. Whilst this has considerable overlap with AP, such as data storage, it does not currently provide point-and-click BI for queries and dashboards. This is because AP's current focus are analyst users, who do more complex analysis and seek a high quality for national statistics and policy formation, which leads to writing code and ensuring it is reproducible.

In addition, MI is something that nearly every team in the department needs to do, and is likely to be closely coupled with the service's systems and business needs. It is not therefore anticipated that BI will be directly integrated into AP. However AP data is accessible by secure internet API, making it accessible to BI systems (although not BI restricted to internal networks).

### Real time data

AP has Airflow, which can schedule data flows and processing as frequently as every few minutes. However as you move towards on-going data processing like this you start to benefit from data streaming technology, to provide real-time results, cope with disturbances in the flow rate, manage processing in small batches etc. 

Technically there is a clear route to enabling data streaming on AP, such as with Apache Kafka or managed cloud services, which we can explore when the need arises.

### Pure data archival

Data often needs to be retained safely for long periods, for possible use in the future. AP offers an assured place for storing data, with durability, backups, security and access controls. Here are some considerations to bear in mind:

* Index and search facility - S3 doesn't offer these, so a way to extract text from files and provide an index & search interface would need to be found.
* S3 is not the cheapest storage, however we can set-up a custom bucket policy to archive it to S3-IA or Glacier.

SaaS alternatives, typified by Sharepoint or Google Drive, may suit pure archival needs better.

## Who it is for

AP is primarily for analysts in the Data and Analytical Services Directorate in the Ministry of Justice. We also have users from CICA, HMCTS, HMPPS, LAA, and OPG. Access for other justice organizations is considered - [contact us](mailto:analytical_platform@digital.justice.gov.uk) to discuss.
