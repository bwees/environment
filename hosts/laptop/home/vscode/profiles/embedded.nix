{
  extensions = [
    "platformio.platformio-ide"
    "ms-vscode.cpptools"
    "ms-vscode.cpptools-extension-pack"
    "ms-vscode.cpptools-themes"
    "llvm-vs-code-extensions.lldb-dap"
    "ms-vscode.hexeditor"
    "icrawl.discord-vscode"
  ];

  settings = {
    "C_Cpp.clang_format_fallbackStyle" = "{ BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 0 }";

    "hexeditor.columnWidth" = 16;
    "hexeditor.showDecodedText" = true;
    "hexeditor.defaultEndianness" = "little";
    "hexeditor.inspectorType" = "aside";

    "editor.detectIndentation" = true;
    "[python]"."editor.formatOnType" = true;
  };
}
