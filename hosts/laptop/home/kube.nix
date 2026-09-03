{
  config,
  lib,
  pkgs,
  ...
}:

let
  # 1Password only accepts desktop-app unlock requests from its own signed
  # binary, so the nixpkgs build of `op` cannot stand in here.
  opCli = "/opt/homebrew/bin/op";

  vault = "Homelab";

  # This file is committed. Client certs and keys are deliberately absent --
  # kubeOpCred fetches them from 1Password on each kubectl invocation.
  clusters = {
    eridani = {
      server = "https://eridani:6443";
      caData = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJlRENDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUzT0RNeU9UQXlOamd3SGhjTk1qWXdOekExTWpFeU5ESTRXaGNOTXpZd056QXlNakV5TkRJNApXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUzT0RNeU9UQXlOamd3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFUci9qL0FrWmk3cnZ5dXZFd1g0YlhyVHowYnRVdE1uSU5Gd1JjZkgwUU4KK2VDcTZZVTlZQ0VqM0pyRmdNcFlLWStzQXRxT1RBVXZlTVY3UmJ6VTlSaUZvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVTMrNzg4WjVhNXRza2lBNXk2WWNyCkR4SFpJZXd3Q2dZSUtvWkl6ajBFQXdJRFNRQXdSZ0loQUx6UWZzWXUzcmJpSUluKzBZTjg5Z21BSzMwTHZLbFUKejk2V2pjWk1Ld3BMQWlFQTBPWFBvWjczNlk0V0MwTGdkWnB4WHhjM0t1TUFMb3YvQ0NKRGxUbm54b2M9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K";
    };
    hail-mary = {
      server = "https://grace:6443";
      caData = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUzT0RBNE1ERXpPRE13SGhjTk1qWXdOakEzTURNd016QXpXaGNOTXpZd05qQTBNRE13TXpBegpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUzT0RBNE1ERXpPRE13V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFSdkY5WmlYMmNwUFNaWHgzTUM5eGN4UDVyckVEeDRBWCsrZnVwVVZ6N2MKYlNaVUdiRHJINGZDRk9KNy9EZHV3RlUvdWE5U3BZSm5LTUZscEprY1k2RVhvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVTNTZ095VWlUUzlvclRwRG1OTTExCjM1UGF0bEF3Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUloQUtsRmtJVFJWVkFENUwvMnRJNlpLRDBQRTdzMnI0eXIKdHpLWm51ZWhUajdCQWlBVkU0VnVwSUJXWnVndHJBbXpGVWFMWHZtVWVMT3RFQnBvQ1MvOFVPOGtoZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K";
    };
    stepien = {
      server = "https://stepien:6443";
      caData = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJlRENDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUzT0RNeU9UQXhOVEl3SGhjTk1qWXdOekExTWpFeU1qTXlXaGNOTXpZd056QXlNakV5TWpNeQpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUzT0RNeU9UQXhOVEl3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFTeFcvekdqRWVkSkJzU0RaQTk3Mk1hTEw5c05CRE10ZE9EK0drU05VZU8KWjJZdnQ1bjN2Sm5xNkxDdkdLYmZWTm5MVm1JK3hTVXl3SjZXcUZVWXp0clVvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVWZ6Q1JTSlFBdEJEU1VFNm8vRTJWCnJmOUl4SEV3Q2dZSUtvWkl6ajBFQXdJRFNRQXdSZ0loQU1HcnVvVG5INmVyd0taR0poZUpaeTdqSlNkdVRmMEQKWG9LS0swU2kxOVNOQWlFQSt6TjN6aE5yWU9HemFJVnFxWUhhdloxNWNCeVA1S0MrMjM5d1dXNlVXYzg9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K";
    };
    tau-ceti = {
      server = "https://tau-ceti:6443";
      caData = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkekNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUzT0RJd05qTTRNell3SGhjTk1qWXdOakl4TVRZME16VTJXaGNOTXpZd05qRTRNVFkwTXpVMgpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUzT0RJd05qTTRNell3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFTUktlaUE0aC9oNFhGUkhPS1psN1FmZ1pOcmJwWXZSWmhFNVNYbHYrOGsKcWRLNWdUUFhPbzVlMkFNT2dWREI0NXpJVldhUGx3cVNYQ3VSQ2VEK2pvUktvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVWhQTHUvYjRoKzg1OENDRXkxWHZrCnBFdUhGY013Q2dZSUtvWkl6ajBFQXdJRFNBQXdSUUlnVXVFb3JESW5oSnI5cytvc056RWlibVdXcFpNSHQ0TDkKR1grR2tLVFFXOG9DSVFEN0VzSkJ0ZDNWblIxTkUzVW1aTjhGSmsyamJaTEJtalRPWUhzbkYxNEhJZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K";
    };
  };

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

  kubeconfig = {
    apiVersion = "v1";
    kind = "Config";

    clusters = lib.mapAttrsToList (name: cluster: {
      inherit name;
      cluster = {
        inherit (cluster) server;
        certificate-authority-data = cluster.caData;
      };
    }) clusters;

    contexts = lib.mapAttrsToList (name: _: {
      inherit name;
      context = {
        cluster = name;
        user = name;
      };
    }) clusters;

    users = lib.mapAttrsToList (name: _: {
      inherit name;
      user.exec = {
        apiVersion = "client.authentication.k8s.io/v1";
        command = "${kubeOpCred}/bin/kube-op-cred";
        args = [ "k8s-${name}" ];
        interactiveMode = "IfAvailable";
        provideClusterInfo = false;
      };
    }) clusters;
  };

  yaml = pkgs.formats.yaml { };

  kubeDir = "${config.home.homeDirectory}/.kube";
in
{
  home.packages = [ kubeOpCred ];

  home.file.".kube/clusters.yaml".source = yaml.generate "kubeconfig-clusters" kubeconfig;

  # k3d writes clusters into ~/.kube/config and `use-context` writes the
  # current context there too, so that file stays mutable and comes first.
  home.sessionVariables.KUBECONFIG = "${kubeDir}/config:${kubeDir}/clusters.yaml";
}
