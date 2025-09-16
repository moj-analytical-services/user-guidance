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

### Optional Information

- Slack channel

### User with Egress 

In addition to the default Ingestion user, a user can also request to be added as a User with Egress. 

In effect this allows a user to download files from SFTP as well as upload them.

If requested a user must also supply the following information in their access [request](https://github.com/ministryofjustice/data-platform-support/issues/new?template=analytical-platform-ingestion.yml):

- Egress S3 bucket
- Egress KMS key

> **Note**: Users with Egress are presented with two directories when connected to SFTP `/upload` for ingestion and `/download` for egress.

### User Action Required

The destination S3 bucket must have the correct permisssions to allow the final `transfer` Lambda function to copy files to it. 

For a given S3 bucket `<destination-bucket-name>` include the following statement:

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

The `ingestion-account-ID` should be `471112983409` when connections are being made by the `transfer` lambda function in `analytical-platform-ingestion-production` and `730335344807` when connections are being made from `analytical-platform-ingestion-development`.

Once you receive confirmation from us that you have been onboarded and we have provided you with a username, you will be able to connect to our transfer service using the following commands:

Production:

```bash
sftp -P 2222 ${USERNAME}@sftp.ingestion.analytical-platform.service.justice.gov.uk
```
Development:

```bash
sftp -P 2222 ${USERNAME}@sftp.development.ingestion.analytical-platform.service.justice.gov.uk
```

> **Note**: Filenames with spaces included are not supported.
