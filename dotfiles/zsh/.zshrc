# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pnpm:$PATH"

export PNPM_HOME="$HOME/.pnpm"

# flutter chrome executable
export CHROME_EXECUTABLE="/Applications/Chromium.app/Contents/MacOS/Chromium"

# aliases
alias gro="git rebase origin/HEAD"
alias gpf="git push --force-with-lease"

# Enable history search using up/down arrows
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# brew
export HOMEBREW_NO_ENV_HINTS=1

# android tools
export ANDROID_HOME=$HOME/Library/Android/sdk

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# k3d and `kubectl config use-context` write to ~/.kube/config, so it stays first
export KUBECONFIG="$HOME/.kube/config:$HOME/.kube/clusters.yaml"

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

eval "$(/opt/homebrew/bin/mise activate zsh)"

if [[ -r "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi
