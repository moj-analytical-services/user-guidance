# Amazon Bedrock

## Getting Access to Amazon Bedrock in the Analytical Platform

First, you will need access to the Control Panel, [see Analytical Platform User Guidance](https://user-guidance.analytical-platform.service.justice.gov.uk/get-started.html).

To enable Bedrock for your user, go to your user page in control panel. This is accessed by clicking your username next to the sign out link at the top of the page. Go to the Enable Bedrock section and check the Bedrock Enabled box. Then hit the save changes button to grant access.

To grant Bedrock access to your Webapp, [raise a support request](https://github.com/ministryofjustice/data-platform-support/issues/new/choose).

## What is Amazon Bedrock?

[Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html) is a managed service that provides an API interface and access to high-performing generative AI foundation models (FMs). These are large-scale, general-purpose machine learning models trained on extensive datasets that can be adapted to perform a wide range of tasks across various applications. FMs generate outputs from one or more inputs (prompts) in the form of human language instructions.

There is a range of foundation models that are tailored to specific use cases. Amazon Bedrock allows users to test leading foundation models, tailor them to your specific use case using methods like fine-tuning and Retrieval Augmented Generation (RAG), and create AI-driven agents that can interact with your data sources.

[See the list of supported foundation models in Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html)

## What can Amazon Bedrock be used for?

Amazon Bedrock enables you to use foundation models for generative AI applications through a unified API. See [What can I do with Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html#servicename-feature-overview) for further information.

## Getting started withAmazon Bedrock

A good starting point is familiarising yourself with the [terms and concepts](https://docs.aws.amazon.com/bedrock/latest/userguide/key-definitions.html) used by AWS Bedrock.

Once you are comfortable with these, you may wish to try the following AWS tutorials:

- **To learn how to run basic prompts and generate model responses:** Use the Playgrounds in the Amazon Bedrock console, continue to [Getting started in the Amazon Bedrock console](https://docs.aws.amazon.com/bedrock/latest/userguide/getting-started-console.html).  **Note:** You will see some errors at the top of the page for ```Model Catalog``` and ```Playgrounds```; these can be ignored and do not affect functionality.
- **To set up access to Amazon Bedrock operations through the Amazon Bedrock API** and test out API calls, continue to [Try making API calls to Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/getting-started-api.html#gs-try-bedrock). **Note:** All the permissions have already been granted to your role.
- **To learn about supported software development kits (SDKs)** supported by Amazon Bedrock, continue to [Using Amazon Bedrock with an AWS SDK](https://docs.aws.amazon.com/bedrock/latest/userguide/sdk-general-information-section.html).

**Note:** If you require access to foundation models not listed in the ```Model Catalog```, please contact Analytical Platform support.

## Central Digital & Data Office guidance

You may also find the following documents, published by the **Central Digital & Data Office**, useful for general guidance on generative AI

- [GDS AI Playbook](https://www.gov.uk/government/publications/ai-playbook-for-the-uk-government/artificial-intelligence-playbook-for-the-uk-government-html)
- [Generative AI Framework for HMG](https://www.gov.uk/government/publications/generative-ai-framework-for-hmg/generative-ai-framework-for-hmg-html)
- [Guidance to civil servants on the use of generative AI](https://www.gov.uk/government/publications/guidance-to-civil-servants-on-use-of-generative-ai/guidance-to-civil-servants-on-use-of-generative-ai)

## Accessing Data with Amazon Bedrock

It is your responsibility to check with the data owners and the security team that your proposed use of the data in Amazon Bedrock is covered by a DPIA before proceeding.

## AWS Bedrock Cross-Region Inference

When you request access to AWS Bedrock ([here](https://github.com/ministryofjustice/data-platform-support/issues/new/choose)), Cross-Region Inference is granted to your user permissions by default.

Only a subset of Bedrock’s models are available for cross-region inference.

### What is Bedrock Cross-Region Inference

**Cross-Region Inference** is a feature of Bedrock that can automatically route inference requests to foundation models hosted in different AWS regions.

For **supported models**, you are able to take advantage of cross-region inference while still keeping your data within the EU. Currently the preset geographical locations are Ireland, Paris and Frankfurt.

Cross-region inference helps maximise application throughput and performance regardless of compute per-region availability. The GPU-enabled compute that these models run on is supply-constrained as all AWS customers rush towards adoption of generative AI that runs on this compute type. Cross-region inference mitigates localised demand constraints.

### Cross-Region Inference Caveats 

As requests are dynamically routed to one of the 3 enabled EU ‘cross-region inference’ regions, there is no way of knowing at the time the query is sent to AWS which region the data will be processed in. 

If there are governance restrictions on the underlying data that limit data processing in any specific AWS region, this feature should **not** be implemented.

### Using Bedrock Cross-Region Inference

To use Cross-Region Inference you will have to specify one of the available Cross-Region Inference models. See the [List of Supported Regions and models for inference profiles](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html)

### Check the available models via the AWS Console:

1. Navigate to Amazon Bedrock.
1. From the left-hand pane, select **"Cross-Region Inference"**.
1. View enabled inference models, along with their profile IDs.

**Note:** The console view will only list models that have been enabled within the Analytical Platform, if you require access to a model not listed please contact  Analytical Platform support.

### Check the available models using the API:

 Run the following command: ```aws bedrock list-inference-profiles```

### How to implement Cross-region Inference

If you are currently using a Foundation model for example:

```python
modelId = 'anthropic.claude-3-5-sonnet-20240620-v1:0'
bedrock_runtime.converse(
  modelId=modelId,
  system=[{
    "text": "You are an AI assistant."
  }],
  messages=[{
    "role": "user",
    "content": [{"text": "Tell me about Amazon Bedrock."}]
  }]
)
```

To use Cross-Region Inference simply amend the ```modelId``` as in the example below:

Before

```python
modelId = 'anthropic.claude-3-5-sonnet-20240620-v1:0'
```
After

```python
modelId = 'eu.anthropic.claude-3-5-sonnet-20240620-v1:0'
```

## Useful Documentation Links

- [Amazon Bedrock User Guide](https://docs.aws.amazon.com/bedrock/latest/userguide/index.html)
- [Increase throughput with cross-region inference](https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html)
- [Getting started with cross-region inference in Amazon Bedrock](https://aws.amazon.com/blogs/machine-learning/getting-started-with-cross-region-inference-in-amazon-bedrock/)
- [Amazon Bedrock Studio Guide](https://docs.aws.amazon.com/bedrock/latest/studio-ug/index.html)
- [API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/index.html)
