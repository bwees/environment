# init Starship prompt
eval "$(starship init zsh)"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pnpm:$PATH"

export PNPM_HOME="$HOME/.pnpm"

# flutter chrome executable
export CHROME_EXECUTABLE="/Applications/Chromium.app/Contents/MacOS/Chromium"

# aliases
alias gro="git rebase origin/main"
alias gpf="git push --force-with-lease"

# Enable history search using up/down arrows
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search