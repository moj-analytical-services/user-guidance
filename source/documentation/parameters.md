# Parameters - working with secrets

We use the 'parameters' feature to securely store 'secrets' in the Analytical Platform.

This page describes how to use parameters and compares it with other ways of storing secrets. It's important that we store secrets securely to protect from data breaches or tampering, and protect computing resources from misuse or loss.

In this context, secrets include:

* passwords
* API keys
* database connection strings
* encryption keys
* tokens

Secrets should **not be stored in code**, even if the GitHub repository is private. See the [GitHub repos](#github-repos-do-not-use-for-secrets) section for further information.

## About parameters

Parameters are the preferred method of storing secrets in the Analytical Platform, including for apps and Airflow pipelines. Analytical Platform uses [AWS Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) to store the parameters in an encrypted form.

### Storing a parameter

Parameters have their own tab in the control panel.

#### Role name 

Description: The IAM Role name for the thing that needs access to the secret. 
Apps are: `alpha_app_APP` Airflow pipelines are: `airflow_PIPELINE`.

Example: `alpha_app_matrixbooking`

#### Key 

Description: A name you can choose for this secret 

Example: `DB_PWD` `maps_api_key` 

#### Value 

Description: The secret itself 

Example: `zzzzzzzzzzzz` 

### Limitations

Currently a parameter can only be managed by the user that originally created it in control panel. This means that ownership of a parameter cannot be shared with or transferred to another user, for example, when moving to a new project. If you need to transfer the ownership of a parameter to another user, there are two methods:

1. Ask the user to create a parameter with the same value in the control panel using a new key and update your code to refer to the new key.
2. Ask an Analytical Platform administrator to manually change the ownership of the parameter in the control panel database.

### Accessing a parameter

In an R Shiny app, when the app is deployed the parameters exist as environment variables. The app can retrieve them using the function `Sys.getenv("parameter_key")`.

In Airflow, parameters are accessed using the AWS API, using the AWS client library.

### Example: Shiny app uses parameters

The example `trains` R Shiny app will access a remote API. We'll set two parameters in the control panel for the API username and password:

* Key: `api_username` Value: `moj_trains_user` Role_name: `alpha_app_trains`
* Key: `api_password` Value: `74PWtU-FAKE-G58aq&HF` Role_name: `alpha_app_trains`

To access these parameters in the app, we can use the `Sys.getenv` function:

```r
results <- trains_api(Sys.getenv("api_username"), Sys.getenv("api_password"))
```

### Example: Airflow uses parameters

The example `flights` Airflow pipeline will access a remote database. We'll set two parameters in the control panel:

* Key: `db_username` Value: `moj_flight_db_user` Role_name: `airflow_prod_flights`
* Key: `db_password` Value: `G58aq&HF-FAKE-74PWtU` Role_name: `airflow_prod_flights`

Add permissions to access these parameters to the role policy specified in the Airflow job's airflow_prod_flights.yaml:

```yaml
secrets: true
```

The Airflow job will access the parameters like this:

```python
from ssm_parameter_store import EC2ParameterStore
store = EC2ParameterStore(region_name='eu-west-1')
parameters = store.get_parameters_by_path('/alpha/airflow/airflow_prod_flights/secrets/', strip_path=True, recursive=True)
db_username = parameters['db_username']
db_password = parameters['db_password']
```

## S3 bucket

You can put a secret in a file in an S3 bucket. This allows you to control access from individual platform users, apps and Airflow.

However this may not be as quick to access or as convenient as using the Parameter Store. Also you may need different permissions for the secret file compared to your data, which means creating separate buckets.

### Example: Airflow gets secret from S3

This example illustrates how an Airflow job might be setup to access a secret stored in a file in S3:

1. Create `secrets.json` with these contents:
`{"username": "moj_scraper", "password": "G58aq&HF-FAKE-74PWtU"}`
2. Upload to bucket 'alpha-dag-foo'.
3. In your Airflow repo's `iam_policy.json` add access to that bucket. See all instructions to [Set up an Airflow pipeline](airflow.html#set-up-an-airflow-pipeline)
4. In your pipeline's Python code, get the secret with `s3_utils`:

```python
secrets = s3_utils.read_json_from_s3(
        "alpha-dag-foo/secrets.json"
    )
username = secrets['username']
password = secrets['password']
```

## A file which is not committed to git

You can store a secret in a file in your Analytical Platform home directory, just don't add it to a git repo. When you work in RStudio or JupyterLab and start off exploring an API or other external service, this will often be sufficient. You could read in a secret in Python like this:

```python
    with open('../secrets/api_key.txt', 'r') as file:
        api_key = file.read()
```

The key risk that you need to manage is the chance of accidentally adding the file with the secret to your git repository. You could add the filename to a `.gitignore` file, but it's probably more reliable if you store it in a directory outside the repository entirely.

This technique is limited to personal use. Whilst you could share the file securely with colleagues, you do lose control and oversight of what they do with it. And it is not suitable for apps or Airflow pipelines. For these needs, store the secret in the cloud using parameters or an S3 bucket.

## GitHub repositories - DO NOT use for secrets

Storing secrets in GitHub repositories is [prohibited for Analytical Platform users](aup.html#github). Secrets should **not be stored in code**, even if the GitHub repository is private.

For example, never write code like this:

```r
   password <- "AIzaSyAqDsnMnOTAyNKXKt3HRuIvLTCctaFVCLQ"
```

Once a secret is added to a git repository, it is likely to be shared with more people than you expect, now and in the future.

Whilst code often needs secrets at the time it runs, the way we store code and secrets need to be completely different. In general, analysts should share their code widely, to spread knowledge and work transparently. But secrets have the opposite property - they are shared on a "need-to-know" basis. Typically, only one person who sets up a connection with an external service needs to know any relevant secrets, not everyone that has access to the code.

Secrets are difficult to spot in a repository. Often they are just a few characters, lost in a sea of code and files. Of particular concern is that it's very easy to miss a secret that has been deleted with `git rm` or where a line containing a secret has been removed in a commit but can still be found in the commit history. There are specialist tools (for example, [gitrob](https://github.com/michenriksen/gitrob)) that hunt through a repo for secrets, searching for common secret names, or looking for high entropy strings, but these tools are not reliable for all secrets. And because they find false positives, it deters people from using these tools regularly.

The users that have access to a repository can change frequently. It's quite normal to give more people access to a repository than are actually working on the code. For example, members of a team may be given access to all repositories relevant to an area of work, or you may be given access to internal repositories as a member of a GitHub organisation. Someone in the future might give another team access to a private repository, or change it to internal or public access. It's easy to forget that a repository contains a secret that should not be shared.

In conclusion, you can easily lose control of secrets if you ever put them in a git repository, because they hide well, can stick around in the history for years, and access control can change over time, due to different motivations for sharing code compared to secrets.

### What to do in the event of a secret being committed to a git repo

If you accidentally push a secret to GitHub:

1. Revoke or deactivate the secret. This will prevent others from using the secret if it has been exposed.
2. Report it as a [security incident](information-governance.html#reporting-security-incidents)
3. Delete all relevant files from the git history using a tool like [bfg](https://rtyley.github.io/bfg-repo-cleaner/).
4. Force push the cleaned git history to GitHub.

You should also do the same for any forks or copies of the repository that also contain the secret.
