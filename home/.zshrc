# init Starship prompt
eval "$(starship init zsh)"

# PATH
export PATH="$HOME/.local/bin:$PATH"

# flutter chrome executable
export CHROME_EXECUTABLE="/Applications/Chromium.app/Contents/MacOS/Chromium"

# aliases
alias gro="git rebase origin/main"
alias gpf="git push --force-with-lease"

# Enable history search using up/down arrows
bindkey '^[[A' history-beginning-search-backward   # Up arrow
bindkey '^[[B' history-beginning-search-forward    # Down arrow