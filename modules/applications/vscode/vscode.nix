{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/vscode";
in {
  programs.vscode.enable = true;

  xdg.configFile."Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/settings.json"; 
}
