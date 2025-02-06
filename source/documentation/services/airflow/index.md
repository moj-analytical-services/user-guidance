# Airflow

> This documentation is for the new Analytical Platform Airflow service.
>
> For Data Engineering Airflow, please refer to [Data Engineering Airflow](/tools/airflow)

## Overview

[Apache Airflow](https://airflow.apache.org/) is a workflow management platform designed for data engineering pipelines.

Pipelines are executed on the Analytical Platform's Kubernetes infrastructure and can interact with services such as Amazon Bedrock and Amazon S3.

Our Kubernetes infrastructure is connected to the MoJO Transit Gateway, providing connectivity to the Cloud Platform, Modernisation Platform, and HMCTS SDP. If you require further connectivity, please raise a [feature request](https://github.com/ministryofjustice/analytical-platform/issues/new?template=feature-request-template.yml).

> **Please note**: Analytical Platform Airflow does not support pipelines that use `BashOperator` or `PythonOperator`.
>
> This is because we run a multi-tenant Airflow service and do not permit running code on the Airflow control plane, which is where non-container operators would run.

## Concepts

We organise Airflow pipelines using **environments**, **projects** and **workflows**:

  * **Environments** are the different stages of infrastructure we provide: `development`, `test` and `production`

  * **Projects** are a unit for grouping workflows dedicated to a distinct business area, business domain, or specific project.
  For example: `BOLD`, `HMCTS` or `HMPPS`.

  * **Workflows** are pipelines, also referred to as [DAGs](https://airflow.apache.org/docs/apache-airflow/2.10.3/core-concepts/dags.html#dags).
  This is a list of the tasks to work through, organised to reflect the relationships between the tasks.
  The workflow definition includes other information such as your repository name and release tag.

## Getting started

Before you can use Airflow, you'll need to:

- [request access](#request-access) on GitHub
- [create a GitHub repository](#create-a-github-repository) 
- [send us a container image](#send-us-a-container-image)
- [send us a workflow manifest](#create-a-workflow-manifest) 

Follow the next steps to get started.

### Request access

To access the Airflow components, you will need a GitHub account (see our [Quickstart guide](/get-started.html#3-create-github-account)), and to also be part of the `ministryofjustice` GitHub organisation, which you can join by using [this link](https://github.com/orgs/ministryofjustice/sso).

When you have joined the `ministryofjustice` GitHub organisation, please raise a [request](link-tbc).

After your request is granted, you will be added to a GitHub team that will give you access to our GitHub repository, and AWS environments.

> Access to AWS may take up to 3 hours.

### Create a GitHub repository

1. Create a repository using one of the provided runtime templates:

    > You can create this repository in either the [`ministryofjustice`](https://github.com/ministryofjustice/) or [`moj-analytical-services`](https://github.com/moj-analytical-services/) GitHub organisation
    >
    > Repository standards, such as branch protection, are out of scope for this guidance.
    >
    > For more information on runtime templates, please refer to [runtime templates](#runtime-templates).

    [**Python**](https://github.com/new?template_name=analytical-platform-airflow-python-template&template_owner=ministryofjustice)

    **R** (coming soon)

1. Add your code to the repo to populate the image that will run in Airflow.

1. Update the `Dockerfile` instructions to copy your code into the image and install packages required to run.

  > For more information on runtime images, please refer to [runtime images](#runtime-images).

1. Create a [release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) (please refer to GitHub's
[documentation]
(https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release))

After a release is created, your container image will be built and published to the Analytical Platform's container registry.

You can check if your container image has been pushed by [logging in to the Analytical Platform Common Production AWS account](https://moj.awsapps.com/start/#/console?account_id=509399598587&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2F509399598587-pyma7ahz.eu-west-2.console.aws.amazon.com%2Fecr%2Fprivate-registry%2Frepositories%3Fregion%3Deu-west-2).

An example repository can be [found here](https://github.com/moj-analytical-services/analytical-platform-airflow-python-example).

### Creating a project

To initialise a project, create a directory in the [relevant environment in our repository](https://github.com/ministryofjustice/analytical-platform-airflow/tree/main/environments), for example, `environments/development/analytical-platform`.

### Creating a workflow

To create a workflow, you need to provide us with a workflow manifest yaml document (`workflow.yml` - [Learn YAML in Y minutes](https://learnxinyminutes.com/yaml/)) in your project.
This manifest specifies the desired state for the Airflow DAG, and provides contextual information used to categorise and label the DAG.

For example, create `environments/development/analytical-platform/example-workflow/workflow.yml`, where `example-workflow` is an identifier for your workflow's name.

The minimum requirements for a workflow file look like this:

```yaml
tags:
  business_unit: hq
  owner: analytical-platform@justice.gov.uk

dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 1.0.2
```

- `tags.business_unit` must be either `central`, `hq`, or `platforms`.
- `tags.owner` must be an email address ending with `@justice.gov.uk`.
- `dag.repository` is the name of the GitHub repository where your code is stored.
- `dag.tag` is the tag you used when creating a release in your GitHub repository.

## Workflow tasks

Providing the minimum keys under `dag` will create a main task that will execute the entrypoint of your container, providing a set of default environment variables:

```bash
AWS_DEFAULT_REGION=eu-west-1
AWS_ATHENA_QUERY_EXTRACT_REGION=eu-west-1
AWS_DEFAULT_EXTRACT_REGION=eu-west-1
AWS_METADATA_SERVICE_TIMEOUT=60
AWS_METADATA_SERVICE_NUM_ATTEMPTS=5
```

### Environment variables

To pass extra environment variables, you can reference them in `env_vars`, like this:

```yaml
dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 1.0.2
  env_vars:
    FOO: "bar"
```

### Compute profiles

We provide a mechanism for requesting minimum levels of CPU and memory from our Kubernetes cluster.
You can additionally specify if your workflow should run on [on-demand](https://aws.amazon.com/ec2/pricing/on-demand/) or can run on [spot](https://aws.amazon.com/ec2/spot/) compute (which can be disrupted).

This is done using the `compute_profile` key, and by default (if not specified), your workflow task will use `general-spot-1vcpu-4gb`, which means:

- `general`: the compute fleet
- `spot`: the compute type
- `1vcpu`: 1 vCPU is guaranteed
- `4gb`: 4GB of memory is guaranteed

In addition to the `general` fleet, we also offer `gpu`, which provides your workflow with an NVIDIA GPU.

The full list of available compute profiles can be found [here](https://github.com/ministryofjustice/analytical-platform-airflow/blob/main/scripts/workflow_schema_validation/schema.json#L30-L57).

### Multi-task

Workflows can also run multiple tasks, with dependencies on other tasks in the same workflow. To enable this, specify the `tasks` key, for example:

```yaml
dag:
  repository: moj-analytical-services/analytical-platform-airflow-python-example
  tag: 1.0.2
  tasks:
    init:
      env_vars:
        PHASE: "init"
    phase-one:
      env_vars:
        PHASE: "one"
      dependencies: [init]
    phase-two:
      env_vars:
        PHASE: "two"
      dependencies: [phase-one]
    phase-three:
      env_vars:
        PHASE: "three"
      compute_profile: gpu-spot-1vcpu-4gb
      dependencies: [phase-one, phase-two]
```

Tasks take the same keys (`env_vars` and `compute_profile`) and can also take `dependencies`, which can be used to make a task dependent on other tasks completing successfully.

`compute_profile` can either be specified at `dag.compute_profile` to set it for all tasks, or at `dag.tasks.{task_name}.compute_profile` to override it for a specific task.

## Workflow identity

By default, for each workflow, we create an associated IAM policy and IAM role in the Analytical Platform's Data Production AWS account.

The name of your workflow's role is derived from its environment, project, and workflow: `airflow-${environment}-${project}-${workflow}`.

To extend the permissions of your workflow's IAM policy, you can do so under the top-level `iam` key in your workflow manifest, for example:

```yaml
iam:
  bedrock: true
  kms:
    - arn:aws:kms:eu-west-2:123456789012:key/mrk-12345678909876543212345678909876
  s3_read_only:
    - mojap-compute-development-dummy/readonly1/*
    - mojap-compute-development-dummy/readonly2/*
  s3_read_write:
    - mojap-compute-development-dummy/readwrite1/*
    - mojap-compute-development-dummy/readwrite2/*
```

- `iam.bedrock`: When set to true, enables Amazon Bedrock access.
- `iam.kms`: A list of KMS ARNs used for encrypt and decrypt operations if objects are KMS encrypted.
- `iam.s3_read_only`: A list of Amazon S3 paths to provide read-only access.
- `iam.s3_read_write`: A list of Amazon S3 paths to provide read-write access.

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

To provide your workflow with secrets, such as a username or password, you can pass a list of secrets names using the `secrets` key in your workflow manifest, for example:

```yaml
secrets:
  - username
  - password
```

This will create an encrypted secret in AWS Secrets Manager in the following path: `/airflow/${environment}/${project}/${workflow}/${secret_id}`, (which you can populate with the secret value via the console) and it will then be injected into your container using an environment variable, for example:

```bash
SECRET_USERNAME=xxxxxx
SECRET_PASSWORD=yyyyyy
```

Secret names with hyphens (`-`) will be converted to use underscores (`_`) for the environment variable.

### Updating a secret value

Secrets are initially created with a placeholder value. To update this, [log in to the Analytical Platform Data Production AWS account](https://moj.awsapps.com/start/#/console?account_id=593291632749&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fsecretsmanager%2Flistsecrets%3Fregion%3Deu-west-2%26search%3Dall%253D%25252Fairflow%25252F) and update the value.

## Accessing environments

To access the Airflow console, you can use these links:

- [Development](https://moj.awsapps.com/start/#/console?account_id=381491960855&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fmwaa%2Fhome%3Fregion%3Deu-west-2%23environments%2Fdevelopment%2Fsso)
- [Test](https://moj.awsapps.com/start/#/console?account_id=767397661611&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fmwaa%2Fhome%3Fregion%3Deu-west-2%23environments%2Ftest%2Fsso)
- [Production](https://moj.awsapps.com/start/#/console?account_id=992382429243&role_name=modernisation-platform-mwaa-user&destination=https%3A%2F%2Feu-west-2.console.aws.amazon.com%2Fmwaa%2Fhome%3Fregion%3Deu-west-2%23environments%2Fproduction%2Fsso)

## Workflow logs and metrics

> This functionality is coming soon.

## Runtime templates

We provide repository templates for the supported runtimes:
- [Python](https://github.com/ministryofjustice/analytical-platform-airflow-python-template)
- R (coming soon).

These templates include:

- GitHub Actions workflow to build and scan your container for vulnerabilities with Trivy.
- GitHub Actions workflow to build and test your container's structure.
- GitHub Actions workflow to perform a dependency review of your repository, if it's public.
- GitHub Actions workflow to build and push your container to the Analytical Platform's container registry.
- Dependabot configuration for updating GitHub Actions, Docker, and dependencies such as Pip.

The GitHub Actions workflows call shared workflows we maintain here.

### Vulnerability scanning

The GitHub Actions workflow to build and scan your container for vulnerabilities with Trivy will alert on any CVEs (Common Vulnerabilities and Exposures) marked `HIGH` or `CRITICAL` that have a fix available. You will need to either update the offending package or skip the CVE by adding it to `.trivyignore` in the root of your repository.

### Configuration testing

To ensure your container is running as the right user, we perform a test using Google's [Container Structure Test](https://github.com/GoogleContainerTools/container-structure-test) package.

The source for the test can be found [here](https://github.com/ministryofjustice/analytical-platform-airflow-github-actions/blob/main/assets/container-structure-test/container-structure-test.yml).


## Runtime images

We provide container images for the supported runtimes:
- [Python](https://github.com/ministryofjustice/analytical-platform-airflow-python-base)
- R (coming soon).

These images include:

- Ubuntu base image
- AWS CLI
- NVIDIA GPU drivers

Additionally, we create a non-root user (`analyticalplatform`) and a working directory (`/opt/analyticalplatform`).

## Migration from Data Engineering Airflow

_TBC_

## Getting help

If you have any questions about Analytical Platform Airflow, please reach out to us on Slack in the [#ask-analytical-platform](https://moj.enterprise.slack.com/archives/C06TFT94JTC) channel.

For assistance, you can raise a [support issue](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-airflow-support.yml).
