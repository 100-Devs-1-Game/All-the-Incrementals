# GitHub Actions in All-the-Incrementals

This repository uses GitHub Actions to automate workflows for building, testing, and deploying the project. Below is an overview of the key workflows configured in `.github/workflows/`:

## Workflows

### 1. **PR checks**
- **Trigger:** On pull request to `main` and `develop` branches.
- **Jobs:**
    - Install dependencies.
    - Run linting and static analysis using `pre-commit`.
    - Execute unit and integration tests.
    - Build the game using configured export config
- **Purpose:** Ensure code quality and prevent regressions before merging.

### 2. **Release**
- **Trigger:** On push of a new tag matching `v*`.
- **Jobs:**
    - Same as the PR checks
    - Create a release on GitHub.
    - Uploads windows.zip artifacts
    = (Coming soon) Upload web build to itch.io
- **Purpose:** Automate the release process and artifact distribution.


## Customization

You can modify or add workflows by editing or creating YAML files in `.github/workflows/`.

## My Github Actions failed and I don't know what to do. Pls help

Depending on what failed, you have some options explained below.

Always feel free to ask for help in `#devops` channel in Discord

### pre-commit checks

- First make sure you have completed the [Development Setup](../README.md)
- Run `pre-commit run --all-files` at the top level of your local repository
- This should add some changes for you or explain the specific changes
- Rinse and repeat until there are no errors then commit and push

### gut unit tests

You can run the unit tests locally in your Godot editor.
The add-on creates a tab in the bottom section where you would normally see program output or the debugger

### Game exports

You can try running `Project > Export` to see if it reproduces locally otherwise ask in `#devops`
