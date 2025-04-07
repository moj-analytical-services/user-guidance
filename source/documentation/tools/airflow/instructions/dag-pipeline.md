# DAG and Role pipeline

The [airflow repo](https://github.com/moj-analytical-services/airflow) contains the DAG definitions and roles used in our Airflow pipelines and is structured in the following way:

```java
airflow
├── environments
│   ├── dev
│   │   ├── dags
│   │   │   ├── project_1
│   │   │   │   ├── dag.py
│   │   │   │   ├── ...
│   │   │   │   └── README.md
│   │   │   ├── project_2
│   │   │   │   ├── dag_1.py
│   │   │   │   ├── dag_2.py
│   │   │   │   ├── ...
│   │   │   │   └── README.md
│   │   │   ├── project_3
│   │   │   │   ├── dag.py
│   │   │   │   └── README.md
│   │   │   └── ...
│   │   └── roles
│   │       ├── airflow_dev_role_1.yaml
│   │       ├── airflow_dev_role_2.yaml
│   │       └── ...
│   ├── prod
│   │   └── ...
│   └── ...
├── imports
│   ├── __init__.py
│   ├── project_3_constants.py
│   └── ...
└── ...
```

Anything in the folder `environment/dev/` is deployed to the Airflow Dev Instance and anything in `enivronment/prod/` is deployed to the Airflow production instance. Both prod and dev have the exact same folder structures. We'll just refer to `dev` in the user guide (knowing the same is true for `prod`). The idea is to test a pipeline in dev, before promoting it to the prod environment.

You should ensure that DAGs or Roles across environments do not share write access to the same AWS resources or reference each other (e.g. a DAG defined in prod can only use roles defined in prod). However they can both reference the same docker image.

## Define the DAG

A DAG is defined in a Python script. An example of a DAG script is provided below, based on the example pipeline. A few more example DAGs are available in [example_DAGS](https://github.com/moj-analytical-services/airflow/tree/main/environments/dev/dags/examples).

### DAG example

> Please add [DAG and/or Task documentation](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/dags.html#dag-task-documentation) as shown below. This will allow users to better find your DAG using GitHub search, and also provide better documentation on the Airflow UI. It is especially useful if your DAG contains more advanced uses of Airflow compared to standard pipeline below.

``` python
from datetime import datetime
from airflow.models import DAG
from mojap_airflow_tools.operators import BasicKubernetesPodOperator

dag_doc = """
Here is where you describe what the DAG is doing (see below for describing inidividual tasks).
It will be rendered in Markdown, so feel free to use Markdown syntax.
"""

# Replace <<username>> with your username
username = <<username>>
# As defined in the image repo
IMAGE_TAG = "v0.0.1"
REPO_NAME = f"airflow-{username}-example"
# The user_id can be any number apart from 1000. In the case of R images, it must match the userid in the dockerfile
USER_ID = 1337
 
"""
The role used by Airflow to run a task. 
This role must be specified in the corresponding `roles/` folder in the same environment 
(i.e. the role is defined in environments/dev/roles/airflow_dev_{username}_example.yaml).
The role must only contain alphanumeric or underscore characters [a-zA-Z0-9_]. 
This can be enforced using: 
ROLE = re.sub(r"[\W]+", "", f"airflow_dev_{username}_example")
"""

# ROLE = re.sub(r"[\W]+", "", f"airflow_dev_{username}_example")
ROLE = f"airflow_dev_{username}_example"
 
# For tips/advice on the default args see the use_dummy_operator.py example
default_args = {
    # Normally you want to set this to False.
    "depends_on_past": False,
    "email_on_failure": False,
    # Name of DAG owner as it will appear on Airflow UI
    "owner": f"{username}",
}
 
dag = DAG(
    # Name of the dag (how it will appear on the Airflow UI)
    # We use the naming convention: <folder_name>.<filename>
    dag_id=f"{username}.copy_file_s3",
    default_args=default_args,
    description="A basic Kubernetes DAG",
    # Requires a start_date as a datetime object. This will be when the
    # DAG will start running from. DO NOT use datetime.now().
    start_date=datetime(2022, 1, 1),
    # How often should I run the dag. If set to None your dag
    # will only run when manually triggered.
    schedule_interval=None,
)
# This renders your DAG documentation at the top
dag.doc_md = dag_doc 

# Environmental variables for passing to the docker container
env_vars = {
    "RUN": "write",
    "TEXT": "Hello",
    "OUTPATH": f"s3://alpha-everyone/airflow-example/{username}/test.txt",
}
 
"""
It is good practice to set task_id as a variable above your task
because it is used for both the name and task_id parameters.
You should also only use alpha numerical characters and dashes (-)
for the task_id value.
"""

task_doc = """
Here is where you describe what the Task is doing. It will be rendered in Markdown,
so feel free to use Markdown syntax.
"""

task_id = "task-1"
task = BasicKubernetesPodOperator(
    dag=dag,
    run_as_user=USER_ID,
    repo_name=REPO_NAME,
    release=IMAGE_TAG,
    role=ROLE,
    task_id=task_id,
    env_vars=env_vars,
    # This renders your Task documentation from task_doc above
    doc_md=task_doc
)
task
```


The DAG uses the `BasicKubernetesPodPperator`, a function created and managed by the Data Engineering Team [here](https://github.com/moj-analytical-services/mojap-airflow-tools) to make it easier to run tasks. If you require something with more functionality you can use `KubernetesPodOperator` (on which `BasicKubernetesPodPperator` is based).

In the example the schedule\_interval is set to None. The `schedule_interval` can be defined using:

*   a cron expression as a `str` (such as `0 0 * * *`) fields are "minute hour day-of-month month day-of-week"
*   a cron preset (such as @once, @daily, @weekly, etc)
*   a `datetime.timedelta` object.
    

You can find more detailed guidance on DAG scripts, including on how to set up dependencies between tasks, in the [Airflow documentation](https://airflow.apache.org/docs/stable/tutorial.html).

You can group multiple DAGs together in a folder making it easier for others to understand how they relate to one another. This also allows you to add READMEs to these folders to again help others understand what the DAGs are for.

**Actions**

1.  Create a new directory in [airflow/dev/dags](https://github.com/moj-analytical-services/airflow/tree/main/environments/dev/dags) and give it an appropriate name. Name the directory {username} if you are creating an example pipeline
    
2.  Create a new python file and give it an appropriate name. Name the file copy\_file\_s3.py if you are creating an example pipeline
    
3.  If you are creating an example pipeline, paste the DAG example as-is but replace <<username>> making sure to include quotation marks. You might need to update the IMAGE_TAG version number depending on the image that builds successfully in the GitHub repository. 

4.  Delete the comments
    
5.  If you are creating your own pipeline modify the IMAGE\_TAG, REPO\_NAME, ROLE, owner, dag\_id, scheduling and env\_vars as appropriate. You can also add additional tasks if required but stick to one DAG per python file.
    

### Using a High-Memory Node (Optional)

You have the option to use a high-memory node for workloads that process large data sets in memory (large datasets here typically meaning datasets larger than 2 GB). Please note that a high-memory node is expensive to run so only use after testing and failing with a standard node. Also note that high-memory nodes need to be provisioned which means pods will take longer to start. Finally we have restricted the number of high-memory nodes that can be provisioned so please schedule appropriately.

Please see [use_high_memory_node.py](https://github.com/moj-analytical-services/airflow/blob/main/environments/dev/dags/examples/use_high_memory_node.py) for an example usage.

You’ll need to import the toleration and affinity:

```python
from imports.high_memory_constants import tolerations, affinity
```

and add the following arguments to the KubernetesPodOperator:

```java
    # Increase startup time to give time for node creation
    startup_timeout_seconds=600,
    tolerations=tolerations,
    affinity=affinity,
```

We have a ticket to [![](https://dsdmoj.atlassian.net/rest/api/2/universal_avatar/view/type/issuetype/avatar/10818?size=medium)PDE-1830](https://dsdmoj.atlassian.net/browse/PDE-1830) - Modify BasicKubernetesPodOperator to specify high-memory node To Do

### Using imports (Optional)

If your DAG relies on custom modules, be this for storing shared constant, or reused functions, you can implement this as seen in the folder structure for `project_3`:

*   Place any modules you might need in the `imports` folder
    
*   Make sure the module starts with the name of the DAG folder e.g. `project_3_constants.py`
    

These can then be imported by your dags. For example, `dag.py` in `project_3` could import `project_3_constants.py` using `from imports.project_3_constants import some_function`

## Define the IAM Policy

We use [IAM Builder](https://github.com/moj-analytical-services/iam_builder) to generate an IAM policy based on a yaml configuration. If you are unfamiliar with the syntax the README of the previous link will help you. There are also some useful test IAM configs which are good examples of what you might want for your own role definition in the in [IAM builder tests](https://github.com/moj-analytical-services/iam_builder/tree/main/tests/test_config) (note: ignore the ones prefixed with `bad_` as they are invalid configs - used to check the package is working). The github action then creates the IAM role and attaches the IAM policy.

**Steps**

1.  Create a new yaml file in airflow/dev/roles to store your IAM role policy. The name of the file must start with airflow\_dev and must match the `ROLE` variable in the DAG. Name the file airflow\_dev\_{username}\_example.yaml if you are creating an example pipeline
    
2.  Define the IAM policy. You can optionally include the field `iam_role_name` in your IAM config yaml but this must match the file name and the `ROLE` variable in the DAG. You only need to include the `iam_role_name` in the IAM config if you also have `glue_job: true` or `secrets: true`, otherwise it is optional.
    
3.  If you are creating an example pipeline, paste the following code, replacing "{username}" with your username:
    
```
iam_role_name: airflow_dev_{username}_example
 
s3:
  read_write:
    - alpha-everyone/airflow-example/*
```

## Validate from the command line (optional)

The `airflow` repo validates the folder structure, DAGs (`validation.dags`) and Roles (`validation.roles`). The validation will run automatically when you raise a PR, but you can also validate using the command line to spot errors sooner.

You’ll have to create and activate the python environment as specified in requirements-validation.txt. Make sure you are in the root of `airflow` repo and that you specify the full path to the file(s) you wish to validate

The preferred method for running this validation is:

```java
python -W ignore -m validation filepath1 filepath2 etc
flake8 .
yamllint .
```

When running these tests for the example pipeline: `filepath1` should be `environments/dev/dags/{username}/copy_file_s3.py` and `filepath2` should be `environments/dev/roles/airflow_dev_{username}_example.yaml`

## Deploy the changes

1.  Raise a PR into the main branch with your changes (ideally within a single commit).
    
2.  This will start a set of github action workflows. Check that all workflows pass after your PR is submitted. If any of the workflows fail the PR cannot be merged in main (and therefore not deployed)
    
3.  DE will be notified through a slack integration to approve the PR. Code changes made to files in the `environments/dev/dags` folder do not need approval:

```java
airflow
├── environments
│   ├── dev
│   │   ├── dags
│   │   │   ├── APPROVAL NOT REQUIRED
│   │   └── roles
│   │       ├── APPROVAL REQUIRED
│   ├── prod
│   │   └── APPROVAL REQUIRED
```
    
4.  Once checks pass and PR is approved in #ask-analytical-platform by the Analytical Platform Team, please merge the PR into main
    
5.  The code in main is then automatically deployed to the Airflow prod and dev instances
