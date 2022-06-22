# Image Pipeline

1.  If you are creating a python codebase, create a repository from [template-airflow-python](https://github.com/moj-analytical-services/template-airflow-python). The image will have the same name so make sure the repository name is appropriate and reflects the pipeline you intend to run. If you are creating an example pipeline call it airflow-{username}-example

2. If you are creating a R codebase, you can use [airflow-sh-location](https://github.com/moj-analytical-services/airflow-sh-location) as an example or wait until the (template-airflow-r)[under construction] is created
    
3.  Review the scripts/run.py file. This has some code to write and copy to S3. Leave as-is if you are creating an example pipeline. Otherwise replace with your own logic (see [Tips on writing the code](#Tips-on-writing-the-code))
    
4.  Review the [Dockerfile](https://dsdmoj.atlassian.net/wiki/spaces/DEUD/pages/3944743134/Airflow+Pipelines+2.0+User+Guide#Dockerfile). The base image is set to python 3.9 by default, but you can use another image if you wish. Example base images are commented out in the Dockerfile. See below for more details.
    
5.  Python libraries to install are specified in the [requirements.txt](https://dsdmoj.atlassian.net/wiki/spaces/DEUD/pages/3944743134/Airflow+Pipelines+2.0+User+Guide#requirements.txt) file. You can add more libraries to the requirements.txt file if required. See below for more details
    
6.  Create a tag and release, ensuring Target is set on the main branch. Set the tag and release to v0.0.1 if you are creating an example pipeline
    
7.  Go to the Actions tab and you should see the “Build, tag, push, and make available image to pods” action running
    
8.  If you have permission, log in to [ECR](https://eu-west-1.console.aws.amazon.com/ecr/repositories?region=eu-west-1) and search for your image and tag.
    

## Tips on writing the code

You can create scripts in any programming language, including R and Python. You may want to test your scripts in RStudio or JupyterLab on the Analytical Platform before running them as part of a pipeline.

All Python scripts in your Airflow repository should be formatted according to `flake8` rules. `flake8` is a code linter that analyses your Python code and flags bugs, programming errors and stylistic errors.

You can automatically format your code using tools like `black`, `autopep8` and `yapf`. These tools are often able to resolve most formatting issues.

You can use environment variables to pass in variables to the docker container. We tend to write them in caps to point out the fact they will be passed in as environmental variables.

## requirements.txt

The `requirements.txt` file contains a list of Python packages to install that are required by your pipeline. You can find out more in the [pip guidance](https://pip.readthedocs.io/en/1.1/requirements.html).

To capture the requirements of your project, run the following command in a terminal:

```java
pip freeze > requirements.txt
```

You can also use conda, packrat, renv or other package management tools to capture the dependencies required by your pipeline. If using one of these tools, you will need to update the `Dockerfile` to install required packages correctly.

## Dockerfile

A `Dockerfile` is a text file that contains the commands used to build a Docker image. It starts with a `FROM` directive, which specifies the [parent image](https://docs.docker.com/glossary/#parent-image) that your image is based on. Each subsequent declaration in the Dockerfile modifies this parent image. We have a range of parent images to chose from. R images have specific needs and you can base your Dockerfile on [airflow-sh-location](https://github.com/moj-analytical-services/airflow-sh-location/blob/master/Dockerfile). Alternatively you can wait until (template-airflow-r)[under construction] is ready.

You can use the same Docker image for multiple tasks by passing an environment variable. In the [use\_kubernetes\_pod\_operator.py](https://github.com/moj-analytical-services/airflow/blob/main/environments/dev/dags/examples/use_kubernetes_pod_operators.py) example, we pass in the environment variable “write” and “copy” to first write to S3, then copy the file across, using the same `"template-airflow-python"` image.

Some python packages, such as `numpy` or `lxml`, depend on C extensions. If installed via pip using a `requirements.txt` file, these C extensions are compiled, which can be slow and liable to failure. To avoid this with `numpy` (which is needed by `pandas`) you can instead install the Debian package `python-numpy`.

## Test Docker image (optional)

If you have a MacBook, you can use Docker locally to build and test your Docker image. You can download Docker Desktop for Mac [here](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

To build and test your Docker image locally, follow the steps below:

1.  Clone your Airflow repository to a new folder on your MacBook – this guarantees that the Docker image will be built using the same code as on the Analytical Platform. You may need to create a new connection to GitHub with [SSH](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).
    
2.  Open a terminal session and navigate to the directory containing the `Dockerfile` using the `cd` command.
    
3.  Build the Docker image by running:
    
    ```java
    docker build . -t IMAGE:TAG
    ```
    
    where `IMAGE` is a name for the image, for example, `my-docker-image`, and `TAG` is the version number, for example, `v0.1`.
    
4.  Run a Docker container created from the Docker image by running:
    
    ```java
    docker run IMAGE:TAG
    ```
    
    This will run the command specified in the `CMD` line of the `Dockerfile`. This will fail if your command requires access to resources on the Analytical Platform, such as data stored in Amazon S3 unless the correct environment variables are passed to the docker container. You would need the following environment variables to ensure correct access to all the AP resources:

    ```
    docker run \
        --env AWS_REGION=$AWS_REGION \
        --env AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
        --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
        --env AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
        IMAGE:TAG
    ```
    
    Oher environment variables such as PYTHON_SCRIPT_NAME or R_SCRIPT_NAME can be passed in the same way.

You can start a bash session in a running Docker container for debugging and troubleshooting purposes by running:

```java
docker run -it IMAGE:TAG bash
```
