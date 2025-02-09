# How to get Support

## Summary

- The Analytical Platform team in MOJ Digital & Technology is responsible for providing access to software like R Studio, Visual Studio Code and Jupyter.
- Analysts themselves are responsible for the code they write in these tools, and the Platform team is not responsible for assisting with problems with this code.  As a rule of thumb, if the problem you're experiencing would also occur with R Studio or Python installed on a standalone computer, then the platform team don't offer support.
- If you've read through the user guidance and are still stuck, the best place to go for support is the [#analytical-platform-support](https://app.slack.com/client/T1PU1AP6D/C4PF7QAJZ) Slack channel for issues with the platform, or the [#r](https://app.slack.com/client/T1PU1AP6D/C1PUCG719) channel and [#python](https://app.slack.com/client/T1PU1AP6D/C1Q09V86S) channel to get support from peers in your code.

What follows provides further details about how to ask for support, and what you can do to get your issues resolved as quickly as possible.

## Introduction

When using the analytical platform you may experience problems with administration and the platform infrastructure (such as logging in and authorisation) issues with your code (running R or Python scripts) or the platform not functioning as expected, each of these will have a different support path as set out below.

For every problem though there are a few quick steps you can try that will make it easier to provide help and may even fix your issue outright. With the exception of direct administration issues such as resetting authorisation try to:

1. Reproduce the issue: if you can reliably recreate the issue time after time this will make it easier to pin point exactly what is going wrong. This may not always be possible with intermittent faults.

2. Be specific: isolate the problem as much as possible and narrow it down to the smallest segment. It's much easier and quicker if you can pin point a function or line of code, or the exact step that is causing a failure.

3. Check if it is a known issue: it could be that the problem is experienced regularly by others or is a known bug currently being fixed. The place to go to check this will vary on the problem but checking GitHub issue logs, googling the problem, checking stackoverflow and browsing the Slack channels can often highlight the best next steps to take.

## Routes of support

### Analytical Platform support

The Analytical Platform team is responsible for supporting problems with the Analytical Platform itself. If there is a issue relating to the running of the Analytlcal Platform or surrounding infrastructure then they can provide support. Examples of this include:

* bugs or unexpected issues
    + Analytical Platform crashing or inaccessible
    + deployment of Shiny apps not working

* administration of accounts
    + reset authorisation
    + access priviledges not working as expected

This **does not** include any problems which occur as a result of the limitations or incorrect use of software by users on the platform. If issues occur whilst running code or using version control please see the sections below. Remember the first port of call for using the platform should always be this user document.

The MoJ Digitech team have a [Slack channel](https://app.slack.com/client/T1PU1AP6D/C4PF7QAJZ) where you can post questions and a GitHub page where you can raise a formal [issue ticket](https://github.com/ministryofjustice/data-platform-support/issues/new/choose).

For only those users who cannot access Slack or GitHub (i.e. some non DOM1 users) there is a direct email address which can be used: analytical_platform@digital.justice.gov.uk - but this will be monitored for emails from non DOM1 users.

We direct users to Slack for support because that means that users can quickly see whether similar issues are being faced by others, and Slack provides a more efficient way of getting the information we need from users to fix their problems.

### Coding support (R & Python)

There is no team who is responsible for offering support, but we have an active community of colleagues who offer support voluntarily. Users are responsible for the code they create and are expected to debug and solve problems themselves.

If you need support, there are a multitude of resources:

* This guidance contains a number of different sections explaining how the platform interfaces with R and common issues that may occur

* There is an [#r](https://app.slack.com/client/T1PU1AP6D/C1PUCG719) Slack channel which is visited frequently by R users from across ASD -- please use this forum to ask questions or post examples of code, putting your problem out in the open is also a great way to help others who may be experiencing the same thing.

* [Stack Overflow](https://stackoverflow.com/) and [Google](https://www.google.co.uk/) are powerful tools when you encounter a problem - it's very unlikely that you are the first to come across it. Stack Overflow also has the added benefit of allowing you to sign up and post questions publicly, massively widening the chance of finding someone who can help. Be aware not to publish data with questions and be sure to follow the guidance of reproducible examples [below](#how-to-ask-for-support-creating-a-reproducible-example).

* An ASD R training group also exists who can help getting you up to speed with R (unfortunately there isn't yet one for Python) -- this is led by Aidan Mews who can be contacted to discuss the option of formal R training or guidance on online based tutorials

* If you've explored the above options and are still having problems, then the Data Science Hub (DaSH) team will try to provide assistance, although please be aware that team members are under no obligation to do so and appreciate the time this may take away from their other work. Data science team members are active contributors to the Slack channels and creating a post there is the preferred method of contact.

### Git support (version control)

Similarly using git and interfacing with GitHub are processes that users are expected to learn and manage themselves. Git and GitHub are hugely beneficially to analysts as they provide a single version of the truth, incorporate continual QA and allow multiple users to work consectutively on a single file (just to name a few of the benefits). The set up and configuration of Git is covered in this guidance but ff you have any further queries related to the use of git or GitHub there are the following routes of support:

* There is a git/GitHub training course being run by the Data Science Hub which will introduce you to the key concepts and provide you a practical example of how it works. It is highly recommended you take this course when first starting out with git. To find out about when the next session is happening, or ask question about git,  you can use the [data science](https://app.slack.com/client/T1PU1AP6D/C1Z8Q18LS) Slack channel.

## How to ask for support: creating a reproducible example

When posting a problem or question on a forum (whether this be the ASD Slack channel or a public website such as Stack Overflow) it is vital to ensure that other users can reproduce your example, and therefore understand your issue. Posting a question with no example or an example which is too large will prevent otheres from being able to help effectively. When creating a minimal reproducible example:

* Isolate the section of code which is causing the problem, ensure that the example can be run without the need for any prior processing or code.

* Remove any real data, helpers cannot be expect to have access to the same dataset so providing a small dummy dataset is important. In R you could use the built in datasets such as [mtcars](https://www.rdocumentation.org/packages/datasets/versions/3.4.3/topics/mtcars) or [iris](https://rpubs.com/moeransm/intro-iris) which all R users have access to.

* Provide the expected output, be clear as to what you are trying to achieve and what the correct outcome will look like.

Details on how to produce a good reproducible example can be found here:

* [stackoverflow.com/help/mcve](https://stackoverflow.com/help/mcve)
* [GitHub.com/tidyverse/reprex](https://GitHub.com/tidyverse/reprex)

## Raising issues

Rather than posting questions on Slack you could also visit the analytical platform [issues](https://github.com/ministryofjustice/data-platform-support/issues/new/choose) and raise Analytical Platform Support Request. This will raise a message in the [Analytical Platform Support](https://mojdt.slack.com/archives/C4PF7QAJZ) slack channel for the team to pick up.

This approach of raising issues also applies to any package, model or project that has a GitHub page. These issue logs are the most common method for highlighting problems in open source project, many R packages for example have a GitHub page where you can raise issues with the developer or search to see whether your problem has already been raised.
