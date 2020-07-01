# Secrets management

Secrets should be stored securely. This page describes describes best practices for doing this on the Analytical Platform. Secrets should not be stored in git repos - good alternatives like Parameters are provided. We need to protect secrets to protect from data breaches or tampering, and protect computing resources from misuse or loss.

In this context, 'secrets' include:

* passwords
* API keys
* database connection strings
* encryption keys
* tokens

Secrets should **not be stored in code**, even if the git repo is private.

No-one should ever write code like this:

```r
   password <- "AIzaSyAqDsnMnOTAyNKXKt3HRuIvLTCctaFVCLQ"
```

## GitHub repos - why not?

Storing secrets in GitHub repos is [banned for Analytical Platform users](aup.html#github). Once it goes into git, it is likely to be shared with more people than you expect, now and in the future.

Whilst code often needs secrets at the time it runs, the way we store code and secrets need to be completely different: in general analysts should share their code widely, to spread knowledge and work transparently. But secrets have the opposite property - they are shared on a "need-to-know" basis. Often only one person setting up a connection with an external service needs to know it, not everyone who has access to the code.

Secrets are difficult to spot in a repository. Often they are just a few characters, lost in a sea of code and files. Of particular concern is that it's very easy to miss a secret that has been deleted with `git rm` or the line in the code is removed in a `git commit`, but it is still found in the `git history`. There are specialist tools that hunt through a repo for secrets, for example [gitrob](https://github.com/michenriksen/gitrob), searching for common secret names, or looking for high entropy strings, but these tools are not reliable for all secrets and show false positives.

The users who have access to a repo does change frequently. It's quite normal to give more people access to a repo than are actually working on the code - maybe it's one repo of many that a team is given access to. Or maybe everyone in the org or GitHub Enterprise Account have access. Someone in the future might give another team access to a private repo, or flip it to internal or public access. It's easy to forget that a repo has a secret that should not be shared.

In conclusion, you can easily lose control of secrets if you ever put them in a git repository, because they hide well, can stick around in the history for years, and access control can change over time, due to different motivations for sharing code compared to secrets.

### What to do in the event of a secret being committed to a git repo

* Revoke the secret (if you can)
* [Report security concerns](information-governance.html#reporting-security-incidents)
* Delete relevant files from the git history using a tool like [bfg](https://rtyley.github.io/bfg-repo-cleaner/). Then force push the cleaned repo to Github. Also search for forks and copies of your repo.

## A file which is not committed to git

You can store a secret in a file in your Analytical Platform home directory, just not adding it to a git repo. When you work in RStudio or Jupyter and start off exploring an API or other external service, this can often be fine. You could read it in like this:

```python
    file  = open('../secrets/apikey.txt', 'r')
    api_key = file.read()
```

The key risk that you need to manage is the chance of accidentally adding the secret file to your git repo. You could add the filename to your .gitignore file, but it's probably more reliable if you put it in a directory outside any repo.

This technique is limited to personal use. Whilst you *could* share the file securely with colleagues, you do lose control and oversight of what they do with it. And it is not suitable for apps or Airflow pipelines. For these needs, store the secret in the cloud using one of the following techniques.

## S3 bucket

You can put a secret in a file in an S3 bucket. This allows you to control access from individual platform users, apps and Airflow.

However this may not be as quick to access or as convenient as using the Parameter Store. Also you may need different permissions for the secret file compared to your data, which means creating separate buckets.

### Example - Airflow gets secret from S3

1. Create 'secrets.json' with these contents:
`{"username": "moj_scraper", "password": "G58aq&HF-FAKE-74PWtU"}`
2. Upload to bucket 'alpha-dag-foo'.
3. In your Airflow repo's `iam_policy.json` add access to that bucket. See all instructions to [Set up an Airflow pipeline](airflow.html#set-up-an-airflow-pipeline)
4. In your pipeline's python get the secret with s3_utils:

```python
secrets = s3_utils.read_json_from_s3(
        "alpha-dag-foo/secrets.json"
    )
username = secrets['username']
password = secrets['password']
```

## Parameters

'Parameters' is the preferred method of storing secrets in Analytical Platform, including for apps and Airflow pipelines. Under the hood, the parameters are stored in encrypted form in [AWS Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html).

Parameters has its own tab in Control Panel.

| Field | Description | Examples |
| ----- | ----------- | -------- |
| Role name | The IAM Role name for the thing that needs access to the secret. Apps are: `alpha_app_APP` Airflow pipelines are: `airflow_PIPELINE` | `alpha_app_matrixbooking` `airflow_github_logs` |
| Key | A name you can choose for this secret | `DB_PWD` `maps_api_key` |
| Value | The secret itself | `AIzaSyAqDsnMnOTAyNKXKt3HRuIvLTCctaFVCLQ` |

Note: 'Parameters' is new to the Analytical Platform and currently it has the limitation that a parameter is 'tied' to the user that creates it in Control Panel in the first place. This could be an issue when the user moves project and wants to handover to someone else. Until this is resolved, in this case you could either:

1. The new user adds the secret themselves to Control Panel, using a new key.
2. Ask an AP administrator to edit the ownership in the Control Panel database.

### Usage

In a Shiny app, when the app is deployed the parameters exist as environment variables. The app can retrieve them with the function `Sys.getenv("parameter_key")`.

In Airflow, parmeters are accessed via the AWS API, using the AWS client library.

### Example - Shiny app get secret from Parameter Store

The example `trains` app will access a remote API. We'll set two parameters in Control Panel:

* Key: `api_username` Value: `moj_trains_user` Role_name: `alpha_app_trains`
* Key: `api_password` Value: `74PWtU-FAKE-G58aq&HF` Role_name: `alpha_app_trains`

In the app it's just use Sys.getenv:

```r
results <- trains_api(Sys.getenv("api_username"), Sys.getenv("api_password"))
```

### Example - Airflow gets secret from Parameter Store

The example `flights` airflow job will access a remote database. We'll set two parameters in Control Panel:

* Key: `db_username` Value: `moj_scraper_user` Role_name: `airflow_flights`
* Key: `db_password` Value: `G58aq&HF-FAKE-74PWtU` Role_name: `airflow_flights`

Add these the parameter's role into the Airflow job's iam_policy.json:

```json
    {
        "Sid": "readParams",
        "Effect": "Allow",
        "Action": [
            "ssm:DescribeParameters",
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParameterHistory",
            "ssm:GetParametersByPath"
        ],
        "Resource": [
            "arn:aws:ssm:*:*:parameter/alpha/airflow/airflow_flights/*"
        ]
    },
    {
        "Sid": "allowDecrypt",
        "Effect": "Allow",
        "Action": [
            "kms:Decrypt"
        ],
        "Resource": [
            "arn:aws:kms:::key/*"
        ]
    }
```

In the airflow job you can access the parameters like this:

```python
from ssm_parameter_store import EC2ParameterStore
store = EC2ParameterStore(region_name='eu-west-1')
parameters = store.get_parameters_by_path('/alpha/airflow/airflow_flights/secrets/', strip_path=True, recursive=True)
db_username = parameters['db_username']
db_password = parameters['db_password']
```
