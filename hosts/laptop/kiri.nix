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
in
{
  system.activationScripts.postActivation.text = ''
    echo "setting up Kiri..."
    su -l ${user} -c ${setupKiri} || echo "warning: Kiri setup failed"
  '';
}
