# Visual Studio Code Set Up

You can also use Visual Studio Code (VScode) with create-a-derived-table.

*NB* - vscode 1.6.0 and later use python 12 by default which *is not compatible* with create-a-derived-table. Please follow the conda instructions below to use newer versions of VSCode with create-a-derived-table.


## Clone the repository using the terminal

`cd` to the directory where you'd like to clone the repository to and then run the following command:

```
git clone git@github.com:moj-analytical-services/create-a-derived-table.git
```

## Setting up a Python virtual environment

Python versions 3.7, 3.8, 3.9, 3.10 and 3.11 are compatible with dbt-core v1.5.0.

You can use conda to install a virtual environment for Python 3.11 or below

```
conda create -n venv python=3.10
```

```
conda activate venv
```

You need to set up the VSCode Python extension to use your new virtual environment. You can use the Python Environment Manager extension.

On the left hand side of the screen, click Extensions.

Search for Python Environment Manager and install.

You should now see a Python symbol on the left hand side of the screen - click this.

Under conda, select your new `venv` environment and click the star to activate this environment in the VSCode terminal.


## Install requirements

Now you need to navigate into the create-a-derived-table repository itself.

```
cd create-a-derived-table
```

Now you are ready to isntall the required packages:-

```
pip install --upgrade pip
```

```
pip install -r requirements.txt
```

To install the lint libraries, run:

```
pip install -r requirements-lint.txt
```

Set the following environment variable in your .bashrc script. Do not use .bash_profile as this is reset every time a session starts.

```
echo "export DBT_PROFILES_DIR=../.dbt/" >> ~/.bashrc
```

Then source your .bashrc script by running:

```
source ~/.bashrc
```

You'll need to be in the dbt project to run dbt commands. This is the `mojap_derived_tables` directory:

```
cd mojap_derived_tables
```

Then to check an active connection, run:

```
dbt debug
```

If that's successful, to install dbt packages, run:

```
dbt deps
```

Congratulations, you're now ready to get dbt-ing!
 
<br />