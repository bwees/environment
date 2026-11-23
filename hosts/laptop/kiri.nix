{ config, pkgs, ... }:

let
  user = config.system.primaryUser;
  kiri = "/Applications/Kiri.app/Contents/MacOS/kiri";

  # `kiri setup` restarts the engine and stops running containers, so only run it once.
  setupKiri = pkgs.writeShellScript "setup-kiri" ''
    if [ -x ${kiri} ] && ! ${pkgs.docker}/bin/docker context inspect kiri >/dev/null 2>&1; then
      ${kiri} setup --use
    fi
  '';

  # Kiri has no setting for its ~/Kiri Finder mount; only this env var on the daemon turns it off.
  disableFinderMount = pkgs.writeShellScript "kiri-disable-finder-mount" ''
    plist="$HOME/Library/LaunchAgents/dev.kiri.daemon.plist"
    key=":EnvironmentVariables:KIRI_NO_FINDER"
    [ -f "$plist" ] || exit 0
    [ "$(/usr/libexec/PlistBuddy -c "Print $key" "$plist" 2>/dev/null)" = "1" ] && exit 0

    /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables dict" "$plist" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Delete $key" "$plist" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Add $key string 1" "$plist"

    launchctl bootout "gui/$(id -u)/dev.kiri.daemon" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$plist"
  '';
in
{
  system.activationScripts.postActivation.text = ''
    echo "setting up Kiri..."
    su -l ${user} -c ${setupKiri} || echo "warning: Kiri setup failed"
    launchctl asuser "$(id -u ${user})" sudo -H -u ${user} ${disableFinderMount} \
      || echo "warning: disabling Kiri Finder mount failed"
  '';
}
