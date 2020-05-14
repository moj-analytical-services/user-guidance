# Using virtual environments in Jupyter

Virtual environments are a powerful, native[^1] way to manage packages and dependencies in python. 

This article assumes some knowledge of the purpose of virtual environments, and doesn't spend too much time motivating their use--you should already want to use them everywhere!
However, it also recognises that for many Analytical Platform users, their introduction to python is through Jupyter, so they may not have used virtual environments in python before.

[^1]: Virtual environments are native in Python 3 (since 3.3) through the inbuilt module `venv`. Additional helper tools are available in the package `virtualenv`.

> **Concepts in this article:**
>
> * Using the terminal;
> * Dependency management;
> * Paths and python interpreters (informally)

## <a name="the-jupyter-kernel"></a> The Jupyter kernel 

For those used to 'classical' python programming, code is written as plain-text scripts before being passed to an interpreter.
This is a piece of software sitting on the computer (or Analytical Platform account) that reads the script and converts its instructions into action.
We might write

```bash
$ python3 scripts/recipe.py
```
to use the `python3` interpreter (a shorthand for a `python.exe` file somewhere in the filesystem) to run a script called `recipe.py` inside a `scripts` folder.

Jupyter uses what it calls a **kernel**, similar to an interpreter but allowing a much greater degree of interactivity, which is what gives coding in Jupyter its particular and intuitive character.
Every Jupyter notebook has an associated kernel, and a kernel can be used for many different notebooks.

The Jupyter instances on the Analytical Platform come with kernels for several different programming languages, including R, Python and Julia.
We select a  default kernel for each new notebook when it is created, but can change it at any time by clicking on its name in the top right hand corner of the notebook. 
Try running a new notebook with a cell written in R language and a cell written in python alternately using an R kernel and a python kernel and observe the difference.

We can also create our own kernels.
Kernels can also capture the environment surrounding an interpreter, including the packages that it has access to.

This makes kernels a powerful tool, allowing us to run at the same time two notebooks, one running Python 3.8 with a large number of hefty NLP tools, the other running numeric analyses in Python 2.6, without interference or loss, or to flit between two very different projects without reinstalling packages.

## <a name="custom-kernels-with-venv"></a> Creating a custom kernel using `venv` 

*You have started a new python project.*
*You've established a virtual environment from the off, to keep all of your packages and dependencies together and isolated from your other projects, but your work is just exploratory at the moment and you want to use Jupyter.*
*How can Jupyter make use of your virtual environment?*

When you want to use `venv` with Jupyter you also have to create a Jupyter kernel that interprets your Jupyter notebook in th context of the virtual environment you created; i.e. instructing ‘whenever I want to run a python command divert it through *this* python copy which is in my virtual environment rather than the base one’.

When you run `source venvname/bin/activate` in the terminal it is only making that diversion for other things that go on in the terminal (or in an IDE like VSCode it picks this cue up too), so you need to do another step in Jupyter.

So say I’m starting a new project I need to do this:

1. <a name="call-venv">Create a virtual environment in the project folder: in the terminal,

    ```bash
    $ python3 -m venv venvname
    ```
  </a>
1. Activate the environment in the terminal to divert any terminal commands (e.g. pip installs): in the terminal,

    ```bash
    $ source venvname/bin/activate
    ```
1. Install the module `ipykernel` within this environment (for creating/managing kernels for ipython which is what Jupyter sits on top of): in the terminal (with venv activated),
    
    ```bash
    (venvname)$ pip3 install ipykernel
    ```
  (before this step pip3 list should show almost none if any packages; after it will have about 10 as this has quite a few dependencies).
1. <a name="install-kernel"></a>Create a kernel attached to this virtual environment so Jupyter knows that it exists: in the terminal (with venv activated),

    ```bash
    (venvname)$ python3 -m ipykernel install --user --name="venvname" --display-name="Prettier Name to Display (Python3)"
    ```
  This looks like a long command, but breaks down into a few key components:
  - `python3 -m ipykernel`: Run `ipykernel` as a module using the python3 interpreter inside the virtual environment;
  - `install`: do the 'install' operation from `ipykernel`; with the options
  - `--user`: only install this kernel for the current user--this prevents any permissions errors;
  - `--name="venvname"`: give the kernel a short internal name. If you use a generic name for your environment like `venv`, make this something different;
  - `--display-name="..."`: give the kernel a display name for selecting it in Jupyter.
  
  **NB:** It’s important here to call `ipykernel` as a module through `python3` rather than by itself; this is how I most often broke my kernels. I think this is because at the start the only things the terminal knows how to redirect through the venv is python commands (it, uh, co-opts the symlink to your python interpreter...or something technical-sounding like that) so if you call `ipykernel` separately it’ll be trying to connect through your normal python interpreter that doesn’t know about your lovely `venv` packages.

5. Open your notebook and then select this kernel by its long name in the top right hand corner. It might take a little time or some refreshes for it to show up.
6. Do your work and install any packages you need along the way using `pip3` in the terminal with your environment active.

> **Tip:** Once you have associated a kernel with a virtual environment, you do not need to recreate/update the kernel.
> Any packages that are installed to the venv via `pip3` after the kernel is established also carry through and are available to the kernel--I find it useful to picture the kernel as a person diverting traffic.

## <a name="returning-to-a-project"></a> Returning to a project that uses a custom kernel

When we resume work on our project after working on something else, we

1. Open the notebook to find it’s remembered which kernel we wanted to use for this notebook and, seamlessly, we can carry on working with all the packages intact! We should also
1. Navigate to the project folder in the terminal and run `source venvname/bin/activate` to activate the environment in terminal should we need to install more packages as the work progresses.

## <a name="sharing-and-collaborating"></a> Sharing and collaborating with virtual environments

One of the core benefits of using virtual environments is that the project becomes *portable*, and collaborators or other users (spare a thought for QA'ers!) can easily run and modify your code without battling for hours to resolve package conflicts with their local system.

If I’m taking over someone else’s project, they *shouldn’t* include their `venvname/` folder in version control.
You might wish to add `venvname/` to your `.gitignore` (this is one benefit of simply using `venv/` in every project.
What they hopefully have included is a minimal `requirements.txt` (called this by tradition not necessity), so me as a new user just needs to:

1. Navigate to the project folder in the terminal after cloning; 
1. Create my own fresh environment by calling venv as a module [as before](#call-venv)
1. Activate the new environment
1. Install packages using

    ```bash 
    (venv)$ pip3 install -r requirements.txt
    ```
1. Create a Kernel attached to this venv (using step (4) from [above](#install-kernel)) and use it to interpret the notebook.

## <a name="FAQ"></a> FAQs and additional tips

I have been tangled with `python/python3/pip/pip3`.
In all of this I exclusively call `pip3` and `python3` to to be sure--cross-using them can do weird things, but I believe that the `*3` versions have better natural support for virtual environments.
Still no idea when `python` calls `python2` or `python3`; `which python` seems to give unreliable results on AP to me, or I might just be getting confused with my messy installations on Mac.
Better safe than sorry.
