# Deploying a static webapp

It is not currently possible to deploy new apps on the Analytical Platform, though we are working to make this functionality available again as soon as possible.

In the meantime, you can still [access](#access-the-app) and [manage](#manage-app-users) existing apps. 

If you have an existing app that requires urgent redeployment, please submit a [request](https://github.com/moj-analytical-services/analytical-platform-applications/issues/new?assignees=EO510%2C+YvanMOJdigital&labels=redeploy&template=redeploy-app-request.md&title=%5BREDEPLOY%5D) via GitHub. We normally redeploy apps each Wednesday, where we have recevied a request by the Friday before.

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
