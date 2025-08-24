# # Path to your Oh My Zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="af-magic"

# plugins=(git)

# source $ZSH/oh-my-zsh.sh

# Add items to PATH
export PATH="$HOME/Developer/flutter/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# aliases
alias gro="git rebase origin/main"
alias gpf="git push --force"