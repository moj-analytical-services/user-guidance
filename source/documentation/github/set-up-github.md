# Set up GitHub

To set up GitHub for use with git in RStudio or JupyterLab, you'll need to:

1. [Create an SSH key](#create-an-ssh-key).
2. [Add the SSH key to GitHub](#add-the-ssh-key-to-github).
3. [Configure your username and email in git on the Analytical Platform](#configure-your-username-and-email-in-git-on-the-analytical-platform).

### Create an SSH key

You can create an SSH key in RStudio or JupyterLab. You must create a separate SSH key for each tool that you use.

#### RStudio

To create an SSH key in RStudio:

1. Open RStudio from the Analytical Platform control panel.
2. In the menu bar, select **Tools** then **Global Options...**
3. In the options window, select **Git/SVN** in the navigation menu.
4. Select **Create RSA key...**
5. Select **Create**.
6. Select **Close** when the information window appears.
7. Select **View public key**.
8. Copy the SSH key to the clipboard by pressing Ctrl+C on Windows or ⌘C on Mac.

#### JupyterLab

To create an SSH key in JupyterLab, follow the steps below:

1.  Open JupyerLab from the Analytical Platform control panel.
2.  Select the **+** icon in the file browser to open a new Launcher tab.
3.  Select **Terminal** from the 'Other' section.
4.  Create an SSH key by running:

          ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

    Here, you should substitute the email address you used to sign up to GitHub.

5.  When prompted to enter a file in which to save the key, press Enter to accept the default location.
6.  When prompted to enter a passphrase, press Enter to not set a passphrase.
7.  View the SSH key by running:

         cat /home/jovyan/.ssh/id_rsa.pub

8.  Select the SSH key and copy it to the clipboard by pressing Ctrl+C on windows or ⌘C on Mac.

### Add the SSH key to GitHub

To add the SSH key to GitHub, you should follow the [guidance from GitHub](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account).

You also need to authorise your SSH key for use with the MoJ-Analytical-Services organisation before you can use it; see [GitHub: Authorizing an SSH key](https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-an-ssh-key-for-use-with-saml-single-sign-on#authorizing-an-ssh-key) for instructions.

### Configure your username and email in git on the Analytical Platform

To configure your username and email in git on the Analytical Platform using RStudio or JupyterLab, follow the steps below:

1.  Open a new terminal:
    - In RStudio, select **Tools** in the menu bar and then **Shell...**
    - In JupyterLap, select the **+** icon in the file browser and then select **Terminal** from the **Other** section in the new Launcher tab.
2.  Configure your username by running:

          git config --global user.name 'Your Name'

    Here, you should substitute your name.

3.  Configure your email address by runnung:

          git config --global user.email 'your_email@example.com'

    Here, you should substitute the email address you used to sign up to GitHub.
