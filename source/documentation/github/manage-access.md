# Manage access in GitHub

Access to repositories in GitHub is managed via [teams](https://docs.github.com/en/organizations/organizing-members-into-teams/about-teams). You can set up teams in any way you like. Commonly, teams in GitHub correspond directly to team in the organisation or to a group of people that are working together on the same project. You can also nest teams in GitHub to mirror organisational structures and cascade permissions.

You cannot provide direct access to repositories, except for [outside collaborators](../github/organisation-management.html#outside-collaborators). If you give a member direct access to a repository, they will [automatically be added to a team](../github/organisation-management.html#moving-members-with-direct-repository-access-to-teams) with the same permissions.

### About teams

Invidividuals can be a member of a team or a maintainer of a team.

Maintainers can add and remove members from the team, and change the role of members in the team.

It is often useful for a team to have at least one maintainer. To add a maintainer to a team, contact the [Operations Engineering Team](../github/organisation-management.html#contact).

If your team has no maintainers, you can also ask the [Operations Engineering Team](../github/organisation-management.html#contact) to add and remove members on your behalf.

### Create a team

To create a team:

1. Navigate to the [MoJ Analytical Services](https://github.com/moj-analytical-services) GitHub organisation.
2. Select **Teams**.
3. Select **New team**.
4. Configure the team information and select **Create team**.

We recommend that you set the team visibility to visible so other members of the organisation can see it.

You can also create [nested team structures](https://docs.github.com/en/organizations/organizing-members-into-teams/about-teams#nested-teams) by selecting a parent team.

### Give a team access to a repository

To give a team access to a repository, you must be an admin for the repository.

When giving teams access to a repository, you can assign one of five roles: read, triage, write, maintain or admin.

> The read role allows members to read and clone repositories, and to open and comment on issues and pull requests.
>
> The triage role has the same permissions as the read role and also allows members to manage issues and pull requests.
>
> The write role has the same permissions as the triage role and also allows members to push to repositories.
>
> The maintain role has the same permissions as the write role and also allows members to manage some repository settings.
>
> The admin role has full permissions on the repository. Only members with the admin role can manage access to the repository.
>
> For more detailed information, see the GitHub guidance on the [permissions for each role](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/repository-roles-for-an-organization#permissions-for-each-role).

To give a team access to a repository:

1. Navigate to the repository that you want to give the team access to.
2. Select **Settings**.
3. Select **Collaborators and teams**.
4. Select **Add teams**.
5. Search for the team you want to give access to and select it from the drop-down menu.
6. Choose the role you want to assign to the team.
7. Select **Add to this repository**.

If your repository is internal or public, all other members of the organisation will have read access by default. If you want to give everyone in the organisation a higher level of access, you can use the `@moj-analytical-services/everyone` team. All members of the organisation (excluding outside collaborators) are [added to this team automatically](organisation-management.html#adding-members-to-the-everyone-team).
