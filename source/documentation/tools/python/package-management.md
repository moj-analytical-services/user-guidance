# Python package management

## venv and pip

[pip](https://pip.pypa.io/en/stable/) is a terminal command used to install and upgrade Python packages.

[PyPI](https://pypi.org) is the main Python package repository. It's 'official', but that doesn't mean a lot - like most of these open source package repositories, a poor quality or even malicious package can easily be uploaded there, so do your diligence when picking them.

A [Python virtual environment](https://docs.python.org/3/tutorial/venv.html) (or `venv`, for short) is a directory you can install a particular Python executable and Python packages into, away from your machine's default ones. Typically each project/repo you work on should have a different venv, and then you never have to deal with conflicting requirements between projects. When you 'activate' a particular venv, then run `python` or `pip`, those commands will work with that venv's Python executable and Python packages.

### Basic usage

**NOTE:** You may need to delete the `.bash_aliases` file (`rm .bash_aliases`) from your home directory for pip to work properly within a virtual environment.

Create a venv for your project, called 'venv' (make sure you run this in the Terminal):

```bash
cd myproject
python3 -m venv venv
```

(Add 'venv' to your .gitignore file, because this shouldn't be added to your git repo.)

When you work with your project's packages in a terminal, you'll want to 'activate' your venv:

```bash
. venv/bin/activate
```

You'll notice the prompt changes to show that the venv is activated: `(venv) jovyan@jupyter-lab-davidread-ju-6966d9b9b4-7zvsk:~/myproject$`

With the venv activated you can install some packages using pip:

```bash
(venv) $ pip install --user pandas
```

The packages will get installed to your venv, in `venv/lib/python3.7/site-packages/`.

You can see what packages are installed using 'pip freeze':

```bash
(venv) $ pip freeze
numpy==1.18.4
pandas==1.0.4
python-dateutil==2.8.1
pytz==2020.1
six==1.15.0
```

With the venv activated, if you run a Python script from the terminal, the package will be available to it. For example:

```bash
(venv) $ python3 -c 'import pandas; print(pandas); print("It worked")'
<module 'pandas' from '/home/jovyan/myproject/venv/lib/python3.7/site-packages/pandas/__init__.py'>
It worked
```

In JupyterLab, to be able to use the venv's packages (instead of the system packages), see [Using a venv in Jupyter](index.html#using-a-virtual-environment-in-jupyter)

When you commit your code, to ensure reproducibility, you should also commit an up-to-date record of what packages you've installed. The simplest way is to do:

```bash
(venv) $ pip freeze >requirements.txt
(venv) $ git add requirements.txt
```

You should also add to your README file the instructions for using requirements.txt - see the following section.

### Using a project that has a requirements.txt

If a project has a 'requirements.txt' then you should install that into a venv.

A project's README file is the traditional place to communicate usage of a requirements.txt. Because of that, this section is provided in markdown format so it can be copied into your project's README, and tailored as necessary:

```markdown

### Setup

Before you can run this project, you need to install some Python packages using the terminal:

    # create a virtual environment
    cd myproject
    python3 -m venv venv

    # install the python packages required
    . venv/bin/activate
    pip install -r requirements.txt
```

### Library conflicts & warnings

If you come across any conflicts or warnings when installing your libraries using pip we advise you use [poetry](https://python-poetry.org/docs/) to resolve them.

## Conda

Conda is an open-source package management and environment management system. It allows you to create isolated environments with specific versions of Python and other packages. The ability to specify the version of Python may be useful if you are working in both JupyterLab (which uses Python `3.9`) and Visual Studio Code (which uses Python `3.12` currently), otherwise you may get library conflicts and dependency errors.

### Create a new conda environment

To create a new Conda environment, use the conda create command followed by the name of the environment and the desired Python version.

```
sh
conda create --name myenv python=3.9
```

Replace `myenv` with your desired environment name and `3.9` with the Python version you need.

### Activating and Deactivating Environments

To start using the newly created environment, you need to activate it.

```
sh
conda activate myenv
```

To deactivate the current environment and return to the base environment, use:

```
sh
conda deactivate
```

### Installing Packages

Once your environment is activated, you can install packages using the `conda install` command.

```
sh
conda install numpy pandas matplotlib
```

You can also install packages from the Anaconda repository or other channels.

sh
Copy code
conda install -c conda-forge somepackage

### Listing and Removing Environments

To list all available environments, use:

```
sh
conda env list
```

To remove an environment, ensure it is deactivated and use the following command:

```
sh
conda remove --name myenv --all
```

### Updating Conda and Packages

To update Conda to the latest version, run:

```
sh
conda update conda
```

To update all packages in the current environment, use:

```
sh
conda update --all
```

### Managing Environments with `conda.yml`

A `conda.yml` file can be used to specify the configuration of a Conda environment, making it easy to share and reproduce environments.

#### Creating a `conda.yml` File

Create a `conda.yml` file with the following structure:

```
yaml
name: myenv
channels:
  - defaults
  - conda-forge
dependencies:
  - python=3.9
  - numpy
  - pandas
  - matplotlib
```

#### Creating an Environment from a `conda.yml` File

To create an environment from a `conda.yml` file, use the `conda env create` command:

```
sh
conda env create -f conda.yml
```

#### Exporting an Environment to a `conda.yml` File

To export the current environment to a `conda.yml` file, use:

```
sh
conda env export > conda.yml
```

This will create a `conda.yml` file with all the packages and versions specified, which can be used to recreate the environment elsewhere.

### Additional Resources
For more information and advanced usage, refer to the official Conda documentation:

- [Conda Documentation](https://docs.conda.io/en/latest/)
- [Conda Cheat Sheet](https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf)

