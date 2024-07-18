# MLFlow Tracking Server

⚠️ This service is in a Development Phase ⚠️

MLFlow Tracking Server is a stand-alone HTTP server that serves multiple REST API endpoints for tracking runs/experiments. We have deployed a development version of an MLFlow Tracking Server on the Analytical Platform at [https://mlflow.compute.development.analytical-platform.service.justice.gov.uk/](https://mlflow.compute.development.analytical-platform.service.justice.gov.uk/).

## Who is the MLFlow Tracking Server for?

The Analytical Platform MLFlow Tracking Server is for both data practitioners, who want to keep track of their model development, and for those who want to reviewer and quality assurance models before they are put into deployment.

## How do I get access to the MLFlow Tracking Server?

Currently, access is done through the [mlflow-access](https://github.com/moj-analytical-services/mlflow-access) GitHub repository.

By creating an experiment `yaml` file in that repository:
* new users in the `yaml` - that have not already been given access to the Tracking Server - will be sent a password to their listed email address
* a new experiment will be created on the Tracking Server and only accessible to users listed in the `yaml`
* users will be given read/write access to the relevant S3 path to access their model artifacts

## How do I upload data to the Tracking Server?

This is primarily done through R or Python code using the relevant MLFlow packages and libraries. The [mlops-example](https://github.com/moj-analytical-services/mlops-example/tree/main/examples/experiment_tracking/mlflow) repository has some simple examples on how to use the Tracking Server with both R and Python. More information can be found on the [MLFlow website](https://mlflow.org/docs).

## Known Issues

* You can only save model artifacts to the default bucket setup on the Analytical Platform currently (`alpha-analytical-platform-mlflow-development`). Artifacts will be saved under `alpha-analytical-platform-mlflow-development/tracking/your_experiment_name`. However, as you will have access to this S3 path, you can copy objects to another S3 location if you want.

* Access to the model artifacts must be given through the AP Control Panel. If you do not have access, please reach out on [#mlflow-users](https://moj.enterprise.slack.com/archives/C07AQSGJGJ0).

* Users can create multiple runs with the same run name

### Specific to R MlFlow package

* Users cannot specify the run name

* Users must close the run session before deleting a run on the UI
