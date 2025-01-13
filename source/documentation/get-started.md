# Quickstart guide

This guide provides the instructions to set up the main accounts and services you need to use the Analytical Platform. Once you complete it, you can:

- access the Analytical Platform Control Panel
- explore data on the Analytical Platform
- begin developing your application in JupyterLab, RStudio or Visual Studio Code
- contribute to the Analytical Platform User Guidance

## Before you begin

To use this guide, you need the following:

- a Ministry of Justice-issued Office 365 account
- a Ministry of Justice-issued laptop you can install apps on
- a mobile device you can install apps on
- access to the **Justice Digital workspace** on Slack

Complete this guide in order, following each step closely.
If you encounter issues, preferably [raise a ticket on GitHub issues](https://github.com/ministryofjustice/data-platform-support/issues/new/choose)

A member of the Analytical Platform team will contact you.

## 1. Read Terms of Use

For Analytical Platform best practice, you need to follow certain guidelines. Bookmark the following pages and ensure you follow them before you begin using the platform:

- [Acceptable use policy](aup.html): covers the way you should use the Analytical Platform and its associated tools and services
- [Data and Analysis Directorates' coding standards](https://moj-analytical-services.github.io/our-coding-standards/): principles outlining how you should write and review code
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

Conversations in Slack are organised into channels, which each have a specific topic. After getting access to Slack workspace you need to separately join channels. Channels can be:

- public (all users can join) or
- private (users can only join by invitation) or
- be created based on teams, projects, locations, tools and techniques among others.

 There are several public channels that are widely used and may be useful to join:

- the [#analytical-platform-support](https://asdslack.slack.com/archives/C4PF7QAJZ) channel is used for general discussion of the Analytical Platform -- it is also monitored by the Analytical Platform team, who can help out with any technical queries or requests. Also used to request new or existing apps and app data sources
- the [#ask-data-engineering](https://asdslack.slack.com/archives/C8X3PP1TN) channel is used for general discussion of data engineering and for getting in touch with the data engineering team with any technical queries or requests (such as airflow DAG reviews, database access, data discovery tool, etc).
- the [#ask-data-modelling](https://moj.enterprise.slack.com/archives/C03J21VFHQ9) channel is used for general discussion of data modelling and for getting in touch with the analytics engineering team with any technical queries or requests (such as create-a-derived-table model reviews).
- the [#git](https://asdslack.slack.com/archives/C4VF9PRLK), [#r](https://asdslack.slack.com/archives/C1PUCG719) and [#python](https://asdslack.slack.com/archives/C1Q09V86S) channels can be used to get support from other users with any technical queries or questions -- the #[intro_r channel](https://asdslack.slack.com/archives/CGKSJV9HN) is aimed specifically at new users of R
- the [#data_science](https://asdslack.slack.com/archives/C1Z8Q18LS) channel is used for general discussion of data science tools and techniques
- the [#general](https://asdslack.slack.com/archives/C1PTUTC3F) channel is used for any discussions that don’t fit anywhere else
- the [#10sc](https://asdslack.slack.com/archives/CC43ZT8AH) channel can be used to get in touch with other people working at 10SC and to ask any questions about the building

There are lots of other channels you can join or you can set up a new one if you think something is missing. You may also wish to set up private channels to discuss specific projects and can direct message individual users.


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

Please sign into the Analytical Platform GitHub Organisation using [SSO](https://github.com/orgs/moj-analytical-services/sso), to get your GitHub account added to the Analytical Platform GitHub Organisation.

### Sign in to the Control Panel

The main entry point to the Analytical Platform is the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/). From there, you configure core tools such as JupyterLab, RStudio and Visual Studio Code. You log in to the Control Panel using your GitHub account.

When accessing the Control Panel for the first time you will be prompted to authenticate with your Justice account. You only need to do this once, and will not see this on subsequent logins.

### Get Athena Access

Many users of the Analytical Platform wish to query our databases using Amazon Athena. We manage access to our databases via the [Data-Engineering-Database-Access](https://github.com/moj-analytical-services/data-engineering-database-access/tree/main) repository. In order to get access to Athena, you will need to have your `alpha_user_` name added to the [Standard Access](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/project_access/standard-database-access.yaml) list. To do this, raise a PR, and post it in #ask-data-engineering on Slack to get it approved by one of our Data Engineers. Once this PR has been merged, your account will be given access to Athena and a selection of non-sensative datasets. For more information, including how to request access to specific databases via `Projects`, please refer to the [README](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/README.md) for Database Access.

## 5. Set up JupyterLab

>**Note**: Only follow this step if you want to use the Analytical Platform as a Python-based user. If you want to use R instead, proceed to step 6 to configure RStudio instead.

If you want to build and deploy applications on the Analytical Platform using Python, you need to set up JupyterLab, the Python-based IDE (Integrated Development Environment) on the Analytical Platform.

To set up JupyterLab, navigate to the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/tools/). Under **Jupyter Lab Data Science [Git extension]**, use the drop-down menu to select the version of JupyterLab you want to deploy. Unless you need to use a specific version, we recommend selecting the first option in the list. This will deploy JupyterLab on a virtual machine in your browser, with all of the required components it requires to run.

### Create and add JupyterLab SSH key to GitHub

To access GitHub repositories from JupyterLab, you need an SSH key to enable secure communication and authentication between the two services.
Do not try to use an existing SSH key; each tool you use requires a unique key.

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

You also need to authorise your SSH key for use with the MoJ-Analytical-Services organisation before you can use it; see [GitHub: Authorizing an SSH key](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-an-ssh-key-for-use-with-saml-single-sign-on#authorizing-an-ssh-key) for instructions.

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

7. You then need to add the SSH key to GitHub; see the [GitHub documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) for instructions.

8. You also need to authorise your SSH key for use with the MoJ-Analytical-Services organisation before you can use it; see [GitHub: Authorizing an SSH key](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-an-ssh-key-for-use-with-saml-single-sign-on#authorizing-an-ssh-key) for instructions.

Now that you have completed this guide you are ready to begin using the Analytical Platform. See [training](training.md) for a list of different resources to help you begin using the platform.

## 7. Set up Visual Studio Code

>**Note**: Visual Studio Code is a general purpose code editor, therefore it might not have all the capabilities you'd expect from JupyterLab or RStudio.

To set up Visual Studio Code, navigate to the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/tools/). Under **Visual Studio Code**, use the drop-down menu to select the version of Visual Studio Code you want to deploy. Currently there is only one release.

### Create and add Visual Studio Code SSH key to GitHub

To access GitHub repositories from Visual Studio Code, you need an SSH key to enable secure communication and authentication between the two services.
Do not try to use an existing SSH key; each tool you use requires a unique key.

To create an SSH key in Visual Studio Code:

1. Open Visual Studio Code from the Analytical Platform Control Panel
2. Open a new terminal, and run the following commands

```
$ ssh-keygen -t ed25519 -C "<your email address>"
```

5. The response will ask you to choose a directory to save the key in; press Enter to accept the default location
6. The response will also ask you to set a passphrase; press Enter to not set a passphrase.
7. To view the SSH key, run:

```
$ cat ~/.ssh/id_ed25519.pub
```

8. Copy the SSH key to your clipboard

You then need to add the SSH key to GitHub; see the [GitHub documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) for instructions.

You also need to authorise your SSH key for use with the MoJ-Analytical-Services organisation before you can use it; see [GitHub: Authorizing an SSH key](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-an-ssh-key-for-use-with-saml-single-sign-on#authorizing-an-ssh-key) for instructions.
