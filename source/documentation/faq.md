# Frequently Asked Questions

## What IP addresses does the Analytical Platform use?

If you are connecting from one of our Analytical Platform services and are required to provide IP addresses as a means of access control, you can find our ranges [here](https://github.com/ministryofjustice/moj-ip-addresses/blob/main/moj-cidr-addresses.yml), under the `analytical_platform` key.

Airflow workflows that have been [migrated](tools/airflow/migration.html) to Analytical Platform Compute will use:

- `analytical_platform.compute.test` for `airflow-dev`
- `analytical_platform.compute.production` for `airflow-prod`

Airflow workflows that have not been [migrated](tools/airflow/migration.html) to Analytical Platform Compute will use:

- `analytical_platform.data_engineering_airflow.development` for `airflow-dev`
- `analytical_platform.data_engineering_airflow.production` for `airflow-prod`

Analytical Platform Tools (JupyterLab, RStudio and Visual Studio Code) will use:

- `analytical_platform.tools.development` for `development`
- `analytical_platform.tools.production` for `production`

Analytical Platform Applications hosted on Cloud Platform will use the IP addresses found [here](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/networking/ip-filtering.html#outbound-ip-filtering).
