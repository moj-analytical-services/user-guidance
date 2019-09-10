# View the logs for an app

All logs from deployed apps can be viewed in [Kibana](https://kibana.services.alpha.mojanalytics.xyz).

To view all app logs:

1.  Select __Discover__ from the left sidebar.
2.  Select __Open__ from the menu bar.
3.  Select __Application logs (alpha)__ from the saved searches.

To view the logs for a specific app:

1.  Select __Add a filter__.
2.  Select __app_name__ as the field.
3.  Select __is__ as the operator.
4.  Insert the app name followed by '-webapp' as the value.
5.  Select __Save__.

If you are an app admin, you can also:

1.  Go to the Analytical Platform [control panel](https://controlpanel.services.alpha.mojanalytics.xyz).
2.  Select the __Webapps__ tab.
3.  Select the name of the app you want to view the logs of or select __Manage app__.
4.  Select __View logs in Kibana__.

This will load a preconfigured query in Kibana.

Log messages are displayed in the __message__ column.

By default, Kibana only shows logs for the last 15 minutes. If no logs are available for that time range, you will receive the warning 'No results match your search criteria'.

To change the time range, select the clock icon in the menu bar. There are several presets or you can define a custom time range.

Kibana also has experimental autocomplete and simple syntax tools that you can use to build custom searches. To enable these features, select __Options___ from within the search bar, then toggle __Turn on query features__.