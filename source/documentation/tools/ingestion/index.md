# Ingestion

> Ingestion on the Analytical Platform is currently a beta service.

## Service Requirements

### Required Information

To use the Ingestion service, data owners must provide the following information:

- Supplier's name
- Supplier's email
- Supplier's IP address(es)
- Supplier's SSH public key
- Target location on Analytical Platform (e.g. `s3://${TARGET_BUCKET}/${OPTIONAL_PREFIX}`)

Please raise a support ticket [here](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-ingestion.yml) with the required information to start the onboarding process.

> **Note**: The Supplier's name you provide us will become your `USERNAME`.

### Optional Information

- Slack channel

### User with Egress

By default, Ingestion users can _upload_ files only. You can also request to be added as a **User with Egress**, which allows you to both upload and download files via SFTP.

To request egress access, include the following additional information in your [support ticket](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-ingestion.yml):

- Egress S3 bucket
- Egress KMS key

> **Note**: Users with Egress are presented with two directories when connected to SFTP: `/upload` for ingestion and `/download` for egress.

## Target Bucket Overview

The *Target Bucket* is the S3 bucket where transferred files will be delivered. Buckets can exist in any Ministry of Justice AWS account, but setup differs depending on ownership.

### Target Bucket Scenarios
There are two main scenarios:

Buckets in `analytical-platform-data-production`, such as:

- `mojap-land`
- `mojap-land-dev`

Buckets outside `analytical-platform-data-production`.

### Who Is Responsible?

*Ministry of Justice colleagues* should raise the appropriate Pull Requests on the target bucket configuration, to enable the transfer.
*Third-party consumers* who cannot raise Pull Requests can request help in the Slack channel: [#ask-analytical-platform](https://moj.enterprise.slack.com/archives/C4PF7QAJZ)

### Adding permissions to `mojap-land` or `mojap-land-dev`

The target S3 bucket (and if using SSE-KMS, the KMS key) must have the correct permissions to allow the final `transfer` Lambda function to copy files to it. 

- Development resource [block](https://github.com/ministryofjustice/analytical-platform/blob/12588ba107e6a490394fb6bbf0cb5d64922c9290/terraform/aws/analytical-platform-data-production/data-engineering-pipelines/locals.tf#L564)
- Production resource [block](https://github.com/ministryofjustice/analytical-platform/blob/12588ba107e6a490394fb6bbf0cb5d64922c9290/terraform/aws/analytical-platform-data-production/data-engineering-pipelines/locals.tf#L742)

An [example Pull Request](https://github.com/ministryofjustice/analytical-platform/commit/e63d25a23d557db679b9823b4b8da8e4331bb9ee) showing how to add a bucket to `mojap-land-dev`.

### Destination Bucket Permissions

For a given S3 bucket `<destination-bucket-name>` not located in `analytical-platform-data-production`, include the following statement:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        ...
        {
            "Sid": "AllowAnalyticalPlatformIngestionService",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<ingestion-account-ID>:role/transfer"
            },
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:PutObjectTagging"
            ],
            "Resource": [
                "arn:aws:s3:::<destination-bucket-name>",
                "arn:aws:s3:::<destination-bucket-name>/*"
            ]
        }
    ]
}
```

Use the correct `ingestion-account-ID` based on the environment:

- for development, use `471112983409`
- for production, use `730335344807`

## Connection Instructions

Connect to our ingestion service using the following commands:

### Production

```bash
sftp -P 2222 ${USERNAME}@sftp.ingestion.analytical-platform.service.justice.gov.uk
```
### Development

```bash
sftp -P 2222 ${USERNAME}@sftp.development.ingestion.analytical-platform.service.justice.gov.uk
```

> **Note**: Filenames with spaces included are not supported.
