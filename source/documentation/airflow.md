# Airflow

> Airflow is a platform created by community to programmatically author, schedule and monitor workflows.
>
> Source: [Airflow](https://airflow.apache.org)

Airflow can be used to:

* run time-consuming processing tasks overnight
* run tasks on a regular schedule
* run end-to-end processing workflows involving multiple steps and dependencies
* monitor the performance of workflows and identify issues

## Concepts

There are a few key concepts of Airflow:

* an Airflow pipeline is defined by a directed acyclic graph (DAG), which is made up of a number of individual tasks
* a DAG could be simple, for example, `task_1 >> task_2 >> task_3`, meaning run `task_1` then `task_2` then `task_3`
* a task can be dependent on multiple previous tasks and can trigger multiple other tasks when it is completed
* each pipeline has a GitHub repository, containing code files that will be run (for example, R or Python scripts) plus configuration files that define the environment in which each task will be run
* you can run a pipeline on a regular schedule or trigger it manually by selecting the __▶__ (trigger dag) button in the [Airflow user interface](https://airflow.tools.alpha.mojanalytics.xyz)

You can find out more about other important concepts in the [Airflow documentation](https://airflow.apache.org/docs/stable/concepts.html).

## Set up an Airflow pipeline

To set up an Airflow pipeline, you should:

1. Create a new repository from the [Airflow template](https://github.com/moj-analytical-services/template-airflow-python).
2. Create scripts for the tasks you want to run.
3. Update configuration files.
4. Push your changes to GitHub.
5. Create a pull request.
6. Test the pipeline in your Airflow sandbox.
7. Create a new release.
8.  Clone the [`airflow-dags`](https://github.com/moj-analytical-services/airflow-dags) repository from GitHub and create a new branch.
9.  Create a DAG script.
10. Push your changes to GitHub.
11. Create a pull request and request review from the Data Engineering team.
12. Merge the pull request into the master branch.

### Create a new repository from the Airflow template

To create a new repository from the Airflow template:

1. Go to the [`template-airflow-python`](https://github.com/moj-analytical-services/template-airflow-python) repository.
2. Select __Use this template__.
3. Fill in the form:
    + Owner: `moj-analytical-services`
    + Name: The name of your pipeline prefixied with `airflow-`, for example, `airflow-my-pipeline`
    + Privacy: Private
4. Select __Create repository from template__.

This copies the entire contents of the Airflow template to a new repository.

### Clone the repository

To clone the repository:

1.  Navigate to the repository on GitHub.
2.  Select __Clone or download__.
3.  Ensure that the dialogue says 'Clone with SSH'. If the dialogue says 'Clone with HTTPS' select __Use SSH__.
4.  Copy the SSH URL. This should start with `git@`.
5.  In RStudio, select __File__ > __New project...__ > __Version control__ > __Git__.
6.  Paste the SSH URL in the __Repository URL__ field.
7.  Select __Create Project__.

### Create scripts for the tasks you want to run

You can create scripts in any programming language, including R and Python. You may want to test your scripts in RStudio or JupyterLab on the Analytical Platform before running them as part of a pipeline.

All Python scripts in your Airflow repository should be formatted according to [`flake8`](https://pypi.org/project/flake8/) rules. `flake8` is a code linter that analyses your Python code and flags bugs, programming errors and stylistic errors.

You can automatically format your code using tools like [`black`](https://pypi.org/project/black/), [`autopep8`](https://pypi.org/project/autopep8/) and [`yapf`](https://pypi.org/project/yapf/). These tools are often able to resolve most formatting issues.

### Update the Dockerfile and configuration files

The Airflow template contains a `Dockerfile` and number of configuration files that you may need to update:

* `iam_config.json`
* `deploy.json`
* `requirements.txt`

#### `Dockerfile`

A `Dockerfile` is a text file that contains the commands used to build a Docker image. You can see an [example Dockerfile](https://github.com/moj-analytical-services/template-airflow-python/blob/master/Dockerfile) in the Airflow template.

You can use the same Docker image for multiple tasks by using an environment variable to call different scripts as in this [example](https://github.com/moj-analytical-services/airflow-magistrates-data-engineering/blob/58ac895abb8a87208f7b6b33426883b2b0e1dba4/Dockerfile#L19).

Some python packages, such as `numpy` or `lxml`, depend on C extensions. If installed via pip using a `requirements.txt` file, these C extensions are compiled, which can be slow and liable to failure. To avoid this with `numpy` (which is needed by `pandas`) you can instead install the Debian package `python-numpy`.

#### `iam_config.yml`

The `iam_config.yml` file defines the permissions that will be attached to the IAM role used by the Airflow pipeline when it is run.

The `iam_role_name` must start with `airflow_`, be lowercase, contain underscores only between words and be unique on the Analytical Platform.

You can find detailed guidance on how to define permissions in the [`iam_builder`](https://github.com/moj-analytical-services/iam_builder) repository on GitHub.

#### `deploy.json`

The `deploy.json` file contains configuration information that is used by Concourse when building and deploying the pipeline.

It is of the following form:

```json
{
    "mojanalytics-deploy": "v1.0.0",
    "type": "airflow_dag",
    "role_name" : "role_name"
}
```

You should change `role_name` to match the name specified in `iam_config.yml`.

#### `requirements.txt`

The `requirements.txt` file contains a list of Python packages to install that are required by your pipeline. You can find out more in the [pip guidance](https://pip.readthedocs.io/en/1.1/requirements.html).

To capture the requirements of your project, run the following command in a terminal:

```sh
pip freeze > requirements.txt
```

You can also use conda, packrat, renv or other package management tools to capture the dependencies required by your pipeline. If using one of these tools, you will need to update the `Dockerfile` to install required packages correctly.

### Push your changes to GitHub

Create a branch and push your changes to GitHub.

### Create a pull request

When you create a new pull request, Concourse will automatically try to build a Docker image from the `Dockerfile` contained in your branch. The image will have the tag `repository_name:branch_name`, where `repository_name` is the name of the repository and `branch_name` is the name of the branch from which you have created the pull request.

Concourse also runs a number of tests. It:
* checks if you have made any changes to the IAM policy
* checks if the IAM role can be created correctly
* checks that your Python code is correctly formatted according to [Flake8](http://flake8.pycqa.org/en/latest/) rules
* runs project-specific unit tests with [pytest](https://docs.pytest.org/en/latest/)

All of these tests should be passing before you merge your changes.

You can check the status of the build and tests in the [Concourse UI](https://concourse.services.alpha.mojanalytics.xyz).

### Create a new release

When you create a new release, Concourse will automatically build a Docker image from the `Dockerfile` contained in the master branch. The image will have the tag `repository_name:release_tag`, where `repository_name` is the name of the repository and `release_tag` is the tag of the release, for example, `v1.0.0`.

Concourse also runs the same tests as above and creates the IAM role.

You can check the status of the build and tests in the [Concourse UI](https://concourse.services.alpha.mojanalytics.xyz).

To create a release, follow the [GitHub guidance](https://help.github.com/en/github/administering-a-repository/creating-releases).

### Clone the [`airflow-dags`](https://github.com/moj-analytical-services/airflow-dags) repository from GitHub

To clone the repository:

1.  Navigate to the repository on GitHub.
2.  Select __Clone or download__.
3.  Ensure that the dialogue says 'Clone with SSH'. If the dialogue says 'Clone with HTTPS' select __Use SSH__.
4.  Copy the SSH URL. This should start with `git@`.
5.  In RStudio, select __File__ > __New project...__ > __Version control__ > __Git__.
6.  Paste the SSH URL in the __Repository URL__ field.
7.  Select __Create Project__.

### Create a DAG script

A DAG is defined in a Python script. An example DAG script using the `KubernetesPodOperator` is outlined below:

```python
from datetime import datetime

from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.utils.log.logging_mixin import LoggingMixin
from airflow.models import DAG

log = LoggingMixin().log

IMAGE_VERSION = "v1.0.0" # the Docker image version that Airflow will use – this should correspond to the latest release version of your Airflow project repository
REPO = "airflow-repository-name" # the name of the repository on GitHub

IMAGE = (
    f"593291632749.dkr.ecr.eu-west-1.amazonaws.com/"
    f"{REPO}:{IMAGE_VERSION}"
)

ROLE = "airflow_iam_role_name" # the role name defined in iam_config.yml
NAMESPACE = "airflow"

default_args = {
    "depends_on_past": False,
    "email_on_failure": True,
    "owner": "github_username", # your GitHub username
    "email": ["example@justice.gov.uk"], # your email address registered on GitHub
}

dag = DAG(
    dag_id="example_dag", # the name of the DAG
    default_args=default_args,
    description=(
        "Example description." # a description of what your DAG does
    ),
    start_date=datetime(2019, 9, 30),
    schedule_interval=None,
)

task = KubernetesPodOperator(
    dag=dag,
    namespace=NAMESPACE,
    image=IMAGE,
    env_vars={
        "AWS_METADATA_SERVICE_TIMEOUT": "60",
        "AWS_METADATA_SERVICE_NUM_ATTEMPTS": "5",
        "AWS_DEFAULT_REGION": "eu-west-1",
    },
    labels={"app": dag.dag_id},
    name="example_task_name", # the name of the task
    in_cluster=True,
    task_id="example_task_name", # the name of the task
    get_logs=True,
    is_delete_operator_pod=True,
    annotations={"iam.amazonaws.com/role": ROLE},
)
```

The `schedule_interval` can be defined using a cron expression as a `str` (such as `0 0 * * *`), a cron preset (such as `@daily`) or a `datetime.timedelta` object. You can find more information on scheduling DAGs in the [Airflow documentation](https://airflow.apache.org/docs/stable/scheduler.html).

Airflow will run your DAG at the end of each interval. For example, if you create a DAG with `start_date=datetime(2019, 9, 30)` and `schedule_interval=@daily`, the first run marked `2019-09-30` will be triggered at `2019-09-30T23:59` and subsequent runs will be triggered every 24 hours thereafter.

You can find detailed guidance on DAG scripts, including on how to set up dependencies between tasks, in the [Airflow documentation](https://airflow.apache.org/docs/stable/tutorial.html) and can find more examples in the [`airflow-dags`](https://github.com/moj-analytical-services/airflow-dags) repository on GitHub.

### Push your changes to GitHub

Commit your DAG script to a new branch and push your changes to GitHub.

### Create a pull request and request review from the Data Engineering team

Create a new pull request and request a review from `moj-analytical-services/data-engineers`. You should also post a link to your pull request in the [#data_engineers](https://app.slack.com/client/T1PU1AP6D/C8X3PP1TN) Slack channel.

### Merge the pull request into the master branch

When you merge your pull request into the master branch, your pipeline will be automatically detected by Airflow.

You can view your pipeline in the Airflow UI at [airflow.services.alpha.mojanalytics.xyz](https://airflow.services.alpha.mojanalytics.xyz). You can find more information on using the Airflow UI in the [Airflow documentation](https://airflow.apache.org/docs/stable/ui.html).

## Testing

### Test a Docker image

If you have a MacBook, you can use Docker locally to build and test your Docker image. You can download Docker Desktop for Mac [here](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

To build and test your Docker image locally, follow the steps below:

1.  Clone your Airflow repository to a new folder on your MacBook -- this guarantees that the Docker image will be built using the same code as on the Analytical Platform. You may need to [create a new connection to GitHub with SSH](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).
2.  Open a terminal session and navigate to the directory containing the `Dockerfile` using the `cd` command.
3.  Build the Docker image by running:
    ```sh
    docker build . -t IMAGE:TAG
    ```
    where `IMAGE` is a name for the image, for example, `my-docker-image`, and `TAG` is the version number, for example, `0.1`.
4.  Run a Docker container created from the Docker image by running:
    ```sh
    docker run IMAGE:TAG
    ```
    This will run the command specified in the `CMD` line of the `Dockerfile`. This will fail if your command requires access to resources on the Analytical Platform, such as data stored in Amazon S3.

You can start a bash session in a running Docker container for debugging and troubleshooting purposes by running:

```sh
docker run -it IMAGE:TAG bash
```

### Test a DAG

You can test a DAG in your Airflow sandbox, before deploying in the production environment.

To deploy your Airflow sandbox, follow the instructions in the [Work with Analytical Tools](introduction.html#deploy-analytical-tools) section of the guidance.

Deploying your Airflow sandbox will create an `airflow` folder in your home directory on the Analytical Platform. This folder contains three subfolders: `db`, `dags` and `logs`.

Once you have deployed your Airflow sandbox, you should store the script for the DAG you want to test in the `airflow/dags` folder in your home directory on the Analytical Platform. Airflow scans this folder every three minutes and will automatically detect your pipeline.

To ensure that your pipeline runs correctly, you should set the `ROLE` variable in your DAG script to be your own IAM role on the Analytical Platform. This is your GitHub username in lowercase prefixed with `alpha_user_`. For example, if your GitHub username was `Octocat-MoJ`, your IAM role would be `alpha_user_octocat-moj`.

You should also set the `NAMESPACE` variable in your DAG script to be your own namespace on the Analytical Platform. This is your GitHub username in lowercase prefixed with `user-`. For example, if your GitHub username was `Octocat-MoJ`, your namespace would be `user-octocat-moj`.

You should only use your Airflow sandbox for testing purposes.
