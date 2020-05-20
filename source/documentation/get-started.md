# Get started

## Get an account

You need an account before you can use the Analytical Platform. To do this, complete the following steps.

### Read the acceptable use policy and coding standards

Use of the Analytical Platform is subject to our [acceptable use policy](#acceptable-use-policy). You should ensure that you have read and understood this before using the Analytical Platform.

You should also follow our [coding standards](https://github.com/moj-analytical-services/our-coding-standards) when working on the Analytical Platform. These set out principles that you should follow when writing and reviewing code.

### Sign up for a GitHub account

To sign up for a GitHub account, go to GitHub's [join page](https://github.com/join) and follow the instructions.

* When signing up, you must use your work email address. If you already have an existing GitHub account, that's fine to use, but your work email address must be in your [your account's emails](https://github.com/settings/emails).
* When instructed to choose your subscription, you should select the free plan.
* It is good practice to choose a username that does not contain upper-case characters.
* You should use a secure password following best [practice guidelines](https://github.com/ministryofjustice/itpolicycontent/blob/master/content/security/framework/password-standard.md).
* We recommend that you use a password manager, such as [LastPass](https://www.lastpass.com/), to generate and store strong passwords.

### Verify your email address for GitHub

Verifying your email address for GitHub ensures that your account is secure and gives you access to all of GitHub's features. Veryifying your email address is also required to sign in to the Analytical Platform.

During sign up, GitHub will send you an email with a link to verify your email address.

If you do not verify your email address at this stage, you can do it later by following the instructions [here](https://help.github.com/en/articles/verifying-your-email-address).

### Configure two-factor authentication for GitHub

To get access to the Analytical Platform, you must first configure two-factor authentication (2FA) for GitHub using a mobile app (on your personal or work phone) or via text message. To configure 2FA for GitHub, follow the instructions [here](https://help.github.com/en/articles/configuring-two-factor-authentication).

We recommend that you configure 2FA using a mobile app. In particular, we recommend that you use [__Authy__](https://authy.com/) for the following reasons:

1. You can sync 2FA tokens across multiple devices, including mobiles, tablets and computers.
2. You can create encrypted recovery backups in case you lose your device.
3. You can use Touch ID, PIN codes and passwords to protect access to your 2FA tokens.
4. You can still access secure websites when you don't have phone signal.

### Request an account from the Analytical Platform team

To request an account for the Analytical Platform, you should send an email with your GitHub username to the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk). The team will then invite you to join the [MoJ Analytical Services](https://github.com/moj-analytical-services) GitHub organisation.

### Accept your invitation to the MoJ Analytical Services GitHub organisation

When you are invited to join the MoJ Analytical Services GitHub organisation, you will receive an email with a link to accept the invitation.

You can also accept your invitation by signing in to GitHub and visiting the [organisation page](https://github.com/moj-analytical-services).

### Configure two-factor authentication for the Analytical Platform

When you sign in to the Analytical Platform for the first time, you will be prompted to configure additional two-factor authentication (2FA) for the Analytical Platform itself.

To sign in, go to the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).

You must configure 2FA for the Analytical Platform using a mobile app (on your personal or work phone). As described above, we recommend that you use __Authy__.

## Access the Analytical Platform

The main entry point to the Analytical Platform is the [control panel](https://controlpanel.services.alpha.mojanalytics.xyz). From here, you can access RStudio and JupyterLab and can manage your warehouse data sources.

You may also need to access other services and tools on the Analytical Platform:

* [Airflow](https://airflow.tools.alpha.mojanalytics.xyz)
* [AWS console](https://aws.services.alpha.mojanalytics.xyz)
* [Concourse](https://concourse.services.alpha.mojanalytics.xyz)
* [Grafana](https://grafana.services.alpha.mojanalytics.xyz)
* [Kibana](https://kibana.services.alpha.mojanalytics.xyz)

If you're going to use R Studio or Jupyter then the next step should be:

* [deploy and open R Studio or Jupyter](tools.html#deploy-analytical-tools)
* [setup to access GitHub from R Studio or Jupyter]()

## Contact us

To get support, you can contact the Analytical Platform team on the [#analytical_platform](https://asdslack.slack.com/messages/C1PTUTC3F/) Slack channel or by [email](mailto:analytical_platform@digital.justice.gov.uk). You can get more information on Slack below.

For more information on support, including incident response, please see our [key support information](https://github.com/ministryofjustice/analytics-platform-ops/wiki/Key-support-information). 

## Slack

### What is Slack?

Slack is a collaboration tool that helps teams work more effectively together. You can use Slack in several ways:

* to get technical support for the Analytical Platform and analytical tools, such as R, Python and Git
* to submit admin requests relating to apps and data sources on the Analytical Platform
* to share knowledge, expertise and best practice
* to communicate quickly with other Analytical Platform users as an alternative to email

### Access Slack

You can access our Slack workspace [here](https://asdslack.slack.com).

To create an account, you will need an email address ending in @justice.gsi.gov.uk, @digital.justice.gov.uk, @cjs.gsi.gov.uk, @noms.gsi.gov.uk, @legalaid.gsi.gov.uk, @justice.gov.uk or @judiciary.uk.

It is not mandatory to join or use Slack (although we highly recommend it) so you shouldn’t use it to make any important announcements and should ensure that you are not excluding anyone from the discussion.

You may have to access Slack differently depending on the IT system you use:

* if you use DOM1, you can access Slack from a browser or using the mobile app on your personal or work phone
* if you use an MoJ Digital and Technology MacBook, you can access Slack from a browser or using the desktop app. You can also access Slack using the mobile app on your personal or work phone
* if you use Quantum, you will not currently be able to access Slack from your computer, however, you can use the mobile app on your personal or work phone
 
### Channels

Conversations in Slack are organised into channels, which each have a specific topic. Channels can be public (all users can join) or private (users can only join by invitation) and can be created based on teams, projects, locations, tools and techniques among others.

 There are several public channels that are widely used and may be useful to join:

* the [#git](), [#r]() and [#python]() channels can be used to get support from other users with any technical queries or questions -- the #[intro_r channel]() is aimed specifically at new users of R
* the [#analytical_platform]() channel is used for general discussion of the Analytical Platform -- it is also monitored by the Analytical Platform team, who can help out with any technical queries
* the [#ap_admin_request]() channel is used to request new apps and app data sources as well as access to existing apps and data sources
* the [#data_engineers]() channel is used for general discussion of data engineering and for getting in touch with the data engineering team as well as to submit Airflow DAG pull requests for review
* the [#data_science]() channel is used for general discussion of data science tools and techniques
* the [#general]() channel is used for any discussions that don’t fit anywhere else
* the [#10sc]() channel can be used to get in touch with other people working at 10SC and to ask any questions about the building
 
There are lots of other channels you can join or you can set up a new one if you think something is missing. You may also wish to set up private channels to discuss specific projects and can direct message individual users.

### Further information

You can find out more about Slack and how to use it in the [Slack Help Centre](https://get.slack.help/hc/en-gb/).
