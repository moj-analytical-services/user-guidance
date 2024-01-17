# Deploying a static webapp

## GitHub repository

Create a repository for your app from the [Data Platfrom App Template](https://github.com/ministryofjustice/data-platform-app-template). By using the template repository, you will be set up with GitHub Actions files that will deploy a `dev` and `prod` environment of your app.

### Create a repository from the template

1. Visit https://github.com/ministryofjustice/data-platform-app-template in your browser
2. Click the "Use this template" button in the top right corner
3. On the "Create a new repository" form, ensure the `ministryofjustice/data-platform-app-template` template is selected
4. Enter a repository name of your choosing. NOTE: the name of the repository will later be used to create your Cloud Platform namespace, and will be used in the URL to access your deployed app.
5. Select "Internal" so that only members of the `ministryofjustice` organisation can see your repository
6. Click the "Create repository" button and wait for your repository to be created

### Update repository teams

The `analytics-hq` team must be added as a repository admin. This change is required or your app will later fail to deploy. Follow these steps:

1. From the main page of your repo, click the "Settings" tab on the nav bar underneath your repo name
2. Under the "Access" subheading, click "Collaborators and teams" from the left-hand menu
3. Click the "Add teams" button
4. Search for `ministryofjustice/analytics-hq`, choose "Admin" access and submit the form
5. Repeat this process for any other GitHub teams that need access

### Using an existing repository

If you already have a repository and do not wish to create a new one with the `ministryofjustice/data-platform-app-template` you will need to manually copy the contents of the [`.github/workflows`](https://github.com/ministryofjustice/data-platform-app-template/tree/main/.github/workflows) directory into your existing repository. These files are required to deploy the application. 

You will need to create a pull request adding the files and merge to your `main` branch. The CI will fail at this point, but merging will ensure that the `dev` and `prod` repository environments are created.

[Click here for further information about deployments](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#overview).

### Environments

By default, your repository is configured to have `dev` and `prod` [environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment). These will be used to store environment variables and secrets used in the deployment workflows.

The environments are created on the initial run of the `.github/workflows/build-push-deploy-dev.yml` and `.github/workflows/build-push-deploy-prod.yml` workflows. The `dev` workflow is set to run when a PR is created. The `prod` workflow will run when changes are published to the `main` branch.

You can check your environments in your repository [settings](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#creating-an-environment):

1. From the main page of your repo, click the "Settings" tab on the nav bar underneath your repo name
2. Under the "Code and automation" subheading, click "Environments" from the left-hand menu
3. If the `dev` or `prod` environments are missing, create them using the "New Environment" button

If you do not require one of the environments, you should delete it before proceeding to register your app with Control Panel and creating your Cloud Platform namespace.

Follow these steps to delete an environment:
1. Delete the relevant GitHub action workflow file for `dev` or `prod` from your repository
2. Then go to the "Environments" settings in your GitHub repository (steps above) and delete the appropriate environment

### Next steps

Once you have your repository, you can [clone it to your local machine](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) and start writing your application, or copy existing code to [push](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository) to the repository.

You will need to create a `Dockerfile` that builds and runs your application. You can define this yourself entirely, or make use of one of two shiny-server base images that AP offer. [Click here to see further documentation about these](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#shiny-server).

When ready to deploy, you can move on to:

1. Create Cloud Platform namespace(s) for your environments
2. Register the app within Control Panel

## Manage existing apps

### Manage app users

To grant access to someone, in the [Control Panel wepapps tab](https://controlpanel.services.analytical-platform.service.justice.gov.uk/webapps) find your App and click "Manage App". In the 'App customers' section you can let people view your app by putting one or more email addresses in the text box and clicking "Add customer".

## Access the app

The URL for the app will be 
- dev deployment environment: the `<respository-name>-dev` followed by `apps.live.cloud-platform.service.justice.gov.uk`.
- prod deployment environment:  `<respository-name>` followed by `apps.live.cloud-platform.service.justice.gov.uk`.

So for the example project above "static-web-deploy", the deployment URL will be 
- dev: `https://static-web-deploy-dev.apps.live.cloud-platform.service.justice.gov.uk`
- prod: `https://static-web-deploy.apps.live.cloud-platform.service.justice.gov.uk`

Note that characters that are not compatible with website URLs are converted. So, repositories with underscores in their name (e.g. `repository_name.apps...`) will be converted to dashes for the URL (e.g. `repository_name.apps...`).

![](images/static/static_deployed.gif)
