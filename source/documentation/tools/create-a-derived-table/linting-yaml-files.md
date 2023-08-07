# Linting YAML files

Linting is the automated checking of your code for programmatic and stylistic errors performed by running a 'linter'. The linter will analyse your code and output error messages to the terminal. Linters should be run from the root of the repository, i.e., the `create-a-derived-table` directory.

<br />

YAML demands 2 spaces (not 1 tab) for each indentation, it can be frustrating, if you get spaces and tabs muddled (they are not always equivalent) as you can get a lint error but not be able to see it easily. We recommend setting up vertical guidlines in RStudio to keep track of your indentations, see above [Show indent guides in RStudio](#show-indent-guides-in-rstudio), and to use the spacebar to create 2 spaces for indentation.

To lint a single YAML file, run:

```
yamllint .../path/to/yaml/file.yaml
```

Or a whole directory of YAML files by running:

```
yamllint .../path/to/yaml/directory/
```

## Folded style `>`

Use `>` to split code over multiple lines; each newline is interpreted as a space (unless the newline is on an empty line or after a differently indented line) hence

```
  description: >
    the quick brown fox
    jumped over the lazy dog
```

is interpreted the same as 

```
  description: the quick brown fox jumped over the lazy dog
```

## Literal style `|`

Use `|` (pipe) to keep newlines, for instance when running subsequent commands in a GitHub action workflow

```
  run: |
    python -m pip install --upgrade pip
    pip install yamllint 
```
