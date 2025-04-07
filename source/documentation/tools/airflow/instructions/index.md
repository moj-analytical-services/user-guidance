# Airflow Instructions

These instructions will show you how to build and run a standard Airflow pipeline based on a Kubernetes operator in the dev environment. You will first complete the two deployment pipelines to build and save a docker image to ECR, as well as create a DAG and IAM role. You can use the provided scripts, DAG and IAM policy to create an “example pipeline” which will write the word “Hello” to a file and upload to an S3 bucket. Alternatively you can define your own scripts, DAG and IAM policy. You will then run the Airflow pipeline.

## Prerequisites

- [Github Account](get-started) 

- [Analytical Platform Account](get-started)

- [Slack Account](get-started) Channel: #ask-analytical-platform

## Create image and save to ECR

See [Image pipeline](/tools/airflow/instructions/image-pipeline)

## Create DAG and IAM Role

See [DAG and Role pipeline](/tools/airflow/instructions/dag-pipeline)

## Run the Airflow Pipeline

1. Log in to the [dev Airflow UI](https://eu-west-1.console.aws.amazon.com/mwaa/home?region=eu-west-1#environments/dev/sso)

2. Find your DAG. In the case of the example pipeline it will be called {username}.write_to_s3

3. Toggle the DAG unpause the DAG

4. Trigger the DAG

5. Click on the DAG to open the tree view

6. Click on the GRAPH tab to see the graph view and wait until it goes green. This should take up to a minute for the example pipeline

7. Click on the task and log to see the log output

8. If you have permission and running the example pipeline, go the S3 directory s3://alpha-everyone/airflow-example and check that a file called test.txt has been created in the {username} folder
