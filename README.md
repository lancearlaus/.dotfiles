# My dotfiles

Customized configuration (dotfiles) managed via bare git repo approach

Thanks: https://www.atlassian.com/git/tutorials/dotfiles

## Installation

Paste the following into a macOS or Linux terminal

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)" -- <branch>

    where `<branch>` is optional and specifies the config branch, without the config/ prefix, to install
    If branch is not specified, the user is presented with a list of available config branches and prompted to select one to install

    Example:
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)" -- config/main

## Implementation Notes

* Installation script installs
  * oh-my-zsh with customizations located in ~/.zsh 
  * Hombrew and applies Brewfile bundle, if present, on OSX systems
  * Executes OS-specific settings script, if present, located in .settings directoy
* Installation does require sudo rights

## Configurations

* Configuration branch names follow the convention 'config/<name>'
* Configuration is checked out in the home directory and contain user-specific customization files
* See a sample configuration branch here: https://github.com/lancearlaus/.dotfiles/tree/config/main

### My configurations

* `config/main` - Standard baseline configuration

