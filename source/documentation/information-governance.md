# Information governance

## Data management

### Permissions and access

Access to data and apps on the Analytical Platform is provided on a need-to-know basis.

If you are an admin for a data source or webapp, you can control which users have access from the Analytical Platform control panel.

Some webapp access permissions can also be specified in `deploy.json`.

You can request access to a data source or app (for yourself, another user or a customer) by contacting an admin for the data source or app, or by contacting the Analytical Platform team on the [#ap-admin-request](https://asdslack.slack.com/messages/CBLAGCQG6/) Slack channel or at [analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk).

When requesting access to a data source, you should provide the GitHub usernames of the users to be added. When requesting access to an app, you should provide the email addresses of the users to be added.

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
* To request that a file be restored or to access a previous version of a file, contact the Analytical Platform team at [analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk).

## Data movements

You can move data classified as OFFICIAL (including OFFICIAL-SENSITIVE) onto the Analytical Platform. SECRET and TOP SECRET data is not allowed on the Analytical Platform. 

All data movements should take place safely and securely to ensure that data is protected at all times, including when in transit.

If you are moving sensitive or personal data, please complete a data movements form on OneTrust. It is your responsibility to know if your data contains personal information. To request access to OneTrust or for further information on how to complete the form please contact dataprotection@justice.gov.uk. You can find more information on the [intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/).

If your data movement is complex, or you will be regularly moving a large amount of data, you may wish to consult the data engineering team for support [#ask-data-engineering](https://asdslack.slack.com/archives/C8X3PP1TN).
### Personal data

If you are working with personal data you have a responsibility to ensure that you are compliant with the requirements of the General Data Protection Regulation (GDPR) and the Data Protection Act (DPA) 2018. This responsibility applies regardless of where you are processing the data.

In practice, this means you must ensure that:

* you are processing personal data in accordance with the [principles of the GDPR](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/principles/) and the [rights of individuals](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/individual-rights/)
* you have a lawful basis for processing the personal data
* you have fulfilled all necessary governance requirements

If your data contains anything that could be considered personal information, you must follow guidance from the data protection team which can be found on the [intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/). You are best to contact the Data Protection Team at dataprotection@justice.gov.uk. A Data Protection Impact Assessment (DPIA) may have already been completed for your dataset but may need to be updated to reflect your use case, or a new one may be required. The Data Protection Team will be able to advise.

#### What is personal data?

Personal data is information that relates to an individual who can be identified or who is identifiable:

* directly from the information in question
* indirectly from the information in question in combination with other information

Personal data could include information such as:

* names
* personal identifiers
* dates of birth
* addresses

You can find detailed guidance from the ICO on what constitutes personal data [here](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/key-definitions/what-is-personal-data/). Further information on handling personal data in MoJ can be found [here](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/personal-data/).

#### Anonymisation and pseudonymisation

Anonymisation is the process of removing personal information from data such that individuals can no longer be identified. Data that has been fully anonymised is not considered personal data and is not subject to the GDPR.

> The principles of data protection should therefore not apply to anonymous information, namely information which does not relate to an identified or identifiable natural person or to personal data rendered anonymous in such a manner that the data subject is not or no longer identifiable.
>
> Source: [GDPR](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679)

If it is possible to identify an individual from the data by any reasonable means, the data will not have been fully anonymised but rather pseudonymised.

> Pseudonymisation means the processing of personal data in such a manner that the personal data can no longer be attributed to a specific data subject without the use of additional information, provided that such additional information is kept separately and is subject to technical and organisational measures to ensure that the personal data are not attributed to an identified or identifiable natural person.
>
> Source: [GDPR](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679)

Pseudonymisation may involve replacing names or other personal identifiers with reference numbers or other artificial identifiers, while maintaining a lookup enabling individuals to be re-identified.

Pseudonymised data is still considered personal data and is subject to the GDPR.

You should try to anonymise or pseudonymise personal data where possible in accordance with the principles of [data minimisation](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/principles/data-minimisation/) and [storage limitation](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/principles/storage-limitation/).

#### Data controllers

When working with personal data, you should determine whether MoJ is the data controller.

A data controller is an entity registered with the Information Commissioner's Office (ICO) that exercises overall control over the purposes and means of the processing of personal data. MoJ is the controller for MoJ HQ, HMPPS, HMCTS, LAA, OPG and some other agencies and public bodies.

The data controller could be another MoJ agency or public body (for which MoJ is not the responsible controller), another government department or a third party. You can use the [ICO Data Protection Register](https://ico.org.uk/ESDWebPages/Search) to determine whether an entity is a controller. The following agencies and public bodies are data controllers:

* Criminal Injuries Compensation Authority (CICA)
* Children and Family Court Advisory and Support Service (CAFCASS)
* Criminal Cases Review Commission (CCRC)
* Legal Services Board (LSB)
* Parole Board for England and Wales
* Youth Justice Board for England and Wales (YJB)
* Civil Justice Council (CJC)
* Family Justice Council (FJC)
* Sentencing Council for England and Wales
* Office for Legal Complaints (Legal Ombudsman for England and Wales)
* The Official Solicitor to the Senior Courts
* The Public Trustee
* Prisons and Probation Ombudsman (PPO)

The Data Protection Team (dataprotection@justice.gov.uk) should be able to advise you.

#### Privacy Notice

You should also check if a [privacy notice](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/individual-rights/right-to-be-informed/) already exists (dataprotection@justice.gov.uk should be able to advise). A privacy notice provides information to individuals about how and why their personal data is being collected and processed.

If a privacy notice already exists, you should update it to reflect use of the Analytical Platform. In particular, you should ensure the privacy notice informs individuals that their data will be:

* shared with Amazon Web Services, Inc. (AWS)
* stored outside of the UK but within the EU

### IAO and SIRO approval

For all data movements containing personal data, you should obtain approval from the Information Asset Owner (IAO). Depending on local information governance requirements, for some complex or high-risk data movements you may also need to obtain approval from the Senior Information Risk Officer (SIRO). The IAO should be able to advise if approval from the SIRO is required.

## Reporting security incidents

As soon as you become aware of an actual or potential security incident, including a loss of data, you should follow the guidance [here](https://intranet.justice.gov.uk/guidance/security/report-a-security-incident/).
