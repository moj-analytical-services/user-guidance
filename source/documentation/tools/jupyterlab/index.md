# JupyterLab

A development environment for writing Python code, including Python notebooks. If you're new to Python and JupyterLab, you can follow a [self-paced introduction to Python](https://github.com/moj-analytical-services/intro-to-python).

You can also use JupyterLab All Spark, a version with tooling for Spark development.

## Resourcing options

JupyterLab runs with a standard set of resources. You can request an option with more powerful computing resources (2 CPUs with 24GB of RAM) for your environment if you need it. This includes situations where you’re working with very large or very complex datasets. However, we do not have additional options for JupyterLab All Spark.

To request increased resourcing, send a message in [#ask-analytical-platform on Slack](https://moj.enterprise.slack.com/archives/C4PF7QAJZ) with:

* the email address for your Analytical Platform account
* the tooling you're using

## Run notebooks

In JupyterLab, before you can successfully run a notebook, you'll need to select the kernel for this project. If it doesn't appear in the drop-down list, run this in a terminal:

```bash
. myproject/venv/bin/activate
python3 -m ipykernel install --user --name="venv_PROJECTNAMEHERE" --display-name="My project (Python3)"
```

## Run scripts

And if your project has analytical scripts that run in a terminal you could add:

To run Python scripts, you'll need to activate the virtual environment (venv) first:

```bash
cd myproject
. venv/bin/activate
python3 myscript.py
```

### Using a virtual environment

You should use a different virtual environment (venv) for each project you do in Python. There is a little bit of setup to get JupyterLab working with a venv. Follow the instructions below to get started:

0. If you haven't yet created a venv for your project, in terminal run:

    ```bash
    cd myproject
    python3 -m venv venv
    ```

1. In the terminal, inside your project directory, activate your venv:

    ```bash
    source venv/bin/activate
    ```

2. Install the module `ipykernel` within this venv:

    ```bash
    pip install ipykernel
    ```

3. Create a Jupyter kernel which is configured to use your venv, changing the display name to match your project name:

    ```bash
    python3 -m ipykernel install --user --name="venv_PROJECTNAMEHERE" --display-name="My project (Python3)"
    ```

4. In JupyterLab, open your notebook and then select this new kernel by its pretty name in the top right hand corner. It might take a little time/refreshes for it to show up.

To resume work on this after working on another project:

1. Activate the environment:

    ```bash
    cd myproject
    source venv/bin/activate
    ```

    Now you've activated this terminal with your venv, things you run on the command-line will default to using your venv for python packages, rather than the system's packages. That's useful if you run `python3`, run Python scripts or `pip install` more packages.

2. Open the notebook - it’s remembered which kernel you wanted to use for this notebook and you can carry on working with the packages available.

Note: *Once you have associated the kernel with the venv you do not need to recreate or update it*. Any packages that are installed to the venv via `pip` after the kernel is established are immediately available to the kernel.

### Using pipenv in JupyterLab

pipenv is another environment manager for Python. In general, please refer to their [basic guidance](https://pipenv-fork.readthedocs.io/en/latest/basics.html).

Set-up for a project results in the creation of `Pipfile` and `Pipfile.lock` in the root directory of your project folder.

The instructions for someone to install the packages specified in `Pipfile`and`Pipfile.lock` are as follows (you don't create a venv yourself, nor is it necessary to 'activate' the pipenv environment):

```bash
cd myproject
pipenv install
```

To use pipenv in JupyterLab, compared to [using a venv in JupyterLab](../tools/package-management.html#venv-and-pip), the syntax of creating the kernel changes to:

```bash
pipenv install ipykernel
python3 -m ipykernel install --user --name="pipenv-name" --display-name="My project (Python3)"
```

And then select the kernel in JupyterLab as [normal](../tools/package-management.html#venv-and-pip).

## Accessing a locally running application

As of version `JupyterLab v3.6.3-4.1.0`, to access an application running locally (such as Dash or Streamlit), it **must** be running on port `8081`.

You can then access it by visiting `https://${USERNAME}-jupyter-lab-tunnel.tools.analytical-platform.service.justice.gov.uk`. As apps are only accessible on port 8081, you can only run one app at a time.

This cannot be accessed by anyone other than yourself as it uses the same authentication method as your tooling.

There is no longer a requirement to run your app (e.g. Dash or Streamlit) on a base url path e.g. `/\_tunnel\_/8050/`. This is only required for older versions of JupyterLab that are now deprecated.

### Hints and tips

- To run a Dash app on port `8081` use the `port` arg when using the `app.run` command in your code e.g.:

    ```
    if __name__ == '__main__':
        app.run(port=8081)
    ```

- To run a Streamlit app on port `8081` you can use the `--server.port` flag when running the app e.g.

    ```
    streamlit run app.py --server.port 8081
    ```

    Alternatively, set the server port environment variable in your terminal session before running your app: `export STREAMLIT_SERVER_PORT=8081`.

## Hidden Files

Follow [JupyterLab's documentation to hide or display hidden files](https://jupyterlab.readthedocs.io/en/stable/user/files.html#displaying-hidden-files).
