# Visual Studio Code

## Packaged Tools

* [AWS Command Line Interface](https://docs.aws.amazon.com/cli/)

* [Amazon Corretto](https://aws.amazon.com/corretto)

* [Miniconda](https://docs.anaconda.com/free/miniconda/index.html)

* [.NET SDK](https://learn.microsoft.com/en-us/dotnet/core/sdk)

* [Python 3.10](https://www.python.org/downloads/release/python-3100/)

* [Ollama](/tools/visual-studio-code/ollama)

## Known Issues

* Like JupyterLab and RStudio, Visual Studio Code runs on Analytical Platform's Kubernetes infrastructure, therefore we cannot provide access to Docker.

* [Visual Studio Code's port forwarding](https://code.visualstudio.com/docs/editor/port-forwarding) functionality doesn't work, which means you cannot run Dash or Streamlit applications, you will need to continue to [use JupyterLab](https://user-guidance.analytical-platform.service.justice.gov.uk/appendix/dash.html#running-your-app-within-jupyter)

* Due to how Analytical Platform automatically scales tooling up and down depending on user activity, session persistence is not available in Visual Studio Code's extensions, for example [GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github).
