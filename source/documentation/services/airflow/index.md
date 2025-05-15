# Airflow

> This documentation is for the new Analytical Platform Airflow service.
>
> For Data Engineering Airflow, please refer to [Data Engineering Airflow](/tools/airflow).

## Overview

[Apache Airflow](https://airflow.apache.org/) is a workflow management platform. Analytical Platform users primarily use it for:

* automating data engineering pipelines
* training machine learning models
* reproducible analytical pipelines ([RAP](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/))

We recommend using it for long-running or compute intensive tasks. 

Workflows are executed on the Analytical Platform's Kubernetes infrastructure and can interact with services such as Amazon Athena, Amazon Bedrock, and Amazon S3.

Our Kubernetes infrastructure is connected to the MoJO Transit Gateway, which connects to:

* MoJ Cloud Platform
* MoJ Modernisation Platform 
* HMCTS SDP
* SOP

If you need additional connectivity, [submit a feature request](https://github.com/ministryofjustice/analytical-platform/issues/new?template=feature-request-template.yml).

> **Please note**: You cannot use Analytical Platform Airflow for workflows using `BashOperator` or `PythonOperator`

## Concepts

![](images/airflow/airflow_diagram.svg)

The Analytical Platform Airflow is made up of **environments**, **projects** and **workflows**:

* **Environments** are the different stages of infrastructure we provide: `development`, `test` and `production`.

> **Please note**: `development` is not connected to the MoJO Transit Gateway

* **Projects** are a unit for grouping workflows dedicated to a distinct business domain, service area, or specific project, for example: `BOLD`, `HMCTS` or `HMPPS`.

* **Workflows** are pipelines, also known as [directed acyclic graph (DAGs)](https://airflow.apache.org/docs/apache-airflow/2.10.3/core-concepts/dags.html#dags).
  They consist of a list of tasks organised to reflect the relationships between them.
  The workflow definition includes additional information, such as your repository name and release tag.

## Getting started

Before you can use Airflow, you'll need to:

* [request Airflow access](#request-airflow-access) 
* [create a GitHub repository](#create-a-github-repository) 
* [create a GitHub release](#create-a-github-release) 
* [create an Airflow pipeline project and workflow](#create-an-airflow-pipeline-project-and-workflow)

Follow the next steps to get started.

### Request Airflow access

To access the Airflow components, you'll need to:

* have a GitHub account (see our [Quickstart guide](/get-started.html#3-create-github-account)) 
* [join the `ministryofjustice` GitHub organisation](https://github.com/orgs/ministryofjustice/sso)

> If you are a member of Data Engineering's GitHub team ([@ministryofjustice/data-engineering](https://github.com/orgs/ministryofjustice/teams/data-engineering)), you are automatically granted access and do not need to submit a request

When you have joined the `ministryofjustice` GitHub organisation, [submit a request for Airflow access](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-airflow-access-request.yml).

After your request is granted, you will be added to a GitHub team that will give you access to our GitHub repository, and AWS environments.

> Our team manually approves requests
>
> Once approved, it can take up to three hours to gain access to AWS

### Create a GitHub repository

> If you already have a repository you've used for Data Engineering Airflow, please refer to [migrating from Data Engineering Airflow](#migrating-from-data-engineering-airflow)

1. Create a repository using one of the provided runtime templates:

- [Python Airflow Template](https://github.com/new?template_name=analytical-platform-airflow-python-template&template_owner=ministryofjustice)

- [R Airflow Template](https://github.com/new?template_name=analytical-platform-airflow-r-template&template_owner=ministryofjustice)
     
  > You can create this repository in either the [`ministryofjustice`](https://github.com/ministryofjustice/) or [`moj-analytical-services`](https://github.com/moj-analytical-services/) GitHub organisation
  >
  > Repository standards, such as branch protection, are out of scope for this guidance
  >
  > For more information on runtime templates, please refer to [runtime templates](#runtime-templates)

2\. Add your code to the repository, including the script(s) your want Airflow to run and a file for your package management

3\. Update the `Dockerfile` instructions to copy your code into the image, install packages required to run, and call the script(s) to run. For example, for Python:

```Dockerfile
FROM ghcr.io/ministryofjustice/analytical-platform-airflow-python-base:1.7.0@sha256:5de4dfa5a59c219789293f843d832b9939fb0beb65ed456c241b21928b6b8f59

USER root

COPY requirements.txt requirements.txt
COPY src/ .
RUN pip install -r requirements.txt

USER ${CONTAINER_UID}

ENTRYPOINT ["python3", "main.py"]
```

  > For more information on runtime images, please refer to [runtime images](#runtime-images)

### Create a GitHub release

1. Follow GitHub's documentation on [creating a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release). Make note of the release tag.

1. After you've created a release, check if your container image has been successfully built and published by [logging in to the Analytical Platform Common Production AWS account](https://moj.awsapps.com/start/#/console?account_id=509399598587&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fecr%2Fprivate-registry%2Frepositories%3Fregion%3Deu-west-2)

> You can also see [our example Python repository](https://github.com/moj-analytical-services/analytical-platform-airflow-python-example).

### Create an Airflow pipeline project and workflow

To initialise an [Airflow pipeline project](#concepts), create a directory in the [relevant environment in the Airflow repository](https://github.com/ministryofjustice/analytical-platform-airflow/tree/main/environments), for example, `environments/development/analytical-platform`.

To create a [Airflow pipeline workflow](#concepts) (a DAG), you need to provide a workflow manifest (`workflow.yml`) file in your project under a workflow identifier name.

This manifest file specifies the desired state for workflow, and provides contextual information used to categorise and label the workflow.

For example, create `environments/development/analytical-platform/example/workflow.yml`, where `example` is an identifier for your workflow's name.

The minimum requirements for a workflow manifest look like this:

```yaml
dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 2.0.0

maintainers:
  - jacobwoffenden

tags:
  business_unit: Central Digital
  owner: analytical-platform@justice.gov.uk
```

- `dag.repository` is the name of the GitHub repository where your code is stored and release has been created
- `dag.tag` is the tag you used when creating the release in your GitHub repository
- `maintainers` are a list of GitHub usernames of individuals responsible for maintaining the workflow, and updating any secret values
- `tags.business_unit` **must** be one of `Central Digital`, `CICA`, `HMCTS`, `HMPPS`, `HQ`, `LAA`, `OPG`, `Platforms`, `Technology Services`
- `tags.owner` must be an email address ending with `@justice.gov.uk`

> Providing a `tags.business_unit` other than `Central Digital`, `CICA`, `HMCTS`, `HMPPS`, `HQ`, `LAA`, `OPG`, `Platforms`, `Technology Services` will result in an error.

## Workflow scheduling

There are several options for configuring your workflow's schedule. By default, if no options are specified, you must manually trigger it in the [Airflow console](#accessing-the-airflow-console).

The following options are available under `dag`:

- `catchup`: please refer to [Airflow's guidance](https://airflow.apache.org/docs/apache-airflow/2.10.3/core-concepts/dag-run.html#catchup) (defaults to `false`)
- `depends_on_past`: when set to true, task instances will run sequentially while relying on the previous task’s schedule to succeed (defaults to `false`)
- `end_date`: the timestamp (`YYYY-MM-DD`) that the scheduler won’t go beyond (defaults to `null`)
- `is_paused_upon_creation`: specifies if the dag is paused when created for the first time (defaults to `false`)
- `max_active_runs`: maximum number of active workflow runs (defaults to `1`)
- `retries`: the number of retries that should be performed before failing the task (defaults to `0`)
- `retry_delay`: delay in seconds between retries (defaults to `300`)
- `schedule`: [cron expression](https://crontab.guru/) that defines how often the workflow runs (defaults to `null`)
- `start_date`: the timestamp (`YYYY-MM-DD`) from which the scheduler will attempt to backfill (defaults to `2025-01-01`)

The [`example-schedule` workflow](https://github.com/ministryofjustice/analytical-platform-airflow/blob/main/environments/development/analytical-platform/example-schedule/workflow.yml) shows an example of a workflow that runs at 08:00 every day and retries 3 times, with a 150 second delay between each retry:

```yaml
dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 2.0.0
  retries: 3
  retry_delay: 150
  schedule: "0 8 * * *"
```

## Workflow tasks

Providing the minimum keys under `dag` will create a main task. This task will execute the entrypoint of your container and provide a set of default environment variables; for example, in `development`:

```bash
AWS_DEFAULT_REGION=eu-west-1
AWS_ATHENA_QUERY_EXTRACT_REGION=eu-west-1
AWS_DEFAULT_EXTRACT_REGION=eu-west-1
AWS_METADATA_SERVICE_TIMEOUT=60
AWS_METADATA_SERVICE_NUM_ATTEMPTS=5
AIRFLOW_ENVIRONMENT=DEVELOPMENT
```

### Environment variables

To pass extra environment variables, you can reference them in `env_vars`, like this:

```yaml
dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 2.0.0
  env_vars:
    x: "1"
```

### Compute profiles

We provide a mechanism for requesting minimum levels of CPU and memory from our Kubernetes cluster.
You can additionally specify if your workflow should run on [on-demand](https://aws.amazon.com/ec2/pricing/on-demand/) or can run on [spot](https://aws.amazon.com/ec2/spot/) compute (which can be disrupted).

This is done using the `dag.compute_profile` key, and by default (if not specified), your workflow task will use `general-spot-1vcpu-4gb`, which means:

- `general`: the compute fleet
- `spot`: the compute type
- `1vcpu`: 1 vCPU is guaranteed
- `4gb`: 4GB of memory is guaranteed

In addition to the `general` fleet, we also offer `gpu`, which provides your workflow with an NVIDIA GPU pre-installed with CUDA.

The full list of available compute profiles can be found [here](https://github.com/ministryofjustice/analytical-platform-airflow/blob/main/scripts/workflow_schema_validation/schema.json#L14-L41).

> Analytical Platform tooling (such as JupyterLab, RStudio and Visual Studio Code) has access to 1 vCPU and 12GB RAM. The closest compute profile is `general-on-demand-4vcpu-16gb`.

### Multi-task

![](images/airflow/airflow_diagram_deps.svg)

Workflows can also run multiple tasks, with dependencies on other tasks in the same workflow. To enable this, specify the `tasks` key, for example:

```yaml
dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 2.0.0
  env_vars:
    x: "1"
  tasks:
    init:
      env_vars:
        y: "0"
    phase-one:
      env_vars:
        y: "1"
      compute_profile: cpu-spot-2vcpu-8gb
      dependencies: [init]
    phase-two:
      env_vars:
        y: "2"
      compute_profile: gpu-spot-1vcpu-4gb
    phase-three:
      env_vars:
        x: "2"
        y: "3"
      dependencies: [phase-one, phase-two]
```

Tasks take the same keys (`env_vars` and `compute_profile`) and can also take `dependencies`, which can be used to make a task dependent on other tasks completing successfully.

You can define global environment variables under `dag.env_vars`, making them available in all tasks. You can then override these by specifying the same environment variable key in the task.

`compute_profile` can either be specified at `dag.compute_profile` to set it for all tasks, or at `dag.tasks.{task_name}.compute_profile` to override it for a specific task.

## Workflow identity

By default, for each workflow, we create an associated IAM policy and IAM role in the Analytical Platform's Data Production AWS account.

The name of your workflow's role is derived from its environment, project, and workflow: `airflow-${environment}-${project}-${workflow}`.

To extend the permissions of your workflow's IAM policy to include access to Athena, Bedrock, Glue, KMS ARNs and/or S3 buckets, you can do so under the top-level `iam` key in your workflow manifest, for example:

```yaml
iam:
  athena: write
  bedrock: true
  glue: true
  kms:
    - arn:aws:kms:eu-west-2:123456789012:key/mrk-12345678909876543212345678909876
  s3_deny:
    - mojap-compute-development-dummy/deny1/*
    - mojap-compute-development-dummy/deny2/*
  s3_read_only:
    - mojap-compute-development-dummy/readonly1/*
    - mojap-compute-development-dummy/readonly2/*
  s3_read_write:
    - mojap-compute-development-dummy/readwrite1/*
    - mojap-compute-development-dummy/readwrite2/*
  s3_write_only:
    - mojap-compute-development-dummy/writeonly1/*
    - mojap-compute-development-dummy/writeonly2/*
```

- `iam.athena`: Can be `read` or `write`, to provide access to Amazon Athena (`write` includes `read`)
- `iam.bedrock`: When set to `true`, enables Amazon Bedrock access
- `iam.glue`: When set to `true`, enables AWS Glue
- `iam.kms`: A list of KMS ARNs used for encrypt and decrypt operations if objects are KMS encrypted
- `iam.s3_deny`: A list of Amazon S3 paths to deny access
- `iam.s3_read_only`: A list of Amazon S3 paths to provide read-only access
- `iam.s3_read_write`: A list of Amazon S3 paths to provide read-write access
- `iam.s3_write_only`: A list of Amazon S3 paths to provide write-only access

### Advanced configuration

#### External IAM roles

If you would like your workflow's identity to run in an account that is not Analytical Platform Data Production, you can provide the ARN using `iam.external_role`, for example:

```yaml
iam:
  external_role: arn:aws:iam::123456789012:role/this-is-not-a-real-role
```

You must have an IAM Identity Provider using the associated environment's Amazon EKS OpenID Connect provider URL.
Please refer to [Amazon's documentation](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html#_create_oidc_provider_console).
We can provide the Amazon EKS OpenID Connect provider URL upon request.

You must also create a role that is [enabled for IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).
We recommend using [this Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-role-for-service-accounts-eks).

You must use the following when referencing service accounts:

```
mwaa:${project}-${workflow}
```

## Workflow secrets

To provide your workflow with sensitive information, such as a username, password or API key, you can pass a list of secret identifiers using the `secrets` key in your workflow manifest, for example:

```yaml
secrets:
  - username
  - password
  - api-key
```

This will create an encrypted secret in AWS Secrets Manager in the following path: `/airflow/${environment}/${project}/${workflow}/${secret_id}`, (which you can populate with the secret value via the AWS console) and it will then be injected into your container using an environment variable, for example:

```bash
SECRET_USERNAME=xxxxxx
SECRET_PASSWORD=yyyyyy
SECRET_API_KEY=zzzzzz
```

Secret names with hyphens (`-`) will be converted to use underscores (`_`) for the environment variable.

### Updating a secret value

Secrets are initially created with a placeholder value. To update this, your GitHub username must be listed in the `maintainers` section of the [workflow manifest file](#create-an-airflow-pipeline-project-and-workflow), and then [log in to the Analytical Platform Data Production AWS account](https://moj.awsapps.com/start/#/console?account_id=593291632749&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fsecretsmanager%2Flistsecrets%3Fregion%3Deu-west-2%26search%3Dall%253D%25252Fairflow%25252F) and update the value.

## Workflow notifications

### Email

To enable email notifications, add the following to your workflow manifest:

```yaml
notifications:
  emails:
    - analytical-platform@justice.gov.uk
    - data-platform@justice.gov.uk
```

### Slack

To enable Slack notifications, you need to:

1. Add the following to your workflow manifest:

    ```yaml
    notifications:
      slack_channel: your-channel-name # e.g. analytical-platform
    ```

1. Invite Analytical Platform's Slack application (`@Analytical Platform`) to your channel

## Workflow logs and metrics

> This functionality is coming soon

## Accessing the Airflow console

To access the Airflow console, you can use these links:

- [Development](https://moj.awsapps.com/start/#/console?account_id=381491960855&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fmwaa%2Fhome%3Fregion%3Deu-west-2%23environments%2Fdevelopment%2Fsso)
- [Test](https://moj.awsapps.com/start/#/console?account_id=767397661611&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fmwaa%2Fhome%3Fregion%3Deu-west-2%23environments%2Ftest%2Fsso)
- [Production](https://moj.awsapps.com/start/#/console?account_id=992382429243&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fmwaa%2Fhome%3Fregion%3Deu-west-2%23environments%2Fproduction%2Fsso)

## Runtime templates

We provide repository templates for the supported runtimes:

- [Python](https://github.com/ministryofjustice/analytical-platform-airflow-python-template)
- [R](https://github.com/ministryofjustice/analytical-platform-airflow-r-template)

These templates include:

- GitHub Actions workflow to build and scan your container for vulnerabilities with Trivy
- GitHub Actions workflow to build and test your container's structure
- GitHub Actions workflow to perform a dependency review of your repository, if it's public
- GitHub Actions workflow to build and push your container to the Analytical Platform's container registry
- Dependabot configuration for updating GitHub Actions, Docker, and dependencies such as Pip

The GitHub Actions workflows call shared workflows we maintain [here](https://github.com/ministryofjustice/analytical-platform-airflow-github-actions).

### Vulnerability scanning

The GitHub Actions workflow builds and scans your container for vulnerabilities with Trivy, alerting you to any CVEs (Common Vulnerabilities and Exposures) marked as `HIGH` or `CRITICAL` that have a fix available. You will need to either update the offending package or skip the CVE by adding it to `.trivyignore` in the root of your repository.

### Configuration testing

To ensure your container is running as the right user, we perform a test using Google's [Container Structure Test](https://github.com/GoogleContainerTools/container-structure-test) tool.

The source for the test can be found [here](https://github.com/ministryofjustice/analytical-platform-airflow-github-actions/blob/main/assets/container-structure-test/container-structure-test.yml).

## Runtime images

We provide container images for the supported runtimes:

- [Python](https://github.com/ministryofjustice/analytical-platform-airflow-python-base)
- [R](https://github.com/ministryofjustice/analytical-platform-airflow-r-base)

These images include:

- AWS CLI
- NVIDIA GPU drivers

Additionally, we create a non-root user (`analyticalplatform`) and a working directory (`/opt/analyticalplatform`).

### Installing system packages

Our runtime images are set to run as a non-root user (`analyticalplatform`) which cannot install system packages. 

To install system packages, you will need to switch to `root`, perform any installations, and switch back to `analyticalplatform`, for example:

```dockerfile
FROM FROM ghcr.io/ministryofjustice/analytical-platform-airflow-python-base:1.6.0
USER root # Switch to root
RUN <<EOF
apt-get update # Refresh APT package lists
apt-get install --yes ${PACKAGE} # Install packages
apt-get clean --yes # Clear APT cache
rm --force --recursive /var/lib/apt/lists/* # Clear APT package lists
EOF
USER ${CONTAINER_UID} # Switch back to analyticalplatform
```

## Migrating from Data Engineering Airflow

### GitHub repository

If you have an existing repository that was created using [moj-analytical-services/template-airflow-python](https://github.com/moj-analytical-services/template-airflow-python) or [moj-analytical-services/template-airflow-r](https://github.com/moj-analytical-services/template-airflow-r), you need to perform the following actions:

1. Remove `.github/workflows/ecr_push.yml`

1. Add the GitHub Actions workflows (`.github/workflows`) from the equivalent [runtime template](#runtime-templates)

1. Add the Dependabot configuration (`.github/dependabot.yml`) from the equivalent [runtime template](#runtime-templates)

1. Refactor your Dockerfile to consume the equivalent [runtime image](#runtime-images)

Refactoring your Dockerfile may cause issues as the legacy templates contain older versions of Python and R, did not provide a non-root user, and used a different working directory. We maintain a repository that can serve as a reference for how to use our runtime image, you can find that [here](https://github.com/moj-analytical-services/analytical-platform-airflow-python-example).

> **Please note**: We require that you use our [runtime images](#runtime-images) as we regularly update the operating system and software 

### Airflow configuration

#### IAM

We do not provide a way of reusing the IAM role from Data Engineering Airflow, you will need to populate `iam` with the same configuration, and update any external references to use the new role format, please refer to [workflow identity](#workflow-identity).

#### Secrets

We do not provide a way of reusing secrets or parameters from Data Engineering Airflow, you will need to follow [workflow secrets](#workflow-secrets), and update your application code to consume the injected variables, or retrieve the value from AWS Secrets Manager ([AWS documentation](https://docs.aws.amazon.com/secretsmanager/latest/userguide/retrieving-secrets-python-sdk.html)).

## Getting help

If you have any questions about Analytical Platform Airflow, please reach out to us on Slack in the [#ask-analytical-platform](https://moj.enterprise.slack.com/archives/C06TFT94JTC) channel.

For assistance, you can [raise a support issue](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-airflow-support.yml).
