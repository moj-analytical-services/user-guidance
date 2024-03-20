# Ollama

## Starting Ollama in Visual Studio Code

* start a terminal session and then execute:

      `ollama serve`

This will start the Ollama service, in the foreground

* Start a  second terminal session and then execute:

      `ollama run model-name`

The first time you execute a run it will download the model which may take some time. Subsequent runs will be much faster as they do not need to re-download the model.

Replace 'model-name' with the name of a model that you wish to run, llama2 is a compact model and a good starting point.

See below for additional models.

## Ollama Models

* [Model Library](https://ollama.com/library)
