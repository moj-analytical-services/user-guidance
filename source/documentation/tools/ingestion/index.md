# Ingestion

> Ingestion on the Analytical Platform is currently a beta feature.

## Service Requirements

### Information to be provided to Analytical Platform

To use the Ingestion feature, data owners must provide the following information to the team via the approved process:

- Supplier's name
- Supplier's email
- Supplier's IP address(es)
- Supplier's SSH public key
- Target location on Analytical Platform (e.g. `s3://${TARGET_BUCKET}/${OPTIONAL_PREFIX}`)

This information will then be merged into the requisite repository. Examples of this information can be found [here](https://github.com/ministryofjustice/modernisation-platform-environments/blob/main/terraform/environments/analytical-platform-ingestion/transfer-user.tf).

### User Action Required

The user's S3 bucket must have the correct permisssions to allow the final `transfer` Lambda function to copy files to it. 

For a given S3 bucket `<supplier-bucket-name>` include the following statement 

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
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:PutObjectTagging"
            ],
            "Resource": [
                "arn:aws:s3:::<supplier-bucket-name>",
                "arn:aws:s3:::<supplier-bucket-name>/*"
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
