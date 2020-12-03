# Airflow

> Airflow is a platform created by community to programmatically author, schedule and monitor workflows.
>
> Source: [Airflow](https://airflow.apache.org)

Airflow is simply a scheduling tool. In the analytical platform implementation, it runs on its own virtual computer watching time go by, waiting to run pre-defined tasks created by platform users. Airflow allows you to make these tasks fairly complicated, taking account of dependencies between them, retries on failure, and email notification.
To create an item for Airflow to schedule (known as a 'DAG'), you need to create a python file which defines the (one or more) tasks involved. This python file must be added to the `airflow-dags` repo. Every 3 minutes, Airflow is updated using the master branch from that repo.
In terms of the content of the scheduled tasks, an Airflow DAG.py file will only reference an 'image'. An image is just a definition of what a virtual computer contains - installed software and files. We use Docker for this. All Airflow does is use that image to create a virtual machine on the cluster. It is up to you to create the image and manage what it does when Airflow launches it. This is done within your github repo using a Dockerfile. The Dockerfile describes the virtual environment: the software you require, the scripts and files you use, and what to do when it starts.

Airflow can be used to:

- run time-consuming processing tasks overnight
- run tasks on a regular schedule
- run end-to-end processing workflows involving multiple steps and dependencies
- monitor the performance of workflows and identify issues

## Concepts

There are a few key concepts of Airflow:

- an Airflow task is defined with python code by a Directed Acyclic Graph (DAG), which is made up of one or more ordered (directed) connected tasks (graph), without loops (acyclic)
- a DAG could be simple, for example, `task_1 >> task_2 >> task_3`, meaning run `task_1` then `task_2` then `task_3`
- each task can be dependent on multiple previous tasks and can trigger multiple other tasks when it is completed
- each pipeline references a GitHub repository, containing code files that will be run (for example, R or Python scripts) plus configuration files that define the environment in which each task will be run
- you can run a DAG on a regular schedule or trigger it manually by selecting the **▶** (trigger dag) button in the [Airflow user interface](https://airflow.tools.alpha.mojanalytics.xyz)

You can find out more about other important concepts in the [Airflow documentation](https://airflow.apache.org/docs/stable/concepts.html).

## Set up an Airflow pipeline

To set up an Airflow pipeline, you should:

1. Create a new repository from the [Airflow template](https://github.com/moj-analytical-services/template-airflow-python).
2. Create scripts for the tasks you want to run.
3. Update the Dockerfile and other configuration files.
4. Push your changes to GitHub.
5. Create a pull request.
6. Test the pipeline in your Airflow sandbox.
7. Create a new release (and check concourse has built it).
8. Clone the [`airflow-dags`](https://github.com/moj-analytical-services/airflow-dags) repository from GitHub and create a new branch.
9. Create a DAG script.
10. Push your changes to GitHub.
11. Create a pull request and request review from the Data Engineering team.
12. Merge the pull request into the master branch.

### (1) Create a new repository from the Airflow template

To create a new repository from the Airflow template:

- Go to the [`template-airflow-python`](https://github.com/moj-analytical-services/template-airflow-python) repository.
- Select **Use this template**.
- Fill in the form:
   - Owner: `moj-analytical-services`
   - Name: The name of your pipeline prefixied with `airflow-`, for example, `airflow-my-pipeline`
   - Privacy: Internal (refer to the [public, internal and private repositories](github.html#public-internal-and-private-repositories) section)
- Select **Create repository from template**.

This copies the entire contents of the Airflow template to a new repository.

#### **Clone the repository**

To clone the repository:

-  Navigate to the repository on GitHub.
-  Select **Clone or download**.
-  Ensure that the dialogue says 'Clone with SSH'. If the dialogue says 'Clone with HTTPS' select **Use SSH**.
-  Copy the SSH URL. This should start with `git@`.
-  In RStudio, select **File** > **New project...** > **Version control** > **Git**.
-  Paste the SSH URL in the **Repository URL** field.
-  Select **Create Project**.

### (2) Create scripts for the tasks you want to run

You can create scripts in any programming language, including R and Python. You may want to test your scripts in RStudio or JupyterLab on the Analytical Platform before running them as part of a pipeline.

All Python scripts in your Airflow repository should be formatted according to [`flake8`](https://pypi.org/project/flake8/) rules. `flake8` is a code linter that analyses your Python code and flags bugs, programming errors and stylistic errors.

You can automatically format your code using tools like [`black`](https://pypi.org/project/black/), [`autopep8`](https://pypi.org/project/autopep8/) and [`yapf`](https://pypi.org/project/yapf/). These tools are often able to resolve most formatting issues.

### (3) Update the Dockerfile and configuration files

The Airflow template contains a `Dockerfile` and number of configuration files that you may need to update:

- `iam_config.json`
- `deploy.json`
- `requirements.txt`

#### `Dockerfile`

A `Dockerfile` is a text file that contains the commands used to build a Docker image. A Docker image is the code to create a well-defined, self-contained virtual computer. You can see an [example Dockerfile](https://github.com/moj-analytical-services/template-airflow-python/blob/master/Dockerfile) in the Airflow template.

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
  "role_name": "role_name"
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

### (4) Push your changes to GitHub

Create a branch and push your changes to GitHub.

### (5) Create a pull request

When you create a new pull request, Concourse will automatically try to build a Docker image from the `Dockerfile` contained in your branch. The image will have the tag `repository_name:branch_name`, where `repository_name` is the name of the repository and `branch_name` is the name of the branch from which you have created the pull request.

Concourse also runs a number of tests. It:

- checks if you have made any changes to the IAM policy
- checks if the IAM role can be created correctly
- checks that your Python code is correctly formatted according to [Flake8](http://flake8.pycqa.org/en/latest/) rules
- runs project-specific unit tests with [pytest](https://docs.pytest.org/en/latest/)

All of these tests should be passing before you merge your changes.

You can check the status of the build and tests in the [Concourse UI](https://concourse.services.alpha.mojanalytics.xyz).

### (7) Create a new release

When you create a new release, Concourse will automatically build a Docker image from the `Dockerfile` contained in the master branch. The image will have the tag `repository_name:release_tag`, where `repository_name` is the name of the repository and `release_tag` is the tag of the release, for example, `v1.0.0`.

Concourse also runs the same tests as above and creates the IAM role.

You can check the status of the build and tests in the [Concourse UI](https://concourse.services.alpha.mojanalytics.xyz).

To create a release, follow the [GitHub guidance](https://help.github.com/en/github/administering-a-repository/creating-releases).

### (8) Clone the [`airflow-dags`](https://github.com/moj-analytical-services/airflow-dags) repository from GitHub

To clone the repository:

1.  Navigate to the repository on GitHub.
2.  Select **Clone or download**.
3.  Ensure that the dialogue says 'Clone with SSH'. If the dialogue says 'Clone with HTTPS' select **Use SSH**.
4.  Copy the SSH URL. This should start with `git@`.
5.  In RStudio, select **File** > **New project...** > **Version control** > **Git**.
6.  Paste the SSH URL in the **Repository URL** field.
7.  Select **Create Project**.

### (9) Create a DAG script

A DAG is defined in a Python script. An two examples of a DAG script are outlined below. One using the `basic_kubernetes_pod_operator` and the other the `KubernetesPodOperator`. Note that the `basic_kubernetes_pod_operator` is a function created and managed by the Data Engineering Team to make it easier to run tasks on your sandboxed airflow instance or the main airflow deployment. If you require something with more functionality the we suggest using the full `KubernetesPodOperator`. Examples of both are below.

#### Example DAG (basic_kubernetes_pod_operator)

<details>

<summary>Click for basic_kubernetes_pod_operator code sample</summary>

```python
from datetime import datetime

from mojap_airflow_tools.operators import basic_kubernetes_pod_operator
from airflow.models import DAG

IMAGE_VERSION = "v1.0.0" # the Docker image version that Airflow will use – this should correspond to the latest release version of your Airflow project repository
REPO = "airflow-repository-name" # the name of the repository on GitHub

ROLE = "airflow_iam_role_name" # the role name defined in iam_config.yml

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

task = basic_kubernetes_pod_operator(
    task_id="example-task-name", # Should only use characters, numbers and '-' for a task_id
    dag=dag,
    repo_name=REPO,
    release=IMAGE_VERSION,
    role=ROLE,
    sandboxed=False, # True if using your sandboxed airflow, False if running on our main airflow deployment
)
```
</details>

The `basic_kubernetes_pod_operator` automates a lot of the parameters that are needed to be defined when using the `KubernetesPodOperator`. This is the recommended operator to use and you should only use the `KubernetesPodOperator` if you need to provide more specific and advanced pod deployments.

For more information on the `basic_kubernetes_pod_operator` you can view [it's repo here](https://github.com/moj-analytical-services/mojap-airflow-tools).

#### Example DAG (KubernetesPodOperator)

<details>
<summary>Click for KubernetesPodOperator code sample</summary>

```python
from datetime import datetime

from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.models import DAG

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

task_id = "example-task-name", # It is good practice to use the same name for the `task_id` and `task_name` parameters. When doing so make sure to only use numbers, characters and '-' to define the name.
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
    name=task_id
    in_cluster=True,
    task_id=task_id
    get_logs=True,
    is_delete_operator_pod=True,
    annotations={"iam.amazonaws.com/role": ROLE},
)
```
</details>

#### Tips on writing a DAG

The `schedule_interval` can be defined using a cron expression as a `str` (such as `0 0 * * *`), a cron preset (such as `@daily`) or a `datetime.timedelta` object. You can find more information on scheduling DAGs in the [Airflow documentation](https://airflow.apache.org/docs/stable/scheduler.html).

Airflow will run your DAG at the end of each interval. For example, if you create a DAG with `start_date=datetime(2019, 9, 30)` and `schedule_interval=@daily`, the first run marked `2019-09-30` will be triggered at `2019-09-30T23:59` and subsequent runs will be triggered every 24 hours thereafter.

You can find detailed guidance on DAG scripts, including on how to set up dependencies between tasks, in the [Airflow documentation](https://airflow.apache.org/docs/stable/tutorial.html) and can find more examples in the [`airflow-dags`](https://github.com/moj-analytical-services/airflow-dags) repository on GitHub.

### (10) Push your changes to GitHub

Commit your DAG script to a new branch and push your changes to GitHub.

### (11) Create a pull request and request review from the Data Engineering team

Create a new pull request and request a review from `moj-analytical-services/data-engineers`. You should also post a link to your pull request in the [#data_engineers](https://app.slack.com/client/T1PU1AP6D/C8X3PP1TN) Slack channel.

### (12) Merge the pull request into the master branch

When you merge your pull request into the master branch, your pipeline will be automatically detected by Airflow.

You can view your pipeline in the Airflow UI at [airflow.tools.alpha.mojanalytics.xyz](https://airflow.tools.alpha.mojanalytics.xyz). You can find more information on using the Airflow UI in the [Airflow documentation](https://airflow.apache.org/docs/stable/ui.html).

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

## Troubleshooting

If a task fails in Airflow, you can click on it and view the logs. The final few lines before `Event with job id your-task-id-9stuff876 Failed` should indicate the problem. As always, it is a good idea to have print statements in your code to help identify the stage at which it failed.
Here are some common errors you might encounter:

- **DAG doesn't start on schedule** Before initial use, a DAG needs to be switched on using the Airflow UI (toggle in top left). If you used the homepage toggles, please be very careful not to turn off other critical DAGs. The Airflow UI can misbehave a lot and sometimes the homepage toggles are just wrong, so better to use the toggle within a DAG menu.

- **ERROR - Pod Launching failed: Pod took too long to start** Usually this happens when the image referenced in Airflow does not exist. This could be because you haven't made a Github release, or because Concourse has failed to build it, either because of an error in the image or Concourse itself. You can check the status within Concourse (image -> Deploy -> top right) to see the latest build version, and prompt a build with the + button. Brand new images will need to be 'unpaused' in the Concourse UI. Subsequent images should build automatically after a Github release, provided they use an incremental v0.0.0 format. Occasionally this error may happen randomly, in which case you should use task retries.

- **airflow_my_task is not authorized to perform: iam:PassRole on resource: arn:aws:iam::593291632749:role/airflow_my_task** The task IAM policy needs to have gluejobs enabled.

- **s3 credentials error** IAM policy needs to allow appropriate read/write access to the s3 resource you are accessing.

- **AWS Athena timeout error** If a task *intermittently* fails when reading data with Athena, it may help to pass the env_args `"AWS_METADATA_SERVICE_TIMEOUT": "60"` and `"AWS_METADATA_SERVICE_NUM_ATTEMPTS": "5"` to make your pod wait longer for Athena (in seconds) and make retries in the event of failure.

- **Other errors once pod is running** Likely to be Python, R or Spark errors from within the task source code.

## Notes on creating Docker environments

The following are the essential aspects in a Dockerfile

### Configuration of software to be installed

There are a couple of parts to this. The first is the basic foundation image to work with. This encompasses the operating system and basic software, like python. This is defined in the `FROM` part of a Dockerfile, eg. `FROM python:3.7`. You should select this from a list available on the AP.
Additionally you will want to install specific Python or R packages that you use in your code. You can do this with `RUN pip install -r requirements.txt` as referenced above. To be robust, you should pin all versions (`package==1.2.0`). For complicated installations this is best done by activating a conda environment:
```
COPY environment.yml environment.yml
RUN conda env create -f environment.yml
RUN echo "source activate env_name" > ~/.bashrc
ENV PATH /opt/conda/envs/env_name/bin:$PATH
```
    
### Configuration of files in Github repo

You will need to specify what files from within your repo exist within the Docker image. This is achieved with `COPY <repo_path> <image_path>` or [`ADD`](https://docs.docker.com/engine/reference/builder/#add). Essentially you should treat the repo like a source directory, and copy files to locations in the virtual computer (the image). It is probably sensible to keep the names the same, so a typical copy in a Dockerfile will look like `COPY scripts/ scripts/`.

### Scripting concerns

All Dockerfiles need an `ENTRYPOINT`, which sets the inital action taken when the image runs. Typically this will be a shell command to run a program and script, eg. `ENTRYPOINT python -u scripts/run.py`, or `ENTRYPOINT Rscript scripts/run.R`. You can set any script control logic within the entrypoint script.
You should be mindful of the working directory when working with Docker images (that is, the path from which programs see other files relatively). This should be reflected in any file path references in your code. A good convention would be too keep the root level of the repo as the working directory, asnd preserve the file structure in your Dockerfile. You can set the workng directory within a Dockerfile with `WORKDIR`.

There is a list of Dockerfile commands and documentation [here](https://docs.docker.com/engine/reference/builder/).
