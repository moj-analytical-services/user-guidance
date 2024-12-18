# Deploying a Webapp

## GitHub Repository

The code for your Application needs to live in a GitHub repository within the [Ministry of Justice organisation](https://github.com/ministryofjustice/).

If you don't already have a repository, create one from the [Data Platfrom App Template](https://github.com/ministryofjustice/data-platform-app-template) following the steps below. By using the template you will be set up with GitHub Actions files that will deploy a `dev` and `prod` environment of your application.

If you already have a repository you will need to copy these files manually.

### Overview of steps

1. Setup your repository
    - [From the template](#create-a-repository-from-the-template)
    - [Or use an existing repository](#using-an-existing-repository)
1. [Update the repository teams](#update-repository-teams)
1. [Check your environments](#environments)
1. [Next steps](#next-steps)

### Create a Repository from the Template

1. Visit https://github.com/ministryofjustice/data-platform-app-template in your browser
1. Click the "Use this template" button in the top right corner
1. On the "Create a new repository" form, ensure the `ministryofjustice/data-platform-app-template` template is selected
1. Enter a repository name of your choosing make sure to use hypens and not underscores. NOTE: the name of the repository will later be used to create your Cloud Platform namespace, and will be used in the URL to access your deployed app. 
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

By default, your repository is configured to deploy a `dev` and `prod` [environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment). These will be used to store environment variables and secrets used in the deployment workflows.

The environments are created on the initial run of the `.github/workflows/build-push-deploy-dev.yml` and `.github/workflows/build-push-deploy-prod.yml` workflows. The `dev` workflow is set to run when a PR is created. The `prod` workflow will run when changes are published to the `main` branch.

Check your environments in your [repository settings](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment):

1. From the main page of your repo, click the "Settings" tab on the nav bar underneath your repo name
1. Under the "Code and automation" subheading, click "Environments" from the left-hand menu
1. If the `dev` or `prod` environments are missing, create them using the "New Environment" button
1. There are no further changes required (i.e. you do not need to add any variables or secrets), but you can configure settings such as "Deployment protection rules" as required by your team

If you do not require one of the environments, you should delete it before proceeding to register your application with Control Panel and creating your Cloud Platform namespace.

Follow these steps to delete an environment:
1. Delete the relevant GitHub action workflow file for `dev` or `prod` from your repository
2. Then go to the "Environments" settings in your GitHub repository (steps above) and delete the appropriate environment

### Next steps

Once you have your repository, you can [clone it to your local machine](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) and start writing your application, or copy existing code to [push](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository) to the repository.

You will need to create a `Dockerfile` that builds and runs your application. You can define this yourself entirely, however we recommend you use the open-source Shiny Server image managed by the Analytical Platform. [Click here to see further documentation about this, including an example Dockerfile](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#open-source-shiny-server). The [webapp_examples repo](https://github.com/moj-analytical-services/webapp_examples) may contain applications built using other languages and frameworks too.
> Note: The healthcheck and other endpoints are sent to port 9999 your application will need this set to work.

When ready to deploy, you can move on to:

1. Create Cloud Platform namespace(s) for your environments
2. Register the application within Control Panel


## Cloud Platform Environments

Repeat the following process for each of the environments (`dev`, `prod`) that you require.

You can follow the instructions for each step individually, with a pull request for each, or complete all steps and include all the files in a single pull request.

> **NOTE:**
> Wait for CI checks to pass before requesting a review on your pull requests.
> Request a review by sending a message including a link to your PR in the `#ask-cloud-platform` slack channel.

### Overview

1. Create a Namespace
1. Create a ECR repository
1. Create a Service Account

### Creating a Namespace

> Note: It is important you create the namespace with the correct name to begin with. Changing the namespace afterwards will likely cause breaking changes on deployment.

[Follow the "Creating a Cloud Platform environment" instructions](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/env-create.html#creating-a-cloud-platform-environment) to create your namespace. Your namespace must meet the Ministry of Justice’s guidance on [naming things](https://technical-guidance.service.justice.gov.uk/documentation/standards/naming-things.html).


In addition, you will need to update the generated `01-rbac.yaml` file in your namespace directory to add the `analytics-hq` team. Open the file, and under the `subjects` section, add the following below the existing entry:

```
- kind: Group
  name: "github:analytics-hq"
  apiGroup: rbac.authorization.k8s.io
```

### Create a Container Repository

> Note: It is important you create the ecr.tf correctly to begin with. Changing the anything afterwards will likely cause breaking changes on deployment, and you may need to remove the variables and secrets from your code repository.

[Follow the instructions in the Cloud Platform user guidance to add a container repository](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#adding-a-container-repository-to-your-namespace).

> **IMPORTANT:**
> Amend the created `ecr.tf` file to add the following settings.

1. `github_repositories` should include the name of your repository e.g. `github_repositories = ["<repo-name>]
1. `github_environments` should include the name of the environment you are setting up e.g. `github_environments = ["dev"]`
1. `github_actions_prefix` is set to the environment you are setting up e.g. `github_actions_prefix = "dev"`

You can find further details about these settings [in the Cloud Platform documentation](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/deploying-an-app/container-repositories/create.html#namespace-configuration).

### Create a Service Account

[Follow the instructions in the Cloud Platform user guidance to create a service account](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#add-a-service-account-to-your-namespace). You will need to amend the generated `resources/serviceaccount.tf` file:

- Uncomment the `github_repositories` setting and check the repository name is correct.
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

Further details about these settings can be found in the [Cloud Platform documentation](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#github-actions-secrets).


### Reference

You can see a [full example of a namespace directory](https://github.com/ministryofjustice/cloud-platform-environments/tree/main/namespaces/live.cloud-platform.service.justice.gov.uk/data-platform-app-ap-rshiny-notesbook-dev) used to host an Analytical Platform application here, with all the above amends made. There are also many other `data-platform-app-` namespaces within the cloud platform environments repo, although as these are managed by the app owners, there may be some custom changes. For a list of deployed applications you may also view the [webapp_examples repo](https://github.com/moj-analytical-services/webapp_examples).

## Register the Application in Control Panel

> **IMPORTANT:**
> You will need to have setup your GitHub repository to complete ths step

1. Login to the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk)
1. Click the "Webapps" link in the main navigation, and click the "Register app" button at the bottom of the page
1. Enter the full URL of your GitHub repository
1. Enter your Cloud Platform namespace, without any env suffix
1. Choose to create a new webapp data source (S3 bucket), connect an existing data source, or choose to do this later.
> **NOTE:**
> If you choose "Do this later" you will be able to create a Webapp data source by clicking the "Webapp data" button in the main navigation after registering your app. You will then need to come back to the "Manage app" page to link it to your Application.

### Manage the Application

After registering the Application, you will be redirected to the "Manage app" page where you will find details about your app and can update deployment settings.

> **IMPORTANT:**
> Any settings changes made via the "Manage app" page in Control Panel require the application to be redeployed before coming into effect

You will need to create an Auth0 client to handle authentication for each environment that you setup.

1. For each environment, click the "Create auth0 client" button underneath the deployment settings. This will:
    - Create an Auth0 client and user group for specific to the Application environment
    - Store the `AUTH0_CLIENT_ID` and `AUTH0_CLIENT_SECRET` as environment secrets in your GitHub repository
1. By default authentication is enabled, with passwordless login by email via [Auth0](https://auth0.com/docs/authenticate/passwordless/authentication-methods/email-otp). You can now use the "Manage customers" button from the previous screen to add users for your Application. [See the section below for more details.](#manage-application-users).

The `AUTH0_CLIENT_ID` and `AUTH0_CLIENT_SECRET` that have been added will be used the next time you deploy your Application. In order to deploy a new version of the Application, you will need to create a pull request in your repository. The GitHub actions jobs will redeploy the dev environment when the PR is opened. The prod environment is deployed when the PR has been merged.

[Click here for further information about deployments](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#overview).


## Accessing the Application

URLs for respective environments are as follows:

- Development: `<repository-name>-dev.apps.live.cloud-platform.service.justice.gov.uk`.
- Production: `<repository-name>.apps.live.cloud-platform.service.justice.gov.uk`.

> **NOTE:**
> The environment is not explicitly stated in the production URL.

### Example URLs

For an example project with a repo called "example-webapp", the respective deployment URLs would be:
- Development: `https://example-webapp-dev.apps.live.cloud-platform.service.justice.gov.uk`
- Production: `https://example-webapp.apps.live.cloud-platform.service.justice.gov.uk`

Note that characters that are not compatible with website URLs are converted. Therefore repositories with underscores in their name (e.g. `repository_name.apps...`) will be converted to dashes for the URL (e.g. `repository-name.apps...`).

### Managing your Application

[Further information about managing deployed apps, including managing user access, can be found in the Managing published apps section.](/apps/rshiny-app.html#managing-published-apps)

### Deleting your Webapp 

To delete your Webapp:

> **NOTE:**
> If your webapp uses [data-engineering-database-access](https://github.com/moj-analytical-services/data-engineering-database-access) to access data on the AP, you will need to **remove all references to the app (alpha_app_*) in any project_access .yaml files and [scripts/db_app_policies.py](https://github.com/moj-analytical-services/data-engineering-database-access/blob/main/scripts/db_app_policies.py) before asking for the webapp to be deleted**. Failure to do this may cause breakages to the [data-engineering-database-access](https://github.com/moj-analytical-services/data-engineering-database-access) repository.

1. Raise a support request detailing the name of the webapp via our [support process](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-support.yml). Only Control Panel Administrators can delete webapps from the Control Panel. 
1. Follow the Cloud Platform's guidance on [removing an unneeded namespace](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/deploying-an-app/cleaning-up.html)
