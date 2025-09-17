{ config, pkgs, ... }:

{
  system.activationScripts.applications.text = ''
    echo "c for Rosetta 2..."
    if [ ! -f /Library/Apple/usr/libexec/oah/libRosettaRuntime ]; then
      echo "Installing Rosetta 2..."
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license || true
    fi

    echo "checking for Xcode Command Line Tools..."
    if ! xcode-select -p >/dev/null 2>&1; then
      echo "Installing Xcode Command Line Tools..."
      /usr/bin/xcode-select --install || true
    fi
  '';
}
