# Airflow Concepts    

What is Airflow
---------------

Below are some key concepts in Airflow. What I discuss is covered in [this talk](https://drive.google.com/file/d/1DVN4HXtOC-HXvv00sEkoB90mxLDnCIKc/view?usp=sharing).

*   [**Tasks**](https://airflow.apache.org/docs/apache-airflow/stable/concepts/tasks.html) These are the things you want to do. Let's say I want to run a script that does some basic data processing and then a second script that writes a report based on the processed data. You might want to model this as a set of tasks i.e. script1 -> script2
    
*   [**Operator**](https://airflow.apache.org/docs/apache-airflow/stable/concepts/operators.html) Each task will have an `Operator` to run the task. There are loads of operators for example to run python or bash scripts or (as we mostly tend to do) launch docker containers based on images which contains the code
    
*   [**DAG**](https://airflow.apache.org/docs/apache-airflow/stable/concepts/dags.html) (Directed Acyclic Graph) is what Airflow groups a set of tasks together into a pipeline. DAGs have a schedule interval (a cron-expression of how often to start) "acyclic" because there can be branches and joins, but never loop back on itself. For example task A -> B -> C -> A is not allowed
    
*   **Scheduler** As stated above you want to run airflow on a schedule. So you might want to run it every minute, hour, once every Tuesday at 4pm
    
*   [Airflow UI](https://airflow.apache.org/docs/apache-airflow/stable/ui.html) The Airflow UI makes it easy to monitor and troubleshoot your data pipelines. You can also use it to manually trigger your workflow


Airflow Pipeline
----------------

Within the MoJ Analytical Platform, a typical Airflow pipeline consists of the following process. (Actions highlighted in grey are automated)

![](images/airflow/airflow-pipeline.drawio.png)

*   The DAG can be triggered by an analyst through the Airflow UI or through a schedule

*   Instead of including the code within the DAG, we mainly use Kubernetes pod operators and pass in an image which contains the required python/R code. This mean the DAG will be a lightweight script and won’t read or process any data. This is vital when writing a DAG
    
*   The Kubernetes pod operator launches a single-container [pod](https://kubernetes.io/docs/concepts/workloads/pods/) in a [Kubernetes](https://kubernetes.io/) cluster
    
*   The pod will need permission to access various AWS resources (i.e. run an Athena query, read-write to a bucket, etc). This is achieved by assuming an [Identity and Access Management (IAM) role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) with the relevant permissions
    
*   The output is then usually saved to an S3 bucket

*   There are two separate Airflow environments, each with it’s own Kubernetes cluster:
    
    *   Dev: for training and testing new/updates to pipelines [UI](https://eu-west-1.console.aws.amazon.com/mwaa/home?region=eu-west-1#environments/dev/sso)
        
    *   Prod: for running production pipelines [UI](https://eu-west-1.console.aws.amazon.com/mwaa/home?region=eu-west-1#environments/prod/sso)
    

The next two sections summarises the process for creating (and maintaining) the DAG, image and IAM roles. This uses two deployment pipelines which are automated using various [Github actions](https://github.com/features/actions) that we have created to facilitate this process.

Image Pipeline
--------------

This deployment pipeline creates a docker image which contains the analytical code (python or R) that will be run in the dockerised task. Actions highlighted in grey are automated.

![](images/airflow/image-pipeline.drawio.png)

The image repo must contain the [build-and-push-to-ecr](https://github.com/moj-analytical-services/.github/blob/master/workflow-templates/data-engineering/build-and-push-to-ecr.yml) Github action to push the docker image to the Data Engineering [Elastic Container Registry](https://aws.amazon.com/ecr/) (ECR). This can be done by:

* copying [template-airflow-python](https://github.com/moj-analytical-services/template-airflow-python) for python images
* copying [template-airflow-r] (under construction) for R images
* copying the Github action to an existing image repo

Please see [Image pipeline](/data-engineering-tools/airflow/instructions/image-pipeline) for more details.

Note that you can skip this pipeline if you already have a working docker image saved to the Data Engineering ECR.

DAG Pipeline
---------------------

This deployment pipeline creates the [Directed Acyclic Graph (DAG)](https://airflow.apache.org/docs/apache-airflow/stable/concepts/dags.html#) which defines the tasks that will be run, as well as the IAM role which the Kubernetes pod will need in order to access relevant AWS resources and services. Actions highlighted in grey are automated.

![](images/airflow/dag-pipeline.drawio.png)

You must add the DAG and role policies to [airflow](https://github.com/moj-analytical-services/airflow) following specific rules. See [DAG pipeline](/data-engineering-tools/airflow/instructions/dag-pipeline) for more details. Once you raise the PR and it is approved by data engineering, various Github actions will automatically:

*   validate the DAG and policies adhere to the rules
*   notify DE through a slack notification
*   create/update the IAM role
*   save the DAG to an S3 bucket which can be accessed by Airflow
    

Component Responsibilities
--------------------------

Since an Airflow pipeline consists of so many moving components, it is helpful to summarise everyone’s remit.

Analysts are responsible for creating/maintaining the following components:

*   DAG which defines the analytical tasks that the pipeline will run
*   IAM policies for the IAM Role that the Kubernetes pod will use
*   image repo and the code that will be run in the taskss
    

Data Engineering is responsible for maintaining the following components:

*   airflow environments
*   kubernetes clusters
*   github actions for automating the deployment pipelines
*   template image repo to base the image repo from
*   user guidandce
    
as well as approving the DAG and IAM Role PR.


When not to use an Airflow
--------------------------

*   to trigger an Analytical Platform app (the Analytical Platform team can create cron jobs for this)
    
*   to trigger a one-time memory-intensive overnight task (it will be quicker to create a cron job for this)
