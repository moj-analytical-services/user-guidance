# Deploying an R Shiny app

It is not currently possible to deploy new apps on the Analytical Platform, though we are working to make this functionality available again as soon as possible.

In the meantime, you can still [access](#access-the-app) and [manage](#manage-app-users) existing apps.

If you have an existing app that requires urgent redeployment, please submit a [request](https://github.com/moj-analytical-services/analytical-platform-applications/issues/new?assignees=EO510%2C+YvanMOJdigital&labels=redeploy&template=redeploy-app-request.md&title=%5BREDEPLOY%5D) via GitHub. We normally redeploy apps each Wednesday, where we have recevied a request by the Friday before.

## Manage existing apps

### Manage app users

If authentication is enabled, access to your app will be controlled by email address.

To manage the users of your app:

1.  Go to the Analytical Platform [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
2.  Select the **Webapps** tab.
3.  Select the name of the app you want to manage or select **Manage app**.

To add app users:

1.  Enter the email addresses of the users in the box titled 'Add app customers by entering their email addresses' -- multiple email addresses can be separated by spaces, tabs, commas and semicolons, and can contain capital letters.
2.  Select **Add customer**.

To remove an app user, select **Remove customer** next to the email address of the customer you want to remove.

You can ask the Analytical Platform team to add or remove users to the access list on the [#analytical-platform-support](https://app.slack.com/client/T02DYEB3A/C4PF7QAJZ) Slack channel or by email to[analytical_platform@digital.justice.gov.uk](mailto:analytical_platform@digital.justice.gov.uk).

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

- Check that they are trying to access the app using a URL beginning with `https://` not `http://`.
- Look for similar issues log in the [`analytics-platform`](https://github.com/ministryofjustice/analytics-platform/issues) repository.
- Try asking the user to clear their cookies by visiting https://alpha-analytics-moj.eu.auth0.com/logout and try again.

In addition the AP team can:

- Check the Auth0 logs for the app in [Kibana](#kibana)
- Check the Auth0 logs in the [Auth0 console](https://manage.auth0.com)

## Advanced

### Editing the Dockerfile

A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image.

In most cases, you will not need to change the `Dockerfile` when deploying your app.

If your app uses packages that have additional system dependencies, you will need to add these in the `Dockerfile`. If you are unsure how to do this, contact the Analytical Platform team.

A `Dockerfile` reference can be found in the [Docker documentation](https://docs.docker.com/engine/reference/builder/).

### Getting the current user of the app

An RShiny app can find out who is using it. This can be useful to log an audit trail of significant events. Specifically, it can determine the email address that the user logged into the app with. This is sensitive data, so you must ensure that you are following all relevant information governance processes.

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

1.  Select **Discover** from the left sidebar.
2.  Select **Open** from the menu bar.
3.  Select **Application logs (alpha)** from the saved searches.

To view the logs for a specific app:

1.  Select **Add a filter**.
2.  Select **app_name** as the field.
3.  Select **is** as the operator.
4.  Insert the app name followed by '-webapp' as the value.
5.  Select **Save**.

Log messages are displayed in the **message** column.

By default, Kibana only shows logs for the last 15 minutes. If no logs are available for that time range, you will receive the warning 'No results match your search criteria'.

To change the time range, select the clock icon in the menu bar. There are several presets or you can define a custom time range.

Kibana also has experimental autocomplete and simple syntax tools that you can use to build custom searches. To enable these features, select **Options\_** from within the search bar, then toggle **Turn on query features**.

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