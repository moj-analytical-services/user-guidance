## Understanding JSON Structure
We began by examining the JSON code provided in the HMCTS probate repo. It contains columns and their corresponding attributes, providing valuable insights into our data structure. We will leverage this information to create our dimensional model. Additionally, we have performed summary statistics of the probate data that is available on Athena to gain an overall understanding of the data, identify any empty variables, or those that contain only blocks of text that are not very useful for analysis. During this process, we also discovered that the ce_id will serve as our primary key, as it is the id with the highest number of unique values.

## Identifying Dimensions and Measures
Next, we needed to identify the key dimensions and measures within our data. Dimensions represent different ways to categorize our data, while measures are the numerical values we want to aggregate or analyze.

## Designing Dimension Tables
Based on the identified dimensions, we will create our dimension tables and these tables will capture the unique values of each dimension and any additional attributes. For example, we will have dimension tables for  applicantOrganisationPolicy, bulkPrintId, caseMatches, scannedDocuments, bulkScanEnvelopes, documentsGenerated, documentsReceived, documentsScanned, caseLegacyId, events, and payments.

## Populating Dimension Tables
Once the dimension tables have been designed, we have populated them with the relevant data from the JSON file. This step ensures that we have complete and accurate dimension tables to reference in our dimensional model.

## Designing Fact Tables
Moving on to designing the fact tables, which is the crucial part of this process we have agreed to create two tables: one at ce level and the other at cd level and I will explain why in a bit. The ce_fact table represents the fact data related to the case event information. It captures the primary key, ce_id, which uniquely identifies each ce event. This fact table will include foreign keys referencing the dimension tables associated with ce data. It allows us to analyze and measure various aspects of ce events, such as state and event details, along with their corresponding attributes.

The cd_fact table represents the fact data related to the cd (case data) information over time. It captures the primary key, cd_reference, which uniquely identifies each cd data entry. This fact table will include foreign keys referencing the dimension tables associated with cd data. It allows us to analyze and measure various aspects of cd data, such as creation dates, jurisdiction, references, and security classifications.

The main reason for having separate fact tables is to maintain the granularity and integrity of the data. In some scenarios, ce events and cd data may have different attributes, timeframes, or levels of detail. By separating them into distinct fact tables, we can analyze and report on them independently and accurately. This approach provides flexibility and avoids data redundancy or confusion when querying or aggregating the data.

Having two fact tables also allows us to capture and analyze different aspects of the overall process. For example, the ce_fact table can focus on event-related metrics, such as event types, user information, and state transitions, while the cd_fact table can focus on case-specific details. So Separating the facts into two tables enables a clearer understanding and analysis of the distinct dimensions associated with each aspect of the data.

By looking at cd fact table you are probably questioning why there are some ce variables there and the reason is that these variables are consistent throughout the case and they are not affected by a change in event and as our goal is to keep tables as simple and consistent as possible we decided to move them under the cd fact table. You may also decide that some of these variables are not even needed for the analysis so we can omit them completely.

## Establishing Relationships
The next stage is to establish relationships with the use of foreign keys. These keys will connect the fact tables with the appropriate dimension tables, enabling us to combine and analyze data from different dimensions seamlessly. An example here is user dimension table which is linked to the ce fact table by user_id. So ce_id is the primary key and user_id is the foreign key. 
For cases where there is no foreign key to link a dimensional table with the fact table, we have a couple of options to consider. We can build a bridge table, which acts as a mediator between the fact and dimensional tables, or introduce a surrogate key in the dimensional table. A surrogate key is a system-generated unique identifier that serves as a substitute for a missing or inadequate foreign key. By assigning a surrogate key to the dimensional table, we can establish a relationship with the fact table. I will be investigating the best approach, in collaboration with the data modeling team and the dbt or create-derived-tables repo on GitHub.

## Validating and Refining the Model
It's important to note that this whole process is iterative. Things will keep changing and before finalizing the dimensional model, we need to validate and refine it. We will review the model and make any necessary adjustments based on your feedback and specific business requirements but it is also important to acknowledge the limitation of our own data.

## Creating the Star Schema
What you are seeing now is a possible star schema. In the star schema, the fact tables (ce_fact and cd_fact) serve as the central points, connected to various dimension tables. Each dimension table captures specific attributes related to the ce and cd data, enabling efficient analysis and reporting.
After various discussion I have omitted the cavatorAddress and deceasedAddress dimension tables as we agreed that usually only the postcode is required for any geospatial or statistical analysis and we kept them in caveator and deceased person dimension tables. 

## Closure
That concludes my explanation of the end-to-end process for building the probate dimensional model based on the provided JSON code. By following this process and leveraging the star schema, we can easily analyze and gain valuable insights from our data. Now, I'm happy to address any questions or concerns you may have
