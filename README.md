## Initial Install

```
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/devenv#laptop
```

## Other installs

Rosetta:

```bash
softwareupdate --install-rosetta
```

Xcode devtools:
```bash
xcode-select --install
```


## Fix 1Password in Ungoogled Chromium
```bash
cp ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.1password.1password.json ~/Library/Application\ Support/Chromium/NativeMessagingHosts
```