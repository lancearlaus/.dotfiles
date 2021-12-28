#!/usr/bin/env bash

# ===============================================================================================
# Purpose: Initialize personalized doftiles configuration from version controlled Git repository
#
# Usage: Paste the following into a macOS or Linux terminal
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/lancearlaus/.dotfiles/install/install.sh)" -- <branch>
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
GITHUB_REPO_URL=https://github.com/$GITHUB_USER/$DOTFILES_REPO_NAME

OS_NAME=`uname -s`

# Note: This function can also be found in the configuration (see functions.zsh)
dotfiles() {
    git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME "$@"
}

# Prompt the user to select a configuration branch
# DOTFILES_BRANCH is set to the selected branch, including $DOTFILES_BRANCH_PREFIX/ prefix
select_dotfiles_branch() {
    read -ra DOTFILES_BRANCHES <<< $(git ls-remote --heads $GITHUB_REPO_URL "refs/heads/${DOTFILES_BRANCH_PREFIX}/*" | cut -f2 | sed -e 's/refs\/heads\///' | sort | tr '\n' ' ')
    
    echo "Dotfiles branches from $GIT_REPO_URL:"
    PS3="Please select a ${DOTFILES_BRANCH_PREFIX} branch to install from the list above: "
    select DOTFILES_BRANCH in ${DOTFILES_BRANCHES[@]}; do break; done
}


# =================================================================
# Begin configuration

# Prompt the user to select a config branch if none specified
if [ -z "$1" ]; then
    select_dotfiles_branch
else
    DOTFILES_BRANCH=$1
fi

echo "Installing $DOTFILES_BRANCH_PREFIX branch $DOTFILES_BRANCH"

# Clone as a bare repository
echo "Cloning repository..."
git clone --bare $GITHUB_REPO_URL $WORK_TREE

# Checkout
# TODO: Add messaging upon error (existing files)
echo "Checking out configuration branch $DOTFILES_BRANCH"
dotfiles checkout $DOTFILES_BRANCH

# Set local option to not show untracked files in status
dotfiles config --local status.showUntrackedFiles no

# Install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
    echo "Installing on-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

if [ "$OS_NAME" == "Darwin" ]; then

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

    # Download private key material from LastPass vault
    # Check for SSH public keys and LastPass command-line and configuration
    if ls ~/.ssh/*.pub 1> /dev/null 2>&1 && command -v lpass &> /dev/null && [ -f ~/.lpass/username ]; then

        read -p "SSH public keys found. Download matching private keys from LastPass vault (y/N)?" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then

            # Ensure active LastPass session
            lpass status -q || lpass login $(cat ~/.lpass/username)

            # For each public key, ask to retrieve private key if not found and public key matches
            for PUBLIC_KEY_FILE in ~/.ssh/*.pub; do
                PRIVATE_KEY_FILE=${PUBLIC_KEY_FILE%.*}
                KEY_PAIR_NAME=${PRIVATE_KEY_FILE##*/}

                if [ -f "$PRIVATE_KEY_FILE" ]; then
                    echo "Private key file found for key pair $KEY_PAIR_NAME, skipping download"
                else 
                    echo "Retrieving and comparing public key for key pair ${KEY_PAIR_NAME}..."
                    PUBLIC_KEY=$(lpass show --field="Public Key" "${KEY_PAIR_NAME}")

                    if echo $PUBLIC_KEY | diff -b "$PUBLIC_KEY_FILE" - ; then
                        echo "Retrieving private key for key pair $KEY_PAIR_NAME"  
                        PRIVATE_KEY=$(lpass show --field="Private Key" "${KEY_PAIR_NAME}")
                        echo "Saving private key for key pair $KEY_PAIR_NAME to $PRIVATE_KEY_FILE"
                        echo "$PRIVATE_KEY" > "$PRIVATE_KEY_FILE"
                        chmod 600 "$PRIVATE_KEY_FILE"
                    else
                        echo "Error: Public key mismatch for key pair $KEY_PAIR_NAME, skipping key pair"
                    fi
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
