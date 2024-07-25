# Deploying an R Shiny app

Once you've built your Shiny app, you can make it available to users through the Analytical Platform.
We have guidance for:

- [Deploying your app](#app-deployment)
- [Accessing your deployed app](#accessing-the-deployed-app)
- [Managing your app users](#manage-app-users)
- [Managing and Monitoring Deployments](#managing-and-monitoring-deployments)
- [Using Shiny Server](#shiny-server)

as well as common issues faced during these stages of publishing your app.

## App deployment

### New apps

Please follow the steps in the [Deploying a Webapp section](/apps/webapp-app.html)

### Existing apps

#### Overview

Your app environment is made up of two key elements:

- A GitHub workflow
- A Cloud Platform namespace

In brief, the workflow builds and deploys your code as a docker container, and then deploys it to Cloud Platform's kubernetes cluster, in your application's namespace.

The flow looks something like this:

![High level visual overview of apps' deployment pipeline using GitHub Actions](images/apps/overview.svg)

The rationale behind this change is to:

- Facilitate testing - including a working development app version and build artifacts like docker containers - before deploying to production
- Give teams more control over their workflows
- Restore the ability to deploy without the Analytical Platform team's intervention

#### Apps hosted on Cloud Platform

After the move to Cloud Platform hosting for Analytical Platform apps, you’ll have two active deployments of your apps at all times.
These are your 'dev' (development) and 'prod' (production) deployments.

Be aware that both production and dev currently point to the same data.

Your code repository within the [ministryofjustice organisation](https://github.com/ministryofjustice/) was built from the [data-platform-app-template repo](https://github.com/ministryofjustice/data-platform-app-template), and has inherited the continuous integration and continuous delivery (CI/CD) pipelines (GitHub Action workflows) from that repo.
These workflows will automatically build your docker images, push them to a remote image store, and then deploy the application based on how you’ve made your code changes:

- **Deploying your application to your development environment** is done through the `-dev` workflow, which will build-push-deploy when any pull request is made in the repo (e.g. `feature-branch` into `main`, or `feature-branch` into `develop-branch`).
  The workflow can also be manually triggered, though this will only build and push the app, it <u>will not deploy</u> it: repo homepage > Actions (tab) > Run workflow (right hand side of the page).

  - Opening any pull request will trigger a dev deployment.
    Any subsequent pushes to that branch (or to any other open branches) will trigger dev deployments too.
    If you’re working on multiple PRs at once in the repo that you will need to coordinate pushes to your PRs so you can track your deployments.
    You can always cancel workflow runs and rerun deployments from the Actions page in the repo.

- **Deploying your application to your production environment** is done through the `-prod` workflow, which will build-push-deploy either:
  - after a pull request is merged into main
  - upon publishing a release

You can view the status of your deployments either by checking the workflow runs in the Actions tab (repo-url/actions), or by checking out the deployments page (repo-url/deployments).

The above describes how CI/CD will be set up by default in the ministryofjustice repo.
Once you have ownership of the repo, you'll have the ownership of the `.github/workflow/` files too so you will be able to amend the processes and triggers so that they meet your needs.

#### Your app deployment pipeline

GitHub Actions has workflow definitions located in your repository under `.github/workflows/`.

By default, you will be provided with two workflows.
The dev environment workflow is triggered when you _open_ or _contribute to_ a Pull Request from any branch (for example, into your `main` branch).
Its steps are:

- Check out the repository
- Authenticate to AWS
- Build a docker container from your development branch
- If the build is successful, push this container to a container registry
- Run `helm` against the development environment namespace.

The production workflow behaves in the exact same way, containing the same steps, but will be triggered when a Pull Request is _merged_ into `main`, and will deploy to the production namespace instead

### Managing published apps settings

Please follow the steps in the [Managing App settings section](/apps/manage-app-settings-from-cpanel.html)

### Managing published app users

Please follow the steps in the [Managing App users section](/apps/managing-app-users.html)

### Managing published app data access

Please follow the steps in the [Managing App data access section](/apps/managing-app-data-access.html)

### Accessing the deployed app

Please follow the steps in the [Accessing your App section](/apps/accessing-app.html)

## Advanced

### Editing the Dockerfile

A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image.

In most cases, you will not need to change the `Dockerfile` when deploying your app.

If your app uses packages that have additional system dependencies, you will need to add these in the `Dockerfile`. If you are unsure how to do this, contact the Analytical Platform team.

A `Dockerfile` reference can be found in the [Docker documentation](https://docs.docker.com/engine/reference/builder/).

### Getting details of current users of the RShiny app

An RShiny app can find out who is using it.
This can be useful to log an audit trail of significant events.
Specifically, it can determine the email address that the user logged into the app with.
This is sensitive data, so you must ensure that you are following all relevant information governance processes.

The [shiny-headers-demo](https://github.com/moj-analytical-services/shiny-headers-demo) repository contains an example of how to do this.

These features are only available in the Analytical Platform version of `shiny-server` and the open source `shiny server` image provided by AP ([see details of both options below](#shiny-server)).

### Finding current users' email addresses

You can obtain the logged in user's email address by using the following code in the `server` function of your app:

```r
get("HTTP_USER_EMAIL", envir=session$request)
```

[This line](https://github.com/moj-analytical-services/shiny-headers-demo/blob/c274d864e5ee020d3a41497b347b299c07305271/app.R#L58)
in `shiny-headers-demo` shows the code in context.

**NOTE**: Ensure the latest `AuthProxy` image is being used or the user email header will not be accessible. This is defined in the `helm upgrade` command in the GitHub actions files that handle deployments - `build-push-deploy-dev.yml` and `build-push-deploy-prod.yml`.

Check these files for `AuthProxy.Image.Tag` and set it to `latest` as the example below:

```
--set AuthProxy.Image.Tag="latest" \
```

A full example in a working deployed app can be found [here](https://github.com/ministryofjustice/ap-rshiny-notesbook/blob/main/.github/workflows/build-push-deploy-dev.yml#L167C11-L167C47).


### Finding current users' user profiles

You can access the full user profile by making a request directly from the RShiny app to the auth-proxy's `/userinfo` endpoint using the following code inside your `server` function.

```r
# library(httr)
# library(jsonlite)

profile <- fromJSON(content(GET("http://localhost:3001/userinfo", add_headers(cookie=get("HTTP_COOKIE", envir=session$request))), "text"))
```

[This line](https://github.com/moj-analytical-services/shiny-headers-demo/blob/c274d864e5ee020d3a41497b347b299c07305271/app.R#L61)
shows the code in context.

#### Example response

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
#### user-profile caching 

Due to the [auth0 rate limit](https://auth0.com/docs/troubleshoot/customer-support/operational-policies/rate-limit-policy/authentication-api-endpoint-rate-limits#limits-for-production-tenants-of-paying-customers) for `/userinfo`, the user-profile will be 
cached for 10 minutes on auth-proxy. If somehow your app receives an exception, for example, token-expired, from the above call, you can add `/userinfo?force=true`
to refresh the user-profle by force.


## Troubleshooting and monitoring

### Deploying locally

If you have a MacBook, you can use Docker locally to test and troubleshoot your RShiny app.
You can download Docker Desktop for Mac from the [Docker website](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

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
