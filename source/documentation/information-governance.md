# Information governance

## Data management

### Permissions and access

Access to data and apps on the Analytical Platform should be provided on a need-to-know basis.

If you are an admin for data source, you can control which users have access from the Analytical Platform control panel.

Some app access permissions can be specified in `deploy.json` (see the [build and deploy](/build-deploy.html) chapter), however, users cannot manage an app's user access list themselves.

DOM1 and MacBook users can request access to a data source (for themselves, other users or customers) on the [#ap-admin-request](https://asdslack.slack.com/messages/CBLAGCQG6/) Slack channel. Quantum users should email the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).

If requesting access to a data source, you should provide the GitHub usernames of the relevant users. If requesting access to an app, you should provide the email addresses of the relevant users.

### Data retention

#### Amazon S3

* Files stored in Amazon S3 are retained indefinitely until they are deleted.
* Files stored in Amazon S3 are backed up automatically.
* Once files are deleted from Amazon S3, they are deleted permanently along with all backups and cannot be restored unless the bucket is versioned. Versioning is disabled by default.

#### Home directory

* Files stored in users' home directories are retained indefinitely until they are deleted.
* Files stored in users' home directories are backed up to Amazon S3 automatically.
* Previous versions of files stored in users' home directories are also backed up to Amazon S3.
* Once files are deleted from a user's home directory, the backup is retained for a further 90 days and can be restored.
* To request that a file be restored or to access a previous version of a file, contact the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).

#### Best practice guidelines

All users should comply with the following best practice guidelines for retaining personal data.

__All users will:__

* be aware when they are working with personal data;
* consider and justify why personal data needs to be retained and for how long;
* identify when personal data needs to be kept for public interest archiving, scientific or historical research, or statistical purposes;
* review the need to retain personal data on a regular basis;
* erase or anonymise personal data when it is no longer required; and
* erase data as required in accordance with an individual's 'right to be forgotten' under the Data Protection Act 2018.

The relevant information asset owner (IAO) should be able to advise if any additional data retention policies or requirements apply.

## Data movements

All data movements should take place safely and securely to ensure that data is protected at all times, including when in transit. To facilitate this, when moving any data onto the Analytical Platform, you __must__ complete a data movement form. The data movement form can be found <a href="https://forms.office.com/Pages/ResponsePage.aspx?id=KEeHxuZx_kGp4S6MNndq2I8ebMaq5PFBoMAkkhrMYHBUQVY2VUczTUNPUzlZQTJTNjFWVUowWUxUMS4u" target="_blank">here</a>. Guidance on completing the form can be found in Section \@ref(data-movement-form).

Depending on the details of the data movement, you may also be required to complete or update:

* A technical migration form;
* Data protection impact assessments (DPIAs);
* Privacy impact assessments (PIAs);
* Privacy notices; or
* Information management and asset logs.

Before completing a data movement form, you should ensure that you have already obtained __all necessary approvals__ and completed all required supplementary documentation.

### Data movement form guidance{#data-movement-form}

You may not be required to complete all of the questions below depending on the details of your data movement.

#### Contact information

* __Name__
* __Email address__
* __Phone number__
* __Is the main person carrying out the data movement the same as the requestor?__
* __Name of the main person carrying out the data movement__
* __Email address of the main person carrying out the data movement__
* __Phone number of the main person carrying out the data movement__
    
#### The data

* __What data is being moved?__  
* __What fields does the data contain?__
* __What is the security marking of the data?__  
  The Analytical Platform is suitable for data classified as OFFICIAL and OFFICIAL-SENSITIVE. SECRET and TOP SECRET data is not allowed on the Analytical Platform.
  Information on security markings and classifying information can be found [here](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/classifying-information/).
* __Will the data be modified or changed in order to mask sensitive content or personal information?__  
  Guidance on masking and anonymisation can be found in sections \@ref(pseudonymisation) and \@ref(anonymisation).
* __How will the data be changed or modified in order to mask sensitive content or personal information?__
* __Will the data be modified or changed before or after being moved to the Analytical Platform?__

#### Personal data

* __Does the data include personal data?__  
  Personal data is information that can be used to identify a person directly or indirectly in combination with other information. Personal data includes names, identification numbers, addresses and online identifiers. Guidance from the Information Commissioner's Office (ICO) on identifying personal data can be found [here](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/key-definitions/what-is-personal-data/). Further information on handling personal data in MoJ can be found [here](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/personal-data/).
  
#### Data controller

* __Is MoJ the data controller responsible for the data?__  
  A data controller is an entity registered with the Information Commissioner's Office (ICO) that exercises overall control over the purposes and means of the processing of personal data. MoJ is the controller for MoJ HQ, HMPPS, HMCTS, LAA, OPG and some other agencies and public bodies. The Analytical Platform guidance contains a list of agencies and arm's length bodies that are data controllers in their own right. The relevant information asset owner (IAO) should also be able to advise who the correct data controller is.
* __Who is the data controller responsible for the data?__  
The data controller could be another MoJ agency or public body (for which MoJ is not the responsible controller), another government department or a third party. You can use the [ICO Data Protection Register](https://ico.org.uk/ESDWebPages/Search) to determine whether an entity is a controller. The following agencies and public bodies are data controllers:
    + Criminal Injuries Compensation Authority (CICA)
    + Children and Family Court Advisory and Support Service (CAFCASS)
    + Criminal Cases Review Commission (CCRC)
    + Legal Services Board (LSB)
    + Parole Board for England and Wales
    + Youth Justice Board for England and Wales (YJB)
    + Civil Justice Council (CJC)
    + Family Justice Council (FJC)
    + Sentencing Council for England and Wales
    + Office for Legal Complaints (Legal Ombudsman for England and Wales)
    + The Official Solicitor to the Senior Courts
    + The Public Trustee
    + Prisons and Probation Ombudsman (PPO)
* __Is a suitable data sharing agreement in place with the data controller?__
* __Is the controller aware of the data movement and the intended use of the Analytical Platform as a data processor?__

#### Data protection and privacy

* __Have the relevant Data Protection Impact Assessments (DPIAs) and Privact Impact Assessments (PIAs) been created or updated and reviewd by the data protection team?__  
If you are unsure whether a DPIA or PIA already exists or needs to be created, you should contact the relevant Information Asset Owner (IAO). Further information on DPIAs and PIAs can be found [here](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/data-protection-impact-assessments-dpias/). You can also contact the Data Protection Officer mailbox [here](mailto:data.compliance@justice.gov.uk).
* __Have the relevant privacy notices been updated to reflect use of the Analytical Platform?__  
A privacy notice is required to let customers using a product or service know:
    + who is collecting the data;
    + what data is being collected;
    + if they are required to provide the data;
    + what is the legal basis for processing the data;
    + how the data will be used;
    + if the data will be shared with any third parties;
    + how long the data will be held for;
    + if the data will be used for automated deecision-making, including profiling;
    + what rights they have in relation to their data; and
    + how they can raise a complaint about the handling of their data.
  Further information on data privacy and privacy notices can be found [here](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/). ICO guidance can also be found [here](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/individual-rights/right-to-be-informed/).

#### The data movement

* __Why is the data being moved?__
* __What is the source of the data?__
* __Where will the data be stored on the Analytical Platform?__
* __Which S3 bucket will the data be stored in?__
* __How many records does the data contain?__
* __Who will have access to the data on the Analytical Platform?__
* __How will the data be moved?__  
  Describe how the data will be moved from the source location. Will the data be moved electronically, by email or by physical media? Will it be uploaded manually to S3 or a home directory or will there be a direct integration with another system?
* __Is a technical migration form required?__  
  A technical migration form is __not required__ for one-off data movements of static files (such as .zip files and .csv files) that are carried out manually (i.e. by email or direct upload to S3 or a home directory). __A technical migration form is required for all other data movements.__ If you are unsure whether your data movement requires a technical migration form, please contact the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk). A template technical migration form can be found [here](https://justiceuk.sharepoint.com/:w:/s/AnalyticalPlatform/EafJPVHk2NRCjZm1WGFPOJcBpkJ-pH8L2o0hKma2bsbWow?e=0pWGjc). To access this template, you must be signed in to Office 365. If you are unable to access the template, please contact the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).
* __Technical migration form__  
  Please send your form as an attachment to the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).
* __Is this a one-off or recurring data movement?__
* __When is the data movement expected to occur?__
* __What is the intended frequency of the data movement?__
* __When is the first data movement expected to occur?__
* __Will the data movement be in place for a fixed period of time?__
* __When will the final data movement occur?__
* __When will the data movement request be reviewed?__  
  Recurring data movements that occur indefinitely should be reviewed at least every two years.

#### Data retention

* __How long will the data be retained on the Analytical Platform?__
* __Is this in line with departmental and Analytical Platform data retention policies?__  
  Guidance on data retention can be found in Section \@ref(data-retention).

#### Information Asset Owner (IAO)

All data in MoJ is assigned an Information Asset Owner (IAO). The IAO is responsible for the registration, labelling, storage, transfer and retention of that data.
You should seek approval from the relevant IAO for __all__ data movements.

* __Does the data movement require approval by an Information Asset Owner (IAO)?__
* __IAO name__
* __IAO email address__
* __Has the IAO approved this data movement?__

#### Senior Information Risk Officer (SIRO)

Information on the responsibilities of SIROs can be found [here](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/information-assurance-roles/).

SIRO approval may be required depending on local information assurance policies. SIRO approval is usually required when a data movement involves non-routine risks. The relevant IAO should be able to advise if SIRO approval is also required.

* __Does the data movement require approval by a Senior Information Risk Officer?__
* __SIRO name__
* __SIRO email address__
* __Has the SIRO approved this data movement?__

#### Information assurance

* __Have you discussed the data movement with the relevant information security team(s)?__  
  The relevant information security teams are:
    + __MoJ HQ__ -- [cybersecurity team](mailto:cybersecurity@digital.justice.gov.uk)
    + __HMCTS__ -- [information assurance team](https://intranet.justice.gov.uk/about-hmcts/digital-change/information-assurance-and-data-security/)
    + __HMPPS__ -- [information management and security team](mailto:informationmgmtsecurity@noms.gsi.gov.uk)
* __Have you considered all other information assurance requirements, including, but not limited to, those arising under the Public Records Act, the Official Secrets Act, the Data Protection Act and the Freedom of Information Act?__

#### Confirmation

* __Have you read and understood the Analytical Platform guidance and acceptable use policy?__

### Data Minimisation

It is good practice to undertake data minimisation when moving data to the Analytical Platform as all software imposes [memory limits](https://moj-analytical-services.github.io/platform_user_guidance/annexes.html#data-minimisation).

Data minimisation is also a princicple of GDPR. Any personal data used should be:

* adequate;
* relevant; and
* limited to what is necessary.

In practice, you may want to consider whether a subset of a larger data set (removing irrelevant fields or observations) is sufficient for your analysis.

## Data Offshoring

The Analytical Platform is hosted on [Amazon Web Services (AWS)](https://aws.amazon.com/) (a US company part of the Amazon group) with primary data storage and processing locations in their [European regions](https://aws.amazon.com/about-aws/global-infrastructure/).

## Reporting security incidents

As soon as you become aware of an actual or potential security incident, including a loss of data, you should follow the guidance [here](https://intranet.justice.gov.uk/guidance/security/report-a-security-incident/) and [here](https://intranet.justice.gov.uk/guidance/security/report-a-security-incident/reporting-a-data-incident/).
