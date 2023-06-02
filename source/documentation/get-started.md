# Get started

## Introduction

You need 3 different accounts to use the Analytical Platform:

* Github Account
* Analytical Platform Account
* Slack Account (recommended)

To do this, complete the following steps.

### Read the acceptable use policy and coding standards

Use of the Analytical Platform is subject to our [acceptable use policy](https://user-guidance.analytical-platform.service.justice.gov.uk/aup.html). You should ensure that you have read and understood this before using the Analytical Platform.

You should also follow our [coding standards](https://github.com/moj-analytical-services/our-coding-standards) when working on the Analytical Platform. These set out principles that you should follow when writing and reviewing code.

## 1. Github Account

### What is Github?

GitHub is a website and cloud-based service that helps developers store and manage their code, as well as track and control changes to their code. To understand exactly what GitHub is, you need to know two connected principles:

* Version control
* Git

for more info see [An Introduction to GitHub](https://digital.gov/resources/an-introduction-github/)

### Sign up for a GitHub account

To sign up for a GitHub account, go to GitHub's [join page](https://github.com/join) and follow the instructions.

* When signing up, you must use your work email address. If you already have an existing GitHub account, that's fine to use, but your work email address must be in your [your account's emails](https://github.com/settings/emails).
* When instructed to choose your subscription, you should select the free plan.
* It is good practice to choose a username that does not contain upper-case characters.
* You should use a secure password following best [practice guidelines](https://security-guidance.service.justice.gov.uk/passwords/#passwords).
* We recommend that you use a password manager, such as [1Password](https://security-guidance.service.justice.gov.uk/using-1password/#using-1password), to generate and store strong passwords.

### Verify your email address for GitHub

Verifying your email address for GitHub ensures that your account is secure and gives you access to all of GitHub's features. Verifying your email address is also required to sign in to the Analytical Platform.

During sign up, GitHub will send you an email with a link to verify your email address.

If you do not verify your email address at this stage, you can do it later by following the instructions [here](https://help.github.com/en/articles/verifying-your-email-address).

### Configure two-factor authentication for GitHub

To get access to the Analytical Platform, you must first configure two-factor authentication (2FA) for GitHub using a mobile app (on your personal or work phone) or via text message. To configure 2FA for GitHub, follow the instructions [here](https://help.github.com/en/articles/configuring-two-factor-authentication).

We recommend that you configure 2FA using a mobile app. In particular, we recommend that you use Google Authenticator or Microsoft Authenticator as they are both widely used. See MoJ guidance [here](https://security-guidance.service.justice.gov.uk/multi-factor-authentication-mfa-guide/#mfa)

For Android:
- [Google Authenticator on Google Play](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2)
- [Microsoft Authenticator on Google Play](https://play.google.com/store/apps/details?id=com.azure.authenticator)

For iPhone:
- [Google Authenticator on the Apple App Store](https://apps.apple.com/us/app/google-authenticator/id388497605)
- [Microsoft Authenticator on the Apple App Store](https://apps.apple.com/gb/app/microsoft-authenticator/id983156458)

During the setup process for any 2FA application, we recommend disabling any “Dark” Mode, Extension or Settings (including themes) in your preferred browser.

Some 2FA applications and QR scanners are unable to scan the QR code generated on a black background. Therefore, these applications and scanners work best, when a QR code is generated, on a white background.

You can re-enable your “Dark” Mode, Extension or Settings once this process has been completed.

### Read more about working with GitHub in MoJ

We use GitHub to store code and collborate on it with others. You should read more about how to work with [git and GitHub](github) on the Analytical Platform. You will need to complete some additional steps before you can start working with it with RStudio or JupyterLab.

## 2. Slack Account

### What is Slack?

Slack is a collaboration tool that helps teams work more effectively together. You can use Slack in several ways:

* to get technical support for the Analytical Platform and analytical tools, such as R, Python and Git
* to submit admin requests relating to apps and data sources on the Analytical Platform
* to share knowledge, expertise and best practice
* to communicate quickly with other Analytical Platform users as an alternative to email

### Access Slack

Send a request to join the ASD Slack workspace [here](https://asdslack.slack.com), once you are part of the workspace you can access the channels within it. To create an account, you will need an email address ending in one of the following:

* @justice.gsi.gov.uk
* @digital.justice.gov.uk
* @cjs.gsi.gov.uk
* @noms.gsi.gov.uk
* @legalaid.gsi.gov.uk
* @justice.gov.uk
* @judiciary.uk

It is not mandatory to join or use Slack (although we highly recommend it) so you shouldn’t use it to make any important announcements and should ensure that you are not excluding anyone from the discussion.

You may have to access Slack differently depending on the IT system you use:

* if you use DOM1, you can access Slack from a browser or on your desktop by downloading Slack app from the [Company Portal](companyportal:ApplicationId=5b3a3776-9335-4994-b940-edb324794764), or using the mobile app on your work phone (note that slack is blocked on personal devices)
* if you use an MoJ Digital and Technology MacBook, you can access Slack from a browser or using the desktop app. You can also access Slack using the mobile app on your personal or work phone
* if you use Quantum, you will not currently be able to access Slack from your computer, however, you can use it via a browser, mobile app on your personal or work phone

## 3. Analytical Platform Account

### What is the Analytical Platform?

The Analytical Platform (often referred to as 'AP') is a data analysis environment, providing modern tools and key datasets for MoJ analysts.

It offers:

* modern data tools and services
* centralised data
* reproducible analysis
* secure and well-engineered environment

See [about the Analytical Platform](/about.html).

The steps required to access the platform (and its resources) are as follows:

1. [Request an account](#request-an-account-from-the-analytical-platform-team)
2. [Wait for invite to our GitHub organisation, then accept](#accept-your-invitation-to-the-moj-analytical-services-github-organisation)
3. [Sign in to the Analytical Platform for the first time](#sign-in-to-the-analytical-platform-for-the-first-time)

### Request an account from the Analytical Platform team

To request an account for the Analytical Platform, please head over to the [#ask-operations-engineering](https://asdslack.slack.com/archives/C01BUKJSZD4) slack channel. Provide your GitHub username and that you want to join the Analytical Services. The [Operations Engineering Team](https://operations-engineering.service.justice.gov.uk/) will invite you to join the [MoJ Analytical Services](https://github.com/moj-analytical-services) GitHub organisation.

> **Note**
> If you are having problems with gaining access to Slack then please contact us via [email](analytical_platform@digital.justice.gov.uk)

### Accept your invitation to the MoJ Analytical Services GitHub organisation

When you are invited to join the MoJ Analytical Services GitHub organisation, you will receive an email with a link to accept the invitation.

You can also accept your invitation by signing in to GitHub and visiting the [organisation page](https://github.com/moj-analytical-services).

### Sign in to the Analytical Platform for the first time

The main entry point to the Analytical Platform is the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).

When you sign in to the Control Panel for the first time, you will be prompted to configure additional two-factor authentication (2FA) for the Analytical Platform itself.

If you are a new member of the organisation, are using the platform for the first time, you will need to log in at least once to be able to get access permissions for data within the platform.

You must configure 2FA for the Analytical Platform using a mobile app (on your personal or work phone). As described above, we recommend Google Authenticator or Microsoft Authenticator as they are both widely used.

As described above, please disable any “Dark” Mode, Extension or Settings (including themes) in your preferred browser, during the 2FA setup process.

> **Note**
> If you are inside an MOJ office you may not be prompted for the additional two-factor authentication (2FA) for the Analytical Platform.


## 3. Slack Account

### What is Slack?

Slack is a collaboration tool that helps teams work more effectively together. You can use Slack in several ways:

* to get technical support for the Analytical Platform and analytical tools, such as R, Python and Git
* to submit admin requests relating to apps and data sources on the Analytical Platform
* to share knowledge, expertise and best practice
* to communicate quickly with other Analytical Platform users as an alternative to email

### Access Slack

Send a request to join the Data and Analysis (ASD) Slack workspace [here](https://asdslack.slack.com), once you are part of the workspace you can access the channels within it. To create an account, you will need an email address ending in one of the following:

* @justice.gsi.gov.uk
* @digital.justice.gov.uk
* @cjs.gsi.gov.uk
* @noms.gsi.gov.uk
* @legalaid.gsi.gov.uk
* @justice.gov.uk
* @judiciary.uk

It is not mandatory to join or use Slack (although we highly recommend it) so you shouldn’t use it to make any important announcements and should ensure that you are not excluding anyone from the discussion.

You may have to access Slack differently depending on the IT system you use:

* if you use DOM1, you can access Slack from a desktop app (via the software center app), browser or using the mobile app on your personal or work phone
* if you use an MoJ Digital and Technology MacBook, you can access Slack from a browser or using the desktop app. You can also access Slack using the mobile app on your personal or work phone
* if you use Quantum, you will not currently be able to access Slack from your computer, however, you can use the mobile app on your personal or work phone


## 4. Training

You can find details on courses and training [here](https://moj-analytical-services.github.io/ap-tools-training/). Upcoming courses are also advertised on The Hive (see Data & Analysis email and Teams communications).

### Channels

Conversations in Slack are organised into channels, which each have a specific topic. After getting access to Slack workspace you need to separately join channels. Channels can be:

* public (all users can join) or
* private (users can only join by invitation) or
* be created based on teams, projects, locations, tools and techniques among others.

 There are several public channels that are widely used and may be useful to join:

* the [#analytical-platform-support](https://asdslack.slack.com/archives/C4PF7QAJZ) channel is used for general discussion of the Analytical Platform -- it is also monitored by the Analytical Platform team, who can help out with any technical queries or requests. Also used to request new or existing apps and app data sources
* the [#ask-data-engineering](https://asdslack.slack.com/archives/C8X3PP1TN) channel is used for general discussion of data engineering and for getting in touch with the data engineering team with any technical queries or requests (such as airflow DAG reviews, database access, data discovery tool, etc).
* the [#git](https://asdslack.slack.com/archives/C4VF9PRLK), [#r](https://asdslack.slack.com/archives/C1PUCG719) and [#python](https://asdslack.slack.com/archives/C1Q09V86S) channels can be used to get support from other users with any technical queries or questions -- the #[intro_r channel](https://asdslack.slack.com/archives/CGKSJV9HN) is aimed specifically at new users of R
* the [#data_science](https://asdslack.slack.com/archives/C1Z8Q18LS) channel is used for general discussion of data science tools and techniques
* the [#general](https://asdslack.slack.com/archives/C1PTUTC3F) channel is used for any discussions that don’t fit anywhere else
* the [#10sc](https://asdslack.slack.com/archives/CC43ZT8AH) channel can be used to get in touch with other people working at 10SC and to ask any questions about the building

There are lots of other channels you can join or you can set up a new one if you think something is missing. You may also wish to set up private channels to discuss specific projects and can direct message individual users.

### Further information

You can find out more about Slack and how to use it in the [Slack Help Centre](https://get.slack.help/hc/en-gb/).


## 5. Using the Analytical Platform

The main entry point to the Analytical Platform is the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).

This allows you to access the various [Analytical Platform tools](tools)

## 6. Best Practice

- See [MoJ Analytical IT Tools Strategy](https://moj-analytical-services.github.io/moj-analytical-it-tools-strategy/) for recommended tools and ways of working

## 7. Contact us

To get support, you can contact the Analytical Platform team on the [#analytical-platform-support]() Slack channel or by [email](mailto:analytical_platform@digital.justice.gov.uk).
