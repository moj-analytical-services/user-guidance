# Deploying a static webapp

There are two ways to deploy a static webapp.

## Choice of Static Web App Deployment

### Option 1

This option uses [this template](https://github.com/moj-analytical-services/webapp-template) to deploy a full static webapp from GitHub. You may want to use this option if it is important to maintain version history for the full webapp. It also makes it easier for you and your collaborators to understand how the webapp works, make edits and review changes.

### Option 2

This option uses [this template](https://github.com/moj-analytical-services/s3-proxy-webapp-template) to deploy a static webapp from S3. You may want to use this option if you are less worried about versioning the content of your webapp and want to automatically update the frontend of your webapp based on data in S3 (for example, using an Airflow task to automatically generate HTML content).


## Step-by-step guide to deploying a static webapp

### Use the webapp template

To create a new repository based on the webapp template:

1. Go to the [webapp-template](https://github.com/moj-analytical-services/webapp-template) repository (option 1) or the [s3-proxy-webapp-template](https://github.com/moj-analytical-services/s3-proxy-webapp-template) repository (option 2).
2. Select __Use this template__.
3. Fill in the form:
    + Owner: `moj-analytical-services`
    + Name: The name of your app, for example, `my-app`
    + Privacy: Internal (refer to the [public, internal and private repositories](github.html#public-internal-and-private-repositories) section)
4. Select __Create repository from template__.

This copies the entire contents of the app template to a new repository.

### Create a new webapp

To create a new webapp or webapp data source, ask the Analytical Platform team on the #[analytical_platform](https://asdslack.slack.com/archives/C4PF7QAJZ) Slack channel or by email (analytical_platform@digital.justice.gov.uk).

You should:

provide the URL of the app’s GitHub repository
indicate if a new webapp data source needs to be created
indicate if any existing webapp data sources need to be connected
The Analytical Platform team will create the webapp and will make you an admin user.

### In your chosen development enviroment, clone the git repository

You can find the clone link on the Github repository.

To download a copy to start editing on your local machine, you need to 'clone' the repositry. If you're using a shell: `git clone git@github.com:moj-analytical-services/YOUR-REPO-NAME.git`

![](images/static/static_git_clone.gif)

#### Further notes if you're having trouble finding your new repo's url

If you navigate to your new repository's home page (which will have a url in the form `https://github.com/moj-analytical-services/your_name_goes_here`), you can use the following buttons to access this url (make sure you click the 'ssh' button):

![](images/static/use_ssh.PNG)

![](images/static/ssh_url.PNG)


### Work on your web app

Work on your web app using your chosen development environment. As you work, commit your changes to GitHub using your chosen GitHub workflow.

#### Option 1

Add the webapp files (HTML, CSS, JavaScript, etc.) to the `www/` directory of your repository. This will be the root directory of the webapp.

#### Option 2

In your Dockerfile, set the line `ENV AWS_S3_BUCKET=alpha-app-your-app-bucket` to the name of your webapp's S3 bucket. Once your webapp is deployed you can set up your app to read data from the bucket you specified. The webapp will look for and host a `index.html` file that should be located in the root directory of your app's S3 bucket.

### Scan organisation and deploy

Include a `deploy.json` file so that Concourse will automatically build and deploy your app, so that it is running and customers can access it. For more about this see [here](/build-deploy.html).

### Grant secure access to the app

To grant access to someone, in the [Control Panel's Wepapps tag](https://controlpanel.services.alpha.mojanalytics.xyz//webapps) find your App and click "Manage App". In the 'App customers' section you can let people view your app by putting one or more email addresses in the text box and clicking "Add customer".

You can also let anyone access it by setting `"disable_authentication": true` in the `deploy.json` and redeploying it - see above.

**Note** that users can only access the app from a computer on a specified corporate network. These are defined in the `deploy.json` under the parameter `allowed_ip_ranges` - see below.

#### Set access permissions

You can set some access permissions for your app in the `deploy.json` file that is included with the app template. This file is used by Concourse to detect apps that are ready to build and deploy.

The `allowed_ip_ranges` parameter controls where your app can be accessed from. It can take any combination of `["DOM1", "QUANTUM", "102PF Wifi", "Digital Wifi and VPN"]` or `["Any"]`.

The `disable_authentication` parameter controls whether sign-in (using a link or one-time passcode sent to an authorised email address) is required for users to access the app when on an allowed network. It can take the values `true` or `false`. In general, this should be set to `false`.

When `disable_authentication` is set to `true`, users do not need to go through a sign-in process but can still only access an app using a system specified in `allowed_ip_ranges`. This is a relatively weak security measure, as discussed [here](https://ministryofjustice.github.io/security-guidance/standards/authentication/#ip-addresses). As such, if you wish to disable authentication, you should first discuss this with the Analytical Platform team.

Changes to `deploy.json` only take effect when they are committed to GitHub, a release is created and the deployment is successful.

## Accessing the app

Depending on the `disable_authentication` setting, the website will either be available directly or authenticated via email. The URL for the app will be the `respository-name` followed by `apps.alpha.mojanalytics.xyz`.

So for the example project above "static-web-deploy", the deployment URL will be `https://static-web-deploy.apps.alpha.mojanalytics.xyz`.

Note that characters that are not compatible with website URLs are converted. So, repositories with underscores in their name (e.g. `repository_name.apps...`) will be converted to dashes for the URL (e.g. `repository_name.apps...`).

![](images/static/static_deployed.gif)


## Advanced deployment

This section contains guidance for advanced users on app deployment.

### Can I change my build?

Yes - if you know Docker, you are welcome to change the
[Dockerfile](https://github.com/moj-analytical-services/webapp-template/blob/master/Dockerfile).
