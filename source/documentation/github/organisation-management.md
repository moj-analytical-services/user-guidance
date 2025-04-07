# GitHub organisation management

The MoJ Analytical Services GitHub organisation is managed by the Operations Engineering Team.

## Processes and practices

### Members

#### Adding a member

To add a member to the organisation, you can either:

1. Follow the [instructions](https://docs.github.com/en/organizations/managing-membership-in-your-organization/inviting-users-to-join-your-organization) in the GitHub documentation. To do this, you must be an organisation owner.
2. If you are an MoJ employee then use the [GitHub SSO](https://github.com/orgs/moj-analytical-services/sso)

You do not need to add members to the `everyone` team manually, as this will be done [automatically](#adding-members-to-the-everyone-team).

### Outside collaborators

An outside collaborator is a person who is not a member of the organisation, but has access to one or more repositories.

We use outside collaborators for external users, such as analysts from other government departments and partner organisations.

To add an outside collaborator you must be a Repository Administrator. Repository Administrators can invite external collaborators directly from the [GitHub](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-outside-collaborators/adding-outside-collaborators-to-repositories-in-your-organization#adding-outside-collaborators-to-a-repository). Operations Engineering guidance relating to this is located [here](https://user-guide.operations-engineering.service.justice.gov.uk/documentation/information/storing-source-code.html#member-of-the-moj-organisation).

## Automation

All automated processes are managed in the [moj-analytical-services/operations-engineering](https://github.com/moj-analytical-services/operations-engineering) repository.

### Archiving GitHub repositories

GitHub repositories are automatically archived when there is no activity on the `main` or `master` branch for more than 1.5 years.

If you still need a repository that has been archived, [contact](#contact) the Operations Engineering Team. Where a repository is inactive but should not be archived, it can be added to an allow list, so it is not archived again in future.

### Moving members with direct repository access to teams

Any members that only have direct access to a repository will be moved to a new team with the same level of access. For example, a member with write access to the `airflow` repository would be added to a team called `airflow-write-team`.

If a member has both direct access to a repository and access via a team, they will only retain access via the team. If the level of access provided by the team is less than the level of direct access, their level of access will be reduced. For example, if a member has direct admin access to a repository and read access via a team, they will only retain read access via the team.

By default, members that are moved to teams will not be maintainers. Therefore, they will not be able to manage team permissions, including adding and removing members, and changing the role of members. You can request to be made a maintainer by [contacting](#contact) the Operations Engineering Team.

### Adding members to the everyone team

All organisation members will automatically be added to the `@moj-analytical-services/everyone` team. This does not include outside collaborators.

### Removing inactive users

Occasionally, we will review active members of the GitHub organisation, and remove accounts that are no longer required. We identify inactive members using information provided by GitHub on [managing dormant users](https://docs.github.com/en/enterprise-cloud@latest/admin/user-management/managing-users-in-your-enterprise/managing-dormant-users).

## Contact

The team can be contacted in the [#ask-operations-engineering](https://mojdt.slack.com/archives/C01BUKJSZD4) Slack channel or by email at [operations-engineering@digital.justice.gov.uk](mailto:operations-engineering@digital.justice.gov.uk).
