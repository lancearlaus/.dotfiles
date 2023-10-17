# My dotfiles

Customized configuration (dotfiles) managed via bare git repo approach

Thanks: https://www.atlassian.com/git/tutorials/dotfiles

## Installation

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/.dotfiles/install.sh)"

Paste the following into a macOS or Linux terminal

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/.dotfiles/install.sh)" -- --branch <branch>

    where `--branch <branch>` is optional and specifies the branch to install, defaulting to master

    Example:
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)" -- client

## Implementation Notes

* Installation script installs
  * Hombrew and applies Brewfile bundle, if present, on Mac
  * Executes MacOS-specific settings script, if present, on Mac
* Installation does require sudo rights


## Useful dotfiles commands

A `dotfiles` function is defined to help manage dotfiles updates. 
Dotfiles are checked out into a bare repository which, lacking a working copy, requires non-intuitive git commands to commit/push/pull.

1. Committing and pushing updated dotfiles works as expected
  * `dotfiles status`
  * `dotfiles add <file(s)>`
  * `dotfiles commit -m "<commit message>"`
  * `dotfiles push`
2. Fetching updated dotfiles is different
  * DO NOT PULL - FETCH ONLY! (pull is the combination of fetch and merge and requires a working copy which doesn't exist for a bare repository)
  * `dotfiles fetch origin <branch>:<branch>`
    * Ex: `dotfiles fetch origin dotfiles/main:dotfiles/main`
3. Checking out updated files (synchronzing changes to another machine) is different
  * `dotfiles checkout <branch> -- <file...>`
    * Ex: `dotfiles checkout master -- .zshrc`
