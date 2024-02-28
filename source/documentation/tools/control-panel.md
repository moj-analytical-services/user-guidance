# Control Panel

The Analytical Platform [Control Panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/) is the main entry point to the Analytical Platform. You can access different resources by clicking on the different tabs.

## Analytical tools

Tools on the Analytical Platform include RStudio and JupyterLab. To use these, you need to start your own copy of the software. This gives you individual reserved memory space (compared to the more common shared R Studio Server) and some control over the version of R that is running.


 ![Tool options in Control Panel](images/tools/tools_options.png)

Use the buttons shown against each tool to manage your copy of the tool:

* "Deploy" - the tool is not yet deployed - this is the initial state. You need to "Deploy" to be able to use the tool for the first time. It sets you up with the latest version and starts it. This may take a few minutes.
* "Open" - the tool is either "Idled" (configured but not running) or "Ready" (running). If your RStudio or JupyterLab is inactive on a Tuesday evening it will be idled. Press "Open" to navigate to the tool in your browser, and if it is not running it will start it (run or "unidle" it). Starting a tool usually takes about 30 seconds, but occasionally will take a few minutes.
* "Restart" - often problems with the tool can be solved by restarting the software on the server.
* "Upgrade" - another release of the tool is available. Occasionally new versions of tools are made available on the Analytical Platform. In this case you'll get the opportunity to upgrade on the control panel. New versions provide new features and bug fixes. In addition, some releases come with improvements to the way tools are containerized and integrated with the Analytical Platform. You should aim to upgrade when it is offered, although in case it may causes minor incompatibilities with your  code, you should not do it in the days just before you have a critical release of your work. When pressed, the status will change to 'Deploying' and then 'Upgraded'. The __Upgrade__ button will no longer be visible (until another version becomes available).

At times very old versions of tools are deprecated/removed from platform but we always inform our users in advance over our slack channel.If you are using an old version of a tool which is due to be removed soon, please do upgrade to an appropriate version.

The Control Panel also provides access to Airflow 2 as an AWS managed service.
You can access the development and production instances of Airflow from the Tools page.
For further details, see the [Airflow documentation](/tools/airflow/).
