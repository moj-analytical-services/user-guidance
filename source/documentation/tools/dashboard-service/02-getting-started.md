# Getting Started

## Prerequisites to registering dashboards

You will need:

* access to the Analytical Platform Control Panel
* QuickSight author permissions for your account in the Analytical Platform Control Panel
* a dashboard you created with QuickSight


## Register dashboard in Analytical Platform Control Panel

1. Go to the [QuickSight UI within Control Panel] and select the *Dashboards* tab on the QuickSight UI. 
1. Right click on the dashboard you want to share and select *Copy link*. 
1. Go to the [Dashboards page] on Control Panel and select the *Register a dashboard* button. 
1. Enter a dashboard name which is unique and descriptive. 
1. Paste the dashboard link you copied from step 2 into the Dashboard URL form. The link should look similar to this example: `https://eu-west-2.quicksight.aws.amazon.com/sn/dashboards/<unique-code-here>`. 
1. Select the *Register dashboard* button. 

If your dashboard has been registered successfully, you will be taken to the dashboard management screen.

## Managing dashboard access

You can find the dashboard management screen by selecting a dashboard on the *Your Dashboards* overview. The management screen provides a link to the viewable dashboard. Dashboard admins can also find other management functions here, such as granting admin access and removing the dashboard from the Analytical Platform Control Panel. 

You can add dashboard viewers by giving access to an individual or to an email domain.

### Add an individual viewer

You can give view access to an individual by using their email address. They do not need to be an Analytical Platform Control Platform user. To do this: 
1. From the *Your Dashboards* overview, select *Manage users*.
1. Enter their email in the box above *Add user*. 
1. Select *Add user*. 

The viewer will be sent an email to notify them you've shared the dashboard with them and give instructions on how to access it. 

### Add view access for an email domain

You can also give view access for an email domain. Adding a domain allows anyone with an email address in that domain to access your dashboard. For example, if you grant access to the `justice.gov.uk` domain, anybody with a Ministry of Justice email address could access your dashboard through the dashboard service. 

To do this:
1. From the *Your Dashboards* overview, select the dashboard name. 
1. Under the *Domain access* section, select the domain. If the domain you want to add is not listed, [contact support](/./support.html). 
1. Select *Grant access*. 

The Dashboard Service does not send a notification email to users when you add view access for an email domain, so you'll need to manually send the dashboard link to users.

## Accessing shared dashboards

To access registered dashboards, go to the [dashboard service] page and log into the service using your justice identity. Once there, you will see a list of dashboards that you have access to. To view a dashboard, click the view dashboard link of the dashboard you want to see.

<!-- External links -->

[QuickSight UI within Control Panel]: https://controlpanel.services.analytical-platform.service.justice.gov.uk/quicksight/
[dashboards page]: https://controlpanel.services.analytical-platform.service.justice.gov.uk/dashboards/
[dashboard service]: https://dashboards.analytical-platform.service.justice.gov.uk/dashboards/
