#!/usr/bin/env bash

# ===============================================================================================
# Purpose: Initialize personalized doftiles configuration from version controlled Git repository
#
# Usage: Paste the following into a macOS or Linux terminal
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/master/install.sh)" -- <branch>
#       where <branch> is optional and specifies the dotfiles branch, without the dotfiles/ prefix, to install
#       If branch is not specified, the user is presented with a list of available dotfiles branches and prompted to select one to install
#
# Configurations:
#   Dotfiles branch names follow the convention 'dotfiles/<name>'
#   Dotfiles are checked out in the home directory and contain user-specific customization files
#   See a sample configuration branch here: https://github.com/lancearlaus/.dotfiles/tree/dotfiles/main
# 
# Thanks: https://www.atlassian.com/git/tutorials/dotfiles
#
# ===============================================================================================

# Exit when any command fails (this may be overly cautious)
set -e

# Dotfiles Github repository configuration (change this to configure for different user)
GITHUB_USER=lancearlaus
DOTFILES_REPO_NAME=.dotfiles.git
DOTFILES_GITHUB_REPO=$GITHUB_USER/$DOTFILES_REPO_NAME
DOTFILES_FETCH_URL=https://github.com/$DOTFILES_GITHUB_REPO
DOTFILES_PUSH_URL=git@github.com:$DOTFILES_GITHUB_REPO

# Command-line option defaults
DOTFILES_BRANCH=dotfiles/main

# Parse command-line options
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--branch)
      DOTFILES_BRANCH="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters


###########################################################################
# Main entry point
###########################################################################

main() {

    # Set default shell
    set_default_shell zsh

    # Mac-specific pre-requisites
    if macos; then    
        install_xcode_command_line_developer_tools
    fi

    # Ensure oh-my-zsh is installed
    # Note: Installed after command line developer tools installation of curl on Mac
    # Note: Installed before dotfiles installation since oh-my-zsh replaces .zshrc 
    install_oh_my_zsh

    # Install dotfiles from branch
    if [ ! -d "$HOME/$DOTFILES_REPO_NAME" ]; then
        install_dotfiles

        # Invoke dotfiles-specific setup, if found
        if [[ -x ~/.dotfiles/setup ]]; then
            echo "Running dotfiles setup..."
            ~/.dotfiles/setup
        fi

        echo "Please restart shell for configuration to take effect"
    else
        echo "WARNING: dotfiles repository found at $DOTFILES_REPO_NAME", skipping installation and setup
    fi
}

###########################################################################
# Support functions
###########################################################################


# Detect MacOS
macos() {
    [[ $OSTYPE == darwin* ]] && return 0 || return 1
}

# Note: This function can also be found in the configuration (see functions.zsh)
dotfiles() {
    git --git-dir="$HOME/$DOTFILES_REPO_NAME"/ --work-tree="$HOME" "$@"
}

set_default_shell() {
    if [[ $(basename "$SHELL") != "$1" && ! -z $(which $1) ]]; then
        echo "Setting default shell to $(which $1)"
        chsh -s $(which $1)
    fi
}

install_xcode_command_line_developer_tools() {
    if ! xcode-select -p &>/dev/null; then
        echo "Installing XCode Developer Command Line Tools..."
        xcode-select --install
        read -s -n 1 -p "Please complete installation and press any key to continue."
        echo
    fi

    xcode-select -p &>/dev/null || (echo "ERROR: XCode Developer Command Line Tools installation failed." && exit 1)
}

install_oh_my_zsh() {
    if [[ $(basename "$SHELL") == "zsh" && -z "$ZSH" ]] && command -v curl &> /dev/null; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
}

install_dotfiles() {
    echo "Installing dotfiles from $DOTFILES_BRANCH..."

    # Clone single branch as a bare repository
    [ ! -d "$HOME/$DOTFILES_REPO_NAME" ] && git clone --bare --single-branch --branch $DOTFILES_BRANCH $DOTFILES_FETCH_URL

    # Set push url to use SSH (instead of HTTPS) to allow pushing updates
    dotfiles remote set-url --push origin $DOTFILES_PUSH_URL

    # Set local option to not show untracked files in status
    dotfiles config --local status.showUntrackedFiles no

    # Check out dotfiles
    dotfiles checkout

}

main