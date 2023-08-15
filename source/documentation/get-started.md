# Quickstart guide

This guide provides the instructions to set up the main accounts and services you need to use the Analytical Platform. Once you complete it, you can: 

- access the Analytical Platform Control Panel
- explore data on the Analytical Platform
- begin developing your application in either JupyterLab or RStudio
- contribute to the Analytical Platform User Guidance

## Before you begin

To use this guide, you need the following:

- a Ministry of Justice-issued Office 365 account
- a Ministry of Justice-issued laptop you can install apps on
- a mobile device you can install apps on
- access to the **Justice Digital workspace** on Slack

Complete this guide in order, following each step closely. 
If you encounter issues, preferably [raise a ticket on GitHub issues](https://github.com/ministryofjustice/data-platform-support/issues/new/choose) 
or email [analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk). 
A member of the Analytical Platform team will contact you.

## 1. Read Terms of Use

For Analytical Platform best practice, you need to follow certain guidelines. Bookmark the following pages and ensure you follow them before you begin using the platform:

- [Acceptable use policy](aup.md): covers the way you should use the Analytical Platform and its associated tools and services
- [Data and Analytical Services Directorate's (DASD) coding standards](https://moj-analytical-services.github.io/our-coding-standards/): principles outlining how you should write and review code
- [MoJ Analytical IT Tools Strategy](https://moj-analytical-services.github.io/moj-analytical-it-tools-strategy/): describes recommended ways of working on the Analytical Platform

## 2. Create Slack account

We use Slack to communicate status updates, such as scheduled maintenance for the Analytical Platform. You can also use it to communicate with our support team and the Analytical Platform user community. 

There are two workspaces we recommend joining: [Justice Digital](https://mojdt.slack.com/) and [ASD](https://asdslack.slack.com/). To join, while signed in to your work email, navigate to each workspace and request to join. Note that workspace moderators only consider users from the following email addresses:

- @justice.gsi.gov.uk
- @digital.justice.gov.uk
- @cjs.gsi.gov.uk
- @noms.gsi.gov.uk
- @legalaid.gsi.gov.uk
- @justice.gov.uk
- @judiciary.uk

> **Note**: You can only access the Justice Digital and ASD workspaces using DOM1 and MoJ Digital and Technology MacBooks. If you use Quantum, you will need to access Slack using a mobile device instead.

### Join Slack channels

Join the following Slack channels in the **ASD workspace**:
- **#ask-data-engineering**: for discussing data engineering and making technical queries to the Data Engineering team regarding Airflow
- **#data_science**: for discussing data science tools and techniques with the Ministry of Justice's Data Science community
- **#git**: for discussing Git tooling with the wider Ministry of Justice community
- **#python**: for discussing Python programming with the wider Ministry of Justice community
- **#r** and **#intro_r**: for discussing R programming with the wider Ministry of Justice community; #intro_r is aimed at new users

Additionally, in the Justice Digital **workspace** join the following:
- **#analytical-platform-support**: for tracking support queries that Analytical Platform users raise on [GitHub Issues](https://github.com/ministryofjustice/data-platform-support/issues)
- **#ask-operations-engineering**: for requesting support with GitHub; you can use this channel to request access to the Analytical Platform later in this guide

## 3. Create GitHub account

Using your work email address (ending either **justice.gov.uk** or **digital.justice.gov.uk**), [sign up for a GitHub account](https://github.com/join). See the [GitHub documentation](https://docs.github.com/en/get-started/signing-up-for-github/signing-up-for-a-new-github-account) for instructions. 

If you already have a GitHub account that you wish to use for work within the Ministry of Justice, you can use it provided you associate your work email address with the account in your user settings.

Ensure that:

- your account uses the free plan subscription
- you choose a username that does not contain upper-case characters (for good practice)
- you set your username to associate with your Git commits for every repository; see the [GitHub documentation](https://docs.github.com/en/get-started/getting-started-with-git/setting-your-username-in-git) for instructions
- you follow the [Ministry of Justice's best practice guidelines](https://security-guidance.service.justice.gov.uk/passwords/#passwords) when setting your password
- you [configure two-factor authentication (2FA)](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication) on your mobile device; we recommend using either Google Authenticator or Microsoft Authenticator for 2FA
    - For more information on 2FA within the Ministry of Justice, see the [MoJ's Security Guidance](https://security-guidance.service.justice.gov.uk/multi-factor-authentication-mfa-guide/#multi-factor-authentication-mfa-guide)

## 4. Access the Analytical Platform

Once you have your GitHub account, there are two more steps to complete before you can access the Analytical Platform: joining the MoJ Analytical Services GitHub organisation and signing in to the Analytical Platform's Control Panel.

### Join MoJ Analytical Services

After configuring your GitHub account you can request access to the Analytical Platform.

Navigate to the [MoJ Analytical Services organisation](https://github.com/moj-analytical-services) and request to join it. The Operations Engineering team will review request. If they approve your request, you will receive an email with a link to accept the invite.

If you do not receive a response within 24 hours, request access in either the **#ask-operations-engineering** Slack channel or email **operations-engineering@digital.justice.gov.uk**, providing your GitHub username in your message.

### Sign in to the Control Panel

The main entry point to the Analytical Platform is the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/). From there, you configure core tools such as JupyterLab and RStudio.

When you access the Control Panel first time, a prompt will appear, requiring you to configure 2FA using your mobile device. Note that while you use your GitHub account to access the Control Panel, this 2FA is separate from the one you use to log in to GitHub. You may need to disable browser extensions such as Dark Mode during the 2FA setup process.

After you log in to the Control Panel for the first time, you can begin requesting access to data on the platform.

## 5. Set up JupyterLab

>**Note**: Only follow this step if you want to use the Analytical Platform as a Python-based user. If you want to use R instead, proceed to step 6 to configure RStudio instead.

If you want to build and deploy applications on the Analytical Platform using Python, you need to set up JupyterLab, the Python-based IDE (Integrated Development Environment) on the Analytical Platform. 

To set up JupyterLab, navigate to the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/tools/). Under **Jupyter Lab Data Science [Git extension]**, use the drop-down menu to select the version of JupyterLab you want to deploy. Unless you need to use a specific version, we recommend selecting the first option in the list. This will deploy JupyterLab on a virtual machine in your browser, with all of the required components it requires to run.

### Create and add JupyterLab SSH key to GitHub

So you can access GitHub repositories from JupyterLab, you need an SSH key to connect the two. Do not try to use an existing SSH key; each tool you use requires a unique key.

To create an SSH key in JupyterLab:

1. Open JupyerLab from the Analytical Platform Control Panel
2. Select the **+** icon in the file browser to open a new **Launcher** tab
3. Navigate to the **Other** section and select **Terminal**
4. Run the following command in your terminal, replacing **your_email@example.com** with the email address you used to sign up for GitHub:

```
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

5. The response will ask you to choose a directory to save the key in; press Enter to accept the default location
6. The response will also ask you to set a passphrase; press Enter to not set a passphrase.
7. To view the SSH key, run:

```
$ cat /home/jovyan/.ssh/id_rsa.pub
```

8. Copy the SSH key to your clipboard

You then need to add the SSH key to GitHub; see the [GitHub documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) for instructions.

## 6. Set up RStudio

>**Note**: Only follow this step if you want to use the Analytical Platform as an R-based user. RStudio supports Python, but we recommend using JupyterLab for Python instead. If you configured JupyterLab in the previous step, proceed to step 7.

If you want to build and deploy applications on the Analytical Platform using R, you need to set up RStudio, the R-based IDE (Integrated Development Environment) the Analytical Platform provides.

To set up RStudio, navigate to the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/tools/). Under **RStudio**, use the drop-down menu to select the version of RStudio you want to deploy. Unless you need to use a specific version, we recommend selecting the first option in the list. This will deploy RStudio on a virtual machine in your browser, with all of the required components it requires to run.

### Create and add RStudio SSH key to GitHub

So you can access GitHub repositories from RStudio, you need an SSH key to connect the two. Do not try to use an existing SSH key; each tool you use requires a unique key.

To create an SSH key in RStudio:

1. Open RStudio from the Analytical Platform Control Panel
2. Navigate to **Tools>Global Options**
3. In the **Options** window, select **Git/SVN** in the navigation menu
4. Select Create RSA key and then Create
5. When the **Information** window appears, select **Close**
6. Select **View public key** and copy the SSH key to your clipboard

You then need to add the SSH key to GitHub; see the [GitHub documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) for instructions.

Now that you have completed this guide you are ready to begin using the Analytical Platform. See [training](training.md) for a list of different resources to help you begin using the platform.