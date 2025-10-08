# Tooling Maintenance Policy

## Release Naming

Each release will adopt [Semantic Versioning](https://semver.org).

We will publish release notes of all changes for each tool. You can find these on GitHub:

- [JupyterLab Releases](https://github.com/ministryofjustice/analytical-platform-jupyterlab/releases)
- [Visual Studio Code Releases](https://github.com/ministryofjustice/analytical-platform-visual-studio-code/releases)
- [RStudio Releases](https://github.com/ministryofjustice/analytical-platform-rstudio/releases)
- [Cloud Development Environment Base Releases](https://github.com/ministryofjustice/analytical-platform-jupyterlab/releases)

Release communications will summarise changes and provide a link to the relevant release note containing all changes.

In the Control Panel, there has historically been a loose naming convention for tooling releases. Going forward, we will adopt a clearer naming convention in the form:

`[release x.y.z] Tool Name x.y.z`

For example, for Visual Studio Code, this will appear as:

`[vscode 2.3.0] Visual Studio Code 2.3.0`

Semantic versions will match across both the GitHub repository and the Control Panel.

## Release Schedule
Our Release Schedule is outlined below.

### High-Importance Security Patching
- **Timing**: As needed, outside the regular release schedule.
- **Process**: Critical security patches will be applied and released immediately upon identification.

### Release Cadence

#### Monthly Releases
- **Goal**: Ensure each software image (Visual Studio Code, JupyterLab, RStudio) is updated with the latest features, patches, and security improvements.
- **Release Date**: [Scheduled issues](https://github.com/ministryofjustice/analytical-platform/blob/087fd6064ef4c1745543e3eee18806408dae0b2a/.github/workflows/schedule-issue-cloud-development-environment-base.yml#L6) are set to maintain the images on the first of every month.

#### Release Latest Image (Version `n`)
- A new image (version `n`) is created, tested, and ready for deployment. This becomes the `latest` release.
- Version `n` is made available to customers to deploy in the Control Panel.

#### Deprecated Image (Version `n-1`) Remains
- The previous image (version `n-1`) is deprecated and remains available and supported.
- Updates for `n-1` cease, but support is still available.

#### Retired Image (Version `n-2`)
- The older image (version `n-2`) is retired and no longer available for download or use.

### Version Availability
- At any time, only the Latest (`n`) and Previous (`n-1`) versions are supported and available.
- Customers will be informed about the discontinuation of version `n-2` upon the release of version `n`.
- Version `n-1` and `n-2` can be any `MAJOR`, `MINOR`, or `PATCH` update as per [Semantic Versioning definitions](https://semver.org/#summary).

## Release Communications
Communications for each new release will be sent to the `#ask-analytical-platform` channel. An example of this communication can be seen [here](https://mojdt.slack.com/archives/C4PF7QAJZ/p1759397923226149).
