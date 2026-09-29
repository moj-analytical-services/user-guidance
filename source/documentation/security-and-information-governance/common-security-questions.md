# AP security – responses to common questions

## General information

Analytical Platform runs on AWS, on top of Modernisation Platform, therefore we are subject to their secure baseline.

Infrastructure (development environments etc.) are hosted in London, and most of the data stored in S3 buckets is hosted in Ireland.

Designed for data at security classifications OFFICIAL and OFFICIAL-SENSITIVE, we follow NCSC Cloud Security Principles, implementing features such as:

- two-factor authentication (enforced via GitHub and MS Entra policy)
- data encryption at rest and in transit
- granular access control
- logging of user behaviour, user privilege requests/changes and data flows
- multiple isolation levels between users and system components
- resilience and high availability to provide optimal performance and uptime
- access restricted to corporate networks and VPNs. 

## DPIAs

There is no platform level DPIA as it depends on the nature of a project’s data and how it is used. Users will have to decide whether the AP is suitable for their use, and whether their project requires a DPIA.

We hope this document will be of use to users completing DPIAs, or assessing if the AP is suitable for their use cases.

## Data retention

We do not apply any data retention policies (i.e. automatic removal of data) as this will depend on the specific use case. Users must implement their own retention policies if required.

## CAF & ITHC

The AP has had a GovAssure assessment (this is essentially the CAF) and IT Heath Check(s). We can't share the detailed reports with users, as they are potentially sensitive, but after the CAF assessment was carried out remediations directly relevant to AP carried out.

The last ITHC was carried out by NCC Group, and again the report has links to all the tickets which were actioned off the back of this.

If you require more detail on these reports, please contact us via the usual support channels.

## SOC integration and alerting 

The AP is integrated with the Security Operations Centre (SOC) and we have a number of "unusual activity" alerts set up. This process is being regularly fine-tuned in an ongoing project between us and the SOC team. We don't engage our users directly with SOC monitoring, and will only relay relevant messages.

## Code and image scanning

We employ Dependabot and Grype to scan code and machine images, including Airflow, for vulnerabilities. Engineers and users will encounter action failures if vulnerabilities are present.

All platform code is peer reviewed before being deployed.

The AP engineering team undertake regular scheduled maintenance to update dependencies and patch CVEs. Our GitHub project board is open to anyone with an MOJ GitHub license if you wish to view these tickets.

## Amazon Bedrock 

For a non-technical overview of Bedrock security, please refer to [this AWS policy](https://aws.amazon.com/bedrock/security-compliance/).

There is no model training by AWS on our data: we have an organisation level AWS opt-out policy enabled.
