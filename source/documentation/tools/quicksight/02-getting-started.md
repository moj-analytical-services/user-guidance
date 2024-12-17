# Getting Started

## Prerequisites to using QuickSight in Analytical Platform

- Permission to read [data available in QuickSight](/tools/quicksight/#what-data-is-in-quicksight)
- QuickSight enabled for your user within Analytical Platform Control Panel
- You have a QuickSight user linked to your `alpha_user_`

### Permissions

You'll need permissions to databases, tables, or domains for datasets within [the `mojap-derived-table` domains] produced by [Create a Derived Table](/tools/create-a-derived-table).

These permissions are defined in [the data-engineering-database-access GitHub repository].

### Ensuring you have a QuickSight user

> **Note:** As you read through the instructions you will notice that you are being asked to authenticate and set up user groups using Azure Entra ID and your `@justice.gov.uk` identity. This is a deliberate choice. Our long-term strategic goal as a platform is to transition away from Github for access management and utilise MOJ’s central directory.

#### 1. Create a User Group in Entra ID

- Go to the [Azure Portal] and sign in with your `justice.gov.uk` credentials.
- In the top search bar, search for **"Entra ID"** and click on **Microsoft Entra ID**.
  - if this is the first time using the Azure Portal there are a few pages you can skip to get to this point.
- Navigate to **Manage** \> **Groups** and click **\+ New group**.
- Set **Group type** to **Security**.
- Enter a **Group name** beginning with `azure-aws-sso-qs-` and a unique identifier (e.g., `azure-aws-sso-qs-yourteam`).
- Choose **Membership type** as **Assigned**.
- Click on **No members selected**, then search for and select all users who will participate in the MVP. Ensure all users have a `justice.gov.uk` email address.
- To add yourself as an admin, click on the **Owners** section, search for your user account, and add it as an owner. This will give you administrative rights to manage group membership and settings.
- Click **Create** to finalise the group setup, and notify the AP team.

#### 2. Notify Us of the Group Name and Begin Synchronisation

- Provide the group name to the AP team by posting in **[\#analytical-platform-quicksight-mvp]** on Slack. The AP team will synchronise the group and update QuickSight roles.

### Enable QuickSight in Analytical Platform Control Panel

[Raise a support request] to enable QuickSight for your user

## Accessing QuickSight

- Complete [prerequisites](#prerequisites-to-using-quicksight-in-analytical-platform)
- Navigate to [QuickSight UI within Control Panel]

<!-- External links -->

[the `mojap-derived-table` domains]: https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models
[the data-engineering-database-access GitHub repository]: https://github.com/moj-analytical-services/data-engineering-database-access/?tab=readme-ov-file#access-to-curated-databases
[Raise a support request]: https://github.com/ministryofjustice/data-platform-support/issues/new/choose
[Azure portal]: https://portal.azure.com/
[\#analytical-platform-quicksight-mvp]: https://moj.enterprise.slack.com/archives/C07LAJB86TZ
[Analytical Platform]: https://analytical-platform.service.justice.gov.uk/
[QuickSight UI within Control Panel]: https://controlpanel.services.analytical-platform.service.justice.gov.uk/quicksight/
