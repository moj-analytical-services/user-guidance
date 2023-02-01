# Security in GitHub

### Protecting information in GitHub

GitHub should primarily be used to store code.

Generally, you should not store any data in GitHub, especially sensitive data. Instead, you should use [warehouse data sources](../data/amazon-s3#warehouse-data-sources).

You can use the following approaches to reduce the risk of accidentally publishing sensitive data to GitHub. See also [repository visibility](create-project.html#repository-visibility) and [managing access in GitHub](manage-access.html).

<div style="height:0px;font-size:0px;">&nbsp;</div>
| What | How it's configured | Reasoning | How to override |
|------|-------------------------------|-----------|-----------------|
| Publishing data files (.csv, .xlsx, etc.) | [gitignore file](https://git-scm.com/docs/gitignore) | You should not store data in GitHub. | Manually add the file using `git add -f <filename>` |
| Publishing file archives (.zip, .tar, .7z, .gz, .bz, .rar, etc.) | [gitignore file](https://git-scm.com/docs/gitignore) | It's better to unzip file archives and commit their raw contents so files can be tracked individually. This helps prevent data from being accidentally published within a file archive. | Manually add the file using `git add -f <filename>` |
| Publishing large files (>5MB) | [Pre-commit hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) | Large files are likely to be data. | Do not run pre-commit hooks using `git commit --no-verify` |
| Publishing Jupyter notebooks | [nbstripout as a pre-commit hook](https://github.com/kynan/nbstripout#using-nbstripout-as-a-pre-commit-hook) | Jupyter notebook outputs often contain data. | Disable nbstripout using `ENABLE_NBSTRIPOUT=false; git commit` |
| Pushing to repositories outside the MoJ Analytical Services GitHub organistion | [Pre-push hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) | You should only store code in the MoJ Analytical Services GitHub organisation. | Force push using `git push -f <remote> <branch>` |
<div style="height:0px;font-size:0px;">&nbsp;</div>

You should also not store secrets in GitHub, including passwords, credentials and keys. You can use [parameters](../parameters.html) to securely store secrets on the Analytical Platform.

### Accidentally publishing data to GitHub

If you accidentally publish sensitive data to GitHub, you should:

- follow the GitHub guidance on [removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [report a security incident](https://intranet.justice.gov.uk/guidance/security/report-a-security-incident/) and follow any instructions given by the security team

If you need further support contact the Data Engineering team in the [#ask-data-engineering](https://app.slack.com/client/T02DYEB3A/C8X3PP1TN) Slack channel.
