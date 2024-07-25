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

You can access your applications logs in Cloud platform by following the the CP guidance [Accessing Application Log Data](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/logging-an-app/access-logs.html#accessing-application-log-data)

#### Kibana on Cloud Platform 

Below are some notes to aid you in working with the Kibana service, on Cloud Platform.

All logs from deployed apps can be viewed in [Kibana](https://kibana.cloud-platform.service.justice.gov.uk/_plugin/kibana/app/discover).

To view the logs for a specific app: 

1.  Select **live_kubernetes_cluster** from the `CHANGE INDEX PATTERN` dropdown list.
2.  Select **Add a filter**.
3.  Select **kubernetes.namespace_name**.
4.  Select **is** as the operator.
5.  Insert the app's name space by following the pattern `data-platform-app-<app_name>-<dev/prod>`.
6.  In order to filter out all the logs related health-check, you can put `NOT log:  "/healthz"` in the `KQL` field.
7.  Select **Save**.
8.  (Optional) - you can select to view only the log output by adding it from the **Available Fields** list in the left hand pane using the (+) button revealed on mouse hover

Log messages are displayed in the **message** column.

By default, Kibana only shows logs for the last 15 minutes.
If no logs are available for that time range, you will receive the warning 'No results match your search criteria'.

To change the time range, select the clock icon in the menu bar.
There are several presets or you can define a custom time range.

Kibana also has experimental autocomplete and simple syntax tools that you can use to build custom searches.
To enable these features, select **Options\_** from within the search bar, then toggle **Turn on query features**.


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

```
# The base docker image
FROM ghcr.io/ministryofjustice/analytical-platform-rshiny-open-source-base:1.3.0

# ** Optional step: only if some of R pakcages requires the system libraries which are not covered by base image
#   the one in the example below has been provided in base image.
# RUN apt-get update \
#   && apt-get install -y --no-install-recommends \
#     libglpk-dev


# use renv for packages
ADD renv.lock renv.lock

# Install R packages
RUN R -e "install.packages('renv'); renv::restore()"

# ** Optional step: only if the app requires python packages
# Make sure reticulate uses the system Python
# ENV RETICULATE_PYTHON="/usr/bin/python3"
# ensure requirements.txt exists (created automatically when making a venv in renv)
# COPY requirements.txt requirements.txt
# RUN python3 -m pip install -r requirements.txt

# Add shiny app code
ADD . .

USER 998
```

### Instructions for switching from the AP shiny server to the open-source server

If you already use the legacy AP shiny server image, and would like to switch to the open source server, the key changes you need to make are:

- Change the base docker image in your Dockerfile:

```
FROM ghcr.io/ministryofjustice/analytical-platform-rshiny-open-source-base:1.3.0
```

- If present, ensure the following redundant parts of your Dockerfile are removed:

```
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
