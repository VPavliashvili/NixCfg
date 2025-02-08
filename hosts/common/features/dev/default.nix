{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.features.dev;
in {
  options.features.dev = {
    go = mkOption {
      type = types.bool;
      default = true;
      description = "enable go dev tools and support to build source code";
    };
    python = mkOption {
      type = types.bool;
      default = true;
      description = "enable python dev tools and support to run scripts";
    };
    nix = mkOption {
      type = types.bool;
      default = true;
      description = "enable nix language dev tools";
    };
    lua = mkOption {
      type = types.bool;
      default = true;
      description = "enable lua dev tools";
    };
    c_lang = mkOption {
      type = types.bool;
      default = true;
      description = "enable tools related to c language";
    };
    dotnet = mkOption {
      type = types.bool;
      default = true;
      description = "enable dotnet runtime and c# language support";
    };
    database = {
      dbms = {
        dbeaver = {
          enable = mkEnableOption "enable dbeaver";
        };
      };
    };
  };

  config = {
    environment.systemPackages =
      [
        pkgs.git
        pkgs.gnumake
      ]
      ++ (optionals cfg.go [
        pkgs.go
        pkgs.gopls
        pkgs.delve
      ])
      ++ (optionals cfg.python [
        pkgs.python3
      ])
      ++ (optionals cfg.nix [
        pkgs.alejandra
      ])
      ++ (optionals cfg.lua [
        pkgs.lua-language-server
        pkgs.stylua
      ])
      ++ (optionals cfg.c_lang [
        pkgs.clang-tools
        pkgs.gcc
      ])
      ++ (optionals cfg.dotnet [
        # build tools and dlls for lsp type definitions
        pkgs.dotnet-sdk
        pkgs.dotnet-runtime
        pkgs.dotnet-aspnetcore

        # formatter, lsp and debugger for neovim
        pkgs.csharpier
        pkgs.roslyn-ls
        pkgs.netcoredbg
      ])
      ++ (optionals cfg.database.dbms.dbeaver.enable [
        pkgs.dbeaver-bin
      ]);
  };
}
