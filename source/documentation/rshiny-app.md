# Deploying an R Shiny app

⚠️ New app deployments are currently paused until at least the beginning of 2023. If you have an existing app that requires redeployment, please raise an issue in [this repo](https://github.com/moj-analytical-services/analytical-platform-applications/issues) with the template Redeploy App Request. ⚠️

## Basic deployment

### Summary

To create and deploy a Shiny app, you should complete the following steps:

1.  Use the app template.
2.  Create a new webapp.
3.  Clone the repository.
4.  Develop the app.
5.  Manage dependencies.
6.  Set access permissions.
7.  Create a release in GitHub.
8.  Deploy in Concourse.
9.  Add users to the app.
10. Access the app.

**NOTE: Renaming Apps**  You can't rename the app by just renaming the Github repo. You need to create a new repository with the new name and use the old one as a template. Then setup a new webapp.

### Use the app template

#### Rstudio 4

To create a new repository based on the Rstudio 4 Shiny app template:

1. Go to [rshiny-template-405](https://github.com/moj-analytical-services/rshiny-template-405) repository.

2. On the main branch select __Use this template__.
3. Fill in the form:
    * Owner: `moj-analytical-services`
    * Name: The name of your app, for example, `my-app`
    * Privacy: Internal (refer to the [public, internal and private repositories](github.html#public-internal-and-private-repositories) section)
4. Select __Create repository from template__. This copies the entire contents of the app template to a new repository.

#### Legacy Rstudio 3

To create a new repository based on the Shiny app template:


1. Go to the [rshiny-template](https://github.com/moj-analytical-services/rshiny-template) repository.
2. Press the "Branch: master" button and choose a suitable branch, according to the requirements of your app:

    | Branch | How it will run your R Shiny app   |
    |--------|----------------------------------|
    | master | R 3.5.1 with conda packaging     |
    | r-3.4  | R 3.4.2 with packrat packaging   |

    It's recommended, when you start a new project, to upgrade your RStudio version to the latest offered in Control Panel, and select an R Shiny template from this list that matches the R version you have in RStudio.

3. Select __Use this template__.
4. Fill in the form:
    * Owner: `moj-analytical-services`
    * Name: The name of your app, for example, `my-app`
    * Privacy: Internal (refer to the [public, internal and private repositories](github.html#public-internal-and-private-repositories) section)
5. Select __Create repository from template__. This copies the entire contents of the app template to a new repository.

### Create a new webapp

To create a new webapp or webapp data source, ask the Analytical Platform team on the [#analytical_platform](https://asdslack.slack.com/archives/C4PF7QAJZ) Slack channel or by email ([analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk)).

You should:

* provide the URL of the app's GitHub repository
* indicate if a new webapp data source needs to be created
* indicate if any existing webapp data sources need to be connected

The Analytical Platform team will create the webapp and will make you an admin user.

### Clone the repository

To clone the repository into RStudio:

1.  Navigate to the app's repository on GitHub.
2.  Select __Clone or download__.
3.  Ensure that the dialogue says 'Clone with SSH'. If the dialogue says 'Clone with HTTPS' select __Use SSH__.
4.  Copy the SSH URL. This should start with `git@`.
5.  In RStudio, select __File__ > __New project...__ > __Version control__ > __Git__.
6.  Paste the SSH URL in the __Repository URL__ field.
7.  Select __Create Project__.

![](images/shiny/ssh-key.png)

### Develop the app

Develop the app in RStudio.

Your app can take one of several forms:

1.  A directory containing `server.R`, plus, either `ui.R` or a www directory that contains the file `index.html`.
2.  A directory containing `app.R`.
3.  An `.R` file containing an R Shiny application, ending with an expression that produces an R Shiny app object.
4.  A list with `ui` and `server` components.
5.  an R Shiny app object created by `shinyApp`.

By default, the template contains `server.R` and `ui.R` files. However, you may wish to take a different approach depending on your requirements. For example, using `app.R`, it is possible to deploy RShiny apps from within a package, as in this [example from the costmodelr package](https://github.com/RobinL/costmodelr/blob/b328902026bd1cce5d17b487e310c59725ea4d62/R/shiny_explorer.r#L20).

### List your package dependencies

Most apps will have dependencies on various third-party packages (for example, `dplyr`).

In your project repository you will need a file that lists your dependencies. We use 'package management' to manage these lists. The packages change through time and may not always be backwards compatible. To avoid compatibility issues and ensure reproducible outputs, it is necessary to use a package management system, such as renv,  conda, or packrat. For further guidance see the [R package management](tools/rstudio/package-management.html) section.

The Dockerfile in the app's repository contains a command to install the packages in the list. This command will be run when Concourse builds the app.

### Set access permissions

You can set some access permissions for your app in the `deploy.json` file that is included with the app template. This file is used by Concourse to detect apps that are ready to build and deploy.

The `allowed_ip_ranges` parameter controls where your app can be accessed from. It can take any combination of `["DOM1", "QUANTUM", "102PF Wifi", "Digital Wifi and VPN", "Alan Turing Institute", "MoJo"]` or `["Any"]`.

The `disable_authentication` parameter controls whether sign-in (using a link or one-time passcode sent to an authorised email address) is required for users to access the app when on an allowed network. It can take the values `true` or `false`. In general, this should be set to `false`.

When `disable_authentication` is set to `true`, users do not need to go through a sign-in process but can still only access an app using a system specified in `allowed_ip_ranges`. This is a relatively weak security measure, as discussed in the [MoJ security guidance on IP addresses](http://security-guidance.service.justice.gov.uk/authentication/#trusting-ip-addresses). As such, if you wish to disable authentication, you should first discuss this with the Analytical Platform team.

Changes to `deploy.json` only take effect when they are committed to GitHub, a release is created and the deployment is successful.

### Create a release in GitHub

When you're ready to share your app, you should create a release in GitHub. When you create a release, this is detected by Concourse, which will automatically begin the build/deploy process for your app. Each time you create a new release, Concourse will create a new build.

To create a release in GitHub:

1.  Navigate to the app's repository.
2.  Select __release__ > __Draft a new release__.
3.  Choose a tag version for the release -- GitHub provides tagging suggestions at the right of the screen that we advise you to follow.
4.  Choose a title for the release.
5.  Describe the contents of the release.
6.  Select __Publish release__.

### Build and deploy in Concourse

Once you have created a release in GitHub, Concourse should automatically start to deploy your app within a few minutes.

If your app does not deploy automatically, you should first check that the pipeline is not paused.

If the app still does not deploy automatically, you can manually trigger a build by pressing the `+` icon in the top right corner of Concourse.

For more information about using Concourse, see the [build and deploy](/build-deploy.html) section.

#### Troubleshooting build & deploy

##### Packrat

If you are having issues with `packrat.lock`, follow the steps below:

1. Delete the entire `packrat` directory.
2. Comment out all code in the project.
3. Enable packrat using `packrat::init()`.
4. Capture all package dependencies using `packrat::snapshot()`.
5. Uncomment all code in the project and install package dependencies one by one.
6. Rerun `packrat::snapshot()`.
7. Redeploy the app.

##### Deployment exceeded its progress deadline

This error can show at the end of the concourse build log:

    Waiting for deployment "crc-workforce-qa-tool-webapp" rollout to finish: 1 out of 3 new replicas have been updated...
    error: deployment "crc-workforce-qa-tool-webapp" exceeded its progress deadline

This means that there was an error during the startup of the app. See: [Troubleshooting app start-up](#troubleshooting-app-start-up)

##### The application failed to start

Sometimes, an R Shiny app can deploy successfully but result in the following error:

    An error has occurred
    The application failed to start

    The application exited during initialization

This is generic error that means there is an error in your R code or there are missing packages.

#### Troubleshooting app start-up

If the app doesn't start, you need to check the logs: go to Control Panel, find the app and then view the logs. Alternatively view the logs in [Kibana](#kibana).

##### "there is no package called X"

A common error is like this:

    info: Error in library(ROI.plugin.lpsolve) :
        there is no package called ‘ROI.plugin.lpsolve’

This means your R code is trying to use a package ('lpsolve' in this example), but it can't be found. There are a few potential reasons it can't find it.

To try to fix this you should:

* explicitly reference all third-party packages using the double colon operator (i.e. use `shiny::hr()` as opposed to `hr()`)
* check if the package is specified in your repo's environment.yml (if using Conda) / packrat.lock (if using Packrat). If it is not, use re-export your environment / `packrat::snapshot()` (see [R Package Management](tools/rstudio/package-management.html))

In general, it is also good practice to:

* minimise the number of packages you use in your project
* test your app early and often
* test using a cloned copy of the app's repository to avoid issues arising as a result of uncommitted local changes

##### ECONNREFUSED error

If the Shiny app fails to start fully, then as a consequence then you'll see an error in the logs like this:

    error: undefined {"code":"ECONNREFUSED","errno":"ECONNREFUSED","syscall":"connect","address":"127.0.0.1","port":7999,"timestamp":"2020-06-17T09:57:49.895Z"}

To find out what is causing this, look for an earlier error.

### Manage app users

If `disable_authentication` is set to `false` in the `deploy.json` file, access to the app will be controlled by email address.

To manage the users of your app:

1.  Go to the Analytical Platform [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
2.  Select the __Webapps__ tab.
3.  Select the name of the app you want to manage or select __Manage app__.

To add app users:

1.  Enter the email addresses of the users in the box titled 'Add app customers by entering their email addresses' -- multiple email addresses can be separated by spaces, tabs, commas and semicolons, and can contain capital letters.
2.  Select __Add customer__.

To remove an app user, select __Remove customer__ next to the email address of the customer you want to remove.

You can ask the Analytical Platform team to add or remove users to the access list on the [#analytical_platform](https://asdslack.slack.com/archives/C4PF7QAJZ) Slack channel or by email([analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk)).

### Access the app

Your deployed app can be accessed at `repository-name.apps.alpha.mojanalytics.xyz`, where `repository-name` is the name of the relevant GitHub repository.

If the repository name contains underscores, these will be converted to dashes in the app URL. For example, an app with a repository called `repository_name` would have the URL `repository-name.apps.alpha.mojanalytics.xyz`.

When accessing an app, you can choose whether to sign in using an email link (default) or a one-time passcode. To sign in with a one-time passcode, add `/login?method=code` to the end of the app's URL, for example, `https://kpi-s3-proxy.apps.alpha.mojanalytics.xyz/login?method=code`. This requires the app to have been deployed since the auth-proxy [release on 30/01/19](https://github.com/ministryofjustice/analytics-platform-auth-proxy/releases/tag/v0.1.8).

#### Troubleshooting app sign-in

##### "That email address is not authorized for this app (or possibly another error occurred)" error, after entering email address

1. Check that the user is authorised to access the app:
    1. Log in to the [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
    2. Navigate to the app detail page.
    3. Check if the user's email address is listed under 'App customers'.
    4. If it is not, refer them to the app owner to obtain access.
2. Check that the user is using the correct email address – there is sometimes confusion between @justice and @digital.justice email addresses.

##### "Access denied" error, having entered email address and clicked link

1. Check that the user is not trying to use the same link to access the app multiple times – links expire after the first user and a new one must be requested.
2. Check that the user is trying to access the app using Chrome or Firefox – if links automatically open in Internet Explorer, they may need to copy and paste the link without clicking it into Chrome or Firefox.

Sometimes the link doesn't work because it gets accessed by a system such as anti-virus software, spam filters or the email client's 'link previewer' (e.g. to display the web page when you hover over the link). In this case, you should sign in using a one-time passcode, as described above in [access the app](#access-the-app) section.

##### "IP x.x.x.x is not whitelisted"

Check that the user is trying to access the app from one of the trusted networks specified in `deploy.json`.

##### Other troubleshooting tips

* Check that they are trying to access the app using a URL beginning with `https://` not `http://`.
* Look for similar issues log in the [`analytics-platform`](https://github.com/ministryofjustice/analytics-platform/issues) repository.
* Try asking the user to clear their cookies by visiting https://alpha-analytics-moj.eu.auth0.com/logout and try again.

In addition the AP team can:

* Check the Auth0 logs for the app in [Kibana](#kibana)
* Check the Auth0 logs in the [Auth0 console](https://manage.auth0.com)

## Advanced

### Editing the Dockerfile

A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image.

In most cases, you will not need to change the `Dockerfile` when deploying your app.

If your app uses packages that have additional system dependencies, you will need to add these in the `Dockerfile`. If you are unsure how to do this, contact the Analytical Platform team.

A `Dockerfile` reference can be found in the [Docker documentation](https://docs.docker.com/engine/reference/builder/).

### Getting the current user of the app

An  RShiny app can find out who is using it. This can be useful to log an audit trail of significant events. Specifically, it can determine the email address that the user logged into the app with. This is sensitive data, so you must ensure that you are following all relevant information governance processes.

The [shiny-headers-demo](https://github.com/moj-analytical-services/shiny-headers-demo) repository contains an example of how to do this.

These features require you to be using the Analytical Platform version of `shiny-server`.

#### Email address

You can obtain the logged in user's email address by using the following code in the `server` function of your app:

```r
get("HTTP_USER_EMAIL", envir=session$request)
```

[This line](https://github.com/moj-analytical-services/shiny-headers-demo/blob/c274d864e5ee020d3a41497b347b299c07305271/app.R#L58)
in `shiny-headers-demo` shows the code in context.

#### Full user profile

You can access the full user profile by making a request directly from the RShiny app to the auth-proxy's `/userinfo` endpoint using the following code inside your `server` function.

```r
# library(httr)
# library(jsonlite)

profile <- fromJSON(content(GET("http://localhost:3001/userinfo", add_headers(cookie=get("HTTP_COOKIE", envir=session$request))), "text"))
```

[This line](https://github.com/moj-analytical-services/shiny-headers-demo/blob/c274d864e5ee020d3a41497b347b299c07305271/app.R#L61)
shows the code in context.

##### Example response
```json
{
    "email": "name@example.gov.uk",
    "email_verified": true,
    "user_id": "email|12345121312",
    "picture": "https://s.gravatar.com/avatar/94deebe3b87fc5e9b3b4469112573cc0?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fna.png",
    "nickname": "name",
    "identities": [
        {
            "user_id": "12345121312",
            "provider": "email",
            "connection": "email",
            "isSocial": false
        }
    ],
    "updated_at": "2019-07-15T09:54:34.353Z",
    "created_at": "2018-07-12T14:26:45.663Z",
    "name": "name@example.gov.uk",
    "last_ip": "1.1.1.1",
    "last_login": "2019-07-15T09:54:34.353Z",
    "logins_count": 20,
    "blocked_for": [],
    "guardian_authenticators": []
}
```

## Troubleshooting

### Kibana

All logs from deployed apps can be viewed in [Kibana](https://kibana.services.analytical-platform.service.justice.gov.uk).

To view all app logs:

1.  Select __Discover__ from the left sidebar.
2.  Select __Open__ from the menu bar.
3.  Select __Application logs (alpha)__ from the saved searches.

To view the logs for a specific app:

1.  Select __Add a filter__.
2.  Select __app_name__ as the field.
3.  Select __is__ as the operator.
4.  Insert the app name followed by '-webapp' as the value.
5.  Select __Save__.

Log messages are displayed in the __message__ column.

By default, Kibana only shows logs for the last 15 minutes. If no logs are available for that time range, you will receive the warning 'No results match your search criteria'.

To change the time range, select the clock icon in the menu bar. There are several presets or you can define a custom time range.

Kibana also has experimental autocomplete and simple syntax tools that you can use to build custom searches. To enable these features, select __Options___ from within the search bar, then toggle __Turn on query features__.

### Deploying locally

If you have a MacBook, you can use Docker locally to test and troubleshoot your RShiny app. You can download Docker Desktop for Mac from the [Docker website](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

To build and run your R Shiny app locally, follow the steps below:

1.  Clone your app's repository to a new folder on your MacBook -- this guarantees that the app will be built using the same code as on the Analytical Platform. You may need to [create a new connection to GitHub with SSH](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).
2.  Open a terminal session and navigate to the directory containing the `Dockerfile` using the `cd` command.
3.  Build the Docker image by running:
    ```{bash}
    docker build . -t IMAGE:TAG
    ```
    where `IMAGE` is a name for the image, for example, `my-docker-image`, and `TAG` is the version number, for example, `0.1`.
4.  Run a Docker container created from the Docker image by running:
    ```{bash}
    docker run -p 80:9999 IMAGE:TAG
    ```
5.  Go to [127.0.0.1:80](127.0.0.1:80) to view the app.

If the app does not work, follow the steps below to troubleshoot it:

1.  Start a bash session in a Docker container created from the Docker image by running:
    ```{bash}
    docker run -it -p 80:80 IMAGE:TAG bash
    ```
2.  Install the `nano` text editor by running:
    ```{bash}
    apt-get update
    apt-get install nano
    ```
3.  Open `shiny-server.conf` in the `nano` text editor by running:
    ```{bash}
    nano /etc/shiny-server/shiny-server.conf
    ```
4.  Add the following lines at the beginning of `shiny-server.conf`:
    ```{bash}
    access_log /var/log/shiny-server/access.log tiny;
    preserve_logs true;
    ```
5.  Write the changes by pressing `Ctrl+O`.
6.  Exit the `nano` text editor by pressing `Ctrl+X`.
7.  Increase the verbosity of logging and start the Shiny server by running:
    ```{bash}
    export SHINY_LOG_LEVEL=TRACE
    /bin/shiny-server.sh
    ```
8.  Open a new terminal session.
9.  Start a new bash session in the Docker container by running:
    ```{bash}
    docker exec -it CONTAINER_ID bash
    ```
    You can find the `CONTAINER_ID` by running `docker ps`.
10. View the logs by running:
    ```{bash}
    cat /var/log/shiny-server/access.log
    ```

For further details, see the [Shiny server documentation](https://docs.rstudio.com/shiny-server/).
