# Data pipelines

## Summary

You can deploy your data processing code to the cloud. Airflow is a tool on the Analytical Platform that is a managed place for your "data pipeline" to run. This can be useful, for example, to:

* run a long job overnight
* run it on a regular schedule (e.g. every night)
* when multiple outputs require the same intermediate result, it can be calculated once for them all
* people other than yourself can see the run and its output (compared to if you run it in your R Studio or Jupyter)
* you keep a history of all the pipeline runs, showing what you ran, the logs, what tasks failed and how long it took

## Concepts

* A **data pipeline** is referred to in Airflow as a "DAG". It is made up of "tasks" which are arranged into a Directed Acyclic Graph.
* A **DAG** is a Directed Acyclic Graph. This could be simple: Task 1 -> Task 2 -> Task 3 (meaning run Task 1 then Task 2 then Task 3). Or a task can be dependent on multiple previous tasks, and when its complete it can trigger multiple tasks. The "Acyclic" bit just means you can't have loops.
* Each **task** is a GitHub repository, containing code files that will be run (e.g. R or python) plus bits that define the environment it runs in - a Dockerfile and an AWS IAM policy.
* You define the DAG to run on a regular schedule, and/or you can run it by clicking the "Play" button on the Airflow web interface

## Set up a pipeline

### Task repository

Each task should be a git repository:

* It should be under the https://github.com/moj-analytical-services organization
* The name of the repo is recommended to start with `airflow-`

The repo should include:

1. `Dockerfile` - contains commands to set-up a Docker image that does your data processing.

    Here's an example python one:

        # Begin with a standard base image (from https://hub.docker.com/_/python/ )
        FROM python:3.7

        # Update the system libraries
        # (The python base image is based on debian)
        RUN apt-get update
        # Install new system libraries
        RUN apt-get install -y --no-install-recommends \
            python-numpy

        # Set the default place in the image where files will be copied
        WORKDIR /usr/src/app

        # Copy files from the repo into the image
        COPY requirements.txt ./
        COPY . .

        # Install python dependencies
        RUN pip install --no-cache-dir -r requirements.txt

        # Run the data processing
        # This is the equivalent of typing: python ./my-script.py
        CMD [ "python", "./my-script.py" ]

    Tip: You can put several related scripts in one repo, and choose which one gets run using an environment variable e.g. https://github.com/moj-analytical-services/airflow-magistrates-data-engineering/blob/88986cf7dbcca9b7ebc21bc2d1286464615739d7/Dockerfile#L19

    Tip: Some python packages, such as 'numpy' or 'lxml', come with C extensions which can cause bother. If installed via pip (requirements.txt) those C extensions are compiled, which can be slow and liable to failure. The Dockerfile example above shows how to avoid these problems with numpy (which is needed by pandas) - it is installed instead using a debian package: `python-numpy`.

2. <a name="deploy.json"></a>`deploy.json` - This is for Concourse to build the repo into a Docker image

    For example:

        {
            "mojanalytics-deploy": "v1.0.0",
            "type": "airflow_dag",
            "role_name" : "airflow_enforcement_data_processing"
        }

    The version number does nothing. The `role_name` needs to be:

    * unique to the Analytical Platform
    * prefixed `airflow_`, otherwise you'll get a build error like this: `An error occurred (AccessDenied) when calling the GetRole operation: User: arn:aws:iam::593291632749:user/dev-concourse-role-putter is not authorized to perform: iam:GetRole on resource: role airflow-prison-population-hub`

3. `iam_policy.json` - This tells Concourse to create an AWS role that gives your code permission to access AWS resource, such as data in S3 buckets. 

    e.g. See: https://github.com/moj-analytical-services/airflow-enforcement-data-engineering/blob/master/iam_policy.json
    for listing, reading and writing to S3 buckets.


## Test pipeline in your own Airflow sandbox

You can deploy your own sandboxed version of Airflow to test DAGs and docker images on.

### Start Airflow sandbox

Click the `Deploy` button next to `airflow-sqlite` in the Analytical tools section of the control panel. This should take a few minutes to deploy. Then click the `Open` button to open your Airflow sandbox in a new window.

This will create an `airflow` directory in your home directory on the Analytical Platform. In this `airflow` directory there are three more directories: `db`, `dags` and `logs`. The `dags` directory is where you will store your test DAG files.

### Create a test DAG

Using JupyterLab on the Analytical Platform, create a Python file in the `airflow/dags` directory in your home directory on the Analytical Platform (e.g., `test_dag.py`). Airflow will automatically scan this directory for DAG files every three minutes.

You must use you own IAM role and set the namespace in the dag to your own Kubernetes namespace.

See above for creating a Docker image to run the DAG if you are using `KubernetesPodOperator`. Concourse will automatically build images from pull requests for Airflow repositories in GitHub that will be tagged with the name of the pull request. For example, if your pull request branch is named `test-dev` then your image will be named `my_repositiry:test-dev`.

Example DAG file contents: {#ex-code}


    from datetime import datetime

    from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
    from airflow.utils.log.logging_mixin import LoggingMixin
    from airflow.models import DAG

    log = LoggingMixin().log

    args = {"owner": "airflow", "start_date": datetime(2019, 3, 18)}

    dag = DAG(
        dag_id="example_kubernetes_operator_assume_role",
        default_args=args,
        schedule_interval=None,
    )

    k = KubernetesPodOperator(
        namespace="user-###YOUR_GITHUB_USERNAME###",
        image="governmentpaas/awscli:latest",
        cmds=["aws", "--debug"],
        arguments=["s3api", "list-objects", "--bucket", "###YOUR_TEST_BUCKET###"],
        env_vars={
            "AWS_METADATA_SERVICE_TIMEOUT": "60",
            "AWS_METADATA_SERVICE_NUM_ATTEMPTS": "5",
        },
        labels={"foo": "bar"},
        name="airflow-test-pod",
        in_cluster=True,
        task_id="task",
        get_logs=True,
        dag=dag,
        is_delete_operator_pod=True,
        annotations={"iam.amazonaws.com/role": "alpha_user_###YOUR_GITHUB_USERNAME###"},
    )



You will have to set the DAG namespace to your namespace and the AWS role to your role, see `###YOUR_GITHUB_USERNAME###` in the above example code.

You will also need to update the image with your DAG image from the AWS Elastic Container Registry and add any environment variables, etc., as you would with a normal DAG.

If you update the image it is likely you will not need to add the arguments `cmds` and `arguments` to the `KubernetesPodOperator` so those lines should be removed. They are the command and arguments that are run on the pod at startup.

### Important considerations

This sandbox Airflow is meant for testing. You should not use it to run regular tasks and should not rely on it for running production pipelines. It is likely that the sandbox will be idled when it is not being used.

Because DAGs are run as your own `alpha_user_...`, they will have the same access permissions. DAGs are not run using an `iam_policy.json`, even if one exists in the task GitHub repository. This means that you may need to either obtain access to any required buckets or copy data into a bucket that you already have access to.

You should still be very careful with what you do as even with your role you may still have access to do a lot of damage.


### Test your image - locally on a Macbook

If you have a Macbook you can use it to test that your Docker image will build, which is much quicker to debug than waiting for Concourse every time you make a change. This can be useful for checking your Dockerfile syntax is right and the dependencies install ok.

However when you run the Docker image, it won't be able to access your project data (from S3), because your machine doesn't have your AP account's AWS credentials. This is right because you shouldn't have sensitive data on your Macbook in general. So the Docker image will fail when it tries to access AWS data, but you've still usefully checked the build works and the install of dependencies.

You need to have installed [Docker for Mac](https://docs.docker.com/docker-for-mac/install/). When it is running you can see its whale icon in the task bar. It consumes 2GB RAM, so you may well not want it to run everytime your machine starts up - change this under "Preferences..." then uncheck "Start Docker when you log in".

To test your Docker image:

1. Clone your repo to your Macbook. e.g. in a terminal:

        git clone git@github.com:moj-analytical-services/airflow-occupeye-scraper.git

   This authenticates GitHub using SSH, so if this is the first time on your machine, you'll need to [create an SSH key and add it to your GitHub account](https://help.github.com/articles/connecting-to-github-with-ssh/) first.

2. Build the repository (from the directory with the Dockefile in it):

        cd airflow-occupeye-scraper
        docker build . -t my-pipeline:0.1

   (If you get `Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?` you need to start 'Docker' application from your Mac's Launchpad)

   This goes through each line ("step") of the Dockerfile and builds (or executes) each in turn (apart from the final `CMD`). The first build can take a while, but the result of each step is saved to disk, so if you change a step and do another build, it only needs to restart from the step that is changed.

3. You might want to run the image as a container, which runs your data processing code specified in the `CMD` of the Dockerfile:

        docker run my-pipeline:0.1

   Which should hopefully get as far as talking to AWS before failing.

4. You can 'shell into' the linux container to take a look for debug purposes:

        docker run -it my-pipeline:0.1 bash

   And if `bash` is not available, try `sh`.

### Build the image

Concourse will:

* build your GitHub repository into a Docker image
* upload the Docker image to a private location in AWS Elastic Container Registry
* creates the AWS Role

For more about the build see: [Build and deploy guidance](https://moj-analytical-services.github.io/platform_user_guidance/build-and-deploy.html)


### Airflow DAG

You need to define a DAG of your Tasks, so that Airflow can run it.

A DAG is defined in its own .py file in the [airflow-dags repository](https://github.com/moj-analytical-services/airflow-dags). Normally you would clone the repo, add the new DAG file, commit it to a branch and create the Pull Request. You can achieve this in R Studio, Jupyter or on your local machine if you have git, and then use GitHub to create the Pull Request. Alternatively you could simply click the "Create new file" button in GitHub and use the web interface to edit it and create a pull request in one go!

The airflow-dags repo has [protected](https://help.github.com/articles/about-protected-branches/) master branch, so it requires a review from the data engineering team before you can merge. Ask for a review from `moj-analytical-services/data-engineers`.

Use an existing DAG as an example: https://github.com/moj-analytical-services/airflow-dags/blob/master/mags_curated.py

The `image` is the address of the Docker image - look in the Concourse build log:

    successfully tagged ...

Tip: Before you commit, run the file with python to check the python syntax is ok. If it gets as far as giving you import errors then you know the python syntax is ok. (If you can be bothered to install the python libraries you could run it all)

Merging the Pull Request needs to be done by the ASD Data Engineering team, to ensure the IAM permissions are acceptable.

The DAG will appear in the Airflow web interface a couple of minutes after the Pull Request is merged.

### Airflow web interface

The Airflow web interface allows you to see the data pipelines running, view the logs, see past runs, etc.

Link: https://airflow.tools.alpha.mojanalytics.xyz

![](images/pipelines/airflow.png)

You can manually start ("trigger") the pipeline with this button:

![](images/pipelines/trigger.png)
