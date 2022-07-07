# Running your app within Jupyter

It is likely that you will want to preview and test your app before you deploy it.
However because of security implications we cannot allow arbritrary ports to be opened.
Instead, you have to use the `/\_tunnel\_/` endpoint we have provided.

Currently the only supported port is 8050, so the url of your app will be `/\_tunnel\_/8050/`

A few things to bear in mind
- You can only run one app on the `8050` port at a time.
- Your app, by default will only respond to `127.0.0.1` which will not work with the tunnel. You should make sure it responds to `0.0.0.0` instead.
- The base URL of your app will need to be set (while in Jupyter development) to be `/\_tunnel\_/8050/` (see the dash walkthrough below for an example)
- Only you will be able to access this url.

_In the old system there was support for a range of ports, so it is possible you may not be using 8050 in existing code. Please update your code accordingly._

## Running Plotly [Dash] apps

See [Coffee and Coding session on Building webapps in Python using Plotly Dash](https://github.com/moj-analytical-services/Coffee-and-Coding/tree/master/2020-04-14%20Python%20webapps%20using%20Plotly%20Dash)

### Install dependencies

In the terminal, install the Dash dependencies:

```bash
pip install --user dash==0.39.0  # The core dash backend
pip install --user dash-daq==0.1.0  # DAQ components (newly open-sourced!)
```

The demo code in this document is known to work with these versions but you can
install any version you like for your own code.

![](images/dash/dash_install_deps.gif)

If you are planning on turning this into a project, you'll need to manage your
dependencies by adding these to either `requirements.txt` and `pip` or
`environment.yaml` and `conda`.

### Example code

Save the Dash hello world app to a new python file called `app.py`:

N.B. You will need to have pandas installed for this code to work.

```python
import dash
from dash.dependencies import Input, Output
import dash_core_components as dcc
import dash_html_components as html

import flask
import pandas as pd
import time
import os

server = flask.Flask('app')
server.secret_key = os.environ.get('secret_key', 'secret')

df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/hello-world-stock.csv')

app = dash.Dash('app', server=server, url_base_pathname='/\_tunnel\_/8050/')

app.scripts.config.serve_locally = False
dcc._js_dist[0]['external_url'] = 'https://cdn.plot.ly/plotly-basic-latest.min.js'

app.layout = html.Div([
    html.H1('Stock Tickers'),
    dcc.Dropdown(
        id='my-dropdown',
        options=[
            {'label': 'Tesla', 'value': 'TSLA'},
            {'label': 'Apple', 'value': 'AAPL'},
            {'label': 'Coke', 'value': 'COKE'}
        ],
        value='TSLA'
    ),
    dcc.Graph(id='my-graph')
], className="container")

@app.callback(Output('my-graph', 'figure'),
              [Input('my-dropdown', 'value')])

def update_graph(selected_dropdown_value):
    dff = df[df['Stock'] == selected_dropdown_value]
    return {
        'data': [{
            'x': dff.Date,
            'y': dff.Close,
            'line': {
                'width': 3,
                'shape': 'spline'
            }
        }],
        'layout': {
            'margin': {
                'l': 30,
                'r': 20,
                'b': 30,
                't': 20
            }
        }
    }

if `__name__` == '\_\_main\_\_':
    app.run_server(host='0.0.0.0')

```

There are two important things to note here, where this code differs from the
Plotly Dash example:

1. The `Dash` class must be instantiated with a `url_base_pathname`. This should
   always be `/_tunnel_/8050/` e.g.
   `app = dash.Dash('app', server=server, url_base_pathname='/_tunnel_/8050/')`.

2. When you run the server, it must be bound to `0.0.0.0`, e.g., `app.run_server(host='0.0.0.0')`.

![](images/dash/save_example.gif)

### Run server from the terminal

```
$ python3 app.py
 \* Serving Flask app "app" (lazy loading)
 \* Environment: production
    WARNING: Do not use the development server in a production environment.
    Use a production WSGI server instead.
 \* Debug mode: off
 \* Running on http://0.0.0.0:8050/ (Press CTRL+C to quit)
```

### Access via `\_tunnel\_` URL

Copy your `jupyter` URL and append `/\_tunnel\_/8050/` to access your running Dash
app. If your `jupyter` URL is `https://r4vi-jupyter-lab.tools.alpha.mojanalytics.xyz/lab?`,
then your Dash app will be available at
`https://r4vi-jupyter-lab.tools.alpha.mojanalytics.xyz/\_tunnel\_/8050/`.

![](images/dash/visit_url.gif)

#### Who can access the `\_tunnel\_` URL?

Only you can access the URL and it can not be shared with other members of your
team. It is intended for testing while developing an application.

## Troubleshooting

This feature has been introduced in the v0.6.5 jupyer-lab helm chart. If following
this guide doesn't work for you it is likely that you're on an older version.
Contact us on the `#analytical-platform` [Slack channel],
alternatively, contact us by [email](mailto:analytical_platform@digital.justice.gov.uk)
to request an upgrade.

[dash]: https://dash.plot.ly/
[Slack channel]: https://asdslack.slack.com/messages/anaytical_platform/
