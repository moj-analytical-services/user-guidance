# Dash apps

If you are developing a web application using Jupyter you will probably want to
preview that web app before you deploy it. The Analytical Platform provides a special set of
endpoints under `/_tunnel_/<portNumber>/` that route to exposed HTTP ports on
the localhost. There are a few things you need to keep in mind:

* `<portNumber>` can only be one from a limited range. By default, you can only route
  to ports 8050 and 4040--4050 inclusive. You should make your web app listen on
  one of those.
* The `/_tunnel_/<portNumber>/` endpoint will only tunnel to services bound to a
  non--public IP address. By default, many web frameworks bind to host `127.0.0.1`.
  You will need to change this to `0.0.0.0` or the tunnel won't work. This is to
  prevent inadvertently exposing webapps to the tunnel.

## Running Plotly [Dash] apps

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

app = dash.Dash('app', server=server, url_base_pathname='/_tunnel_/8050/')

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

if __name__ == '__main__':
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

```sh
yovyan@jupyter-lab-r4vi-jupyter-7cb4bb58cf-6hngf:~$ python3 app.py
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8050/ (Press CTRL+C to quit)
```

### Access via `_tunnel_` URL

Copy your `jupyter` URL and append `/_tunnel_/8050/` to access your running Dash
app. If your `jupyter` URL is `https://r4vi-jupyter-lab.tools.alpha.mojanalytics.xyz/lab?`,
then your Dash app will be available at
`https://r4vi-jupyter-lab.tools.alpha.mojanalytics.xyz/_tunnel_/8050/`.

![](images/dash/visit_url.gif)

#### Who can access this `/_tunnel_/` URL?

Only you can access the URL and it can not be shared with other members of your
team. It is intended for testing while developing an application.

## Troubleshooting

This feature has been introduced in the v0.6.5 jupyer-lab helm chart. If following
this guide doesn't work for you it is likely that you're on an older version.
Contact us on the `#analytical_platform` [Slack channel],
alternatively, contact us by [email](mailto:analytical_platform@digital.justice.gov.uk)
to request an upgrade.

[dash]: https://dash.plot.ly/
[Slack channel]: (https://asdslack.slack.com/messages/anaytical_platform/
