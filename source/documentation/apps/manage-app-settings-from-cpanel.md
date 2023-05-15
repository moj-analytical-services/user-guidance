# Manage deployment settings of an app on Control panel

After you complete the process of registering an app through Control panel and [initialise the infrastructure resource under Cloud platform](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/cloud-platform-cli.html#functions), you can start to manage the deployment settings through the [Control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).

The settings are stored as github secrets or environment variables depending on whether the setting contains sensitive information or not. 

This section is to explain each setting and how the value of setting affect the app.

## Permission required

The user :-
- Has been granted as the app's admin on Control panel
- Has been the memember of github admin team

If you do not satisfy above requirements, ask someone in your team who has the admin permission on Control panel and github to grant you the permissions.

## Context 

You can have multiple deployment environments for an app for different purposes, minumum is the production environment, then you can have extra ones, e.g. one for testing purpose. 

**What a deploytment environment means to the app?**
it contains the following parts
- A namepace with other required resources on CP's cluster e.g. ECR repo for storing app's docker images
- An environment on github repo
- Set of [deployment settings](#introduction-to-the-settings) under each github environment and can be managed through Control panel
- A endpoint (app URL) for you to access the deployed app under each environment 
The docker image of app will be built and pushed into app's ECR, then be deployed with deployment settings on its namespace via github workflow and can be accessed via the app's URL. 

By default,  2 deployment environments are provided :-
|- `dev` environment:  the environment you can use for testing the changes of your app and can be used as the staging env before releasing a new version to the prod environment.
|-- namespace: `data-platform-app-<repo-name>-dev`
|-- `dev` environment on Github repo
|-- app URL: `<repo_name>-dev.apps.live.cloud-platform.service.justice.gov.uk`
|- `prod` environment:  the production environment where the live app sits 
|-- namespace: `data-platform-app-<repo-name>-prod`
|-- `prod` enviroment on github repo
|-- app URL: `<repo_name>.apps.live.cloud-platform.service.justice.gov.uk`

All the deployment settings linked to each deployment environment will be displayed and can be managed under the app-detail page on Control panel

## Introduction to the settings 

First,  the following flag can be used for switching on/off the user-access-control to the app
<div style="height:0px;font-size:0px;">&nbsp;</div>
| Setting | Format | Description |
|------------------|---------------------------------------------|
| `AUTHENTICATION_REQUIRED` | github environment var | True/False indicate whether your app needs user-access-control, editable|
<div style="height:0px;font-size:0px;">&nbsp;</div>

If the value of flag is `True`, then an auth0 client is required which can be created by clicking the button 
`Create auth0 client` under the deployment environment you choose. The auth0-client is responsible for providing the integration with different login options e.g. 
- passwordless flow: allow user to gain access by one-time magic link. more detail is [here](https://auth0.com/docs/authenticate/passwordless/authentication-methods/email-magic-link). This approach allow external users to be able to access app via their email. This flow appears as `email` in the `AUTH0_CONNECTIONS` field.
- github 
- nomis login (HMPPS Auth): allow the user login with their NOMIS credentials, the guide about how to set it up will be provided soon.

The credentail of the auth0-client with other related settings need to be available in app's deployment environment and be stored as github secrets and environment vars which is explained in the [following section](#authentication-related-settings)

### Authentication related settings

<div style="height:0px;font-size:0px;">&nbsp;</div>
| Command | Format | Description |
|------------------|---------------------------------------------|
| `AUTH0_DOMAIN`   |  github environment var | The domain of the auth0 tenant, not editable  |
| `AUTH0_CLIENT_ID`      | github secret | The client_id of the auth0-client, not editable |
| `AUTH0_CLIENT_SECRET`  | github secret | The client_secret of the auth0-client, not editable |
| `AUTH0_CALLBACK_URL`  | github environment var | The app's callback URL when auth0 will call once the user passes the login stage, not editable |
| `AUTH0_CONNECTIONS`  | stored in auth0 platform | The list of login opions the app can choose, only superuser can edit it|
| `AUTH0_PASSWORDLESS`  | github environment var | only True if `email` is choosen from `AUTH0_CONNECTIONS`, not editable|
<div style="height:0px;font-size:0px;">&nbsp;</div>

If you choose to use `email` (`passwordless` flow),  then you can manage the app's customers for each deployment environment through clicking `Manage customers` button on [app-list page](https://controlpanel.services.analytical-platform.service.justice.gov.uk/webapp-data/). 

Right now we only provide customer management for `email` login option,  if you choose other options like `nomis` or `github` etc, then it means you apps will open to any users who have nomis credential or who has github account and has joined `moj-analytical-services` github org,  further user management and control is required under app-level if the default scope of users is wider than the target audience of the app.

### IP whitelist

You can configure whether your app needs extra protection from internet environment by setting the allowed IP_RANGES (the list VPN managed in MoJ). Even your app is public facing (`AUTHENTICATION_REQUIRED` is `False`), you can still set up this options

<div style="height:0px;font-size:0px;">&nbsp;</div>
| Command | Format | Description |
|------------------|---------------------------------------------|
| `IP_RANGES`      | github secret | The list of MoJ VPNS being allowed to this app, editable|
<div style="height:0px;font-size:0px;">&nbsp;</div>

### Self-defined secrets or environment vars

If the app has own setting and the value of setting depends on which deployment environment the app run,  you can create secret (senstive value e.g., credentail or api-key) or environment variable (non-sensitive value) through app-detail page. 

### other github secrets and environment vars

Other secrets and vars which are not mentioned in the section, if they are not the ones you defined, e.g. having `ECR` or `KUBE` or `AWS` as part of the name,  then they are created during the process of initialising the infrastructure resources on CP and are required by the deployment workflows too.  They are maintained or updated usually through the terraforms of CP.

## Want to make change to `AUTHENTICATION_REQUIRED` flag?

If the flag was off (`False` for `AUTHENTICATION_REQUIRED`) and you switch it on,  then an auth0-client is required to be created by clicking `Create auth0 client` on app-detail page on Control panel. If the client is missing,  a red warning flag will be displayed on the page to remind you

If the flag was on (`True` for `AUTHENTICATION_REQUIRED`) and you swtich it off,  then existing auth0-client becomes redundant and please do remove it by clicking the `Remove the auth0 client` to saving the resource on auth0 platform. 

## Can I make changes(add/remove/update) the secrets/vars on github repo directly?

As the deployment settings are stored as github repo not in Control panel,  any changes made on github repo will be reflected back on Control panel,

DO NOT change the value of the settings mentioned in this section on github repo directly, feel free to change self-defined settings.

## When the changes made on Control panel will be applied to the deployment pipeline?

The changes will be appled when the next deployment workflow is triggered. 
