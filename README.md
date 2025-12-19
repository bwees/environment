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

## Chromium Fixes

- 1Password Native Messaging Host:

  ```bash
  cp ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.1password.1password.json ~/Library/Application\ Support/Chromium/NativeMessagingHosts
  ```

- WebRTC Fixes:

  - Set [chrome://flags/#webrtc-ip-handling-policy](chrome://flags/#webrtc-ip-handling-policy) to "Default"

- Extension Install Support
  - Set [chrome://flags/#extension-mime-request-handling](chrome://flags/#extension-mime-request-handling) to "Always prompt for install"
