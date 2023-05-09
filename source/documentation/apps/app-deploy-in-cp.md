# Deploying your app

## How do I deploy my app after migration to Cloud Platform hosting?

After the move to Cloud Platform hosting for Analytical Platform apps, you’ll have two active deployments of your apps at all times. These are your 'dev' (development) and 'prod' (production) deployments. 

Your code repository within the [ministryofjustice organisation](https://github.com/ministryofjustice/) was built from the [data-platform-app-template repo](https://github.com/ministryofjustice/data-platform-app-template), and has inherited the continuous integration and continuous delivery (CI/CD) pipelines (GitHub Action workflows) from that repo. These workflows will automatically build your docker images, push them to a remote image store, and then deploy the application based on how you’ve made your code changes:

- **Deploying your application to your development environment** is done through the `-dev` workflow, which will build-push-deploy when any pull request is made in the repo (e.g. `feature-branch` into `main`, or `feature-branch` into `develop-branch`). The workflow can also be manually triggered, though this will only build and push the app, it  <u>will not deploy</u> it: repo homepage > Actions (tab) > Run workflow (right hand side of the page).

  - Opening any pull request will trigger a dev deployment. Any subsequent pushes to that branch (or to any other open branches) will trigger dev deployments too. If you’re working on multiple PRs at once in the repo that you will need to coordinate pushes to your PRs so you can track your deployments. You can always cancel workflow runs and rerun deployments from the Actions page in the repo.

- **Deploying your application to your production environment** is done through the `-prod` workflow, which will build-push-deploy either:
  - after a pull request is merged into main
  - upon publishing a release

You can view the status of your deployments either by checking the workflow runs in the Actions tab (repo-url/actions), or by checking out the deployments page (repo-url/deployments).

The above describes how CI/CD will be set up by default in the ministryofjustice repo. Once you have ownership of the repo, you'll have the ownership of the `.github/workflow/` files too so you will be able to amend the processes and triggers so that they meet your needs.
