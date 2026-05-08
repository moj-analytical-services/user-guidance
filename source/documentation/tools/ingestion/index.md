# Ingestion service

The ingestion service provides a secure, standardised way to copy data into Ministry of Justice S3 buckets using AWS Family Transfer Server. This means you can use an SFTP server to receive data from a supplier or external organisation in a controlled, auditable way with security scanning. The service can also provide alerts on Slack or by email to notify you of security scan results.

You should use the ingestion service if:

- you need a supplier or external organisation to send you data
- you want a standardised approach that automatically scans files
- the files are under 5 GB in size

The ingestion service cannot: 

- provide full control over AWS infrastructure or security configuration
- allow a user to copy data to more than one bucket (you need separate usernames for a test bucket and a prod bucket)
- support custom workflows or bespoke configurations per team
- transform, clean, or process your data
- support custom security requirements outside the standard offering

If you need to receive files larger than 5 GB, you'll need to split them up to use the ingestion service.

## How the ingestion service works

### Onboarding 

1. You raise an onboarding request by sending us information about the supplier and destination bucket.
1. We check whether this is a standard use case. If the request needs bespoke logging, security rules, transformations, or other non-standard behaviour, it may be outside our current offer.
1. We use the supplier details to create access with an SFTP account and IP addresses.
1. We configure the destination bucket location.
1. We check the bucket's permissions. You may need to update the bucket's policy to allow the ingestion service to copy files into it.  
1. If your destination bucket uses KMS encryption, we use the key you sent us to set up write permissions for the ingestion service.
1. We notify you that the onboarding request has been completed and confirm the username for your account. 

### Copying data to an S3 bucket

1. Your supplier connects to the SFTP endpoint with the username we created and SSH key.
1. Your supplier uploads files to their home directory in a landing bucket.
1. Each file triggers a GuardDuty security scan. 
1. When GuardDuty finishes scanning, you'll receive a notification by Slack or email if you requested this The service moves clean files to your destination bucket and infected files to a quarantine bucket. You cannot access files in the quarantine bucket. 
1. Your team accesses the files in the destination bucket. If any files are in the quarantine bucket, speak to your supplier.

## Onboard to the service

To use the ingestion service, you'll need to give us information about the supplier using the service and the destination bucket. We need contact information of an individual to send notifications and updates about the ingestion service. 

[Raise a support ticket](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-ingestion.yml) with the following information to start the onboarding process:

- supplier's name (this should be a specific person)
- supplier's email (not a generic inbox)
- supplier's IP addresses
- supplier's SSH public key
- destination bucket's location on Analytical Platform (for example: `s3://${DESTINATION_BUCKET}/${OPTIONAL_PREFIX}`)
- destination bucket's KMS key, if encrypted
- an email address or Slack channel to send scan completion alerts to (optional)

> **Note**: We'll generally use the supplier's name or organisation as the account's `USERNAME`, which the person or system using the ingestion service needs to log in. We may change it if we think there's a security issue.

### Request access if you need to download files

By default, ingestion users can only upload files. If you need to download files too, [raise a ticket to request Egress access](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-ingestion.yml) which allows you to upload and download files using SFTP.

You'll need to include your:

- Egress S3 bucket
- Egress KMS key

> **Note**: Users with Egress are presented with two directories when connected to SFTP: `/upload` for ingestion and `/download` for Egress.

### Choose your destination bucket 

The 'destination bucket' is the S3 bucket where transferred files will be delivered. Buckets can exist in any Ministry of Justice AWS account, but setup differs depending on ownership.

There are two options for where to copy your data.

Option 1: Buckets in `analytical-platform-data-production`, such as:

- `mojap-land`
- `mojap-land-dev`

Option 2: Buckets outside `analytical-platform-data-production` but within a Ministry of Justice AWS account.

#### Update destination bucket's permissions 

You'll need to add the correct permissions to the destination bucket's configuration by raising a pull request to update the bucket policy file.

If you are a member of the Ministry of Justice GitHub organisation, you should raise the pull requests yourself.

If you are a not member of the Ministry of Justice GitHub organisation, ask someone to raise pull requests on your behalf in the Slack channel [#ask-analytical-platform](https://moj.enterprise.slack.com/archives/C4PF7QAJZ).

#### Adding permissions to `mojap-land` or `mojap-land-dev`

The destination S3 bucket (and if using SSE-KMS, the KMS key) must have the correct permissions to allow the final `transfer` Lambda function to copy files to it. 

- Development resource [block](https://github.com/ministryofjustice/analytical-platform/blob/12588ba107e6a490394fb6bbf0cb5d64922c9290/terraform/aws/analytical-platform-data-production/data-engineering-pipelines/locals.tf#L564)
- Production resource [block](https://github.com/ministryofjustice/analytical-platform/blob/12588ba107e6a490394fb6bbf0cb5d64922c9290/terraform/aws/analytical-platform-data-production/data-engineering-pipelines/locals.tf#L742)

An [example Pull Request](https://github.com/ministryofjustice/analytical-platform/commit/e63d25a23d557db679b9823b4b8da8e4331bb9ee) showing how to add a bucket to `mojap-land-dev`.

#### Destination bucket permissions

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

- for development, use `730335344807`
- for production, use `471112983409`


#### Destination bucket KMS key

If the destination S3 bucket is encrypted with a customer-managed KMS key, the Analytical Platform ingestion role must be allowed to encrypt objects with that key. Add the following statement to the KMS key policy for the bucket’s key.

```json
    {
      "Sid": "AllowAnalyticalPlatformIngestionService",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<ingestion-account-ID>:role/transfer"
      },
      "Action": [
        "kms:GenerateDataKey",
        "kms:Encrypt"
      ],
      "Resource": "*"
    }
```


Use the correct `ingestion-account-ID` based on the environment:

- for development, use `730335344807`
- for production, use `471112983409`

## Connection Instructions

Connect to our ingestion service using the following commands (see note on `USERNAME` above):

Production

```bash
sftp -P 2222 ${USERNAME}@sftp.ingestion.analytical-platform.service.justice.gov.uk
```
Development

```bash
sftp -P 2222 ${USERNAME}@sftp.development.ingestion.analytical-platform.service.justice.gov.uk
```

### User Home Directories and Access Permissions

Each user connecting to the ingestion service is assigned a dedicated home directory within the `mojap-ingestion-<environment>-landing` S3 bucket. The directory format is:

`/mojap-ingestion-<environment>-landing/<username>`

For example:

`/mojap-ingestion-production-landing/analytical-platform`

When users connect via their SFTP they are restricted to their assigned home directory. Attempts to list or read directories outside of this path (for example, the root `/`) will result in permission errors.

## Known Limitations

### File Names
You cannot use file names with spaces.
