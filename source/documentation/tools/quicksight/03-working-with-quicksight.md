# Working with QuickSight

## Adding a dataset

Datasets are available via the `Athena` data source in QuickSight:

> Datasets > New Dataset (top right) > Athena > New Athena data source.

When adding a new dataset via Athena you'll be prompted for a `Data source name`.
This is just a descriptive name for the new data source tile for **you** in **your** QuickSight interface.

Here's [the advice from AWS] about naming your Data source:

> _This name displays on the Amazon QuickSight list of existing data sources, which is at the bottom of the 'Create a Dataset' view.
> Use a name that makes it easy to distinguish your data sources from other similar data sources._

Unless specified elsewhere for your data, use the default `Athena workgroup`.

Data will be in the default Catalog (`AwsDataCatalog`), and you should only see Databases that your user has access to via the Database Access Repo.

Adding a dataset in this way enables you to add a single table at a time.

You'll be asked if you want to 'Import to [SPICE] for quicker analytics'.
This imports the data into memory, rather than querying the data where it lives in S3. Whether to use SPICE or directly query the data is a judgement call, and will likely come down to:

- how complex the analysis is
- the size, format and structure of the underlying data
- how likely users are to drill down into the dashboards
- user tolerance for load times while making changes to dashboards

## Publishing Dashboards

- To create a dashboard, you'll need to publish it from an analysis. 
[The AWS QuickSight documentation] has details around the publishing flow.

## Sharing Dashboards

>**⚠️ Important ⚠️**
> 
>Users who have access to the dashboard can also see the data used in the associated analysis.

[Published dashboards](#publishing-dashboards) can be shared with anyone who already has a QuickSight user. 
Dashoards can be shared as-is, or they can be shared on a schedule via email, as an attachment or a link to the dashboard.

From [the AWS documentation on sharing dashboards]:

"By default, dashboards in Amazon QuickSight aren't shared with anyone and are only accessible to the owner.
However, after you publish a dashboard, you can share it with other users or groups in your QuickSight account. 
You can also choose to share the dashboard with everyone in your QuickSight account and make the dashboard visible on the QuickSight homepage for all users in your account. 
Additionally, you can copy a link to the dashboard to share with others who have access to it."

## Embedding a dashboard in a Cloud Platform app

1. Create a new service account and IRSA in your app's cloud platform namespace. You can use [this terraform module](https://github.com/ministryofjustice/cloud-platform-terraform-irsa) and the policy should allow you to assume a role (which also needs creating) in the quicksight aws account, where the role_name in the below is the name of the role that will be created in the quicksight aws account. When this IRSA is created it will be saved in the secrets of your namespace

    <details>
    <summary>Click here to see an example terraform code block</summary>
    <pre>
    <code>
    module "quicksight_irsa" {
        source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=2.0.0"
        eks_cluster_name      = var.eks_cluster_name
        namespace             = var.namespace
        service_account_name  = "my-cp-app-quicksight"
        role_policy_arns = {
            quicksight = aws_iam_policy.my_cp_app_quicksight.arn
        }
        # Tags 
        business_unit          = var.business_unit
        application            = var.application
        is_production          = false
        environment_name       = var.environment
        team_name              = var.team_name
        infrastructure_support = "some-team-email@justice.gov.uk"
    }
    data "aws_iam_policy_document" "my_cp_app_quicksight" {
        statement {
            effect = "Allow"
            actions = [
                "sts:TagSession",
                "sts:AssumeRole"
            ]
            resources = [
                "arn:aws:iam::{account_id}:role/{role_name}"
            ]
        }
    }
    resource "aws_iam_policy" "my_cp_app_quicksight" {
        name   = "my-cp-app-quicksight"
        policy = data.aws_iam_policy_document.my_cp_app_quicksight.json
        tags = {
            business-unit          = var.business_unit
            application            = var.application
            is-production          = false
            environment-name       = var.environment
            owner                  = var.team_name
            infrastructure-support = "some-team-email@justice.gov.uk"
        }
    }
    resource "kubernetes_secret" "irsa" {
        metadata {
        name      = "quicksight-irsa-output"
        namespace = var.namespace
        }
        data = {
            role           = module.quicksight_irsa.role_name
            rolearn        = module.quicksight_irsa.role_arn
            serviceaccount = module.quicksight_irsa.service_account.name
        }
    }
    </code>
    </pre>
    </details>


2. You will need to find out the arn, dashboard ID and quicksight namespace for the dashboard that you want to embed, as these will be needed for the policy you'll create in the next step. You can get these by asking in the #ask-analytical-platform slack channel.

3. Create an IAM role in the AP compute account in terraform via the [modernisation platform environments repository](https://github.com/ministryofjustice/modernisation-platform-environments/tree/main/terraform/environments/analytical-platform-compute).

    The iam role should be defined in the iam-roles.tf file

    <details><summary>Click here to see an example terraform code block</summary>
    <pre>
    <code>
        ...
    </code>
    </pre>
    </details>


4. Add your new service account to your apps deployment yaml manifest file, so the IAM roles are available to your application. Your service account name can be decoded from the `quicksight_irsa` secret you've previously created.

    <details>
    <summary>Click here to see an example yaml code block</summary>
    <pre>
    <code>
    apiVersion: apps/v1
    kind: Deployment
    metadata:
        name: my-cp-app
    spec:
        replicas: 1
        selector:
        matchLabels:
            app: my-cp-app
        template:
        metadata:
            labels:
            app: my-cp-app
        spec:
            serviceAccountName: <serviceaccount>
            containers:
            - name: my-cp-app
            image: ${IMAGE_PATH}
            ports:
            - containerPort: 4567
    </code>
    </pre>
    </details>

5. The Analytical Platform team will need to add your allowed domains to quicksight via the console in AWS - request this via the #ask-analytical-platform slack channel.

6. You should now be able to write code in your app to generate and return a url which can be embedded within a page of your application. 
    <details>
    <summary>Click here to see an example Python code block</summary>

    ```python
    import logging
    import boto3
    from botocore.exceptions import ClientError
    from django.conf import settings


    def get_quicksight_client():
        sts = boto3.client("sts")
        role_response = sts.assume_role(
            RoleArn=settings.QUICKSIGHT_ROLE_ARN, RoleSessionName="quicksight"
        )["Credentials"]

        session = boto3.Session(
            aws_access_key_id=role_response["AccessKeyId"],
            aws_secret_access_key=role_response["SecretAccessKey"],
            aws_session_token=role_response["SessionToken"],
        )

        return session.client("quicksight")


    def generate_embed_url_for_anonymous_user() -> str | None:
        """
        Generates an embed URL for an anonymous user to access a QuickSight dashboard.

        Returns:
            str | None: The embed URL if successful, otherwise None.
        """
        quicksight_client = get_quicksight_client()
        try:
            response = quicksight_client.generate_embed_url_for_anonymous_user(
                AwsAccountId=settings.QUICKSIGHT_ACCOUNT_ID,
                Namespace=settings.QUICKSIGHT_NAMESPACE,
                AuthorizedResourceArns=[settings.QUICKSIGHT_METADATA_DASHBOARD_ARN],
                ExperienceConfiguration={
                    "Dashboard": {
                        "InitialDashboardId": settings.QUICKSIGHT_METADATA_DASHBOARD_ID
                    }
                },
                SessionLifetimeInMinutes=600,
            )

            return response["EmbedUrl"]

        except ClientError as e:
            logging.error(
                f"Failed to generate embed URL for anonymous user: {e.response['Error']['Message']}"
            )
            return None
    ```

    </details>

<!-- External links -->

[the advice from AWS]: https://docs.aws.amazon.com/quicksight/latest/user/create-a-data-source.html
[SPICE]: https://docs.aws.amazon.com/quicksight/latest/user/managing-spice-capacity.html
[AWS resources]: https://aws.amazon.com/quicksight/resources/
[AWS example analysis]: https://docs.aws.amazon.com/quicksight/latest/user/example-analysis.html
[The AWS QuickSight documentation]: https://docs.aws.amazon.com/quicksight/latest/user/creating-a-dashboard.html
[the AWS documentation on sharing dashboards]: https://docs.aws.amazon.com/quicksight/latest/user/sharing-a-dashboard.html