# Seeds


## What are seeds?

Seeds are lookup tables easily created from a `.csv` file. Put the `.csv` in the [`./mojap_derived_tables/seeds/`](./mojap_derived_tables/seeds/) directory and follow the same directory structure requirements and naming conventions as for models. As with marts models, your seeds should have property files that have the same filename as the seed. Seeds can be accessed by anyone with standard database access and so must not contain sensitive data. Generally, seeds shouldn't contain more than 1000 rows, they don't contain complex data types, and they don't change very often. You can deploy a seed with more than 1000 rows, but it's not reccomended and it will take quite a long time to build.

⚠️ Seeds must not contain sensitive data. ⚠️
