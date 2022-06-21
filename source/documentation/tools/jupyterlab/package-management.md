# Python Package Management

## venv and pip

[pip](https://pip.pypa.io/en/stable/) is a terminal command used to install and upgrade Python packages.

[PyPI](https://pypi.org) is the main Python package repository. It's 'official', but that doesn't mean a lot - like most of these open source package repositories, a poor quality or even malicious package can easily be uploaded there, so do your diligence when picking them.

A [Python virtual environment](https://docs.python.org/3/tutorial/venv.html) (or `venv`, for short) is a directory you can install a particular python executable and python packages into, away from your machine's default ones. Typically each project/repo you work on should have a different venv, and then you never have to deal with conflicting requirements between projects. When you 'activate' a particular venv, then when you run `python` or `pip`, then it will work with that venv's python executable and python packages.

## Basic usage

**NOTE:** You may need to delete the `.bash_aliases` file (`rm .bash_aliases`) from your home directory for pip to work properly within a virtual environment.

Create a venv for your project, called 'venv' (make sure you run this in the Terminal):

```bash
cd myproject
python3 -m venv venv
```

(You'll probably want to add 'venv' to you .gitignore file, because this shouldn't be added to your git repo.)

When you work with your project's packages in a terminal, you'll want to 'activate' your venv:

```bash
. venv/bin/activate
```

You'll notice the prompt changes to show that the venv is activated: `(venv) jovyan@jupyter-lab-davidread-ju-6966d9b9b4-7zvsk:~/myproject$`

With the venv activated you can install some packages using pip:

```bash
(venv) $ pip install pandas
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

With the venv activated, if you run some python script from the terminal, the package will be available to it. e.g.

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

## Using a project that has a requirements.txt

If a project has a 'requirements.txt' then you should install that into a venv.

A project's README file is the traditional place to communicate usage of a requirements.txt. Because of that, this section is provided in markdown format so it can be copied into your project's README, and tailored as necessary:

```markdown
## Setup

Before you can run this project, you need some files setup in your home dir, using the terminal:

    # create a virtual environment
    cd myproject
    python3 -m venv venv

    # install the python packages required
    . venv/bin/activate
    pip install -r requirements.txt