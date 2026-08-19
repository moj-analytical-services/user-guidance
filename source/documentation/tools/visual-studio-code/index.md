# Visual Studio Code (VS Code)

We provide a version of VS Code with a curated set of development tools pre-installed. You can check the [full list of included tools](https://github.com/ministryofjustice/analytical-platform-cloud-development-environment-base?tab=readme-ov-file#features).

## Computing resources

VS Code runs with a standard set of resources. You can request more powerful computing resources (a GPU or 2 CPUs with 24GB of RAM) for your environment if you need them. This includes situations where you’re working with very large or very complex datasets.

Use the following as a guide for which resourcing option to request:

* choose the 2 CPU, 24 GB RAM environment if your work is slow or runs out of memory when using the standard environment

* choose the GPU environment only if the software or guidance you're following specifically recommends using a GPU

Send a message in [#ask-analytical-platform on Slack](https://moj.enterprise.slack.com/archives/C4PF7QAJZ) with:

* the email address for your Analytical Platform account
* the tooling you're using
* the resourcing option you need

>The Analytical Platform provides on-demand GPU resources, but sometimes AWS cannot meet demand. Your environment may fail to start more often compared to the version of VS Code without GPU access. Retrying later usually resolves the issue.

>GPU resources are also shared between multiple users and sessions, so workloads may run more slowly or stop unexpectedly when GPU capacity is limited. If this happens, reduce your workload's GPU requirements or try again later.

## GitHub Copilot

Starting from release 2.41.0, we have included GitHub's [CLI](https://cli.github.com/) and [Copilot CLI](https://github.com/features/copilot/cli).

To authenticate with GitHub, run the following command:

```bash
gh auth login --git-protocol ssh --hostname github.com --skip-ssh-key --web
```

Once authenticated, you can launch GitHub Copilot by running `copilot`.

For more information on using GitHub Copilot CLI, please refer to GitHub's [documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli).

## Accessing a locally running application

As Visual Studio Code's [port forwarding](https://code.visualstudio.com/docs/editor/port-forwarding) functionality does not work in our environment, we have enabled similar functionality using [host based routing](https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/).

To access an application running locally, it must be running on port `8081`, you can then access it by visiting `https://${USERNAME}-vscode-tunnel.tools.analytical-platform.service.justice.gov.uk`.

This cannot be accessed by anyone other than yourself as it uses the same authentication method as Visual Studio Code.

## Known issues and limitations

* Like JupyterLab and RStudio, Visual Studio Code runs on Analytical Platform's Kubernetes infrastructure, therefore we cannot provide access to Docker.

* Due to how Analytical Platform automatically scales tooling up and down depending on user activity, session persistence is not available in Visual Studio Code's extensions, for example [GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github).

* Connecting to Microsoft Azure is possible, however you will need to change the setting `mssql.azureActiveDirectory` to `DeviceCode`, as per this [comment](https://github.com/ministryofjustice/analytical-platform/issues/4246#issuecomment-2088316112)

* We are aware of an [issue](https://github.com/ministryofjustice/analytical-platform/issues/5242) with Visual Studio Code timing out, while we determine the cause of this, users will need to choose "Reload Window".

- Conda's environments do not persist (fresh deployment or unidling) as it's directory `/opt/conda` is not stored on the persistent file system. We are evaluating if we should move this to persistent storage.
