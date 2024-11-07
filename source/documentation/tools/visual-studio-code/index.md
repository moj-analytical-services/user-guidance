# Visual Studio Code

## Packaged Tools

Visual Studio Code uses our Cloud Development Environment Base image, and includes the features highlighted [here](https://github.com/ministryofjustice/analytical-platform-cloud-development-environment-base?tab=readme-ov-file#features).

## Accessing a Locally Running Application

As Visual Studio Code's [port forwarding](https://code.visualstudio.com/docs/editor/port-forwarding) functionality does not work in our environment, we have enabled similar functionality using [host based routing](https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/).

To access an application running locally, it must be running on port `8081`, you can then access it by visiting `https://${USERNAME}-vscode-tunnel.tools.analytical-platform.service.justice.gov.uk`.

This cannot be accessed by anyone other than yourself as it uses the same authentication method as Visual Studio Code.

## Known Issues and Limitations

* Like JupyterLab and RStudio, Visual Studio Code runs on Analytical Platform's Kubernetes infrastructure, therefore we cannot provide access to Docker.

* Due to how Analytical Platform automatically scales tooling up and down depending on user activity, session persistence is not available in Visual Studio Code's extensions, for example [GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github).

* Connecting to Microsoft Azure is possible, however you will need to change the setting `mssql.azureActiveDirectory` to `DeviceCode`, as per this [comment](https://github.com/ministryofjustice/analytical-platform/issues/4246#issuecomment-2088316112)

* We are aware of an [issue](https://github.com/ministryofjustice/analytical-platform/issues/5242) with Visual Studio Code timing out, while we determine the cause of this, users will need to choose "Reload Window".

- Conda's environments do not persist (fresh deployment or unidling) as it's directory `/opt/conda` is not stored on the persistent file system. We are evaluating if we should move this to persistent storage.
