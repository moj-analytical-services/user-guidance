# Airflow

> **Important**
>
> This documentation is for the now deprecated Data Engineering Airflow service.
> This service is now in updates only mode, and will be shuttered on July 8th 2025.
>
> Please refer to [Analytical Platform Airflow](/services/airflow) for more information on our new Airflow service.


[Airflow](https://airflow.apache.org) is a platform to programmatically author, schedule and monitor workflows

## Important links

- [AWS control panel](https://aws.services.analytical-platform.service.justice.gov.uk/): to login to AWS and access AP tools including the Airflow dev and prod UI
- [Airflow dev UI](https://eu-west-1.console.aws.amazon.com/mwaa/home?region=eu-west-1#environments/dev/sso): for running and monitoring development and training workflows on the Airflow UI (you will need to login to AWS first)
- [Airflow prod UI](https://eu-west-1.console.aws.amazon.com/mwaa/home?region=eu-west-1#environments/prod/sso): for running and monitoring production workflows on the Airflow UI (you will need to login to AWS first)
- [Airflow repo](https://github.com/moj-analytical-services/airflow): Github repo to store Airflow DAGs and roles
- [Airflow template for Python](https://github.com/moj-analytical-services/template-airflow-python): Github template repository for creating a Python image to run an Airflow pipeline
- [Airflow template for R](https://github.com/moj-analytical-services/template-airflow-r): Github template repository for creating an R image to run an Airflow pipeline
- Support: contact the Analytical Platform team on [#ask-analytical-platform](https://moj.enterprise.slack.com/archives/C06TFT94JTC)

## To find out more

- [Airflow pipeline concepts](/tools/airflow/concepts): What is Airflow and why you should use it
- [Airflow pipeline instructions](/tools/airflow/instructions): Step by step guide for creating an example Airflow pipeline and related resources 
- [Troubleshooting Airflow pipelines](/tools/airflow/troubleshooting): Common pitfalls
