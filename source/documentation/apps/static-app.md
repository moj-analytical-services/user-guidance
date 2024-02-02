# Deploying a static webapp

## GitHub Repository

Create a repository for your application from the [Data Platfrom App Template](https://github.com/ministryofjustice/data-platform-app-template). By using the template repository, you will be set up with GitHub Actions files that will deploy a `dev` and `prod` environment of your application.

### Overview

1. Create your repository
    - [From the template](#create-a-repository-from-the-template)
    - [Or use an existing repository](#using-an-existing-repository)
1. [Update the repository teams](#update-repository-teams)
1. [Check your environments](#environments)
1. [Next steps](#next-steps)

### Create a Repository from the Template

1. Visit https://github.com/ministryofjustice/data-platform-app-template in your browser
1. Click the "Use this template" button in the top right corner
1. On the "Create a new repository" form, ensure the `ministryofjustice/data-platform-app-template` template is selected
1. Enter a repository name of your choosing. NOTE: the name of the repository will later be used to create your Cloud Platform namespace, and will be used in the URL to access your deployed app.
1. Select "Internal" so that only members of the `ministryofjustice` organisation can see your repository
1. Click the "Create repository" button and wait for your repository to be created

### Using an Existing Repository

If you already have a repository and do not wish to create a new one with the `ministryofjustice/data-platform-app-template` you will need to manually copy the contents of the [`.github/workflows`](https://github.com/ministryofjustice/data-platform-app-template/tree/main/.github/workflows) directory into your existing repository. These files are required to deploy the application. 

You will need to create a pull request adding the files and merge to your `main` branch. The CI will fail at this point, but merging will ensure that the `dev` and `prod` repository environments are created.

[Click here for further information about deployments](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#overview).

### Update Repository Teams

The `analytics-hq` team must be added as a repository admin. This change is required or your application will later fail to deploy. Follow these steps:

1. From the main page of your repo, click the "Settings" tab on the nav bar underneath your repo name
1. Under the "Access" subheading, click "Collaborators and teams" from the left-hand menu
1. Click the "Add teams" button
1. Search for `ministryofjustice/analytics-hq`, choose "Admin" access and submit the form
1. Repeat this process for any other GitHub teams that need access

### Environments

By default, your repository is configured to have `dev` and `prod` [environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment). These will be used to store environment variables and secrets used in the deployment workflows.

The environments are created on the initial run of the `.github/workflows/build-push-deploy-dev.yml` and `.github/workflows/build-push-deploy-prod.yml` workflows. The `dev` workflow is set to run when a PR is created. The `prod` workflow will run when changes are published to the `main` branch.

You can check your environments in your repository [settings](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment):

1. From the main page of your repo, click the "Settings" tab on the nav bar underneath your repo name
1. Under the "Code and automation" subheading, click "Environments" from the left-hand menu
1. If the `dev` or `prod` environments are missing, create them using the "New Environment" button

If you do not require one of the environments, you should delete it before proceeding to register your application with Control Panel and creating your Cloud Platform namespace.

Follow these steps to delete an environment:
1. Delete the relevant GitHub action workflow file for `dev` or `prod` from your repository
2. Then go to the "Environments" settings in your GitHub repository (steps above) and delete the appropriate environment

### Next steps

Once you have your repository, you can [clone it to your local machine](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) and start writing your application, or copy existing code to [push](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository) to the repository.

You will need to create a `Dockerfile` that builds and runs your application. You can define this yourself entirely, or make use of one of two shiny-server base images that AP offer. [Click here to see further documentation about these](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#shiny-server).

When ready to deploy, you can move on to:

1. Create Cloud Platform namespace(s) for your environments
2. Register the application within Control Panel


## Cloud Platform Environments

Repeat the following process for each of the environments (`dev`, `prod`) that you require.

You can follow the instructions for each step individually, with a pull request for each, or complete all steps and include all the files in a single pull request. All pull requests need to be posted in the `#ask-cloud-platform` slack channel.

### Overview

1. Create a Namespace
1. Create a ECR repository
1. Create a Service Account

### Creating a Namespace

[Follow the "Creating a Cloud Platform environment" instructions](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/env-create.html#creating-a-cloud-platform-environment) to create your namespace. Please note, your namespace name **must** follow the format of:

```data-platform-app-<repo-name>-<env>```

The `<repo-name>` should be the name of the repository you set up in the [previous step](#create-a-repository-from-the-template), not the full url.

The `<env>` should be `dev` or `prod` based on which environment you are setting up. E.g.

```
data-platform-app-my-github-repo-dev
data-platform-app-app-my-github-repo-prod
```

In addition, you will need to update the generated `01-rbac.yaml` file in your namespace directory to add the `analytics-hq` team. Open the file, and under the `subjects` section, add the following below the existing entry:

```
- kind: Group
  name: "github:analytics-hq"
  apiGroup: rbac.authorization.k8s.io
```

### Create a Container Repository

[Follow the instructions in the Cloud Platform user guidance to add a container repository](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#adding-a-container-repository-to-your-namespace).

If you set up your namespace correctly there should be manual changes required.

### Create a Service Account

[Follow the instructions in the Cloud Platform user guidance to create a service account](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#add-a-service-account-to-your-namespace). You will need to amend the generated `resources/serviceaccount.tf` file:

- Uncomment the `github_repositories` line
- On a new line, add `github_environments = ["<env>"]` where `<env>` is `dev` or `prod`, depending on which environment you are setting up
- On a new line, copy and paste the following variable in its entirety:

```
  serviceaccount_rules = [
    {
      api_groups = [""]
      resources = [
        "pods/portforward",
        "deployment",
        "secrets",
        "services",
        "pods",
        "serviceaccounts",
        "configmaps",
        "persistentvolumeclaims",

      ]
      verbs = [
        "update",
        "patch",
        "get",
        "create",
        "delete",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "extensions",
        "apps",
        "batch",
        "networking.k8s.io",
        "rbac.authorization.k8s.io",
        "policy",
      ]
      resources = [
        "deployments",
        "ingresses",
        "cronjobs",
        "jobs",
        "replicasets",
        "statefulsets",
        "networkpolicies",
        "servicemonitors",
        "roles",
        "rolebindings",
        "poddisruptionbudgets",
      ]
      verbs = [
        "get",
        "update",
        "delete",
        "create",
        "patch",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "monitoring.coreos.com",
      ]
      resources = [
        "prometheusrules",
      ]
      verbs = [
        "*",
      ]
    },
  ]

```

### Reference

You can see a [full example of a namespace directory]((https://github.com/ministryofjustice/cloud-platform-environments/tree/main/namespaces/live.cloud-platform.service.justice.gov.uk/data-platform-app-ap-rshiny-notesbook-dev)) used to host an Analytical Platform application here, with all the above amends made. There are also many other `data-platform-app-` namespaces within the cloud platform environments repo, although as these are managed by the app owners, there may be some custom changes.

## Register the Application in Control Panel

> [!IMPORTANT]
> You will need to have setup your GitHub repository to complete ths step

1. Login to the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk)
1. Click the "Webapps" link in the main navigation, and click the "Register app" button at the bottom of the page
1. Enter the full URL of your GitHub repository
1. Choose to create a new webapp data source (S3 bucket), connect an existing data source, or choose to do this later.
> [!NOTE]
> If you choose "Do this later" you will be able to create a Webapp data source by clicking the "Webapp data" button in the main navigation after registering your app. You will then need to come back to the "Manage app" page to link it to your Application.

### Manage the Application

After registering the Application, you will be redirected to a page where you can choose to "Manage Customers" or "Manage app". You will need to make some initial changes before you can add customers for your site, so click the "Manage app" button.

> [!NOTE]
> By default, `AUTHENTICATION_REQUIRED` is true. If this is not the case, you can chagne update this setting and skip the next steps.

Before you can start adding users allowed to access the site, you will need to create an Auth0 client, which is used to manage user access to your Application. 

1. For each environment, click the "Create auth0 client" button. This will:
    - Create an Auth0 client and user group for specific to the Application environment
    - Store the `AUTH0_CLIENT_ID` and `AUTH0_CLIENT_SECRET` as environment secrets in your GitHub repository
1. You can now use the "Manage customers" button from the previous screen to add users for your Application. [See the section below for more details.](#manage-application-users).

> [!IMPORTANT]
> Any settings changes made via the "Manage app" page in Control Panel require the application to be redeployed before coming into effect

The `AUTH0_CLIENT_ID` and `AUTH0_CLIENT_SECRET` that have been added will be used the next time you deploy your Application. In order to deploy a new version of the Application, you will need to create a pull request in your repository. The GitHub actions jobs will redeploy the dev environment when the PR is opened. The prod environment is deployed when the PR has been merged.

[Click here for further information about deployments](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#overview).


## Manage Existing Applications

### Manage Application Users

To grant access to someone, in the [Control Panel wepapps tab](https://controlpanel.services.analytical-platform.service.justice.gov.uk/webapps) find your App and click "Manage App". In the 'App customers' section you can let people view your app by putting one or more email addresses in the text box and clicking "Add customer".

## Accessing the Application

URLs for respective environments are as follows:
- Development: `<repository-name>-dev.apps.live.cloud-platform.service.justice.gov.uk`.
- Production: `<repository-name>.apps.live.cloud-platform.service.justice.gov.uk`.
> [!NOTE]  
> The environment is not explicitly stated in the production URL.

### Example URLs

For the example project above "static-web-deploy", the respective deployment URLs would be:
- Development: `https://static-web-deploy-dev.apps.live.cloud-platform.service.justice.gov.uk`
- Production: `https://static-web-deploy.apps.live.cloud-platform.service.justice.gov.uk`

Note that characters that are not compatible with website URLs are converted. Therefore repositories with underscores in their name (e.g. `repository_name.apps...`) will be converted to dashes for the URL (e.g. `repository-name.apps...`).

![](images/static/static_deployed.gif)
