# JupyterLab

A development environment for writing Python code including Python notebooks

See: <https://github.com/RobinL/cheatsheets_etc/blob/master/jupyter_conda.md>

## Run notebooks

In Jupyter, before you can successfully run the notebook, you'll need to select the Jupyter kernel for this project. If it doesn't appear in the drop-down list, run this in a terminal:

```bash
. myproject/venv/bin/activate
python3 -m ipykernel install --user --name="venv" --display-name="My project (Python3)"
```

And if your project has analytical scripts that run in a terminal you could add:

## Run scripts

To run the python scripts, you'll need to activate the virtual env first:

```bash
cd myproject
. venv/bin/activate
python3 myscript.py
```

### Using a venv in Jupyter

Jupyter won't use your venv, and the packages installed into it, unless you do the following set-up:

1. In the terminal, activate your venv:

    ```bash
    cd myproject
    source venv/bin/activate
    ```

2. Install the module ipykernel within this venv (for creating/managing kernels for ipython which is what Jupyter sits on top of):

    ```bash
    pip3 install ipykernel
    ```

3. Create a Jupyter kernel which is configured to use your venv. (Change the display name to match your project name):

    ```bash
    python3 -m ipykernel install --user --name="venvname" --display-name="My project (Python3)"
    ```

4. In Jupyter, open your notebook and then select this new kernel by its pretty name in the top right hand corner. It might take a little time/refreshes for it to show up.

To resume work on this after working on another project:

1. Activate the environment:

    ```bash
    cd myproject
    source venv/bin/activate
    ```

    Now you've activated this terminal with your venv, things you run on the command-line will default to using your venv for python packages, rather than the system's packages. That's useful if you run 'python', run python scripts or 'pip install' more packages.

2. Open the notebook - it’s remembered which kernel you wanted to use for this notebook and you can carry on working with the packages available.

Note: *Once you have associated the kernel with the venv you dont need to recreate/update it*. Any packages that are installed to the venv via pip after the kernel is established are immediately available to the kernel.

### Using pipenv in Jupyter

pipenv is another environment manager for Python. In general, please refer to their [basic guidance](https://pipenv-fork.readthedocs.io/en/latest/basics.html).

Set-up for a project results in the creation of `Pipfile` and `Pipfile.lock` in the root directory of your project folder.

The instructions for someone to install the packages specified in Pipefile/Pipefile.lock, are as follows (you don't create a venv yourself, nor is it necessary to 'activate' the pipenv environment):

```bash
cd myproject
pipenv install
```

To use the pipenv in Jupyter, compared to [using a venv in Jupyter](using-a-venv-in-jupyter), the syntax of creating the kernel is simply adjusted to:

```bash
pipenv install ipykernel
python3 -m ipykernel install --user --name="pipenv-name" --display-name="My project (Python3)"
```

And then select the kernel in Jupyter as [normal](using-a-venv-in-jupyter).
