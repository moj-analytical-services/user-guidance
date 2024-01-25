# Data Linking

As a department, we struggle with a lack of consistent, reliable, unique identifiers within and across our systems. Unique IDs are critical to getting a true picture of the justice system and as an analyst it is important to be able to link together different datasets across domains.

The Internal Data Linking team have created Data Linking tables (using the [Splink](https://moj-analytical-services.github.io/splink/index.html) under the hood) for use across Data & Analysis to allow analysts to:

1. Deduplicate Individual Datasets
2. Link between Datasets (i.e. across domains)

The Data Linking tables contain estimated unique IDs attached to each ID within the linked datasets. They function as a lookup table that associates a raw system ID with the unique linked ID we have generated. This linked ID can then be used to deduplicate and/or link datasets.

For more on the Data Linking tables, how they are made and how to use them, check out the [data discovery tool](https://data-discovery-tool.analytical-platform.service.justice.gov.uk/data_linking_anonymised/index.html).
