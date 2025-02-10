{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/ghostty";
in {
  home.packages = [ pkgs.ghostty];
  programs.ghostty.enable = true;
  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/config";
}
