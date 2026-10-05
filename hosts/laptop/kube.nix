{
  lib,
  pkgs,
  ...
}:

let
  # 1Password only accepts desktop-app unlock requests from its own signed
  # binary, so the nixpkgs build of `op` cannot stand in here.
  opCli = "/opt/homebrew/bin/op";

  vault = "Homelab";

  kubeOpCred = pkgs.writeShellApplication {
    name = "kube-op-cred";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      ${opCli} item get "$1" --vault ${lib.escapeShellArg vault} --format json | jq -c '
        (.fields | map({ key: .label, value: .value }) | from_entries) as $f
        | {
            apiVersion: "client.authentication.k8s.io/v1",
            kind: "ExecCredential",
            status: {
              clientCertificateData: $f.certificate,
              clientKeyData: $f.key,
            },
          }
      '
    '';
  };
in
{
  environment.systemPackages = [ kubeOpCred ];
}
