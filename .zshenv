
# See: https://zsh.sourceforge.io/Doc/Release/Functions.html
fpath+=(~/.zsh_functions)
typeset -U fpath
source ~/.zsh_functions/autoload

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Configure SSH client to use 1Password SSH agent
# See: https://developer.1password.com/docs/ssh/get-started/#step-4-configure-your-ssh-or-git-client
for SSH_AUTH_SOCK in "$HOME/.1password/agent.sock" "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"; do
    [[ -S "$SSH_AUTH_SOCK" ]] && export SSH_AUTH_SOCK && break
done


# Aliases
# Git
alias commit="git add . && git commit -m"
alias gcommit="git add . && git commit"
alias gst="git status"
alias gc="git checkout"
alias gd="git diff"
alias gl="git log --oneline --decorate --color"
