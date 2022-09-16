# Scheduling
There are three options for scheduling table updates: 'daily', 'weekly', and 'monthly'. The monthly schedule runs on the first Sunday of every month and the weekly schedule runs every Sunday. All schedules run at 3AM. To select a schedule for your table, add the 'tags' property to your model's configuration file, like this:
```
version: 2

models:
  - name: <your_model_name>
    config:
      tags: daily
```