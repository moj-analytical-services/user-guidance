# Work with git on the command line

The command line is the text interface to your Analytical Platform tools. When googling, it may also be referred to as the shell, terminal, or console (and perhaps other names). In Jupyter, you can get the command line by selecting 'Terminal' from the launcher screen (the + button in the top left of JupyterLab). You can also use all these commands in RStudio by going to Tools -> Terminal -> New Terminal. In Visual Studio Code, it's Terminal -> New Terminal.

Once you are comfortable using the Terminal (in RStudio, Visual Studio Code or Jupyter) you can run all Git commands from the command line. If you are quite new to the command line, there are a few commands you may find useful to know, in addition to the git commands described later in this section:

- `mkdir`: create a new directory/folder
- `cd`: change directory
- `touch`: create a file
- `ls`: list files

For example, to create a new python script, `main.py` in a new folder, `scripts` you would do:

```bash
> mkdir scripts
> cd scripts
> touch main.py
> ls
main.py
```

You can go back a directory using `cd ..` and back to your home directory with `cd ~`. Some other commands you may wish to use are:

- `rm <filename>`: delete file(s)
- `cp <filename> <new_location>`: copy a file from current location to a new one
- `mv <filename> <new_location>`: move a file from current location to a new one

It is a good idea to avoid the use of whitespace in file, folder and repository names, but if you have included a space you can escape it using a backslash (e.g. `cd directory\ with\ spaces`). You can also hit the tab key to autocomplete if your file or directory already exists.

### Make a copy of a GitHub project ('cloning')

Use your browser to go to the repository you want to copy. Click on 'Code' and select the 'SSH' tab. You'll see a link. Click on the button to its right (the overlapping rectangles) to copy that link.

![A button labelled 'Code' with a dropdown showing the cloning interface. The 'SSH' tab is active, and shows the first part of an SSH link. To the right of the link is a grey button with two overlapping squares.](images/github/github_clone.png "GitHub's cloning interface")

In the command line, navigate to the directory where you want to keep your copy of the project.

Type `git clone` followed by the link you've just copied from GitHub. So to clone this guidance enter: `git clone git@github.com:moj-analytical-services/user-guidance.git`

### Add files to your next commit ('staging')

Add changed files to your next commit with: `git add <filename1> <filename2>`

This is known as 'staging' the files.

You can also type `git add .` to add _all_ changed files to your next commit. Before you do this, use `git status` to check which files will be added.

### Commit files

'Commit' the files you've added: `git commit`. After calling this command, you need to provide a commit message. R Studio provides a popup. Jupyter will start an editor where you write the message, before saving and exiting it.

To commit and add a message in one command, use `git commit -m "Your commit message"`. This is useful if you're only including a short commit message.

### Sync work with GitHub ('pushing')

'Push' your commits to GitHub: `git push origin <branch_name>`.

The default branch name is `main`. If you're pushing to this your command would be `git push origin main`.
