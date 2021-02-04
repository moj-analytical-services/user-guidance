# Using GitHub with the platform

Code written on the Analytical Platform should be stored in a git repository on GitHub. This includes R, Python and notebooks. Be careful NOT to include data or [secrets](#secrets-and-passwords) on GitHub. (Data goes in [S3 buckets](../data.html) and secrets, such as passwords or API keys, should be in Parameter Store.)

**Note** Before you can use Github with R Studio or Jupyter, you need to connect them together by creating an 'ssh key'. Full guidance is [here](#setup-github-keys-to-access-it-from-r-studio-and-jupyter).

Github enables you to collaborate with colleagues on code and share you work with them. It puts your code in a centralised, searchable place. It enables easier and more robust approaches to quality assurance, and it enables you to version control your work. More information about the benefits of Github can be found [here](../annexes.html#what-are-the-benefits-of-github-and-why-do-we-recommend-it).

If you are new to Git and Github, it is worth clarifying the difference between Git and Github. Git is the software that looks after the version control of code, whereas Github is the website on which you publish and share your version controlled code. In practice this means you use Git to track versions of your code, and then submit those changes to Github.

Follow the step-by-step guide [of how to create a GitHub project repo](#creating-your-project-repo-on-github), followed by how to sync with it in R Studio and Jupyter.

Note: If any of the animated gifs below do not display correctly, try a different web browser e.g. Microsoft Edge, which is installed on your DOM1 machine.

## Setup GitHub keys to access it from R Studio and Jupyter

To configure Git and GitHub for the Analytical Platform, you must complete the following steps:

1. [Create an SSH key](#create-an-ssh-key).
2. [Add the SSH key to GitHub](#add-the-ssh-key-to-github).
3. [Configure your username and email in Git on the Analytical Platform](#configure-your-username-and-email-in-git-on-the-analytical-platform).

### Create an SSH key

You can create an SSH key in RStudio or JupyterLab. We recommend that you use RStudio.

#### RStudio

To create an SSH key in RStudio, follow the steps below:

1. Open RStudio from the Analytical Platform control panel.
2. In the menu bar, select __Tools__ then __Global Options...__
3. In the options window, select __Git/SVN__ in the navigation menu.
4. Select __Create RSA key...__
5. Select __Create__.
6. Select __Close__ when the information window appears.
7. Select __View public key__.
8. Copy the SSH key to the clipboard by pressing Ctrl+C on Windows or ⌘C on Mac.

#### JupyterLab

To create an SSH key in JupyterLab, follow the steps below:

1. Open JupyerLab from the Analytical Platform control panel.
2. Select the __+__ icon in the file browser to open a new Launcher tab.
3. Select __Terminal__ from the 'Other' section.
4. Create an SSH key by running:

    ```bash
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
   Here, you should substitute the email address you used to sign up to GitHub.
5. When prompted to enter a file in which to save the key, press Enter to accept the default location.
6. When prompted to enter a passphrase, press Enter to not set a passphrase.
7. View the SSH key by running:

    ```bash
    cat /home/jovyan/.ssh/id_rsa.pub
    ```
8. Select the SSH key and copy it to the clipboard by pressing Ctrl+C on windows or ⌘C on Mac.

### Add the SSH key to GitHub

To add the SSH key to GitHub, you should follow the guidance [here](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account).

### Configure you username and email in Git on the Analytical Platform

To configure your username and email in Git on the Analytical Platform using RStudio or JupyterLab, follow the steps below:

1. Open a new terminal:
    * In RStudio, select __Tools__ in the menu bar and then __Shell...__
    * In JupyterLap, select the __+__ icon in the file browser and then select __Terminal__ from the __Other__ section in the new Launcher tab.
2. Configure your username by running:

     ```bash
     git config --global user.name 'Your Name'
     ```
    Here, you should substitute your GitHub username.
3. Configure your email address by runnung:

     ```bash
     git config --global user.email 'your_email@example.com'
     ```
    Here, you should substitute the email address you used to sign up to GitHub.

See [using GitHub with platform](/github.html).

## Creating your project repo on GitHub

### Step 1 - Create a new project repo in the moj-analytical-services Github page

A GitHub 'repo' (short for 'repository') is conceptually similar to setting up a project folder on the DOM1 shared drive to save your work, and share it with others. The files in this Github repo represent the definitive version of the project. Everyone who works on the project makes contributions to this definitive version from their personal versions.

Note that if you want to contribute to an existing project, you can skip this step.

In your web browser go to `github.com` and make sure you're signed in.

Once signed in, go to the MoJ Analytical Services [homepage](https://github.com/moj-analytical-services/).

Then follow the steps in this gif to create a new repository.

![create repo](images/github/create_repo.gif)

Notes:

* Leave your repository 'private' for now - the default setting. In the next step you will add access to colleagues and possibly make it 'public' (on the internet).

* Make sure the owner is set to 'moj-analytical-services'. This is the default setting, so long as you have clicked on 'New' from the MoJ Analytical Services [homepage](https://github.com/moj-analytical-services).

### Step 2:  Navigate to your new Repository on GitHub to decide who can see your code

Try to be as open as possible about who can view your code. Go to the Settings section of your repository (top right of the repository's homepage) and then click on Collaborators & Teams on the left hand side panel. From there you can then decide on one of the four options below. They start with the most private all the way to completely public code:

1. PRIVATE: Leave the default setting of your repository so it's only visible to you as the creator.
2. YOUR TEAM: Can the code be shared within your team? If so, add your team to the repository.
3. ALL PLATFORM USERS: Can the code be shared with all Analytical Platform users?  If so, add the ‘everyone’ team to the repository.
4. PUBLIC: Can the code be public?  If so, make it a public repository. To do this, click on the 'Options' section of the Settings, then scroll down to the 'Danger Zone' area that has a 'Make public' button.

We find that for most of our work, there’s no reason not to add the ‘+everyone’ team of all Analytical Platform users with read access to the code. This is possible as sensitive datasets are not stored in Github. By making code more open (either internally or publicly), users can start to get much more value of out the extremely powerful code search in GitHub.

Warning: Repos should contain **no passwords/secrets and no data** (apart from small reference tables) - this is particulary important for public repos, but applies to private ones too. And remember that GitHub shows the *full history* of files and changes in your repo, so removing these things requires special effort.

For more info, see [choosing public or private repos](#choosing-public-or-private-repos).

Notes:

* you can add one or more teams to a repository, each with different permissions. For example, your team could have write privileges, but the ‘everyone’ team could be read only.

## R Studio

Here's how you can sync with your new GitHub repo in R Studio.

### Step 1:  Navigate to your platform R Studio and make a copy of the Github project in your R Studio

In this step, we create a copy of the definitive GitHub project in your personal R Studio workspace. This means you have a version of the project which you can work on and change.

Follow the steps in this gif:

![clone repo](images/github/clone_repo.gif)

Notes:

* When you copy the link to the repo from Github, ensure you use the ssh link, which starts `git@github.com` as opposed to the https one, which starts `https://github.com/`.

### Step 2: Edit your files, track them using Git, and sync ('push') changes to Github

Edit your files as usual using R Studio.

Once you're happy with your changes, Git enables you to create a 'commit'. Each git commit creates a snapshot of your personal files on the Platform. You can can always undo changes to your work by reverting back to any of the snapshots.  This 'snapshotting' ability is why git is a 'verson control' system.

In the following gif, we demonstrate changing a single file, staging the changes, and committing them.  In reality, each commit would typically include changes to a number of different files, rather than the single file shown in the gif.

![stage changes](images/github/make_changes_and_stage.gif)

Notes:

* 'committing' does **not** sync your changes with github.com.  It just creates a snapshot of your personal files in your platform disk.
* Git will only become aware of changes you've made after you've saved the file as shown in the gif.  Unsaved changes are signified when the filename in the code editor tab is red with an asterisk.

### Step 3: Sync ('push') your work with github.com

In R Studio, click the 'Push' button (the green up arrow).  This will send any change you have committed to the definitive version of the project on Github. You can then navigate to the project on Github in your web browser and you should see the changes.

![push to github](images/github/push_to_github.gif)

Notes:

* After pushing, make sure you refresh the GitHub page in your web browser to see changes.

**That's it!  If you're working on a personal project, and are not collaborating with others, those three basic steps will allow you to apply version control to your work with Github**

## Jupyter

There is not the same integration. Use the command-line - see below.

## Command-line

Once you are comfortable using the Terminal (in either R Studio or Jupyter) you can do steps 3 and 4 using the following git commands:

* Select the files that you want to commit: `git add <filename1> <filename2>` ((This will 'add' them to git's 'index' / 'staging' area)
* 'Commit' the files you have added: `git commit`. After calling this command, you need to provide a commit message: in R Studio it provides a popup; in Jupyter it'll start an editor where you write the message, before saving and exiting it.
* 'Push' your commits to GitHub: `git push origin <branch_name>`. Most likely your branch name will be `master` which is the default. So your code would be `git push origin master`.

## Working on a branch

One of the most useful aspects of git is 'branching'.  This involves a few extra steps, but it enables some really important benefits:

* Allows you to separate out work in progress from completed work.  This means there is always a single 'latest' definitive working version of the code, that everyone agrees is the 'master copy'.

* Enables you and collaborators to work on the same project and files concurrently, resolving conflicts if you edit the same parts of the same files.

* Enables you to coordinate work on several new features or bugs at once, keeping track of how the code has changed and why, and whether it's been quality assured.

* Creates intutitive, tagged 'undo points' which allow you to revert back to previous version of the project e.g. we may wish to revert to the exact code that was tagged 'model run 2015Q1'.

We therefore *highly recommend* using branches.  (Up until now, we've been working on a single branch called 'master'.)

### Step 1 (optional):  Create an Issue in github that describes the piece of work you're about to do (the purpose of the branch)

Github 'issues' are a central place to maintain a 'to do' list for a project, and to discuss them with your team.  'Issues' can be bug fixes (such as 'fix divide by zero errors in output tables'), or features (e.g. 'add a percentage change column to output table'), or anything else you want.

By using issues, you can keep track of who is working on what.  If you use issues, you automatically preserve a record of _why_ changes were made to code.  So you can see when a line of code was last changed, and which issue it related to, and who wrote it.

![](images/github/create_issue.gif)

### Step 2:  Create a new branch in R Studio and tell Github about its existence

Create a branch with a name of your choosing.  The branch is essentially a label for the segment of work you're doing.  If you're working on an issue, it often makes sense to name the branch after the issue.

To create a branch, you need to enter the following two commands into the shell:

* `git checkout -b my_branch_name`.  Substitute `my_branch_name` for a name of your choosing. This command simultaneously creates the branch and switches to it, so you are immediately working on it.
* `git push -u origin my_branch_name`.  This tells github.com about the existence of the new branch.

![](images/github/checkout_branch.gif)

### Step 3:  Make some changes to address the Github issue, and push (sync) them with Github

Make changes to the code, commit them, and push them to Github.

![](images/github/make_changes_and_push.gif)

### Step 4: View changes on Github and create pull request

You can now view the changes in Github.

Github recognises that you've synced some code on a branch, and asks you whether you want to merge these changes onto the main 'master' branch.

You merge the changes using something called a 'pull request'.  A 'pull request' is a set of suggested changes to your project.  You can merge these changes in yourself, or you can ask another collaborator to review the changes.

One way of using this process is for quality assurance. For instance, a team may agree that each pull request must be reviewed by a second team member before it is merged.  The code on the main 'master' branch is then considered to be quality assured at all times. Pull requests also allow you and others working on the project to leave comments and feedback about the code. You can also leave comments that reference issues on the issue log (by writing `#` followed by the issue number). For example you might comment saying "This pull request now fixes issue #102 and completes task #103".

![](images/github/view_on_github_and_pr.gif)

### Step 5:  Sync the changes you made on github.com with your local platform

When you merged the pull request, you made changes to your files on Github.  Your personal version of the project in your R Studio hasn't changed, and is unaware of these changes.

The final step is therefore to switch back to the 'master' branch in R Studio, and 'Pull' the code.  'Pulling' makes R Studio check for changes on Github, and update your local files to incorporate any changes.

![](images/github/pull.gif)

## Git training resources

If you are new to git and you want to learn more, we recommend that you complete the basic tutorial [available here](https://try.github.io/levels/1/challenges/1).

The slides from from the ASD git training are [available here (dom1 access only)](file://dom1.infra.int/data/hq/102PF/Shared/Group_LCDSHD2/Analytical Services/ASD Training/Training materials/git/git_training_slides.pdf)

* [Using Github with R](http://happygitwithr.com/)
* [Introductory interactive tutorial](https://try.github.io/levels/1/challenges/1).
* Quickstart guide and cheatsheet [here](http://rogerdudler.github.io/git-guide/) and in pdf format  [here](http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf).
* More in depth materials:
  * [Learn Git branching](http://learngitbranching.js.org/)
  * [Git from the inside out](https://maryrosecook.com/blog/post/git-from-the-inside-out)

## Safety barriers

The platform has configured simple "safety barriers" to reduce risk of accidentally exposing sensitive data on GitHub. For example it stops you committing a CSV file, because in most circumstances you should not put data into GitHub - it should be kept in an S3 bucket where it can be shared with authorized people (rather than the whole of DASD). This is the case even for internal or private repositories, because it doesn't take much to make these public in the future. These rules can be overridden if that makes more sense.

<div style="height:0px;font-size:0px;">&nbsp;</div>
| What | How it's configured | Reasoning | How to override |
|------|-------------------------------|-----------|-----------------|
| Data files (.csv, .xls etc) & zip files | ~/.gitignore | You should not put data into GitHub - it should be kept in an S3 bucket where it can be shared with authorized people. | When you add the file: `git add -f <filename>` |
| Zip files | ~/.gitignore | It's better to unpack these files and commit the raw source. You can't keep track of diffs of individual files if you keep them bundled up. There might be a data file lurking in the zip, which isn't checked if it is bundled like this. Note: git has its own built in compression methods. | When you add the file: `git add -f <filename>` |
| Large files (>5 Mb) | ~/.git-templates/hooks/pre-commit | Likely to be data | When you commit: `git commit --no-verify` |
| Notebook output stripping | ~/.git-templates/hooks/pre-commit | Jupyter Notebook output often contains data | When you commit: `ENABLE_NBSTRIPOUT=false; git commit` |
| Pushing to non-official GitHub organizations | ~/.git-templates/hooks/pre-push | It would be outside MoJ control - not normally allowed. | When you push: `git push -f <remote> <branch>` |
<div style="height:0px;font-size:0px;">&nbsp;</div>

## Private R packages on GitHub: PAT authentication

### Public, internal and private repositories

GitHub repositories can public, internal or private.

In any case, repos should contain **no passwords/secrets and no data** (apart from small reference tables) - this is particulary important for public repos, but applies to internal and private ones too. And remember that GitHub shows the *full history* of files and changes in your repo, so removing these things requires special effort.

A *public repo* is visible to the world. Again, it is particulary important these contain no passwords/secrets or data.

An *internal repo* is internal to the `moj-analytical-services` GitHub organisation and not visible to the outside world. The repo's Owners and Admins can control which people / teams can see the repo on GitHub by going to **_Settings_ > _Collaborators & Teams_** and adding teams to read/write/admin access groups. ('Internal' is equivalent to 'private' but adding the group `everyone` with read permission.)

A *Private repo* is visible only to the users/team specifically added to the repo by the repo's owners (or organization admins). Configure this here: **_Settings_ > _Collaborators & Teams_**

#### Choosing public, internal or private repos

As an organization we aspire to use *public* repos by default.
There are a host of [benefits of coding in the open](https://gds.blog.gov.uk/2017/09/04/the-benefits-of-coding-in-the-open/).
With research and analysis it builds trust and transparency with the public, and reproducible methods allows others to test and build on your work.

However, it requires more discipline to avoid mistakes like slipping secrets and sensitive information, so tends to require more experienced developers and care over any political sensitivities related to the topics your analysis covers: open-source coding is continuous and worldwide publishing.

As a result, sometime *internal* and *private* repos are necessary, for example when it reveals a sensitive policy change that is not yet announced.

In this case, an *internal* repo has huge benefits over a *private repo* because it gives the code visibility amongst internal users:

* it is good for learning and sharing methods
* it is good for collaboration
* it makes your code [searchable](../github.html#other-tips-and-tricks).

Choosing *internal* still keeps code that shouldn't be in the public domain (e.g. unpublished commentary on a `.Rmd` file) hidden from anyone _outside_ the organisation.

*Private* repos are unlikely to be appropriate for MoJ work, but are available if necessary.

If in doubt, discuss with your manager and/or the AP team.

### Private R packages for reproducible analysis

When a repo (e.g. an R package) is internal or private you need to use a Personal Access Token (PAT) to access it from R. This token acts much like a password to your personal GitHub account. If you don't use the token then you get: `Error: HTTP error 404. Not Found`. (GitHub doesn't even acknowledge the existence of the repo, to avoid speculative searching for private repositories.)

### Generating a PAT

You can get a PAT from your GitHub user profile. A user can generate a number of tokens that grant various different levels of permission.

**The PAT must be kept secret and protected like a password. It must not be shared with other users. Only generate your PAT to have the minimum permissions needed for the job.**

To generate your PAT for reading private repos in R:

  1. Navigate to the [GitHub personal access tokens page](https://github.com/settings/tokens/new?scopes=repo&description=R:GITHUB_PAT). You can also access this from any other GitHub page by selecting your user icon, then **Settings**, then **Developer settings**, then **Personal access tokens**.
  
  2. Select **_Generate new token_** and select the **scope** of access you want to grant using this token.
  
     **IMPORTANT: Only select the first group: 'repo'. Granting other rights can be dangerous if your PAT falls into the wrong hands, allowing someone else to irrevocably delete your repos, read and change your user profile settings, or even access billing information. If you need to to use other rights, consult with the AP team for advice on security arrangements to protect the PAT.**
  !['New PAT' page](images/pat/pat-scope.png)
  
  3. Copy your PAT to the clipboard. It is now ready to paste directly into the place it will be used, which is likely to be your R or Python environment - see the next section.
  
     Note: Although GitHub won't show this PAT again, DON'T save it elsewhere. If you need a PAT in the future (eg you wiped your .rstudio folder) simply create a new PAT, and revoke the previous one. Storing secrets unnecessarily, particularly in plain text, is a security hazard.
  ![The page displaying the new PAT](images/pat/pat-copy.png)

### Using a PAT to authenticate in R/RStudio

You should store your PAT in a special R file, called `.Renviron` in your home directory on the Analytical Platform. This file gets run when you start R, putting the PAT into the system environment variable `GITHUB_PAT`. This is where common R packages (for example, remotes, devtools and renv) will look for it.

Set this up by running this in your R console (you only need to run it once; do **not** save this line in any file in any repo) and substitute your own PAT Token in place of the example PAT `ax451...8838b1` below:
  
```{r, eval = FALSE}
writeLines("GITHUB_PAT=ax451...8838b1", con = "~/.Renviron")
```

**Warning: This line should not be put in any repo, and this .Rprofile file should not be added to any repo.**

Now restart your R Session (in the menu 'Session' -> 'Restart R'). You can check it worked by typing in your R console to see the token:

```{r, eval = FALSE}
Sys.getenv("GITHUB_PAT")
```

Now your code can include `remotes::install_github` to install an R package from which is in a private repo using the token. For example:

  ```{r, eval = FALSE}
  remotes::install_github("moj-analytical-services/[private-package]@v1.6")
  ```

Putting the secret in ~/.Rprofile - a file outside your repo directories - avoids the serious error of putting the token (a secret) in your repo.

#### Secrets and passwords

Never put a secret or password in your code. Even when the repo is private. See MOJ policy: <https://ministryofjustice.github.io/security-guidance/standards/secrets-management/#application--infrastructure-secrets>

## Other tips and tricks

### Search the code in MoJ Analytical Services to see who else has used a package.

An example of a code search is [here](https://github.com/search?q=org%3Amoj-analytical-services+xltabr&type=Code).  Further guidance is [here](https://help.github.com/articles/about-searching-on-github/)

### Hyperlink to a specific line of code in your project

See [here](https://stackoverflow.com/a/31282559/) for how to do this.

### View who made changes to code, when and why using Git blame.

See [here](https://help.github.com/articles/tracing-changes-in-a-file/).  An example of this is [here](https://github.com/moj-analytical-services/our-coding-standards/blame/master/version_control_pattern.md).

### Make your project available to people on different teams

### Assign a reviewer to a pull request, and leave comments.

### View how files have changed on the platform and on

 [](images/github/view_history.gif)
