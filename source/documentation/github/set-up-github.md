# Set up GitHub

To set up GitHub for use with git in RStudio or JupyterLab, you'll need to:

1. [Create an SSH key](#create-an-ssh-key).
2. [Add the SSH key to GitHub](#add-the-ssh-key-to-github).
3. [Configure your username and email in git on the Analytical Platform](#configure-your-username-and-email-in-git-on-the-analytical-platform).

### Create an SSH key

You can create an SSH key in RStudio, JupyterLab or Visual Studio Code. You must create a separate SSH key for each tool that you use.

#### RStudio

To create an SSH key in RStudio:

1. Open RStudio from the Analytical Platform Control Panel
2. Navigate to **Tools>Global Options**
3. In the **Options** window, select **Git/SVN** in the navigation menu
4. Select Create RSA key and then Create
5. When the **Information** window appears, select **Close**
6. Select **View public key** and copy the SSH key to your clipboard

#### JupyterLab

To create an SSH key in JupyterLab, follow the steps below:

1. Open JupyerLab from the Analytical Platform Control Panel
2. Select the **+** icon in the file browser to open a new **Launcher** tab
3. Navigate to the **Other** section and select **Terminal**
4. Run the following command in your terminal, replacing **your_email@example.com** with the email address you used to sign up for GitHub:

    ```
    $ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

5. The response will ask you to choose a directory to save the key in; press Enter to accept the default location
6. The response will also ask you to set a passphrase; press Enter to not set a passphrase.
7. To view the SSH key, run:

    ```
    $ cat /home/jovyan/.ssh/id_rsa.pub
    ```

8. Copy the SSH key to your clipboard

#### Visual Studio Code

To create an SSH key in Visual Studio Code, follow the steps below:

1. Open Visual Studio Code from the Analytical Platform Control Panel
2. Open a new terminal, and run the following commands

    ```
    $ ssh-keygen -t ed25519 -C "<your email address>"
    ```

3. The response will ask you to choose a directory to save the key in; press Enter to accept the default location
4. The response will also ask you to set a passphrase; press Enter to not set a passphrase.
5. To view the SSH key, run:

    ```
    $ cat ~/.ssh/id_ed25519.pub
    ```

6. Copy the SSH key to your clipboard

### Add the SSH key to GitHub

To add the SSH key to GitHub, you should follow the [guidance from GitHub](https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account).

### Configure your username and email in git on the Analytical Platform

To configure your username and email in git on the Analytical Platform using RStudio, JupyterLab or Visual Studio Code, follow the steps below:

1.  Open a new terminal:
    - In RStudio, select **Tools** in the menu bar and then **Shell...**
    - In JupyterLab, select the **+** icon in the file browser and then select **Terminal** from the **Other** section in the new Launcher tab.
    - In Visual Studio Code, select the **≡** icon in the top right and click **Terminal** then **New Terminal**.

2.  Configure your username by running:

          git config --global user.name 'Your Name'

    Here, you should substitute your name.

3.  Configure your email address by runnung:

          git config --global user.email 'your_email@example.com'

    Here, you should substitute the email address you used to sign up to GitHub.
