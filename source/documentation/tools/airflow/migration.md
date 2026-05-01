# Migration

The Analytical Platform team are making changes to how and where Airflow DAGs are run, these changes are:

-   Scheduling DAGs on Analytical Platform’s new compute environment
-   Migrating to an AWS-recommended approach to managing access to resources

>   **Note:** Airflow DAGs identified in the migration discovery that utilise internal networking (Modernisation Platform and HMCTS SDP) are not included in this initial migration phase as the networking is not ready yet.


### Steps to migrate Airflow DAGs to run on the new Analytical Platform Compute EKS clusters:
You must take the following two steps to migrate your Airflow DAG:

#### Step 1. Release a new version of your container image
Release a new version of your container image (e.g. *airflow-cjs-dashboard-data*). This doesn’t need any changes, just increment the version number and generate release notes.  
    *  **Note:** You do not need to use this new version in your DAG, it is just to update the ECR repository policy.

#### Step 2. Modify your DAG

In your DAG file in the [airflow repo](https://github.com/moj-analytical-services/airflow) (e.g. *r_validation.py*), make the following changes:

-   If your DAG uses the `BasicKubernetesPodOperator`, add the following arguments:
    -   `service_account_name=ROLE.replace("_", "-")` 
        -   **Note:** `ROLE` should contain the airflow role name used by your DAG
    -   `environment="dev"` for Development environment 
    -   `environment="prod"` for Production environment
    -   Remove `annotations={"iam.amazonaws.com/role": ROLE}` from the arguments list. 
        -   **Note:** If you are using other annotations than the standard role one, simply remove `"iam.amazonaws.com/role": ROLE` from the list of annotations.
-   If your DAG uses the `KubernetesPodOperator`, add the following arguments:
    -   `service_account_name=ROLE.replace("_", "-")`
    -   update `cluster_context` argument to `"analytical-platform-compute-test"` for Development environment
    -   update `cluster_context` argument to `"analytical-platform-compute-production"` for Production environment
    -   Remove `annotations={"iam.amazonaws.com/role": ROLE}` from the arguments list.
-   Merge the changes in a pull request in the airflow repo as normal.

An example of what an updated DAG should look like is the [examples.use_kubernetes_pod_operators](https://github.com/moj-analytical-services/airflow/blob/main/environments/dev/dags/examples/use_kubernetes_pod_operators.py) DAG. This DAG demonstrates for the `dev` environment both an updated `BasicKubernetesPodOperator` and `KubernetesPodOperator`.

## Important Notes - Package Versioning in Images

If your R packages in renv.lock or your Python packages in requirements.txt are not locked to a version, you will potentially encounter issues if newer versions of those packages are downloaded and installed. This can also occur even if all your packages are at pinned versions, as those packages themselves may have partially unpinned requirements.

While we are unable to assist in resolving dependency issues, our other users have gotten great assistance in our slack [#R](https://moj.enterprise.slack.com/archives/C1PUCG719) and [#python](https://moj.enterprise.slack.com/archives/C1Q09V86S) channels.

## Important Notes - Change in Default Region

The new compute cluster exists in eu-west-2 (London). This change will not affect the majority of customers, as they were either doing operations that were region agnostic, or they were explicitly stating what region they wanted work to be carried out in as part of their image. However, in cases where the region is NOT explictly specified, jobs may fail after migration due to the change in default region. Examples of errors that may be caused by this are:

```An error occurred (InvalidRequestException) when calling the StartQueryExecution operation: The S3 location provided to save your query results is invalid.```
or
```An error occurred (AccessDenied) when calling the CopyObject operation: VPC endpoints do not support cross-region requests```

In this case, you will need to update your image to ensure that all interactions with AWS (using packages such as `boto3`, `awswrangler`, `pydbtools`, and `rdbtools`) are done while including the `region='eu-west-1'` (or appropriate equivalent) argument for operations.
