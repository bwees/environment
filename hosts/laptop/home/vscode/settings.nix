{
  "workbench.colorTheme" = "Dark Modern";
  "workbench.iconTheme" = "material-icon-theme";
  "workbench.experimental.modernUI" = true;
  "workbench.browser.openLocalhostLinks" = false;
  "window.newWindowProfile" = "Default";

  "editor.fontFamily" = "Menlo, Monaco, 'Courier New', monospace, 'Symbols Nerd Font Mono'";
  "editor.formatOnSave" = true;
  "editor.inlayHints.enabled" = "offUnlessPressed";
  "editor.inlineSuggest.edits.showCollapsed" = true;
  "editor.codeActionsOnSave" = {
    "source.fixAll" = "always";
    "source.organizeImports" = "always";
  };
  "editor.quickSuggestions" = {
    other = "on";
    comments = "off";
    strings = "off";
  };

  "files.autoSave" = "onFocusChange";
  "diffEditor.ignoreTrimWhitespace" = false;

  "explorer.confirmDelete" = false;
  "explorer.confirmDragAndDrop" = false;
  "explorer.confirmPasteNative" = false;
  "explorer.fileNesting.patterns" = {
    "*.ts" = "\${capture}.js";
    "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
    "*.jsx" = "\${capture}.js";
    "*.tsx" = "\${capture}.ts";
    "tsconfig.json" = "tsconfig.*.json";
    "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb, bun.lock";
    "flake.nix" = "flake.lock";
    "*.sqlite" = "\${capture}.\${extname}-*";
    "*.db" = "\${capture}.\${extname}-*";
    "*.sqlite3" = "\${capture}.\${extname}-*";
    "*.db3" = "\${capture}.\${extname}-*";
    "*.sdb" = "\${capture}.\${extname}-*";
    "*.s3db" = "\${capture}.\${extname}-*";
  };

  "git.autofetch" = true;
  "git.enableSmartCommit" = true;
  "git.confirmSync" = false;
  "git.ignoreRebaseWarning" = true;
  "git.replaceTagsWhenPull" = true;
  "git.addAICoAuthor" = "off";
  "githubPullRequests.pullBranch" = "never";

  "extensions.ignoreRecommendations" = true;
  "chat.mcp.autostart" = "never";
  "chat.viewSessions.orientation" = "stacked";
  "redhat.telemetry.enabled" = false;
  "terminal.integrated.enableMultiLinePasteWarning" = false;

  "claudeCode.preferredLocation" = "panel";
  "claudeCode.hideOnboarding" = true;
  "claudeCode.allowDangerouslySkipPermissions" = true;
  "claudeCode.initialPermissionMode" = "bypassPermissions";

  "github.copilot.nextEditSuggestions.enabled" = true;
  "github.copilot.enable" = {
    "*" = true;
    plaintext = false;
    markdown = true;
    scminput = false;
    r = false;
  };

  "errorLens.delayMode" = "debounce";
  "errorLens.margin" = "4 ch";
  "errorLens.alignMessage" = {
    start = 100;
    end = 0;
    minimumMargin = 0;
  };

  "typescript.updateImportsOnFileMove.enabled" = "always";
  "javascript.updateImportsOnFileMove.enabled" = "always";
  "js/ts.experimental.useTsgo" = false;
  "svelte.enable-ts-plugin" = true;

  "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
  "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
  "[svelte]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
  "[yaml]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
  "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
  "[json]"."editor.defaultFormatter" = "vscode.json-language-features";

  "json.schemaDownload.trustedDomains" = {
    "https://developer.microsoft.com/json-schemas/" = true;
    "https://docs.renovatebot.com" = true;
    "https://json-schema.org/" = true;
    "https://json.schemastore.org/" = true;
    "https://raw.githubusercontent.com" = true;
    "https://raw.githubusercontent.com/devcontainers/spec/" = true;
    "https://raw.githubusercontent.com/microsoft/vscode/" = true;
    "https://schemastore.azurewebsites.net/" = true;
    "https://www.schemastore.org/" = true;
  };

  "yaml.disableSchemaDetection" = [
    "**/.github/workflows/*.yml"
    "**/.github/workflows/*.yaml"
    "**/.gitea/workflows/*.yml"
    "**/.gitea/workflows/*.yaml"
    "**/.forgejo/workflows/*.yml"
    "**/.forgejo/workflows/*.yaml"
  ];
}
