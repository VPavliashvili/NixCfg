{
  config,
  lib,
  sshpub,
  ...
}:
let
  cfg = config.features.cli.git;
in {
  options.features.cli.git = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "user name for git";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "email name for git";
    };
    useSshSign = lib.mkOption {
      type = lib.types.bool;
      description = "whether to use ssh for git sign and auth";
    };
  };

  config = {
    # * means to attach this public key for any email address
    home.file.".ssh/allowed_signers" = lib.mkIf cfg.useSshSign {
      text = "${cfg.email} ${sshpub}";
    };

    programs.git = {
      enable = true;
      userName = cfg.name;
      userEmail = cfg.email;
      aliases = {
        graph = "log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --all --graph --date=relative";
        lgraph = "log --pretty='%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s' --all --decorate --graph";
      };
      extraConfig = lib.mkMerge [
        { }
        (lib.mkIf cfg.useSshSign {
          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          };
          user = {
            signingkey = "/home/${config.home.username}/.ssh/id_ed25519.pub";
          };
          commit = {
            gpgSign = true;
          };
        })
      ];
    };
  };
}
