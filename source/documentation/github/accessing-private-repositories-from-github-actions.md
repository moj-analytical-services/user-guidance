# Accessing private repositories from GitHub Actions

Projects sometimes need to consume other private projects in GitHub Actions. Traditionally, this has meant project teams must generate deploy keys or personal access tokens (PAT). However, this adds the overhead of managing these secrets.

The Analytical Platform team has installed [Octo STS](https://github.com/apps/octo-sts) to remove the requirement for deploy keys or personal access tokens.

To make use of this, you will need to do the following:

1. Create an Octo STS definition in the repository you want to consume
   
    `.github/chainguard/${IDENTITY}.sts.yaml` where `${IDENTITY}` is a reference to your repository, e.g. `.github/chainguard/moj-analytical-services-airflow-create-a-pipeline.sts.yaml`, which is `${GITHUB_ORGANISATION}-${GITHUB_REPOSITORY}`

    This example gives all workflows on all branches the read permission.

    > Not all permissions are available via Octo STS

    ```yaml
    ---
    issuer: https://token.actions.githubusercontent.com
    subject_pattern: repo:moj-analytical-services/airflow-create-a-pipeline:.*

    permissions:
      contents: read
    ```


1. Retrieve the token in the repository you are consuming the private repository from

    ```yaml
    - name: Obtain Octo STS Token
      uses: octo-sts/action@6177b4481c00308b3839969c3eca88c96a91775f # v1.0.0
      id: octo_sts
      with:
        scope: moj-analytical-services/private-repository           # Reference to repository you want to consume
        identity: moj-analytical-services-airflow-create-a-pipeline # Reference to ${IDENTITY} you created in step 1
    ```

1. You can then use the output token to clone the repository

    ```yaml
    - name: Checkout moj-analytical-services/private-repository
      id: checkout_private_repo
      uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      with:
        persist-credentials: false
        token: ${{ steps.octo_sts.outputs.token }}
        repository: moj-analytical-services/private-repository
        path: private-repository
    ```
