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

> [!CAUTION]
> **Seek advice before using Copilot** with production, privileged or high-value credentials, sensitive operational data, personal or case-level data, restricted systems or repositories, or where you are otherwise unsure whether the proposed use is appropriate.

Starting from release 2.41.0, we have included GitHub's [CLI](https://cli.github.com/) and [Copilot CLI](https://github.com/features/copilot/cli).

GitHub Copilot is an AI coding assistant that can read files, generate and modify code, and, when using agent capabilities, run commands and tools within your development environment. **Users remain responsible for reviewing Copilot's actions and outputs and for ensuring that data, credentials and other sensitive information are handled appropriately.**

The requirements below apply specifically to the use of GitHub Copilot and should be followed alongside the wider Analytical Platform guidance. Existing requirements for secure data handling, information assurance and development continue to apply.

### Before using Copilot

#### Approval and information assurance
- **Make sure your use of Copilot has been agreed with your line management chain.** Teams should have an agreed approach to using Copilot, including when additional advice or approval is required.
- **Follow normal information-assurance requirements.** Where a DPIA or other approval is required for the data or activity, it should cover the intended use of GitHub Copilot.

#### Protect data and credentials

- **Keep data in approved storage.** Datasets and other sensitive information should not be saved within your development environment, including within your Analytical Platform VS Code workspace. Data should be stored in AWS in line with [Analytical Platform guidance](https://user-guidance.analytical-platform.service.justice.gov.uk/data/data-faqs/index.html#where-should-i-store-my-own-data). Be particularly mindful of data inadvertently retained locally in notebook outputs, temporary files or downloads.
- **Keep secrets out of source code and Git.** Never hard-code API keys, passwords or other credentials. Ensure local secret files such as `.env` are excluded from GitHub using `.gitignore`.
- **Be aware that `.gitignore` is not a security boundary.** Copilot Agent may be able to access files in your workspace even where they are excluded from GitHub. GitHub's Copilot content-exclusion controls do not currently apply to Agent mode or Copilot CLI.
- **Check your entire workspace before using agent capabilities.** Review your workspace for sensitive data, outputs or credentials stored locally, and remove anything Copilot does not need access to.

#### Use agent capabilities safely
- **Keep approval controls enabled.** Do not use **Allow all**, **Autopilot**, or equivalent settings that allow Agent actions to proceed without appropriate review. Review terminal commands and tool calls before approving them.
- **Only enable the tools you need.** Copilot Agent can be given access to tools for reading and editing files, executing code, accessing the web and interacting with other services. Review the enabled tools and disable those that are not required for your work. In VS Code, use the **Configure Tools** button in Copilot Chat. In Copilot CLI, use the `--available-tools` or `--excluded-tools` options ([guidance](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/allowing-tools)).
- **Treat Copilot-generated code like your own code.** Review and test changes before committing or running them. Do not bypass secret scanning, push protection or other security controls.

### Getting started

To authenticate with GitHub, run:

```bash
gh auth login --git-protocol ssh --hostname github.com --skip-ssh-key --web
```

Once authenticated, you can use Copilot through either VS Code Chat or Copilot CLI.

### Using GitHub Copilot

There are two main ways to use GitHub Copilot on the Analytical Platform.

#### Option 1 – VS Code Chat

Copilot is integrated directly into VS Code. To open it:

1. Use the VS Code search bar at the top of the window.
2. Search for and select `>Chat: Focus on Chat View` (exact wording may vary).
3. In the Chat window, select **Agent** mode where available.

Agent mode allows Copilot to work across your workspace, including reading and editing files and using enabled tools such as running terminal commands. You will normally be asked to approve actions where required.

#### Option 2 – Copilot CLI

Copilot CLI provides similar agent capabilities through the command line.

From VS Code, use the search bar and select:

`>Chat: New Copilot CLI Session to the Side`

Alternatively, launch it directly from a terminal:

```bash
copilot
```

You can then interact with Copilot directly from the terminal:

For more information, see GitHub's [Copilot CLI documentation](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli).

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
