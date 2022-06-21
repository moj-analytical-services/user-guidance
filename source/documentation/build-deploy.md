# Build and Deploy

**Concourse** is the Analytical Platform service that automatically builds and deploys R Shiny apps, Web apps and Airflow data pipelines. This is also known as 'continuous integration' and 'continuous deployment' (CI/CD).

## deploy.json

Concourse automatically scans git repositories in the [moj-analytical-services](https://github.com/moj-analytical-services/) Github organisation to find repos that are ready to build/deploy.  It does this by checking whether repositories contains a 'magic' file (on the `master` branch) that controls the build/deploy: `deploy.json`. The scan happens every 24 hours, or sooner if a [repo in moj-analytical-services](https://github.com/moj-analytical-services) is tagged with a release on GitHub (or if it is urgent it can be triggered by an admin).

For the format of deploy.json, see the relevant subject:

* [R Shiny app](../rshiny-app.html)
* [Web app](../static-app.html)

Changes to deploy.json only take effect when committed to GitHub (master branch), a Release is created and the deploy is successful (see [Scan organisation and deploy](/static-app.html#scan-organisation-and-deploy)).

## Starting a build/deploy

To trigger a Concourse build/deploy, make sure your code is committed and pushed to GitHub and then [create a release on GitHub](https://help.github.com/articles/creating-releases/). It's good practise to use [semantic versioning](https://semver.org/), for example to call the first release `v0.0.1`, then `v0.0.2` etc. The version should always go up in number: concourse automatically looks for a version higher than the one it last deployed, so if your latest release has a version number lower than the currently deployed version it won't build. [You can check your version order here.](https://semvercompare.azurewebsites.net/).

Your task appears in Concourse within 30 seconds. Find it in Concourse to start it as follows:

1. Open [Concourse](https://concourse.services.alpha.mojanalytics.xyz).
2. Select team 'main'.
3. Click 'login with ap-main' followed by your GitHub login and possibly 2FA for GitHub and possibly 2FA for AP.
4. Click the hamburger icon: ![Hamburger menu icon](images/build_and_deploy/concourse_menu.png) (top-left) to see the list of repos that can be built.
5. Click your repo name to see its diagram with the big 'Deploy' box in the middle, inputs and outputs.
6. Click on the 'deploy' box to see details of its builds. You can see previous builds (numbered - e.g. "8 7 6 5 4 3 2 1"). The colour of the build number box gives the status:
    * Grey = paused or pending
    * Yellow = in progress
    * Blue = paused
    * Green = built ok
    * Red = build failed
    * Brown = aborted
    * Orange = errored
7. To start the job (this first time): Click *play* (on the left, against your repo name) AND the "*+*":

    ![Play and "+" buttons](images/build_and_deploy/concourse_new_build.png)

    It should go grey (pending):

    ![Pending state](images/build_and_deploy/concourse_pending.png)

    After 30 seconds it should got yellow (building). If it does not go yellow, check the task is not paused (and possibly the job itself is paused) - press play if is showing.

    ![In progress state](images/build_and_deploy/concourse_in_progress.png)

    It will build/deploy, taking 5 minutes to an hour. You can track progress and see any errors like this:

    ![Error state](images/build_and_deploy/concourse_error.png)

Subsequent build/deploys are started about 5 seconds after doing a GitHub release (unless someone pressed the pause button on the Concourse task). You have to refresh Concourse in your browser to see a fresh build.

### Upcoming Changes
This page has been reviewed and updated on 20th June 2022. Please note that the process above will be changing once we migrate all Apps to the new EKS cluster, we will keep you updated but please check back here regularly for any updates.
