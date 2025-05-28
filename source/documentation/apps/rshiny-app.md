# R Shiny app publishing

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

Please follow the steps in in the [Deploying a Webapp section](/apps/static-app.html)

### Existing apps


##### Overview

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

##### Apps hosted on Cloud Platform

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

##### Your app deployment pipeline

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

## Managing published apps

### Manage app users

If authentication is enabled and you choose to use email as the login option, user access management to app can be done through Control Panel.

To manage the users of your app:

1. Login Control Panel as app admin
2. Go to the [Analytical Platform control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
3. Select the **Webapps** tab.
4. Select the name of the app you want to manage or select **Manage customers**.
5. Select the environment where app is deployed (`dev/prod`)

To add app users:

1.  Enter the email addresses of the users in the box titled 'Add app customers by entering their email addresses' -- multiple email addresses can be separated by spaces, tabs, commas and semicolons, and can contain capital letters.
2.  Select **Add customer**.

To remove an app user, select **Remove customer** next to the email address of the customer you want to remove.

### Accessing the deployed app

#### Apps hosted on Cloud Platform

Your deployed app can be accessed at two URLs:

- `prod` is at: `repository-name.apps.live.cloud-platform.service.justice.gov.uk`
- `dev` is at: `repository-name-dev.apps.live.cloud-platform.service.justice.gov.uk`

(where `repository-name` is the name of the relevant GitHub repository)

By default, the user list on  `dev`  empty and you will need to add any users requiring access via control panel.


#### Authenticating to your app

For the dashboard apps using passwordless flow (email login), when accessing an app, you can choose whether to sign in using a one-time passcode (default) or an email magic link.
To sign in with an email magic link, add `/login?method=link` to the end of the app's URL, for example,
`https://apps.live.cloud-platform.service.justice.gov.uk/login?method=code`.


#### **Troubleshooting app sign-in**

##### "That email address is not authorized for this app (or possibly another error occurred)" error, after entering email address

1. Check that the user is authorised to access the app:
   1. Log in to the [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
   2. Navigate to the app detail page.
   3. Choose the right deployment environment (dev/prod)
   4. Check if the user's email address is listed under 'App customers'.
   5. If it is not, refer them to the app owner to obtain access.
2. Check that the user is using the correct email address – there is sometimes confusion between @justice and @digital.justice email addresses.

##### "Access denied" error, having entered email address and copied the one-time passcode into the login page

Please follow the same steps above to check whether the user is in the customer list of the app.

##### "IP x.x.x.x is not allowlisted"

Check that the user is trying to access the app from one of the trusted networks listed on app's app-detail from Control Panel

The app admin can modify the IP_Ranges on the app's app-detail detail page. 

##### Other troubleshooting tips

- Check that they are trying to access the app using a URL beginning with `https://` not `http://`.
- Look for similar issues log in the [`data-platform-support` repository](https://github.com/ministryofjustice/data-platform-support/issues).
- Try asking the user to clear their cookies by visiting https://alpha-analytics-moj.eu.auth0.com/logout and try again.

In addition the AP team can:

- Check the Auth0 logs in the [Auth0 console](https://manage.auth0.com)

## Advanced

### Editing the Dockerfile

A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image.

In most cases, you will not need to change the `Dockerfile` when deploying your app.

If your app uses packages that have additional system dependencies, you will need to add these in the `Dockerfile`. If you are unsure how to do this, contact the Analytical Platform team.

A `Dockerfile` reference can be found in the [Docker documentation](https://docs.docker.com/engine/reference/builder/).

### Getting details of current users of the app

An RShiny app can find out who is using it.
This can be useful to log an audit trail of significant events.
Specifically, it can determine the email address that the user logged into the app with.
This is sensitive data, so you must ensure that you are following all relevant information governance processes.

The [shiny-headers-demo](https://github.com/moj-analytical-services/shiny-headers-demo) repository contains an example of how to do this.

These features are only available in the Analytical Platform version of `shiny-server` and the open source `shiny server` image provided by AP ([see details of both options below](#shiny-server)).

#### Finding current users' email addresses

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


#### Finding current users' user profiles

You can access the full user profile by making a request directly from the RShiny app to the auth-proxy's `/userinfo` endpoint using the following code inside your `server` function.

```r
# library(httr)
# library(jsonlite)

profile <- fromJSON(content(GET("http://localhost:3001/userinfo", add_headers(cookie=get("HTTP_COOKIE", envir=session$request))), "text"))
```

If you are using an R-Shiny base image that is at v1.3.0 or greater, use the example below to get the user data: 

```r
# library(httr)
# library(jsonlite)

cookie=get("HTTP_COOKIE", envir=session$request)
headers <- c(
  "App-Cookie" = cookie
)

profile <- fromJSON(content(GET("http://localhost:3001/userinfo", add_headers(.headers = headers)), "text"))
```

[This line](https://github.com/moj-analytical-services/shiny-headers-demo/blob/c274d864e5ee020d3a41497b347b299c07305271/app.R#L61)
shows the code in context.

You can also access `userinfo` in a similar manner from a Python based application. You will need to access the raw cookie string and pass it as a header in the request to the `userinfo` endpoint.

For example in a Flask application, where you have access to a `request` object, you can retrieve the raw cookie string from the header as below:

```python
cookie = request.headers.get("Cookie")
```

You can then use the [`requests` library](https://requests.readthedocs.io/en/latest/) to call the `userinfo` endpoint, passing the cookie as a `"App-Cookie"` header as below:

```python
requests.get(
    "http://localhost:3001/userinfo",
    headers={"App-Cookie": cookie},
)
```

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
##### user-profile caching 

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

## Managing and Monitoring Deployments 

### Monitoring Deployments

By default all applications deployed into Cloud platform have a basic level of monitoring which can be accessed on the following link [Cloud Platform grafana namespace monitoring](https://grafana.live.cloud-platform.service.justice.gov.uk/d/k8s_views_ns/kubernetes-views-namespaces?orgId=1&refresh=30s&var-datasource=Prometheus&var-namespace=All&var-resolution=30s). Grafana dashboards are accessed using single-sign-on (SSO) via your GitHub account.

This page shows all namespaces and can be refined by typing the name of your namespace in namespace drop down and selecting as needed.

![Grafana screen shot](images/apps/apps-4.png)

Note: Kubernetes defines Limits as the maximum amount of a resource to be used by a container. This means that the container can never consume more than the memory amount or CPU amount indicated. Requests, on the other hand, are the minimum guaranteed amount of a resource that is reserved for a container.

#### A brief overview of namespaces

Within Kubernetes a namespace provides a mechanism for isolating groups of resources within a single cluster, it can be thought of as a virtual cluster within the cluster. Your Application is deployed into its own namespace, this restricts access to your team and enables the setting of resource limits. Within the namespace are the various Kubernetes components:
  

- Pods the smallest deployable units of computing that you can create and manage in Kubernetes, usually one pod per function of your application ie web server, db server.

- Service is a method for exposing a network application that is running as one or more Pods in your cluster, basically simplifying the connections within your namespace.

- Deployment provides declarative updates for Pods and ReplicaSets.

- ReplicaSet's their purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

#### What information is displayed on the Grafana namespace chart:

- Namespace(s) usage on total cluster CPU in % - This is the total usage by all namespaces on the cluster

- Namespace(s) usage on total cluster RAM in % - This is the total usage by all namespaces on the cluster

- Kubernetes Resource Count - A simple count of resources running within your namespace.

- CPU usage by Pod - CPU usage per pod within your namespace.

- Memory usage by Pod - Memory usage per pod within your namespace.

- Nb of pods by state - Count of pods at various states  within your namespace.

- Nb of containers by pod - Number of containers within each pod.

- Replicas available by deployment - the number of replicas available to your deployment.

- Replicas unavailable by deployment - the number of replicas unavailable to your deployment.

- Persistent Volumes Capacity - If your application uses persistent volumes the total capacity is displayed here.

- Persistent Volumes Inodes - If your application uses persistent volumes the detail on the inodes is displayed here.


Further technical details can be found in the [Cloud Platform's Monitoring section of the user guidance](https://user-guide.cloud-platform.service.justice.gov.uk/#monitoring) and [Configuring a dashboard using Grafana UI documentation](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/monitoring-an-app/prometheus.html#configure-a-dashboard-using-the-grafana-ui)

#### Accessing logs

You can access your applications logs in Cloud Platform by following their guidance [Accessing Application Log Data](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/logging-an-app/access-logs-os.html)

#### OpenSearch on Cloud Platform 

Below are some notes to aid you in working with the Opensearch service, on Cloud Platform.

All logs from deployed apps can be viewed in [Opensearch](https://app-logs.cloud-platform.service.justice.gov.uk/_dashboards/app/data-explorer/discover#).

To view the logs for a specific app: 

1.  Select **live_kubernetes_cluster** from the `CHANGE INDEX PATTERN` dropdown in the top left.
2.  Select **Add filter**.
3.  Select **kubernetes.namespace_name**.
4.  Select **is** as the operator.
5.  Insert the app's name space by following the pattern `data-platform-app-<app_name>-<dev/prod>`.
6.  In order to filter out all the logs related health-check, you can put `NOT log:  "/healthz"` in the `DQL` field.
7.  Select **Save**.
8.  (Optional) - you can select to view only the log output by adding it from the **Available Fields** list in the left hand pane using the (+) button revealed on mouse hover

Log messages are displayed in the **log** column.

By default, Opensearch only shows logs for the last 15 minutes.
If no logs are available for that time range, you will receive the warning 'No results match your search criteria'.

To change the time range, select the bar next to the calendar icon at the top of the page.
There are several presets or you can define a custom time range.


### Managing Deployments

Cloud platform  allows teams to connect to the Kubernetes cluster and manage their applications, using  ```kubectl```, the command line tool for Kubernetes.

To do this you will need to setup access through JupyterLab as follows:

- Go to Analytical Platform Control Panel 

- '> Analytical Tools 

- '> open JupyterLab Data Science

- '> Terminal

#### Installing Kubectl

In the terminal session install `kubectl`

1. ```curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"```
2. ```curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"```
3. ```echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check```
      
      If valid, the output is:  `kubectl: OK`
4. ```chmod +x kubectl```
5. ```mkdir -p ~/.local/bin```
6. ```mv ./kubectl ~/.local/bin/kubectl```
7. ```which kubectl```
      
      you should see: `/home/jovyan/.local/bin/kubectl`

You should only need to carry out the above steps once.

#### Setup Cloud Platform Access

Follow the steps in [CP's Generating a Kubeconfig file documentation](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html#generating-a-kubeconfig-file). As we are accessing via Jupyter Labs  step 7 “Move the config file to the location expected by kubectl” has to be carried out slightly differently.

  First upload the `kubecfg.yaml` from your local  PC to the Jupyter terminal session.

  click on the upload arrow (see below) and select the `kubecfg.yaml`

![Jupyter screen shot](images/apps/apps-5.png)

Then continue with the remaining steps in CP’s documentation

#### Accessing the AWS console 

If required you can access the Cloud platform via AWS, please follow the guidance in [Accessing the AWS console (read-only)](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/accessing-the-cloud-console.html)

#### Adding cron job to your application

A cronjob for restarting your application can be setup easier by adding the following line in to your app's development or production GitHub workflow:

```
--set Cron.schedule="0 6 * * *"
```

[crontab.guru](https://crontab.guru/) can be used to setup the schedule.

If you need to a cron job for the other jobs, more guides are available on the Cloud Platform [kubernetes cronjobs](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/other-topics/Cronjobs.html#kubernetes-cronjobs)


#### Changing the resources available to the application

When you deploy an update to the application the Kubernetes resources are built from a standard Helm chart with the following default memory/cpu resources:

Limits -  CPU 25m.  Memory 1Gi

Requests - CPU 3m.  Memory 1Gi

To override this you will have to amend the GitHub  workflow in your application repository

The file(s) to amend are .github/workflows/build-push-deploy-dev.yml or build-push-deploy-prod.yml

Below is the section of code that calls the helm chart 

  > ```
helm upgrade --install --wait --timeout 10m0s --namespace $KUBE_NAMESPACE $KUBE_NAMESPACE mojanalytics/webapp-cp \
--set AuthProxy.Env.Auth0Domain=$AUTH0_DOMAIN \
--set AuthProxy.Env.Auth0Passwordless=$AUTH0_PASSWORDLESS \
--set AuthProxy.Env.Auth0TokenAlg=$AUTH0_TOKEN_ALG \
--set AuthProxy.Env.AuthenticationRequired=$AUTHENTICATION_REQUIRED \
--set AuthProxy.Env.IPRanges=$process_ip_range \
--set AuthProxy.Image.Repository=$ECR_REPO_AUTH0 \
--set AuthProxy.Image.Tag="latest" \
--set Namespace=$KUBE_NAMESPACE \
--set Secrets.Auth0.ClientId=$AUTH0_CLIENT_ID \
--set Secrets.Auth0.ClientSecret=$AUTH0_CLIENT_SECRET \
--set Secrets.Auth0.CookieSecret=$COOKIE_SECRET \
--set ServiceAccount.RoleARN=$APP_ROLE_ARN \
--set WebApp.Image.Repository=$ECR_REPO_WEBAPP \
--set WebApp.Image.Tag=$NEW_TAG_V \
--set WebApp.Name=$KUBE_NAMESPACE \
$custom_variables ```

To change the resources  insert at  the end of the file just before the $custom_variables the following as appropriate, remembering to use the line continuation “\” on the existing last line.

 >          `--set WebApp.resources.limits.cpu=100m \`
 >          `--set WebApp.resources.limits.memory=2Gi \`
 >          `--set WebApp.resources.requests.cpu=50m \`
 >          `--set WebApp.resources.requests.memory=2Gi \`
 >          `$custom_variables`
          

Once the changes are pushed/merged to the repository the values will be applied to your Kubernetes namespace. 

#### Changing the number of instances (pods) on name space

The number of app instances running on `dev`/`prod` is 1 by default, if users experience long response times from the application (apart from trying to improving the performance through the code itself) you can increase the number of instances to reduce the wating time on `dev`/`prod` GitHub workflows, for example :-

```
--set ReplicaCount=3
```

#### Remember: “With great power comes great responsibility”  Your application’s namespace will be one of a number hosted on the same cluster, setting the values too high could crash the cluster!

#### Enabling Web Application Firewall (WAF) for Data Platform Apps

There are two flags that need to be set to enable WAF for your application, Ingress.ModSec.enabled and GithubTeam

To do this modify your app's `build-push-deploy-dev.yml` and `build-push-deploy-prod.yml` GitHub action workflow files as follows:

```
 --set WebApp.Image.Tag=$NEW_TAG_V \
 --set WebApp.Name=$KUBE_NAMESPACE \
 --set Ingress.ModSec.enabled="true" \
 --set GithubTeam="your github team" \
$custom_variables
```

The changes  will be will be applied to your Kubernetes namespace following a push/merge to the repository and the running of the workflow

To disable:

> --set Ingress.ModSec.enabled="false"

#### Adding Extra Annotations to an Ingress

The Data Platform Apps template includes a default set of annotations ([link](https://github.com/ministryofjustice/analytics-platform-helm-charts/blob/222f9b70c51d026dd7c54610ebf7cfcd003064d7/charts/webapp-cp/templates/ingress.yaml#L12-L17)) for the ingress. To include extra annotations, modify your app's `build-push-deploy-dev.yml` and `build-push-deploy-prod.yml` GitHub action workflow files as follows:

```
--set 'Ingress.ExtraAnnotations.nginx\.ingress\.kubernetes\.io/key=value'
```

To add multiple, use a comma separated string

```
--set 'Ingress.ExtraAnnotations.nginx\.ingress\.kubernetes\.io/key=value,Ingress.ExtraAnnotations.nginx\.ingress\.kubernetes\.io/another-key=value'
```

#### Storage guidance

Guidance on storage within Cloud Platform can be found here [Cloud platform storage](https://user-guide.cloud-platform.service.justice.gov.uk/#storage-other-topics) 

#### Continuous Deployment

Within Cloud platform your application is already automatically deployed by Github workflows but further guidance on continuous deployment within  CP can be found here [Cloud Platform continuous deployment.](https://user-guide.cloud-platform.service.justice.gov.uk/#continuous-deployment) 

#### Deploying Updates to the Application

As the application is now hosted in Cloud Platform and GitHub workflow has been implemented, you will now be able to apply update to your application, full guidance can be found here  [Application deployment.](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/rshiny-app.html#app-deployment)

#### Other guidance 

Guidance on  managing Auth and Secrets through the Control Panel can be found [Manage deployment settings of an app on Control Panel.](https://user-guidance.analytical-platform.service.justice.gov.uk/apps/manage-app-settings-from-cpanel.html#manage-deployment-settings-of-an-app-on-control-panel)


## Shiny server

There are a few choices for running a RShiny app on Cloud Platform. The team responsible for developing and maintaining the dashboard app has full control to choose the best way and practices to run the app by building their own Dockerfile.

Since the shiny-framework uses `websocket` as the primary communication protocol between frontend and backend, no matter which choice you decide, the minimum capabilities required are:

- Keeping the connection live as long as possible e.g. implementing heart-beat mechanism.
- Being able to handle the lifecyle of session 
- Providing a method for reconnecting when the websocket drops
- Working with auth-proxy, the AP component responsible for controlling user's access,  unless the app is public facing or application handles authentication itself.

### Open source shiny-server

We provide a solution for using the [open source Shiny Server] [open source Shiny Server](https://github.com/rstudio/shiny-server) with a few minor tweaks to support the `USER_EMAIL` and `COOKIE` headers. The base docker image is defined [here](https://github.com/ministryofjustice/analytical-platform-rshiny-open-source-base/blob/main/Dockerfile). The version of open source shiny server is defined by `SHINY_SERVER_VERSION`, currently set to `1.5.20.1002`.

It offers more features than the previous AP shiny server and supports:

- Better reconnection behaviour:
  - Reconnect and load existing session rather than creating a new session automatically 
  - If reconnection continues to fail, the manual reconnection pop-up will trigger an app reload rather than re-triggering the same reconnection behaviour
- Better session management:
  - The session will be closed when the session is idle for a certain period of time

This behaviour can result in:
- Session data (reactive values) is retained even after a reconnection happens
- Release resources e.g. memory linked to the session which avoids potential memory leaking

It also provides more [configuration options as outlined here](https://docs.posit.co/shiny-server/).

> **NOTE:**
> Options marked as "pro" are not available

### Instructions for using the open source shiny server image

#### Example Dockerfile

The following example can be used as the starting point when making your own Dockerfile. You may need to make adjustments specific to your app.

Please note, the example below is for using version [2.0.0](https://github.com/ministryofjustice/analytical-platform-rshiny-open-source-base/releases/tag/2.0.0) of the [Analytical Platform RShiny Open Source Base image](https://github.com/ministryofjustice/analytical-platform-rshiny-open-source-base). The Dockerfile may vary for apps using older versions of the base image.

```docker
# The base docker image
FROM ghcr.io/ministryofjustice/analytical-platform-rshiny-open-source-base:2.0.0

# ** Optional step: only required if your R packages require system libraries
#   which are not provided by the base image
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    <package-name>

# use renv for packages
ADD renv.lock renv.lock

# Install R packages
RUN R -e "install.packages('renv'); renv::restore()"

# ** Optional step: only required if the app requires python packages
# Set the Python interpreter path for reticulate
ENV RETICULATE_PYTHON="/opt/venv/bin/python"
# Ensure requirements.txt exists (renv or otherwise)
COPY requirements.txt requirements.txt
# Create venv in the path specified above and install dependencies e.g.
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install -r requirements.txt

# Add shiny app code
ADD . .

USER 998
```

### Instructions for switching from the legacy AP shiny server image to the Analytical Platform RShiny Open Source Base image

If you already use the legacy AP shiny server image, and would like to switch to the open source server, the key changes you need to make are:

- Ensure your R project dependencies are up to date and compatible with the R version used by the open source image version you are switching to. You can view a list of releases [here](https://github.com/ministryofjustice/analytical-platform-rshiny-open-source-base/releases)

- Change the base docker image in your Dockerfile to your chosen release:

```docker
FROM ghcr.io/ministryofjustice/analytical-platform-rshiny-open-source-base:2.0.0
```

- If present, ensure the following redundant parts of your Dockerfile are removed:

```docker
ENV PATH="/opt/shiny-server/bin:/opt/shiny-server/ext/node/bin:${PATH}"
ENV SHINY_APP=/srv/shiny-server
ENV NODE_ENV=production

RUN chown shiny:shiny /srv/shiny-server
CMD analytics-platform-shiny-server
EXPOSE 9999
```

#### Update GitHub actions work flows

Assuming the app uses the GitHub actions workflows from AP, the following parameters for helm installation are required in both the `build-push-deploy-dev.yml` and `build-push-deploy-prod.yml` github action workflow files:

```
WebApp.AlternativeHealthCheck.enabled="true"
WebApp.AlternativeHealthCheck.port=9999
```
A complete example for installing the helm chart in the workflow below. These changes will need to be made in both:


```
  helm upgrade --install --wait --timeout 10m0s --namespace $KUBE_NAMESPACE $RELEASE_NAME mojanalytics/webapp-cp \
  --set AuthProxy.Env.Auth0Domain=$AUTH0_DOMAIN \
  --set AuthProxy.Env.Auth0Passwordless=$AUTH0_PASSWORDLESS \
  --set AuthProxy.Env.Auth0TokenAlg=$AUTH0_TOKEN_ALG \
  --set AuthProxy.Env.AuthenticationRequired=$AUTHENTICATION_REQUIRED \
  --set AuthProxy.Env.IPRanges=$process_ip_range \
  --set AuthProxy.Image.Repository=$ECR_REPO_AUTH0 \
  --set AuthProxy.Image.Tag="latest" \
  --set Namespace=$KUBE_NAMESPACE \
  --set WebApp.AlternativeHealthCheck.enabled="true" \
  --set WebApp.AlternativeHealthCheck.port=9999 \
  --set Secrets.Auth0.ClientId=$AUTH0_CLIENT_ID \
  --set Secrets.Auth0.ClientSecret=$AUTH0_CLIENT_SECRET \
  --set Secrets.Auth0.CookieSecret=$COOKIE_SECRET \
  --set ServiceAccount.RoleARN=$APP_ROLE_ARN \
  --set WebApp.Image.Repository=$ECR_REPO_WEBAPP \
  --set WebApp.Image.Tag=$NEW_TAG_V \
  --set WebApp.Name=$KUBE_NAMESPACE \
  $custom_variables
```

You can view a full working example of an app [here](https://github.com/ministryofjustice/ap-rshiny-notesbook). This app uses:
- The AP provided open source RShiny base Docker image. For reference, see the [Dockerfile here](https://github.com/ministryofjustice/ap-rshiny-notesbook/blob/main/Dockerfile)
- The AP provided GitHub action file to deploy a development environment. For reference, see the [GitHub action file)](https://github.com/ministryofjustice/ap-rshiny-notesbook/blob/main/.github/workflows/build-push-deploy-dev.yml)
- A Cloud Platform namespace to host the app. For reference, the environment configuration for this app can be [viewed here](https://github.com/ministryofjustice/cloud-platform-environments/tree/main/namespaces/live.cloud-platform.service.justice.gov.uk/data-platform-app-ap-rshiny-notesbook-dev)


##### Troubleshooting

If you see an error in the `Upgrade the Helm chart` step of a deployment action like the below:

```
Error: "helm upgrade" requires 2 arguments

Usage:  helm upgrade [RELEASE] [CHART] [flags]
Error: Process completed with exit code 1.
```

This indictates there is something wrong with your GitHub action file. Check that it looks exactly as described above, and that all secrets/variables referenced exist within your environment.

Pay **particular attention** to the `helm upgrade` command itself - something as minor as additional whitespace on a line within this section of your file can cause a failure with the above error.

## Cloud Platform IAM Role

If you wish to integrate with AWS services hosted in Cloud Platform's account, such as Amazon DynamoDB, Amazon OpenSearch or Amazon RDS, you will need to run your web application using your Cloud Platform created IAM role.

If you use our [application template](https://github.com/ministryofjustice/data-platform-app-template), you will need to update the following flag in [`build-push-deploy-dev.yml`](https://github.com/ministryofjustice/data-platform-app-template/blob/main/.github/workflows/build-push-deploy-dev.yml) and [`build-push-deploy-dev.yml`](https://github.com/ministryofjustice/data-platform-app-template/blob/main/.github/workflows/build-push-deploy-prod.yml);

```bash
--set ServiceAccount.RoleARN="< ARN of your Cloud Platform IRSA role >"
```
