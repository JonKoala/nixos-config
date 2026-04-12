{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/vesktop";
in {
  programs.vesktop = {
    enable = true;

    settings.spellCheckLanguages = [ "en-US" "pt-BR" ];
    vencord.settings.enabledThemes = [ "theme.css" ];
  };

  xdg.configFile."vesktop/themes/theme.css".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/theme.css";
}

