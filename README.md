# Analytical Platform user guidance

[![CircleCI](https://circleci.com/gh/moj-analytical-services/user-guidance.svg?style=svg)](https://circleci.com/gh/moj-analytical-services/user-guidance)

The Analytical Platform user guidance uses the [Tech Docs Template][template]. To find out more about how to use this template, see the [Tech Docs Template documentation][tdt-docs].

## Build and deployment process

The user guidance is built and deployed using CircleCI.

When you create a PR, CircleCI will check that your changes build correctly.

When you merge a PR into `main`, CircleCI will build the user guidance and deploy the output files to a bucket in Amazon S3. The user guidance is then served at [user-guidance.services.alpha.mojanalytics.xyz][url] through a content delivey network (CDN) provided by Amazon CloudFront.

## Contribute to the guidance

To make changes to the documentation for the Tech Docs Template website, edit files in the `source` folder of the repository.

### Structure

The `.html.md.erb` files control the structure of the guidance. These files support content in:

* Markdown
* HTML
* Ruby

They are generally of the form:

```yaml
---
title: Page title
weight: 10
last_reviewed_on: YYYY-MM-DD
review_in: 2 years
show_expiry: true
---

<%= partial 'documentation/page-title' %>
```

The weight of a page controls its position in the guidance. Pages are sorted according to increasing weight. For example, a page with a weight of 50 would appear after a page with a weight of 40.

When you review a page, you should update the `last_reviewed_on` date.

The guidance uses a multipage structure to nest content. To find out more about how to manage this structure, see the [Build a multipage documentation site][multipage] in the Tech Docs Template documentation.

### Content

Page content is stored in `.md` files in the `source/documentation` folder of the repository.

To find out more about how to work with Markdown files, see the [Change your content][change-content] section of the Tech Docs Template documentation.

### Style

When contributing to the user guidance, you should make sure that your changes:

* are consistent with the Government Digital Service (GDS) [style guide][style-guide]
* meet [government accessibility requirements][accessibility] as far as possible
* follow the spelling and grammar conventions outlined in the Analytical Platform [A to Z][a-to-z].

## Preview your changes locally

To preview the guidance locally on an MoJ Digital and Technology MacBook, navigate to your project folder and run:

```sh
bundle exec middleman server
```

You can view the guidance on `http://localhost:4567` in your browser. Any content changes you make to your website will be updated in real time.

To shut down the Middleman instance running on your machine, select ⌘+C.

If you make changes to the `config/tech-docs.yml` configuration file, you will need to restart the Middleman server to see the changes.

## Build

To build the HTML pages from content in your `source` folder, run:

```sh
bundle exec middleman build
```

Every time you run this command, the `build` folder gets generated from scratch. This means any changes to the `build` folder that are not part of the build command will get overwritten.

## Update dependencies

To update this repo's Ruby dependencies, run:

```sh
bundle update
bundle exec middleman server  # and quickly test it in your browser
```

Now commit the updated `Gemfile.lock` in a PR, as usual.

## Troubleshooting

Run `bundle update` to make sure you're using the most recent Ruby gem versions.

Run `bundle exec middleman build --verbose` to get detailed error messages to help with finding the problem.

## Licence

Unless stated otherwise, the codebase is released under [the MIT License][mit].
This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright][copyright] and available under the terms of the [Open Government 3.0][ogl] licence.

[mit]: LICENCE
[copyright]: http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/
[ogl]: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
[mmt]: https://middlemanapp.com/advanced/project_templates/
[tdt-docs]: https://tdt-documentation.london.cloudapps.digital
[config]: https://tdt-documentation.london.cloudapps.digital/configuration-options.html#configuration-options
[frontmatter]: https://tdt-documentation.london.cloudapps.digital/frontmatter.html#frontmatter
[multipage]: https://tdt-documentation.london.cloudapps.digital/create_project/multipage/#build-a-multipage-documentation-site
[example-content]: https://tdt-documentation.london.cloudapps.digital/content.html#content-examples
[partials]: https://tdt-documentation.london.cloudapps.digital/single_page.html#add-partial-lines
[install-ruby]: https://tdt-documentation.london.cloudapps.digital/install_macs.html#install-ruby
[install-middleman]: https://tdt-documentation.london.cloudapps.digital/install_macs.html#install-middleman
[gem]: https://github.com/alphagov/tech-docs-gem
[template]: https://github.com/alphagov/tech-docs-template
[change-content]: https://tdt-documentation.london.cloudapps.digital/amend_project/content/#change-your-content
[style-guide]: https://www.gov.uk/guidance/style-guide/a-to-z-of-gov-uk-style
[accessibility]: https://www.gov.uk/service-manual/helping-people-to-use-your-service/making-your-service-accessible-an-introduction#meeting-government-accessibility-requirements
[a-to-z]: https://github.com/moj-analytical-services/user-guidance/blob/master/a-to-z.md
[url]: https://user-guidance.services.alpha.mojanalytics.xyz
