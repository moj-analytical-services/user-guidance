# Linting SQL files

Linting is the automated checking of your code for programmatic and stylistic errors performed by running a 'linter'. The linter will analyse your code and output error messages to the terminal. Linters should be run from the root of the repository, i.e., the `create-a-derived-table` directory.
<br />


To lint a single SQL file, run:

```
sqlfluff lint .../path/to/sql/file.sql
```

Or a whole directory of SQL files by running:

```
sqlfluff lint .../path/to/sql/directory/
```

SQLFluff is a formatter as well as a linter. That means you can use it to edit your SQL files to match the linting rules. To format SQL files using SQLFluff replace `lint` in the commands above with `fix`.

## .sqlfluffignore

The `.sqlfluffignore` file (found in the root of the repository) can be used to list files for SQLFluff to exclude from linting. This is **only** to be used if files continually fail linting, despite best efforts. To date this has only applied to complex macros. The default Jinja templater used by SQLFluff simply cannot deal with complex macros. The dbt templater should solve this issue, and we intend to trial it in the future.
