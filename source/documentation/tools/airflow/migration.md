# Migration

The Analytical Platform team are making changes to how and where Airflow DAGs are run, these changes are:

-   Scheduling DAGs on Analytical Platform’s new compute environment
-   Migrating to an AWS-recommended approach to managing access to resources

>   **Note:** Airflow DAGs identified in the migration discovery that utilise internal networking (Modernisation Platform and HMCTS SDP) are not included in this initial migration phase as the networking is not ready yet.


### Steps to migrate Airflow DAGs to run on the new Analytical Platform Compute EKS clusters:

*   Release a new version of your container image (e.g. *airflow-cjs-dashboard-data*), this doesn’t need any changes, just increment the version number and generate release notes.  
    *  **Note:** You do not need to use this new version in your DAG, it is just to update the ECR repository policy.

In your DAG file in the airflow repo (e.g. *r_validation.py*), make the following changes:

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

An example of what an updated DAG should look like is the [examples.use_kubernetes_pod_operators](https://github.com/moj-analytical-services/airflow/blob/main/environments/dev/dags/examples/use_kubernetes_pod_operators.py) DAG.