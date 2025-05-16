# Getting Started

## Prerequisites to registering dashboards

- You will need to be able to access the Analytical Platform Control Panel
- QuickSight author permissions are enabled for your user within Analytical Platform Control Panel
- You have created a dashboard using Quicksight


## Register dashboard in Analytical Platform Control Panel

First go to the [QuickSight UI within Control Panel] and click the dashboards tab on the Quicksight UI. Right click on the dashboard you want to share and click Copy Link. Go to the [dashboards page] on Control Panel and click the Register a dashboard button. From here, add a dashboad name and paste the link you copied into the Dashboard URL form. The dashboard link should look something like `https://eu-west-2.quicksight.aws.amazon.com/sn/dashboards/<unique-code-here>`. Dashboard names and URLs should be unique and can be registered by one user only. Click the Register dashboard button. If your dashboard has been registered successfully, you will be taken to the dashboard management screen.

The management screen provides a link to the viewable dashboard in the dashboard service as well as other management functions such as granting admin access and de-register the dashboard from control panel. Dashboard admins can manage access to the dashboard and de-register it from the dashboard service.

## Managing Dashboard Access

Sharing access can be managed in two ways. The first is granting access to individuals via their email on the customer management page. Individual viewers will be sent a notificaiton email that the dashboard has been shared with them and give them instructions on how to access it. The second method is on the dashboard management page under Domain Access. By adding a domain, this will allow anyone with an email address in that domain to access your dashboard. For example, if you granted access to the justice.gov.uk domain, anybody with a justice email address would be able to access your dashboard through the dashboard service. A notification email will not be sent when granting access through a domain and you may wish to email the dashboard link to users.

## Accessing shared dashboards

To access registered dashboards, go to the [dashboard service] page and log into the service using your justice identity. Once there, you will see a list of dashboards that you have access to. To view a dashboard, click the view dashboard link of the dashboard you want to see.

<!-- External links -->

[QuickSight UI within Control Panel]: https://controlpanel.services.analytical-platform.service.justice.gov.uk/quicksight/
[dashboards page]: https://controlpanel.services.analytical-platform.service.justice.gov.uk/dashboards/
[dashboard service]: https://dashboards.analytical-platform.service.justice.gov.uk/dashboards/
