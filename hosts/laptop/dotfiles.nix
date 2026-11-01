{
  dotfiles.links = {
    ".zshrc" = "zsh/.zshrc";
    ".config/git/config" = "git/config";
    ".ssh/config" = "ssh/config";
    ".config/starship.toml" = "starship/starship.toml";
    ".config/mise/config.toml" = "mise/config.toml";
    ".config/ghostty" = "ghostty";
    ".config/1Password/ssh/agent.toml" = "1password/agent.toml";
    ".kube/clusters.yaml" = "kube/clusters.yaml";
    ".claude/CLAUDE.md" = "claude/CLAUDE.md";
    ".claude/settings.json" = "claude/settings.json";
    "/opt/homebrew/etc/tailmux/config.json" = "tailmux/config.json";
    ".t3/userdata/settings.json" = "t3/settings.json";
    ".t3/userdata/client-settings.json" = "t3/client-settings.json";
    ".t3/userdata/keybindings.json" = "t3/keybindings.json";
  };
}
