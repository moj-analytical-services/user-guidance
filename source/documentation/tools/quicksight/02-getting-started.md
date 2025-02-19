# Getting Started

## Prerequisites to using QuickSight in Analytical Platform

- Permission to read [data available in QuickSight](/tools/quicksight/#what-data-is-in-quicksight)
- QuickSight enabled for your user within Analytical Platform Control Panel
- You have a QuickSight user linked to your `alpha_user_`

### Permissions

You'll need permissions to databases, tables, or domains for datasets within [the `mojap-derived-table` domains] produced by [Create a Derived Table](/tools/create-a-derived-table).

These permissions are defined in [the data-engineering-database-access GitHub repository].

### Enable QuickSight in Analytical Platform Control Panel

To enable Quicksight, go to your user page in control panel. This is accessed by clicking your username next to the sign out link at the top of the page. Go to the Quicksight access section and check either author or reader depending on your needs. Then hit the save changes button to grant access.

## Accessing QuickSight

- Complete [prerequisites](#prerequisites-to-using-quicksight-in-analytical-platform)
- Navigate to [QuickSight UI within Control Panel]

<!-- External links -->

[the `mojap-derived-table` domains]: https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models
[the data-engineering-database-access GitHub repository]: https://github.com/moj-analytical-services/data-engineering-database-access/?tab=readme-ov-file#access-to-curated-databases
[Azure portal]: https://portal.azure.com/
[\#analytical-platform-quicksight-mvp]: https://moj.enterprise.slack.com/archives/C07LAJB86TZ
[Analytical Platform]: https://analytical-platform.service.justice.gov.uk/
[QuickSight UI within Control Panel]: https://controlpanel.services.analytical-platform.service.justice.gov.uk/quicksight/
