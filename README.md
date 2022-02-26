# My dotfiles

Customized configuration (dotfiles) managed via bare git repo approach

Thanks: https://www.atlassian.com/git/tutorials/dotfiles

## Installation

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)"

Paste the following into a macOS or Linux terminal

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)" -- <branch>

    where `<branch>` is optional and specifies the config branch, without the dotfiles/ prefix, to install
    If branch is not specified, the user is presented with a list of available config branches and prompted to select one to install

    Example:
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)" -- dotfiles/main

## Implementation Notes

* Installation script installs
  * oh-my-zsh with customizations located in ~/.zsh 
  * Hombrew and applies Brewfile bundle, if present, on OSX systems
  * Optionally downloads private keys from LastPass vault
  * Executes OS-specific settings script, if present, located in .settings directoy
* Installation does require sudo rights

## Configurations

* Configuration branch names follow the convention 'dotfiles/<name>'
* Configuration is checked out in the home directory and contain user-specific customization files
* See a sample configuration branch here: https://github.com/lancearlaus/.dotfiles/tree/dotfiles/main

### My configurations

* `dotfiles/main` - Standard baseline configuration

## Useful dotfiles commands

Dotfiles are checked out into a bare repository and, since bare repositories lack a working copy, require non-intuitive git commands to manage updates (commit/push/pull)

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
    * Ex: `dotfiles checkout dotfiles/main -- .zshrc`
