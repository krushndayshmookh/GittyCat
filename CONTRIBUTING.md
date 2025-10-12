# Contributing to GittyCat

First off, thanks for taking the time to contribute! ❤️

This document contains the rules and guidelines that developers are expected to follow, while contributing to this repository. All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for us maintainers and smooth out the experience for all involved. The community looks forward to your contributions. 🎉

<!-- omit in toc -->
## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your first code contribution](#your-first-code-contribution)
- [Styleguides](#styleguides)
  - [Branches and PRs](#branches-and-prs)
  - [Commit message conventions](#commit-message-conventions)
  - [Coding Style Guidelines](#coding-style-guidelines)


## Code of Conduct

This project and everyone participating in it is governed by the [GittyCat Code of Conduct](https://github.com/krushndayshmookh/GittyCat/blob/main/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the [repository owner](https://github.com/krushndayshmookh).

## I Have a Question

Before you ask a question, it is best to search for existing [Issues](https://github.com/krushndayshmookh/GittyCat/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in the issue. It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://github.com/krushndayshmookh/GittyCat/issues/new).
- Provide as much context as you can about what you're running into.
- Provide project and platform versions, depending on what seems relevant.

We will then take care of the issue as soon as possible.

## I Want To Contribute

When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project licence.

### Reporting Bugs

<!-- omit in toc -->
#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report. Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (Make sure that you have read the [documentation](README.md). If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error in the [bug tracker](https://github.com/krushndayshmookh/GittyCat/issues?q=label%3Abug).
- Also make sure to search the internet (including Stack Overflow) to see if users outside of the GitHub community have discussed the issue.
- Collect information about the bug:
  - Steps to reproduce the bug.
  - Any stack trace (for crashes) or relevant logs.
  - macOS Version.
  - Version of Xcode.
  - Can you reliably reproduce the issue?

<!-- omit in toc -->
#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent to the [repository owner](https://github.com/krushndayshmookh).

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](https://github.com/krushndayshmookh/GittyCat/issues/new). (Since we can't be sure at this point whether it is a bug or not, we ask you not to talk about a bug yet and not to label the issue.)
- Explain the behavior you would expect and the actual behavior.
- Please provide as much context as possible and describe the *reproduction steps* that someone else can follow to recreate the issue on their own. This usually includes your code. For good bug reports you should isolate the problem and create a reduced test case.
- Provide the information you collected in the previous section.

Once it's filed:

- The project team will label the issue accordingly.
- A team member will try to reproduce the issue with your provided steps. If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for those steps and mark the issue as `needs-repro`. Bugs with the `needs-repro` tag will not be addressed until they are reproduced.
- If the team is able to reproduce the issue, it will be marked `needs-fix`, as well as possibly other tags (such as `critical`), and the issue will be left to be implemented by someone.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for GittyCat, **including completely new features and minor improvements to existing functionality**. Following these guidelines will help maintainers and the community to understand your suggestion and find related suggestions.

<!-- omit in toc -->
#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Read the [documentation](README.md) carefully and find out if the functionality is already covered.
- Perform a [search](https://github.com/krushndayshmookh/GittyCat/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.
- Find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. Keep in mind that we want features that will be useful to the majority of our users and not just a small subset. If you're just targeting a minority of users, consider writing an add-on/plugin library.

<!-- omit in toc -->
#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/krushndayshmookh/GittyCat/issues).

- Use a **clear and descriptive title** for the issue to identify the suggestion.
- Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why. At this point you can also tell which alternatives do not work for you.
- You may want to **include screenshots or screen recordings** which help you demonstrate the steps or point out the part which the suggestion is related to.
- **Explain why this enhancement would be useful** to most GittyCat users. You may also want to point out the other projects that solved it better and which could serve as inspiration.

### Your first code contribution

<!-- omit in toc -->
#### Prerequisites

- Download Xcode 16.0 or later
- Set your Xcode settings correctly:
   - Open Xcode Settings `Cmd + ,`
   - Text Editing
   - Indentation tab
   - Prefer Indent using Spaces
   - Tab Width: 4
   - Indent Width: 4

<!-- omit in toc -->
#### Start here

- **Check existing issues** to see if your idea or bug is already being discussed.
- **Comment on the issue** to let maintainers know you'd like to work on it (avoid duplicate work).
- **Fork** this repo
- **Clone** your forked repo to your local machine.
- **Create a branch** for your changes following the [branch naming conventions](#branches-and-prs).
- **Make necessary changes** to the code following [coding style guidelines](#coding-style-guidelines).
- **Test** your changes locally (run existing tests, add new tests if needed).
- **Commit** your changes with a clear message following [commit message conventions](#commit-message-conventions).
- **Push** your changes to your forked repo.
- **Open a Pull Request** to the `main` branch of the original repo from your repo.
- **Link related issues** in your PR description (e.g., "Fixes #42" or "Related to #15").
- **Wait for review** and respond to any feedback.
- **Celebrate** your contribution to the project! 🎉


## Styleguides

### Branches and PRs

No commits should be made to the `main` branch directly. The `main` branch shall only consist of the deployed code. Developers are expected to work on feature branches, and upon successful development and testing, a PR (pull request) must be opened to merge with `main`.

**General Rules for branch names**:
- **Lowercase**: Use lowercase letters for consistency.
- **Hyphens**: Separate words with hyphens (kebab-case) for readability (e.g., `feat/18-add-new-login`).
- **Alphanumeric characters and hyphens**: Avoid spaces, underscores, and other special characters.
- **No leading/trailing hyphens or consecutive hyphens**.
- **Concise and Descriptive**: Branch names should be short but clearly indicate the purpose of the branch.

**Common Prefixes for Branch Types**:

- `feat/`: For new features (e.g., `feat/60-add-tooltips`).
- `bugfix/`: For fixing bugs (e.g., `bugfix/110-login-issue`).
- `hotfix/`: For urgent bug fixes in production (e.g., `hotfix/critical-security-patch`).
- `release/`: For preparing a new release (e.g., `release/v1.2.0`).
- `docs/`: For documentation updates (e.g., `docs/110-api-endpoints`).
- `chore/`: For maintenance tasks, build process changes, or dependency updates (e.g., `chore/46-update-dependencies`).

Although not mandatory, it is a good practice to include the issue number in the branch name. Examples -
- `feat/60-add-tooltips`
- `chore/26-status-badge-in-readme`

### Commit message conventions
Commit message conventions aim to standardize the way commit messages are written for clarity, maintainability, and automated tooling. The "Conventional Commits" specification is followed in this repository.

**Subject line**:
- Concise summary of the change (50-72 characters recommended).
- Written in the imperative mood (e.g., "fix: Correct user authentication," not "fixed: user authentication").
- No period at the end.
- Capitalize the first letter.

**Body (Optional)**:
- Detailed explanation of what was changed and why, but generally not how.
- Wrap lines at 72 characters for readability in various tools.
- Use imperative mood.

**Footer (Optional)**:
- References to issues or pull requests (e.g., Closes #123, Fixes #456).
- Indication of breaking changes (e.g., BREAKING CHANGE: API endpoint changed).

**Type**: Categorizes the nature of the change. Common types include:
- `feat`: A new feature.
- `fix`: A bug fix.
- `docs`: Documentation-only changes.
- `style`: Code style changes (formatting, semicolons, etc.).
- `refactor`: Code refactoring that neither fixes a bug nor adds a feature.
- `test`: Adding or updating tests.
- `chore`: Routine tasks, dependency updates, build tooling.
- `build`: Changes affecting the build system or external dependencies.


### Coding Style Guidelines

Developers should aim to write clean, maintainable, scalable and testable code. The following guidelines might come in handy for this: [Swift Best Practices](https://github.com/Lickability/swift-best-practices), by [Lickability](https://lickability.com).
