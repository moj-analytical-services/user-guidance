# Create a new project in GitHub

In GitHub, you can use a repository to store and collaborate on all of your project's code.

You can also use:

- [pull requests](https://docs.github.com/en/pull-requests) to propose changes to your code and receive reviews from others
- [issues](https://docs.github.com/en/issues) to plan and track your work

### Create a new repository

To create a new repository, you should:

1. Navigate to the [MoJ Analytical Services](https://github.com/moj-analytical-services) GitHub organisation page.
2. In the repositories section, select **New**.
3. Configure the properties of your repository, in line with the information below.
4. Select **Create repository**.

#### Repository template

You may find it helpful to use a repository template, such as the [moj-analytical-services/template-repository](https://github.com/moj-analytical-services/template-repository), instead of starting with a blank repository. Templates are often pre-configured with initial files and workflows, and sensible defaults that enable you to get going more quickly. You can also [create your own template repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository) that you can reuse and share with others.

#### Owner

You should select **moj-analytical-services** as the **Owner** of the repository. This should be selected by default.

If you accidentally create a repository in your personal GitHub account or a different organisation, you can [transfer it](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository#transferring-a-repository-owned-by-your-personal-account) to the MoJ Analytical Services GitHub organisation.

#### Repository name

When choosing a name for your repository, we recommend:

- keeping it short and simple
- making it descriptive and meaningful
- avoiding abbreviations and acronyms
- using dashes to separate words and not full stops or underscores

#### Description

We recommend providing a description for your repository that will help others understand what it is for.

#### Repository visibility

You can create a repository that is public, internal or private.

> Public repositories are visible to anyone on the internet.
>
> Internal repositories are visible to anyone within the MoJ GitHub enterprise. This includes members of the [MoJ Analytical Services](https://github.com/moj-analytical-services) organisation, the [Ministry of Justice](https://github.com/ministryofjustice) organisation and the > [Criminal Injuries Compensation Authority](https://github.com/CriminalInjuriesCompensationAuthority) organisation.
>
> Private repositories are only visible to you and other people that you share access with.

Where possible, you should [make your code open and reusable](https://www.gov.uk/service-manual/technology/making-source-code-open-and-reusable) so [others can benefit from it](https://gds.blog.gov.uk/2017/09/04/the-benefits-of-coding-in-the-open/).

In practice, this is not always possible and you should take care to avoid [publishing any information that is sensitive](security-in-github.html) or should not be in the public domain. This may include:

- credentials and secrets
- data
- code relating to the development of policy that has not been announced
- code that could enable people to exploit systems or processes

In such cases, we recommend that you create an internal repository.

Generally, you shouldn't use private repositories, unless you are working on a project that is particularly sensitive.

If you are unsure what visibility setting to use, contact the [Analytical Platform team](../support.html).

#### README

We recommend that you add a README file when creating your repository. You can use a [README](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes) file to tell other people why your project is useful, what they can do with your project, and how they can use it.

#### `.gitignore`

A `.gitignore` file allows you tell git to [ignore certain files and directories](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository#_ignoring), such as configuration files and temporary files.

We recommend that you select a `.gitignore` template for the language you are going to use for your project. `.gitignore` templates are available for R and Python.

#### Licence

If your repository is public, you may wish to include a license to tell other people what they can do with your code. At MoJ we use the [MIT License](https://choosealicense.com/licenses/mit/).

### Manage access to a repository

Once you have created a repository, you can [give other people access](manage-access.html) to it.
