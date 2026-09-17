{
  extensions = [
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "michalhajny.kustomize-navigator"
    "opentofu.vscode-opentofu"
    "ms-azuretools.vscode-docker"
  ];

  settings = {
    "vs-kubernetes" = {
      "vs-kubernetes.crd-code-completion" = "enabled";
      "vscode-kubernetes.helm-path-mac" = "/Users/bwees/.vs-kubernetes/tools/helm/darwin-arm64/helm";
      "vscode-kubernetes.minikube-path-mac" = "/Users/bwees/.vs-kubernetes/tools/minikube/darwin-arm64/minikube";
    };

    "opentofu.languageServer.tofu.path" = "/Users/bwees/.local/share/mise/shims/tofu";
    "opentofu.validation.enableEnhancedValidation" = true;

    "[opentofu]"."editor.defaultFormatter" = "opentofu.vscode-opentofu";

    "[terraform]"."editor.defaultFormatter" = "bwees.custom-formatter";
    "[terraform]"."customFormatter.command" = "tofu fmt";
  };
}
