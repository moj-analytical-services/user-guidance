# Apps

It is not currently possible to deploy new apps on the Analytical Platform, though we are working to make this functionality available again as soon as possible.

In the meantime, you can still access and manage existing apps.

If you have an existing app that requires urgent redeployment, please submit a [request](https://github.com/moj-analytical-services/analytical-platform-applications/issues/new?assignees=EO510%2C+YvanMOJdigital&labels=redeploy&template=redeploy-app-request.md&title=%5BREDEPLOY%5D) via GitHub. We normally redeploy apps each Wednesday, where we have recevied a request by the Friday before.

## Your post-migration app and you

As part of the migration path from the Analytical Platform's hosting to the Cloud Platform there are some changes to how environments work. Previously, only applications whose owners had specifically created a separate dev environment had a means of testing deployments before production. Post-migration, all applications will have a live-like development environment, complete with continuous integration. This document provides an overview of that new setup.

## Overview

Your new environment is made up of two key elements:

* A Github workflow
* A Cloud Platform namespace

In brief, the workflow builds and deploys your code as a docker container, and then deploys it to Cloud Platform's kubernetes cluster, in your application's namespace. 

The flow looks something like this:

![High level visual overview of post-migration apps' deployment pipeline using Github Actions](images/apps/overview.svg)

The rationale behind this change is to:

* Facilitate testing - including build artifacts like docker containers - before deploying to production
* Give teams more control over their workflows
* Restore the ability to deploy without the Analytical Platform team's intervention

## Your new deployment pipeline

Concourse was decomissioned in 2022: its replacement is Github's CI system, Github Actions.

GHA has workflow definitions located in your repository under `.github/workflows/`.

By default, you will be provided with two workflows. The dev environment workflow is triggered when you _open_ a Pull Request from any branch into your `main` branch. Its steps are:

* Check out the repository
* Authenticate to AWS
* Build a docker container from your development branch
* If the build is successful, push this container to a container registry
* Run `helm` against the development environment namespace. 

The production workflow behaves in the exact same way, containing the same steps, but will be triggered when a Pull Request is _merged_ into `main`, and will deploy to the production namespace instead

## How to use it

Usage is simple: create a new branch in your repository, push it to Github, open a Pull Request into main, and then view the "Actions" tab on Github. You'll see a list of jobs appear:

![Screenshot of Github Actions with some passing and some failing jobs](images/apps/actions.jpg)

This will show a couple of types of job:

* Code formatting, to suggest where linting might be required
* Deployment, including the building of the image to be deployed

To see the results of a run, click through to it and view the logs. The builds are split into multiple subsections, so you will be able to see what has succeeded or failed:

![Screenshot of Github Actions build step failure](images/apps/actions-overview.jpg)

![Screenshot of Github Actions log error](images/apps/actions-log.jpg)

## Glossary. 

_Namespace_ is the term used for an environment on Kubernetes with its own resource limits and role based access control (RBAC). A namespace will be dedicated to a particular use-case, such as running an application in development or production.
