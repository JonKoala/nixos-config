{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/ghostty";
in {
  programs.ghostty.enable = true;
  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/config";
}
