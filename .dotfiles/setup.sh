#!/usr/bin/env bash

BREWFILE=$HOME/Brewfile

# Detect MacOS
macos() {
    [[ $OSTYPE == darwin* ]] && return 0 || return 1
}

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    command -v brew &> /dev/null || (echo "ERROR: Homebrew installation failed." && exit 1)
}

if macos; then

    # Thanks: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
    # Ask for the administrator password upfront
    echo "Please enter password for sudo installation access"
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until this script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Install Homebrew
    install_homebrew

    # Install Homebrew bundle packages
    if [[ -f "$BREWFILE" ]]; then
        echo "Installing packages from brew bundle..."
        brew bundle --file "$BREWFILE" || true     # Ignore missing packages
    fi
fi
