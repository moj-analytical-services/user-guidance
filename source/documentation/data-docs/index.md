# Data
There are several different data sources on the Analytical Platform:

* [Amazon S3](amazon-s3/)
* [Curated databases](curated-databases/)
* [Home directories](home-directories)


Also see [Demos on how to use our AWS Tools](https://github.com/moj-analytical-services/mojap-aws-tools-demo/)


## Getting the data you need

The data you need may already exist on the Analytical Platform. The diagram and steps below show the process for finding and getting access to it. 

If, after following this, you find out the data you need is not on the Platform, you may need to find it and upload it yourself. In that case please refer to the [Information Governance](../information-governance.html) section.

<%= image_tag "/images/data/get-data-user-flow.svg", { :alt => '' } %>

1. Do you know where the data is?
* If you do, go to step 4.
* If you do not, go to step 2.

2. Check Find MoJ data for what you need
* If you've found what you need, go to step 4.
* If you have not found what you need, go to step 3.

3. Ask in #ask-data-engineering
* Once you find what you need, go to step 4.

4. Where is the data?
* If it's a maintained database, go to step 5.
* If it's an S3 bucket, go to step 6.

5. Make a pull request on Data Engineering Database Access
* When you have access, go to step 7.

6. Find the S3 bucket owner
* Go to 'Warehouse data' in Control Panel and ask them to add you, or ask #ask-analytical-platform if no admin is listed.
* When you have access, go to step 7.

7. Query the data
* If the data is in a maintained database, use your chosen software to query it. 
* If the data is an S3 bucket, access it directly from R or Python.

## FAQs

There are also some [FAQs](data-faqs/) on data access.