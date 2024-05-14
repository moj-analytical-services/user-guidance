# Ollama

## How to use Ollama on Visual Studio Code

1. Start a terminal session and then execute:

`ollama serve`

![ollama serve](/images/ollama/ollama-serve.png)


This will start the Ollama service, in the foreground.

2. Start a second terminal session (in Visual Studio Code click the `+` symbol at the top right of the terminal) and then execute:

`ollama run llama3`

![ollama run](/images/ollama/ollama-run.png)

The first time you execute a run it will download the model which may take some time. Subsequent runs will be much faster as they do not need to re-download the model. You can view the models which you have downloaded with the `ollama list` command.

Now you can interact with the model in the terminal in a chat-like fashion as demonstrated below:

![ollama query](/images/ollama/ollama-query.png)

For a list of all models view the [Ollama Library](https://ollama.com/library)
