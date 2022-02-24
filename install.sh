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
DOTFILES_BRANCH_PREFIX=dotfiles
DOTFILES_FETCH_URL=https://github.com/$GITHUB_USER/$DOTFILES_REPO_NAME
DOTFILES_PUSH_URL=git@github.com:$GITHUB_USER/$DOTFILES_REPO_NAME

# Note: This function can also be found in the configuration (see functions.zsh)
dotfiles() {
    git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME "$@"
}

# Prompt the user to select a configuration branch
# DOTFILES_BRANCH is set to the selected branch, including $DOTFILES_BRANCH_PREFIX/ prefix
select_dotfiles_branch() {
    read -ra DOTFILES_BRANCHES <<< $(git ls-remote --heads $DOTFILES_FETCH_URL "refs/heads/${DOTFILES_BRANCH_PREFIX}/*" | cut -f2 | sed -e 's/refs\/heads\///' | sort | tr '\n' ' ')
    
    echo "Dotfiles branches from $GIT_REPO_URL:"
    PS3="Please select a ${DOTFILES_BRANCH_PREFIX} branch to install from the list above: "
    select DOTFILES_BRANCH in ${DOTFILES_BRANCHES[@]}; do break; done
}

# Download SSH key pair from LastPass vault
# Returns key pair in PUBLIC_KEY and PRIVATE_KEY environment variables
# Retrieves username from LastPass configuration (~/.lpass/username)
download_ssh_key_pair() {
    local key_pair_name="$1"

    unset PUBLIC_KEY PRIVATE_KEY

    command -v lpass &> /dev/null || (( echo "Missing lpass command. Please install LastPass command-line program." && return 1 ))

    if [ -z "${LPASS_USERNAME:=$( cat $HOME/.lpass/username 2>/dev/null ) }" ]; then
        read -e -p "Please enter LastPass user name (e.g. user@domain.com): " LPASS_USERNAME
    fi
    
    # Ensure active LastPass session
    lpass status -q || lpass login $LPASS_USERNAME

    # Retrieve key pair
    PUBLIC_KEY=$( lpass show --field="Public Key"  "${key_pair_name}")
    PRIVATE_KEY=$(lpass show --field="Private Key" "${key_pair_name}")
}

# =================================================================
# Begin configuration

# Check for XCode command line tools installation on MacOS
if [[ $OSTYPE == 'darwin'* ]] && ! xcode-select -p &>/dev/null; then
    echo "No developer tools were found, requesting install. Please choose an option in the dialog and rerun setup after installation."
    xcode-select --install
    exit 1
fi

# Prompt the user to select a config branch if none specified
if [ -z "$1" ]; then
    select_dotfiles_branch
else
    DOTFILES_BRANCH=$1
fi

echo "Installing $DOTFILES_BRANCH_PREFIX branch $DOTFILES_BRANCH"

# Clone single branch as a bare repository
echo "Cloning repository..."
git clone --bare --single-branch --branch $DOTFILES_BRANCH $DOTFILES_FETCH_URL $WORK_TREE

# Set push url to use SSH (instead of HTTPS) to allow pushing updates
dotfiles remote set-url --push origin $DOTFILES_PUSH_URL

# Set local option to not show untracked files in status
dotfiles config --local status.showUntrackedFiles no

# Install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing on-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

if [[ $OSTYPE == 'darwin'* ]]; then

    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew already installed."
    fi

    # Install bundle packages
    if [[ -f Brewfile ]]; then
        echo "Installing packages from brew bundle..."
        brew bundle || true     # Ignore missing packages
    fi

    # Optionally download private key material from LastPass vault
    # Check for SSH public keys and LastPass command-line and configuration
    # Convention: Name of key pair in vault is the same as the private key file name
    if ls ~/.ssh/*.pub 1> /dev/null 2>&1 ]; then

        read -p "SSH public key(s) found. Install matching private keys from vault (y/N)?" -n 1 -r ; echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Install matching private key(s) from vault
            for PUBLIC_KEY_FILE in ~/.ssh/*.pub; do
                PRIVATE_KEY_FILE=${PUBLIC_KEY_FILE%.*}
                KEY_PAIR_NAME=${PRIVATE_KEY_FILE##*/}

                if [[ -L "$PUBLIC_KEY_FILE" || -L "$PRIVATE_KEY_FILE" ]]; then
                    echo "Skipping linked key pair $KEY_PAIR_NAME"
                elif [ -f "$PRIVATE_KEY_FILE" ]; then
                    echo "Private key file $PRIVATE_KEY_FILE found for key pair $KEY_PAIR_NAME, skipping download"
                else
                    download_ssh_key_pair $KEY_PAIR_NAME

                    # Check that public key from vault matches before installing private key
                    echo $PUBLIC_KEY | diff -b "$PUBLIC_KEY_FILE" - || (( echo "ERROR: Public key material mismatch for key pair $KEY_PAIR_NAME. Local file content does not match LastPass vault content." && return 1 ))

                    echo "Saving private key for key pair $KEY_PAIR_NAME to $PRIVATE_KEY_FILE"
                    echo "$PRIVATE_KEY" > "$PRIVATE_KEY_FILE"
                    chmod 600 "$PRIVATE_KEY_FILE"
                fi
            done
        fi
    fi
fi

# Apply context specific settings
# TODO: Improve this to allow for different settings based on OS, version, hostname, etc.
SETTINGS_FILE=.settings/$OS_NAME.sh
if [[ -f $SETTINGS_FILE ]]; then
    echo "Applying settings from $SETTINGS_FILE..."
    source $SETTINGS_FILE
fi


echo "Please restart shell for configuration to take effect"
