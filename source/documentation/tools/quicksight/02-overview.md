# Overview

## What is QuickSight?
QuickSight is a data visualisation service that allows you to create interactive dashboards and reports from data available on the Analytical Platform; straight to your browser, in a reproducible way. All you’ll need to do is connect your data sources and start building your visualizations using QuickSight's interface. QuickSight is packed full of features for analyzing data using various visualization types, so you'll need to get familiar with certain bits of QuickSight functionality. To learn more about QuickSight, take a look at [the aws documentation]. Some of the basics about working with QuickSight in this user guide, but you can also sign up and work through [QuickSight's own examples].

We’re still in beta so we'd love to get some of you using QuickSight to get your feedback to help guide data visualization best practices in the Ministry of Justice and make sure we can continue to improve the user experience.

## What data is available in QuickSight?
QuickSight is connected to [the `mojap-derived-table` domains] published through [Create a Derived Table](/tools/create-a-derived-table). 

If the output from Create a Derived Table goes to the `mojap_derived_tables/prod/models` path in S3, it should be available in QuickSight.


<!-- External links -->

[the aws documentation]: https://docs.aws.amazon.com/quicksight/latest/user/welcome.html
[QuickSight's own examples]: https://docs.aws.amazon.com/quicksight/latest/user/quickstart-createanalysis.html
[the `mojap-derived-table` domains]: https://github.com/moj-analytical-services/create-a-derived-table/tree/main/mojap_derived_tables/models
