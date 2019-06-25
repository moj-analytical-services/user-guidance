# Introduction

## What is the Analytical Platform?

__The Analytical Platform is a cloud–based system that provides a range of services, tools and resources to analysts across MoJ.__

The Analytical Platform:

*   provides access to the latest versions of open–source analytical software, such as RStudio and JupyterLab, allowing analysts to work in the way that suits them best
*   allows analysts to freely install packages from CRAN and PyPI, enabling them to utilise advanced analytical tools and techniques, including text mining, predictive analytics and data visualisation
*   uses Amazon S3 and Athena to provide a single location for all of our data, including a growing set of curated data, and GitHub to provide a single location for all of our code -- this enables analysts to collaborate more effectively, share knowledge and produce high–quality reproducible analysis
*   allows analysts to build and deploy interactive apps and web pages that can be used to communicate analysis and insight to decision–makers
*   gives analysts the tools to develop reproducible analytical pipelines (RAPs) to automate time–consuming and repetitive tasks, allowing them to focus on interpreting the results
*   is built in a cloud–based ecosystem that is easy to access remotely from all MoJ IT systems and provides analysts with access to powerful computational resources that can be scaled to meet demand -- this allows analysts to quickly and easily work with big data and perform complex analytical tasks
*   is secure, resilient and has high availability -- this means analysts can depend on it to store their work and data, and to complete time–sensitive and business–critical projects

## Get started

To get started on the Analytical Platform, you should complete the following steps:

1.  [Read our acceptable use policy and coding standards](#read-our-acceptable-use-policy-and-coding-standards).
2.  [Sign up for a GitHub account](#sign-up-for-a-github-account).
3.  [Verify your email address for GitHub](#verify-your-email-address-for-github).
4.  [Configure two-factor authentication for GitHub](#configure-two-factor-authentication-for-github).
5.  [Request an account from the Analytical Platform team](#request-an-account-from-the-analytical-platform-team).
6.  [Accept your invitation to the MoJ Analytical Services GitHub organisation](#accept-your-invitation-to-the-moj-analytical-services-github-organisation).
7.  [Configure two-factor authentication for the Analytical Platform](#configure-two-factor-authentication-for-the-analytical-platform).

### Read our acceptable use policy and coding standards

Use of the Analytical Platform is subject to our [acceptable use policy](#acceptable-use-policy). You should ensure that you have read and understood this before getting started on the Analytical Platform.

You should also follow our [coding standards](https://github.com/moj-analytical-services/our-coding-standards) when working on the Analytical Platform. These set out principles that you should follow when writing and reviewing code.

### Sign up for a GitHub account

To sign up for a GitHub account, go to GitHub's [join page](https://github.com/join) and follow the instructions.

*   When signing up, we recommend that you use your work email address.
*   When instructed to choose your subscription, you should select the free plan.
*   It is good practice to choose a username that does not contain upper-case characters.
*   You should use a secure password following best [practice guidelines](https://github.com/ministryofjustice/itpolicycontent/blob/master/content/security/framework/password-standard.md).
*   We recommend that you use a password manager, such as [LastPass](https://www.lastpass.com/), to generate and store strong passwords.

### Verify your email address for GitHub

Verifying your email address for GitHub ensures that your account is secure and gives you access to all of GitHub's features. Veryifying your email address is also required to sign in to the Analytical Platform.

During sign up, GitHub will send you an email with a link to verify your email address.

If you do not verify your email address at this stage, you can do it later by following the instructions [here](https://help.github.com/en/articles/verifying-your-email-address).

### Configure two-factor authentication for GitHub

To get access to the Analytical Platform, you must first configure two-factor authentication (2FA) for GitHub using a mobile app (on your personal or work phone) or via text message. To configure 2FA for GitHub, follow the instructions [here](https://help.github.com/en/articles/configuring-two-factor-authentication).

We recommend that you configure 2FA using a mobile app. In particular, we recommend that you use [__Authy__](https://authy.com/) for the following reasons:

1.  You can sync 2FA tokens across multiple devices, including mobiles, tablets and computers.
2.  You can create encrypted recovery backups in case you lose your device.
3.  You can use Touch ID, PIN codes and passwords to protect access to your 2FA tokens.
4.  You can still access secure websites when you don't have phone signal.

### Request an account from the Analytical Platform team

To request an account for the Analytical Platform, you should send an email with your GitHub username to the [Analytical Platform team](mailto:analytical_platform@digital.justice.gov.uk). The team will then invite you to join the [MoJ Analytical Services](https://github.com/moj-analytical-services) GitHub organisation.

### Accept your invitation to the MoJ Analytical Services GitHub organisation

When you are invited to join the MoJ Analytical Services GitHub organisation, you will receive an email with a link to accept the invitation.

You can also accept your invitation by signing in to GitHub and visiting the [organisation page](https://github.com/moj-analytical-services).

### Configure two-factor authentication for the Analytical Platform

When you sign in to the Analytical Platform for the first time, you will be prompted to configure additional two-factor authentication (2FA) for the Analytical Platform itself.

To sign in, go to the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).

You must configure 2FA for the Analytical Platform using a mobile app (on your personal or work phone). As described in Section \@ref(configure-two-factor-authentication-for-github), we recommend that you use __Authy__.

## Access the Analytical Platform

The main entry point to the Analytical Platform is the [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz). From here, you can access RStudio and JupyterLab and can manage your warehouse data sources.

You may also need to access other services and tools on the Analytical Platform:

*   [Airflow](https://airflow.tools.alpha.mojanalytics.xyz)
*   [AWS console](https://aws.services.alpha.mojanalytics.xyz)
*   [Concourse](https://concourse.services.alpha.mojanalytics.xyz)
*   [Grafana](https://grafana.services.alpha.mojanalytics.xyz)
*   [Kibana](https://kibana.services.alpha.mojanalytics.xyz)

## Work with analytical tools

### Deploy analytical tools

Before using RStudio, JupyterLab and Airflow, you must first deploy them.

To deploy RStudio, JupyterLab and Airflow on the Analytical Platform, you should complete the following steps:

1.  Go the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).
2.  Select the __Analytical tools__ tab.
3.  Select the __Deploy__ buttons next to RStudio, JupyterLab and Airflow.

It may take a few minutes for the tools to deploy.

### Open analytical tools

To open RStudio, JupyterLab or Airflow:

1.  Go the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).
2.  Select the __Analytical tools__ tab.
3.  Select the __Open__ button to the right of the tool's name.

### Restart analytical tools

If your RStudio, JupyterLab or Airflow is not working as expected, it may help to restart it.

To restart RStudio, JupyterLab or Airflow:

1.  Go the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).
2.  Select the __Analytical tools__ tab.
3.  Select the __Restart__ button to the right of the tool's name.

### Unidle analytical tools

If your RStudio, JupyterLab or Airflow instance is inactive for an extended period of time (for example, overnight) it will be idled.

1.  Go the Analytical Platform [control panel](https://cpanel-master.services.alpha.mojanalytics.xyz).
2.  Select the __Analytical tools__ tab.
3.  Select the __Unidle__ button to the right of the tool's name. 

Unidling usually only takes a few seconds, however, it can take up to several minutes.

## Configure Git and GitHub

To configure Git and GitHub for the Analytical Platform, you must complete the following steps:

1.  [Create an SSH key](#create-an-ssh-key).
2.  [Add the SSH key to GitHub](#add-the-ssh-key-to-github).
3.  [Configure your username and email in Git on the Analytical Platform](#configure-your-username-and-email-in-git-on-the-analytical-platform).

### Create an SSH key

You can create an SSH key in RStudio or JupyterLab. We recommend that you use RStudio.

#### RStudio

To create an SSH key in RStudio, follow the steps below:

1.  Open RStudio from the Analytical Platform control panel.
2.  In the menu bar, select __Tools__ then __Global Options...__
3.  In the options window, select __Git/SVN__ in the navigation menu.
4.  Select __Create RSA key...__
5.  Select __Create__.
6.  Select __Close__ when the information window appears.
7.  Select __View public key__.
8.  Copy the SSH key to the clipboard by pressing Ctrl+C on Windows or ⌘C on Mac.

#### JupyterLab

To create an SSH key in JupyterLab, follow the steps below:

1.  Open JupyerLab from the Analytical Platform control panel.
2.  Select the __+__ icon in the file browser to open a new Launcher tab.
3.  Select __Terminal__ from the 'Other' section.
4.  Create an SSH key by running:
    ```
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
     Here, you should substitute the email address you used to sign up to GitHub.
5.  When prompted to enter a file in which to save the key, press Enter to accept the default location.
6.  When prompted to enter a passphrase, press Enter to not set a passphrase.
6.  View the SSH key by running:  
    ```
    cat /home/jovyan/.ssh/id_rsa.pub
    ```
7.  Select the SSH key and copy it to the clipboard by pressing Ctrl+C on windows or ⌘C on Mac.

### Add the SSH key to GitHub

To add the SSH key to GitHub, you should follow the guidance [here](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account).

### Configure you username and email in Git on the Analytical Platform

To configure your username and email in Git on the Analytical Platform using RStudio or JupyterLab, follow the steps below:

1.  Open a new terminal:
    +   In RStudio, select __Tools__ in the menu bar and then __Shell...__
    +   In JupyterLap, select the __+__ icon in the file browser and then select __Terminal__ from the __Other__ section in the new Launcher tab.
2.  Configure your username by running:
    ```
    git config --global user.name 'Your Name'
    ```
    Here, you should substitute your GitHub username.
3.  Configure your email address by runnung:
    ```
    git config --global user.email 'your_email@example.com'
    ```
    Here, you should substitute the email address you used to sign up to GitHub.

Further guidance on using Git and GitHub with the Analytical Platform can be found in Section \@ref(github).

## Contact us

To get support, you can contact the Analytical Platform team on the [#analytical_platform](https://asdslack.slack.com/messages/C1PTUTC3F/) Slack channel or by [email](mailto:analytical_platform@digital.justice.gov.uk). You can get more information on Slack in Section \@ref(slack).

For more information on support, including incident response, please see our [key support information](https://github.com/ministryofjustice/analytics-platform-ops/wiki/Key-support-information). 

## Slack

### What is Slack?

Slack is a collaboration tool that helps teams work more effectively together. You can use Slack in several ways:

*   to get technical support for the Analytical Platform and analytical tools, such as R, Python and Git
*   to submit admin requests relating to apps and data sources on the Analytical Platform
*   to share knowledge, expertise and best practice
*   to communicate quickly with other Analytical Platform users as an alternative to email

### Access Slack

You can access our Slack workspace [here](https://asdslack.slack.com).

To create an account, you will need an email address ending in @justice.gsi.gov.uk, @digital.justice.gov.uk, @cjs.gsi.gov.uk, @noms.gsi.gov.uk, @legalaid.gsi.gov.uk, @justice.gov.uk or @judiciary.uk.

It is not mandatory to join or use Slack (although we highly recommend it) so you shouldn’t use it to make any important announcements and should ensure that you are not excluding anyone from the discussion.

You may have to access Slack differently depending on the IT system you use:

*   if you use DOM1, you can access Slack from a browser or using the mobile app on your personal or work phone
*   if you use an MoJ Digital and Technology MacBook, you can access Slack from a browser or using the desktop app. You can also access Slack using the mobile app on your personal or work phone
*   if you use Quantum, you will not currently be able to access Slack from your computer, however, you can use the mobile app on your personal or work phone
 
### Channels

Conversations in Slack are organised into channels, which each have a specific topic. Channels can be public (all users can join) or private (users can only join by invitation) and can be created based on teams, projects, locations, tools and techniques among others.

 There are several public channels that are widely used and may be useful to join:

*   the [#git](), [#r]() and [#python]() channels can be used to get support from other users with any technical queries or questions -- the #[intro_r channel]() is aimed specifically at new users of R
*   the [#analytical_platform]() channel is used for general discussion of the Analytical Platform -- it is also monitored by the Analytical Platform team, who can help out with any technical queries
*   the [#ap_admin_request]() channel is used to request new apps and app data sources as well as access to existing apps and data sources
*   the [#data_engineers]() channel is used for general discussion of data engineering and for getting in touch with the data engineering team as well as to submit Airflow DAG pull requests for review
*   the [#data_science]() channel is used for general discussion of data science tools and techniques
*   the [#general]() channel is used for any discussions that don’t fit anywhere else
*   the [#10sc]() channel can be used to get in touch with other people working at 10SC and to ask any questions about the building
 
There are lots of other channels you can join or you can set up a new one if you think something is missing. You may also wish to set up private channels to discuss specific projects and can direct message individual users.

### Further information

You can find out more about Slack and how to use it in the [Slack Help Centre](https://get.slack.help/hc/en-gb/).
