{
  config,
  inputs,
  pkgs,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$os$username$hostname$directory$git_branch$git_commit$git_status$c$golang$haskell$java$julia$nodejs$nim$rust$scala$dotnet$docker_context$character";

      username = {
        show_always = true;
        format = "[$user ]($style)";
        disabled = false;
      };

      time = {
        format = "[$time]($style)";
        time_format = "%R";
        style = "fg:white";
        disabled = false;
      };

      hostname.format = "[$ssh_symbol$hostname ]($style)";

      fill.symbol = " ";

      c.symbol = " ";

      directory = {
        read_only = " ";
        format = "[$path ]($style)";
        truncation_length = 3;
        truncation_symbol = ".../";
      };

      docker_context.symbol = " ";
      fossil_branch.symbol = " ";
      git_branch.symbol = " ";

      git_commit = {
        commit_hash_length = 4;
        tag_symbol = "🔖 ";
      };

      git_status.format = "[$all_status$ahead_behind ]($style)";

      golang.symbol = " ";
      haskell.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      lua.symbol = " ";
      memory_usage.symbol = " ";
      meson.symbol = "喝 ";
      nim.symbol = " ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";

      os.symbols = {
        Alpine = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "﯑ ";
        Gentoo = " ";
        HardenedBSD = "ﲊ ";
        Illumos = " ";
        Linux = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = " ";
        openSUSE = " ";
        OracleLinux = " ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        Redox = " ";
        Solus = "ﴱ ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Windows = " ";
      };

      package.symbol = " ";
      pijul_channel.symbol = "🪺 ";
      python.symbol = " ";
      rlang.symbol = "ﳒ ";
      ruby.symbol = " ";
      rust.symbol = " ";
      scala.symbol = " ";
      spack.symbol = "🅢 ";
    };
  };
}
