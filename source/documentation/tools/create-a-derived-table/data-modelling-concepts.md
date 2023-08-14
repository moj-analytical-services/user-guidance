# Data Modelling Overview

⚠️ This service is in beta ⚠️

This page is intended to give users a brief introduction to Dimensional Modelling concepts, the process the Data Modelling team take toc reate Dimensional Models, and why we are using `dbt` as the backend for `create-a-derived-table`. Please post suggestions to improve this document in our slack channel [#ask-data-modelling](https://asdslack.slack.com/archives/C03J21VFHQ9), or edit and raise a PR.

## Dimensional Modelling: Key Conepts

Data modelling is the process of creating a structured representation of data. There are several approaches to creating a data model but the data modelling team tends to use and endorse the dimensional modelling approach introduced by Ralph Kimball. If you have hear the term data modelling used by members of the team then it is likely they are referring to dimensional modelling. 

This section contains several important concepts related to dimensional modelling and the explanations are heavily influenced by explanations given in the following book 'The Data Warehouse Toolkit, 3rd Edition' by Ralph Kimball and Margy Ross. This book as well as 'Kimball Dimensional Modeling Techniques' [PDF LINK TO ADD] are great places to start if you want to dive deeper into dimensional modelling.

### What is Dimensional Modelling

Dimensional Modelling involves designing the data structure in a way that optimizes querying and analysis. This is done through organising data into easily understandable "dimensions" (descriptive categories, such as time, geography, or product) and "facts" (measurable metrics, such as sales or revenue). The core guiding principle behind dimensional modelling is simplicity. Simplicity is critical because it ensures that users can easily understand the data, as well as allows software to navigate and deliver results quickly and efficiently.

### What are Fact Tables
The fact table in a dimensional model stores the measurements or outcomes which results from an event. You should strive to store the low-level measurement data resulting from a business process in a single dimensional model.

Each row in a fact table corresponds to a measurement event. The data on each row is at a specific level of detail, referred to as the grain, such as one row per disposal. One of the core tenets of dimensional modelling is that all the measurement rows in a fact table must be at the same grain. Having the discipline to create fact tables with a single level of detail ensures that measurements aren’t inappropriately double-counted.

### What are Dimension Tables
Dimension tables are integral companions to a fact table. The dimension tables contain the descriptive context associated with a fact table event. They describe the “who, what, where, when, how, and why” associated with the event.

### What is a Star Schema 
A star schema is a dimensional model which contains a sigle fact table containg the measurements/outcomes of a business process  which is connected to several dimension tables that provide the descriptive context for that measurement/outcome. For example for a disposal dimensional model we would have a single fact table containing the disposals that occured and then several dimension tables such as defendant, offence, court. A visual example can be seen here [LINK to Khristiania's diagram]

### What is meant by the "Grain" of the data.
The grain is the level of detail a row of data in a fact table is. Often work from the principle that it is best to use the atomic grain which is the lowest level grain as it is easier to aggregate up compared to disaggregating. A fact table must have a consistent grain though different fact tables can have different grains e.g. we can have a disposal fact table and a cases fact table. 

## Process of creating a Dimensional Model.

## The benefits of dbt.