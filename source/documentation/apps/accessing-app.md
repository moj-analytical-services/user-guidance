## Accessing your deployed app

### Apps hosted on Cloud Platform

Your deployed app can be accessed at two URLs:

- `prod` is at: `repository-name.apps.live.cloud-platform.service.justice.gov.uk`
- `dev` is at: `repository-name-dev.apps.live.cloud-platform.service.justice.gov.uk`

(where `repository-name` is the name of the relevant GitHub repository)

By default, the user list on  `dev`  empty and you will need to add any users requiring access via control panel.

### Authenticating to your app

For the dashboard apps using passwordless flow (email login), when accessing an app, you can choose whether to sign in using a one-time passcode (default) or an email magic link.
To sign in with an email magic link, add `/login?method=link` to the end of the app's URL, for example,
`https://apps.live.cloud-platform.service.justice.gov.uk/login?method=code`.

### **Troubleshooting app sign-in**

#### "That email address is not authorized for this app (or possibly another error occurred)" error, after entering email address

1. Check that the user is authorised to access the app:
   1. Log in to the [control panel](https://controlpanel.services.analytical-platform.service.justice.gov.uk/).
   2. Navigate to the app detail page.
   3. Choose the right deployment environment (dev/prod)
   4. Check if the user's email address is listed under 'App customers'.
   5. If it is not, refer them to the app owner to obtain access.
2. Check that the user is using the correct email address – there is sometimes confusion between @justice and @digital.justice email addresses.

#### "Access denied" error, having entered email address and copied the one-time passcode into the login page

Please follow the same steps above to check whether the user is in the customer list of the app.

#### "IP x.x.x.x is not whitelisted"

Check that the user is trying to access the app from one of the trusted networks listed on app's app-detail from Control Panel

The app admin can modify the IP_Ranges on the app's app-detail detail page. 

#### Other troubleshooting tips

- Check that they are trying to access the app using a URL beginning with `https://` not `http://`.
- Look for similar issues log in the [`data-platform-support` repository](https://github.com/ministryofjustice/data-platform-support/issues).
- Try asking the user to clear their cookies by visiting https://alpha-analytics-moj.eu.auth0.com/logout and try again.

In addition the AP team can:

- Check the Auth0 logs for the app in [Kibana](#kibana)
- Check the Auth0 logs in the [Auth0 console](https://manage.auth0.com)