# Deploying a static webapp

## Github repository

Create a repository for you app from the [Data Platfrom App Template](https://github.com/ministryofjustice/data-platform-app-template). By using the template repository, you will be set up with Github Actions files that will deploy a dev and prod environment of your app.

To create your rep:

1. Visit https://github.com/ministryofjustice/data-platform-app-template in your browser
2. Click the "Use this template" button in the top right corner
3. On the "Create a new repository" form , ensure the `ministryofjustice/data-platform-app-template` template is selected
4. Enter a repository name of your choosing. NOTE: the name of the repository will later be used to create your Cloud Platform namespace, and will be used in the url to access your deployed app.
5. Select "Internal" so that only members of the `ministryofjustice` organisation can see your repository.
6. Click the "Create repository" button and wait for your repository to be created.
7. You will redirected to your new repository. You now need to edit the repository settings to add the `analytics-hq` team as an admin. This change is required or your app will later fail to deploy. Follow these steps:
    1. From the main page of your repo, click the "Settings" tab on the nav bar underneath your repo name
    2. Under the "Access" subheading, click "Collaborators and teams" from the left hand menu
    3. Click the "Add teams" button
    4. Search for `ministryofjustice/analytics-hq`, choose "Admin" access and submit the form
    5. Repeat this process for any other github teams that need access

Now that you have your repository, you can [clone it to your local machine](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) and start creating your application, or copy existing code to [push](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository) to the repository.

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
