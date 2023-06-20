# Shared Responsibility Model

The Shared Responsibility Model (SRM) for the Analytical Platform is a framework that outlines the duties of:

- Analytical Platform teams as platform providers
- Analytical Platform users as platform consumers

We have organised the responsibilities into a series of tasks within tables for different aspects of the platform.

Some of the responsibilities are shared between users and the Analytical Platform team or another team; check the **Notes column** for details, including how to get support with a particular task.

## Documentation

| Responsibility                                                                              | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                                                                                                                         |
| :------------------------------------------------------------------------------------------- | :-------------------: | :-----: | :--------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Owning the Analytical Platform User Guidance                                                | ✅                |  |           | The Data Platform Documentation team are responsible.                                                                                                                                                                                                                         |
| Reviewing Analytical Platform User Guidance content                                         | ✅                |  |           | The Data Platform Documentation team are responsible.                                                                                                                                                                                                                         |
| Updating Analytical Platform User Guidance content                                          | ✅                | ✅  |           | Anyone can make updates but they must contact the Data Platform Documentation team, who will review and approve any changes before merging.                                                                                                                                   |
| Migrating content from another source to the Analytical Platform User Guidance              | ✅                |  |           | Anyone with prospective content should contact the Data Platform Documentation team.                                                                                                                                                                                          |
| Providing support for the Analytical Platform User Guidance documentation tooling           | ✅                |  |           | The Data Platform Documentation team are responsible.                                                                                                                                                                                                                         |
| Updating this Shared Responsibility Model                                                   | ✅                |  |           | It is up to teams to define their respective responsibilities and relay them to the Data Platform Documentation team, who should then update this model accordingly.                                                                                                          |
| Documenting processes that involve third-party services                                     |                |  | ✅           | The Analytical Platform only provides documentation on how to use third-party tools and services in the context of the platform.<br><br>For any other functionality users should consult the relevant vendor's documentation (eg. AWS docs).                                  |
| Completing and/or facilitating the completion of a Data Protection Impact Assessment (DPIA) |                | ✅  | ✅           | We do not provide support for DPIAs.<br><br>Users should see [the MoJ's Data Protection guidance](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/) and contact the Data Protection team (dataprotection@justice.gov.uk) |
| Managing internal team documentation                                                        |                | ✅  |           | Teams are responsible for their respective internal documentation, including runbooks and Confluence spaces.                                                                                                                                                                  |
| Updating GitHub READMEs                                                                     | ✅                |  |           | Teams should follow [The GDS Way's guidance on writing READMEs](https://gds-way.cloudapps.digital/manuals/readme-guidance.html) and contact the Data Platform Documentation team to review README content.                                                                    |

## Onboarding and offboarding

| Responsibility                              | Analytical Platform | User | Other MoJ Team | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| :------------------------------------------- | :-------------------: | :----: | :--------------: | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Creating MoJ Office 365 account credentials |                | ✅ | ✅           | Users are responsible for obtaining their Office 365 credentials from their line managers.                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Creating GitHub account credentials         |                | ✅ |           | Users are responsible for creating their own GitHub account.                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Creating Analytical Platform accounts       | ✅                | ✅ |           | Users login to the Analytical Platform with their GitHub acccounts, but require access to the MoJ Analytical Services GitHub organisation.<br><br>Users should email analytical_platform@digital.justice.gov.uk their role, team and reasons for requiring access to the AP; successful requests will receive an invitation to join the organisation in response.<br><br>If users do not receive a response within 24 hours, they can follow up in the **#analytical-platform-support** Slack channel on the **Justice Digital workspace**. |
| Creating Slack accounts                     |                | ✅ |           | Users are responsible for creating their own Slack account and joining the **ASD and Justice Digital workspaces**.                                                                                                                                                                                                                                                                                                                                                                                                                      |

## Platform maintenance

| Responsibility                                                       | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                                                                                |
| :-------------------------------------------------------------------- | :-------------------: | :-----: | :--------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Monitoring and communicating the Analytical Platform's online status | ✅                |  |           | We only share the status with users in the event of an outage or an anticipated outage.                                                                                                         |
| Updating the Analytical Platform                                     | ✅                |  |           | Maintainers communicate scheduled maintenace in the **#analytical-platform-support** Slack channel on the **Justice Digital workspace**, along with the team carrying out the work and expected impacts and outages while they are doing so. |

## Platform security

| Responsibility                                      | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                   |
| :--------------------------------------------------- | :-------------------: | :-----: | :--------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Managing Single-Sign On (SSO) access                | ✅                |  | ✅           | The Analytical Platform and Operations Engineering share the responsibilities of managing SSO access.<br><br> We report any changes to SSO via email and Slack. |
| Implementing, enforcing and managing security rules | ✅                |  |           | The Analytical Platform and Platforms & Architecture (P&A) Cyber team share the responsibilities of security rules.                                                |

## Tools and packages

### Airflow

| Responsibility                           | Analytical Platform | User  | Other MoJ Team | Notes                                         |
| :---------------------------------------- | :-------------------: | :-----: | :--------------: | :--------------------------------------------- |
| Managing and supporting the Airflow tool | ✅                |  |           |  |

### AWS resources

| Responsibility                        | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                                        |
| :------------------------------------- | :-------------------: | :-----: | :--------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Managing and supporting AWS resources |                |  |           | The Analytical Platform team are responsible for resources accessed via the Analytical Platform's Control Panel.                                                                             |
| Creating S3 buckets                   |                | ✅  |           | Users can create their own S3 buckets from the Analytical Platform's Control Panel.                                                                                                          |
| Managing access to S3 buckets         | ✅                | ✅  |           | Users manage access to their own S3 buckets.<br><br>For S3 buckets uesrs do not own, they request access in the **#analytical-platform-support** Slack channel on the **Justice Digital workspace**. |

### Create a derived table

| Responsibility                                          | Analytical Platform | User  | Other MoJ Team | Notes                                         |
| :------------------------------------------------------- | :-------------------: | :-----: | :--------------: | :--------------------------------------------- |
| Adding sources                                          | ✅                |  |           |  |
| Managing and supporting the Create a derived table tool | ✅                |  |           |  |

### Data discovery

| Responsibility                                  | Analytical Platform | User  | Other MoJ Team | Notes                                         |
| :----------------------------------------------- | :-------------------: | :-----: | :--------------: | :--------------------------------------------- |
| Managing and supporting the Data Discovery tool | ✅                |  |           |  |

### Data extractor

| Responsibility                                  | Analytical Platform | User  | Other MoJ Team | Notes                                        |
| :----------------------------------------------- | :-------------------: | :-----: | :--------------: | :-------------------------------------------- |
| Managing and supporting the Data Extractor tool | ✅                |  |           |  |

### Data registration

| Responsibility                                    | Analytical Platform | User  | Other MoJ Team | Notes                                        |
| :-------------------------------------------------: | :-------------------: | :-----: | :--------------: | :-------------------------------------------- |
| Managing and supporting the Register My Data tool | ✅               |  |           | |

### Data uploader

| Responsibility                                 | Analytical Platform | User  | Other MoJ Team | Notes                                        |
| :---------------------------------------------- | :-------------------: | :-----: | :--------------: | :-------------------------------------------- |
| Managing and supporting the Data Uploader tool | ✅                |  |           |  |

### JupyterLab

| Responsibility                                                | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                                                                                                           |
| :------------------------------------------------------------- | :-------------------: | :-----: | :--------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Supporting JupyterLab environments on the Analytical Platform | ✅                |  |           | The Analytical Platform team provide support for tasks related to using JupyterLab on the Analytical Platform.<br><br>For help with Python-related issues, users can request support in the **#analytical-platform-support** Slack channel on the **ASD workspace**. |

### Python packages

| Responsibility                         | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                                |
| :-------------------------------------- | :-------------------: | :-----: | :--------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Manging and supporting Python packages |                |  | ✅           | The Data Engineering team are responsible for most Python packages.<br><br>Users can request support in the **#ask-data-engineering** Slack channel on the **Justice Digital workspace**. |

### R packages

| Responsibility                     | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                   |
| :---------------------------------- | :-------------------: | :-----: | :--------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Managing and supporting R packages |                |  | ✅           | The Data Engineering team are responsible for R packages.<br><br>Users can request support in the **#ask-data-engineering** Slack channel on the **Justice Digital workspace**. |

### RStudio

| Responsibility                                             | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                      |
| :---------------------------------------------------------- | :-------------------: | :-----: | :--------------: | :---------------------------------------------------------------------------------------------------------- |
| Supporting RStudio environments on the Analytical Platform | ✅                |  |           | The Analytical Platform team provide support for tasks related to using RStudio on the Analytical Platform |

### Training

| Responsibility                                             | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                                                                                                                                         |
| :---------------------------------------------------------- | :-------------------: | :-----: | :--------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Learning how to use Analytical Platform tools and services |                | ✅ |            | The Analytical Platform provides some training documentation for how to use its tools in the context of the platform.<br><br>Users are responsible for completing these and learning how to use third-party tools. |

### User applications

| Responsibility        | Analytical Platform | User  | Other MoJ Team | Notes                                                                                                                     |
| :--------------------- | :-------------------: | :-----: | :--------------: | :------------------------------------------------------------------------------------------------------------------------- |
| User application code |                |  | ✅           | Users are responsible for their own code.                                                                                 |
| Monitoring apps       | ✅                |  |           |                                     |
| Application restarts  | ✅                |  |           | Users can request application restarts in the **#analytical-platform-support** Slack channel on the **Justice Digital workspace** |