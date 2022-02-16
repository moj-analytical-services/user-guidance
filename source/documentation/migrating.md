# Migrating to the new Analytical Platform

## What is the Migration?

As part of ongoing improvements to the Analytical Platform,
we are migrating the platform to a new ‘managed cluster’.

This will bring the following benefits for users:

* Access to the latest version of analytical tools (RStudio and JupyterLab)
* We can retire problematic tech like conda for RStudio (this will be replaced by **renv**) and concourse (this will be replaced by **GitHub Actions** as a next step)
* Enhanced security
* Enhanced reliability and easier maintenance, leading to a better service

The new environment has been built and we are in the process of migrating all users to it.

## Preparation for migration

Some instructions before you upgrade:

* Make sure all your code is pushed to Github and your data is saved on S3 as your home directories (your personal file storage inside RStudio or JupyterLab) will be wiped

## What happens when it’s time?

* We aim to upgrade people in batches so that we can manage any teeting issues incrementally. Before you are due to upgrade you will be notified by email and on the [#ap-upgrade-testing](https://asdslack.slack.com/archives/C02JFGPHU8G) channel on slack.  Once you have back up your code and data (see 'Preparation' above) you can just click the link to the [new control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/) which will instigate your upgrade.
* The URL link / address for the Analytical Platform has changed, so make sure you save the link and update any bookmarks. The new link is [https://controlpanel.services.analytical-platform.service.justice.gov.uk/](https://controlpanel.services.analytical-platform.service.justice.gov.uk/)
* Upgrade done - enjoy!


## What happens afterwards?

* The Control Panel is not changing at all, so once you are on the Tools page just choose what version of Tool you want to deploy (we recommend using the latest available versions)
* Once you deploy your tools, you will have to reconnect to GitHub using your SSH key.  You will need to do this separately for JupyterLab and RStudio as the Home Directories are no longer connected. Guidance [here](/github.html#setup-github-keys-to-access-it-from-r-studio-and-jupyter)
* As part of the upgrade, s3tools which was built internally by a group of analysts and data engineers will cease to work
* This has been replaced by boto3 and there is now official guidance on how to change your projects. This can be found [here](/appendix/botor.html#installation)
* Conda has been replaced by renv and further guidance can be found [here](/tools/package-management.html#renv)
* Currently no Apps will be impacted by the upgrade and once all the users are on-boarded on the new infrastructure, we will be focusing on the Apps.


## Common Problems

* Issue: “There is a problem with your session” Error message on trying to log in

![](/images/control_panel/there_is_a_problem.png)

Solution: Make sure you are using the link to the new platform and that you’ve updated your bookmarks.
The new link is [https://controlpanel.services.analytical-platform.service.justice.gov.uk/](https://controlpanel.services.analytical-platform.service.justice.gov.uk/)


## Technical details about the upgrade

The MOJ analytical platform runs in AWS, primarily on Kubernetes clusters running in our Data account.  The team have determined that there were various issues with the old Kops managed cluster that necessitated an upgrade, namely:

* Security risk of running an old Kubernetes version
* We have to manage the Kubernetes Control plane
* Our development environment does not match our production environment

We are therefore migrating the platform to EKS managed clusters that will deliver the following benefits to the AP team:

* A more secure version of Kubernetes
* Kubernetes upgrades will be more straightforward to perform
* AWS manages the Kubernetes Control plane
* A development environment that matches our production environment
