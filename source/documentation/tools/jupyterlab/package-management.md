# Python package management

## venv and pip

[pip](https://pip.pypa.io/en/stable/) is a terminal command used to install and upgrade Python packages.

[PyPI](https://pypi.org) is the main Python package repository. It's 'official', but that doesn't mean a lot - like most of these open source package repositories, a poor quality or even malicious package can easily be uploaded there, so do your diligence when picking them.

A [Python virtual environment](https://docs.python.org/3/tutorial/venv.html) (or `venv`, for short) is a directory you can install a particular Python executable and Python packages into, away from your machine's default ones. Typically each project/repo you work on should have a different venv, and then you never have to deal with conflicting requirements between projects. When you 'activate' a particular venv, then run `python` or `pip`, those commands will work with that venv's Python executable and Python packages.

## Basic usage

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

## Using a project that has a requirements.txt

If a project has a 'requirements.txt' then you should install that into a venv.

A project's README file is the traditional place to communicate usage of a requirements.txt. Because of that, this section is provided in markdown format so it can be copied into your project's README, and tailored as necessary:

```markdown

## Setup

Before you can run this project, you need to install some Python packages using the terminal:

    # create a virtual environment
    cd myproject
    python3 -m venv venv

    # install the python packages required
    . venv/bin/activate
    pip install -r requirements.txt
```

## Poetry
We advise the use of [poetry](https://python-poetry.org/docs/) as a library.

### why use poetry 
poetry stops conflicts between libraries and their dependencies.
It makes sure that libraries play well together.
If virtualenv is used without poetry, you may start experiencing library version conflict and start getting warnings.

### setup steps:-
- after creating your virtualenv, activate your venv 
    ```
        source venv/bin/activate
    ```

- 
    ```
        pip install poetry
    ```
- initialize poetry and tracking using 
    ```
    poetry init
    ```
- during init step, when asked the following questions, answer as follows 
1. <i>`Author`</i> you can choose `n` or whoever wants to be the author
2. <i>`Would you like to define your main dependencies interactively?`</i> choose `no`
3. <i>`Would you like to define your development dependencies interactively?`</i> choose `no`
- after a `pyproject.toml` file is created, you can now start installing your libraries.

### install libraries
guided steps
- Use poetry to add library. Poetry will try and get the latest version.

    ```
        poetry add <library>
    ```
- If the library has a conflict, get all the versions and try using the next one down.
    1. using 
    ```
        pip index versions <library
    ```
    2.  
    ```
        poetry add <library>@<version>
    ```

- If there is a conflict with another library, play around with the versions that work together
- When finished you can export the libraries.
    ```
    poetry export > requirements.txt
    ```

- Use pip to install the libraries that now should work perfectly. 
    ```
        pip install -r requirements.txt
    ```


### listing available library versions
```
    pip index versions <library>
```


### exporting poetry libraries
Exporting libraries is very similar to `pip freeze` and in poetry it is 

```
    poetry export
```

### Commiting files
Of course, committing requirements.txt is important.

You will want to commit to your repo `pyproject.toml` but not the poetry.lock
When next wanting to install another library, you can use:-
- select your venv.
`source venv/bin/activate`

```
    poetry install
```

- then go ahead and install your new library the same way as above
```
    poetry add <library>
```