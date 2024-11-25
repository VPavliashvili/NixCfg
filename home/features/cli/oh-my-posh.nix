{
  config,
  lib,
  unstable,
  ...
}:
let
  cfg = config.features.cli.oh-my-posh;
in {
  options.features.cli.oh-my-posh.enable = lib.mkEnableOption "enable oh-my-posh in bash";

  config = lib.mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      package = unstable.oh-my-posh;
      settings = builtins.fromJSON ''
        {
          "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
          "blocks": [
            {
              "alignment": "left",
              "segments": [
                {
                  "foreground": "#61AFEF",
                  "style": "plain",
                  "template": "[<#ABB2BF>󱩊 </>{{ .UserName }}<#ABB2BF> </>from {{ .HostName }}<#ABB2BF> ",
                  "type": "session"
                },
                {
                  "properties": {
                    "root_icon": ""
                  },
                  "style": "diamond",
                  "template": "",
                  "type": "root"
                },
                {
                  "foreground": "#ffa5d8",
                  "style": "plain",
                  "template": "[]",
                  "type": "root"
                }
              ],
              "type": "prompt"
            },
            {
              "alignment": "left",
              "segments": [
                {
                  "foreground": "#7eb8da",
                  "properties": {
                    "style": "full"
                  },
                  "style": "plain",
                  "template": "<#98C379>{{ .Path }}</>]",
                  "type": "path"
                }
              ],
              "type": "prompt"
            },
            {
              "alignment": "left",
              "newline": true,
              "segments": [
                {
                  "foreground": "#7eb8da",
                  "style": "plain",
                  "template": "└ ",
                  "type": "text"
                }
              ],
              "type": "prompt"
            }
          ],
          "final_space": true,
          "version": 2
        }
      '';
    };
  };
}
