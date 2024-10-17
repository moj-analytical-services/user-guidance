# Manage deployment settings of an app on Control Panel

After you complete the process of registering an app through Control Panel and [initialise the infrastructure resource under Cloud platform](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#functions), you can start to manage the deployment settings through the [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).

The settings are stored as GitHub secrets or environment variables depending on whether the setting contains sensitive information or not. 

This section is to explain each setting and how the value of the setting affect the app.

## Permission required

The user:
- Has been granted as the app's admin on Control Panel
- Has been the memember of GitHub admin team

If you do not satisfy the above requirements, ask someone in your team who has admin permissions on Control Panel and GitHub to grant you the permissions.

## Context 

You can have multiple deployment environments for an app for different purposes, minumum is the production environment, then you can have extra ones, e.g. one for testing purpose. 

**What is an application environment?**

Environments contain the following parts:
- A namepace with other required resources on Cloud Platform's cluster, e.g. an ECR repo for storing your app's docker images
- An environment on GitHub repo
- [Deployment settings](#introduction-to-the-settings) under each GitHub environment and can be managed through Control Panel
- An ingress (app URL) for you to access the deployed app in each environment 
The docker image of app will be built and pushed into app's ECR, then be deployed with deployment settings on its namespace via GitHub workflow and can be accessed via the app's URL. 

By default, 2 deployment environments are provided :-
- `dev` environment: used for testing changes to your application and can be used as the staging environment before releasing a new version to the production environment.
  - namespace: `data-platform-app-<repo-name>-dev`
  - `dev` environment on GitHub repo
  - app URL: `<repo_name>-dev.apps.live.cloud-platform.service.justice.gov.uk`
- `prod` environment:  the production environment where the live application sits 
  - namespace: `data-platform-app-<repo-name>-prod`
  - `prod` enviroment on GitHub repo
  - app URL: `<repo_name>.apps.live.cloud-platform.service.justice.gov.uk`

All the deployment settings linked to each deployment environment will be displayed and can be managed under the app-detail page on Control Panel.

## Introduction to the settings 

First, the following flag can be used for switching on/off the user-access-control to the app

| Setting | Format | Description |
|---------|---------|---------------------------------------------|
| `AUTHENTICATION_REQUIRED` | GitHub environment var | True/False indicate whether your app needs user-access-control, editable|

If the value of flag is `True`, then an auth0 client is required which can be created by clicking the button 
`Create auth0 client` under the deployment environment you choose. 
The auth0-client is responsible for providing the integration with different login options, for example below:
- passwordless flow: allow user to gain access by one-time magic link. more detail is [here](https://auth0.com/docs/authenticate/passwordless/authentication-methods/email-magic-link). This approach allows external users to be able to access app via their email. This flow appears as `email` in the `AUTH0_CONNECTIONS` field.
- GitHub 
- nomis login (HMPPS Auth): allow the user login with their NOMIS credentials, the guide about how to set it up will be provided soon.

The credentials of the auth0-client with other related settings need to be available in the app's deployment environment and be stored as GitHub secrets and environment vars which is explained in the [following section](#authentication-related-settings)

### Authentication related settings

| Command | Format | Description |
|---------|---------|---------------------------------------------|
| `AUTH0_DOMAIN`   |  GitHub environment var | The domain of the auth0 tenant, not editable  |
| `AUTH0_CLIENT_ID`      | GitHub secret | The client_id of the auth0-client, not editable |
| `AUTH0_CLIENT_SECRET`  | GitHub secret | The client_secret of the auth0-client, not editable |
| `AUTH0_CONNECTIONS`  | stored in auth0 platform | The list of login opions the app can choose, only superuser can edit it|
| `AUTH0_PASSWORDLESS`  | GitHub environment var | only True if `email` is choosen from `AUTH0_CONNECTIONS`, not editable|

If you choose to use `email` (`passwordless` flow),  then you can manage the app's customers for each deployment environment through clicking `Manage customers` button on [app-list page](https://controlpanel.services.analytical-platform.service.justice.gov.uk/webapp-data/). 

Right now we only provide customer management for `email` login option. If you choose other options like `nomis` or `github` etc, then it means your app will be open to any users who have nomis credential or who has a GitHub account and has joined the `moj-analytical-services` GitHub org.  Further user management and control is required under app-level if the default scope of users is wider than the target audience of the app.

### IP allowlist

You can configure whether your app needs extra protection from internet environment by setting the allowed IP_RANGES (the list VPN managed in MoJ). You can set up this option even if your app is public facing (`AUTHENTICATION_REQUIRED` is `False`)

| Command | Format | Description |
|---------|---------|---------------------------------------------|
| `IP_RANGES`      | GitHub secret | The list of MoJ VPNS being allowed to this app, editable|

### Self-defined secrets or environment vars

If the app has its own settings and the value of the setting depends on which deployment environment the app is running in, you can create secret (sensitive value e.g., credential or api-key) or environment variable (non-sensitive value) through the app-detail page. 

The GitHub name of self-defined secrets and environment vars will be have `XXX_` as prefix which differentiate themselves with other system secrets and vars, 
but the prefix `XXX_` will be removed when GitHub workflow (dev/prod) pass the their values to application.

We strongly recommend to define one environment variable for indicating which deployment environment the app is running, is dev environment or production environment?
for example, naming the variable as `ENV`,  then give it a string value of `dev` on dev environment,  a string value of `prod` on prod environment.
In your application code,  retrieve the value of `ENV` by using `Sys.getenv('ENV')` for R,  `os.environ.get('ENV')` for python.


### Other Github secrets and environment vars

Other secrets and vars which are not mentioned in the section, if they are not the ones you defined, e.g. having `ECR` or `KUBE` or `AWS` as part of the name,  then they are created during the process of initialising the infrastructure resources on CP and are required by the deployment workflows too.  They are maintained or updated usually through the terraforms of CP.

## Want to make change to `AUTHENTICATION_REQUIRED` flag?

If the flag was off (`False` for `AUTHENTICATION_REQUIRED`) and you switch it on,  then an auth0-client is required to be created by clicking `Create auth0 client` on app-detail page on Control Panel. If the client is missing,  a red warning flag will be displayed on the page to remind you

If the flag was on (`True` for `AUTHENTICATION_REQUIRED`) and you swtich it off,  then existing auth0-client becomes redundant and please do remove it by clicking the `Remove the auth0 client` to save resource on auth0 platform. 

## Can I make changes(add/remove/update) the secrets/vars on GitHub repo directly?

As the deployment settings are stored in the GitHub repo and not in Control Panel,  any changes made on the GitHub repo will be reflected back in Control Panel.

DO NOT change the value of the settings mentioned in this section on GitHub repo directly, feel free to change self-defined settings.

## When will the changes made on Control Panel will be applied to the deployment pipeline?

The changes will be applied when the next deployment workflow is triggered. 
