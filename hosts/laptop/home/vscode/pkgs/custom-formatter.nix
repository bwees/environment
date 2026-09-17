{
  fetchurl,
  vscode-utils,
}:

vscode-utils.buildVscodeExtension rec {
  pname = "custom-formatter";
  version = "0.2.0";

  vscodeExtPublisher = "bwees";
  vscodeExtName = pname;
  vscodeExtUniqueId = "${vscodeExtPublisher}.${vscodeExtName}";

  src = fetchurl {
    url = "https://github.com/bwees/custom-format/releases/download/v${version}/${pname}-${version}.vsix";
    hash = "sha256-3guVUHd0EJekfnocHyVixdEqH1XSOTGWZyfY0zgFCcg=";
  };
}
