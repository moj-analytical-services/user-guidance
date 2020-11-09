# How to complete a data movement form

You should use this reference in conjunction with the
[Information governance](../../information-governance.html) section of the user
guidance when completing a data movement form.

You may not be required to complete all of the questions below depending on the
details of your data movement.

## Contact information

#### Name

#### Email address

#### Phone number

#### Is the main person carrying out the data movement the same as the requestor?

#### Name of the main person carrying out the data movement

#### Email address of the main person carrying out the data movement

#### Phone number of the main person carrying out the data movement

## The data

#### What data is being moved?

#### What fields does the data contain?

#### What is the security marking of the data?

The Analytical Platform is suitable for data classified as OFFICIAL, including
data that is marked OFFICIAL-SENSITIVE. SECRET and TOP SECRET data is not
allowed on the Analytical Platform. Information on security markings and
classifying information can be found on the
[intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/classifying-information/).

#### Will the data be modified or changed in order to mask sensitive content or personal information?

Guidance on masking and anonymisation can be found in the
[anonymisation and pseudonymisation](../../information-governance.html#anonymisation-and-pseudonymisation)
section.

#### How will the data be changed or modified in order to mask sensitive content or personal information?

#### Will the data be modified or changed before or after being moved to the Analytical Platform?

## Personal data

#### Does the data include personal data?

Personal data is information that can be used to identify a person directly or
indirectly in combination with other information. Personal data includes names,
identification numbers, addresses and online identifiers. Guidance from the
Information Commissioner's Office (ICO) on identifying personal data can be
found on their
[website](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/key-definitions/what-is-personal-data/).
Further information on handling personal data in MoJ can be found on the
[intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/personal-data/).

## Data controller

#### Is MoJ the data controller responsible for the data?

MoJ is the data controller for any data collected by or on behalf of MoJ HQ,
HMPPS, HMCTS, LAA, OPG, CICA and some other agencies and public bodies. MoJ may also
be a joint data controller for any data shared with the ministry by other
organisations, such as other government department. This should be specified in
the data sharing agreement or memorandum of understanding that governs the
sharing of the data.

#### Who is the data controller responsible for the data?

The data controller could be another MoJ agency or public body (for which MoJ is
not the responsible controller), another government department or a third party.

You can use the
[ICO Data Protection Register](https://ico.org.uk/ESDWebPages/Search) to
determine whether an entity is a controller.

The relevant information asset owner (IAO) should also be able to advise who the
correct data controller is.

The following agencies and public bodies are data controllers:

- Children and Family Court Advisory and Support Service (CAFCASS)
- Criminal Cases Review Commission (CCRC)
- Legal Services Board (LSB)
- Parole Board for England and Wales
- Youth Justice Board for England and Wales (YJB)
- Civil Justice Council (CJC)
- Family Justice Council (FJC)
- Sentencing Council for England and Wales
- Office for Legal Complaints (Legal Ombudsman for England and Wales)
- The Official Solicitor to the Senior Courts
- The Public Trustee
- Prisons and Probation Ombudsman (PPO)

#### Is a suitable data sharing agreement in place with the data controller?

#### Is the controller aware of the data movement and the intended use of the Analytical Platform as a data processor?

## Data protection and privacy

#### Have the relevant Data Protection Impact Assessments (DPIAs) and Privact Impact Assessments (PIAs) been created or updated and reviewd by the data protection team?

If you are unsure whether a DPIA or PIA already exists or needs to be created,
you should contact the relevant Information Asset Owner (IAO).

Further information on DPIAs and PIAs can be found on the
[intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/data-protection-impact-assessments-dpias/).

You can also contact the
[Data Protection Officer mailbox](mailto:data.compliance@justice.gov.uk).

#### Have the relevant privacy notices been updated to reflect use of the Analytical Platform?

A privacy notice is required to let customers using a product or service know:

- who is collecting the data
- what data is being collected
- if they are required to provide the data
- what is the legal basis for processing the data
- how the data will be used
- if the data will be shared with any third parties
- how long the data will be held for
- if the data will be used for automated deecision-making, including profiling
- what rights they have in relation to their data
- how they can raise a complaint about the handling of their data.

Further information on data privacy and privacy notices can be found on the
[intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/privacy-reform/).

ICO guidance can also be found on their
[website](https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/individual-rights/right-to-be-informed/).

## The data movement

#### Why is the data being moved?

#### What is the source of the data?

#### Where will the data be stored on the Analytical Platform?

#### Which S3 bucket will the data be stored in?

#### How many records does the data contain?

#### Who will have access to the data on the Analytical Platform?

#### How will the data be moved?

Describe how the data will be moved from the source location. Will the data be
moved electronically, by email or by physical media? Will it be uploaded
manually to S3 or a home directory or will there be a direct integration with
another system?

#### Is a technical migration form required?

A technical migration form is **not required** for one-off data movements of
static files (such as .zip files and .csv files) that are carried out manually
(for example, by email or direct upload to S3 or a home directory).

<div class="govuk-warning-text">
  <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
  <strong class="govuk-warning-text__text">
    <span class="govuk-warning-text__assistive">Warning</span>
    A technical migration form is required for all other data movements.
  </strong>
</div>

If you are unsure whether your data movement requires a technical migration
form, please contact the
[Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).

A template technical migration form can be found
[here](https://justiceuk.sharepoint.com/:w:/s/AnalyticalPlatform/EafJPVHk2NRCjZm1WGFPOJcBpkJ-pH8L2o0hKma2bsbWow?e=0pWGjc).
To access this template, you must be signed in to Office 365. If you are unable
to access the template, please contact the
[Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).

#### Technical migration form

Please send your form as an attachment to the
[Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk).

#### Is this a one-off or recurring data movement?

#### When is the data movement expected to occur?

#### What is the intended frequency of the data movement?

#### When is the first data movement expected to occur?

#### Will the data movement be in place for a fixed period of time?

#### When will the final data movement occur?

#### When will the data movement request be reviewed?

Recurring data movements that occur indefinitely should be reviewed at least
every two years.

## Data retention

#### How long will the data be retained on the Analytical Platform?

#### Is this in line with departmental and Analytical Platform data retention policies?

See the [data retention](../../information-governance.html#data-retention)
section.

## Information Asset Owner (IAO)

All data in MoJ is assigned an Information Asset Owner (IAO). The IAO is
responsible for the registration, labelling, storage, transfer and retention of
that data.

<div class="govuk-warning-text">
  <span class="govuk-warning-text__icon" aria-hidden="true">!</span>
  <strong class="govuk-warning-text__text">
    <span class="govuk-warning-text__assistive">Warning</span>
    You must obtain approval from the relevant IAO for all data
movements.
  </strong>
</div>

#### Does the data movement require approval by an Information Asset Owner (IAO)?

#### IAO name

#### IAO email address

#### Has the IAO approved this data movement?

## Senior Information Risk Officer (SIRO)

Information on the responsibilities of SIROs can be found on the
[intranet](https://intranet.justice.gov.uk/guidance/knowledge-information/protecting-information/information-assurance-roles/).

SIRO approval may be required depending on local information assurance policies.
SIRO approval is usually required when a data movement involves non-routine
risks. The relevant IAO should be able to advise if SIRO approval is also
required.

#### Does the data movement require approval by a Senior Information Risk Officer (SIRO)?

#### SIRO name

#### SIRO email address

#### Has the SIRO approved this data movement?

## Information assurance

#### Have you discussed the data movement with the relevant information security team(s)?

It is not mandatory to consult any other information security teams before
submitting a data movement form, however, it is advisable to do so when:

- the data is new
- you want to move a large quantity of data
- you want to move data on a regular basis
- the data is particularly sensitive
- the method of transfer is non-standard
- the data will be retained on the Analytical Platform for longer than is
  permitted for operational purposes

Some information security teams that may be relevant are:

- [MoJ HQ cybersecurity team](mailto:cybersecurity@digital.justice.gov.uk)
- [HMCTS information assurance team](https://intranet.justice.gov.uk/about-hmcts/digital-change/information-assurance-and-data-security/)
- [HMPPS information management and security team](mailto:informationmgmtsecurity@noms.gsi.gov.uk)

#### Have you considered all other information assurance requirements, including, but not limited to, those arising under the Public Records Act, the Official Secrets Act, the Data Protection Act and the Freedom of Information Act?

## Confirmation

#### Have you read and understood the Analytical Platform guidance and acceptable use policy?
