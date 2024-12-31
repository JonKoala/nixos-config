{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/vscode";
in {
  home.packages = [ pkgs.vscode ];
  programs.vscode.enable = true;
  xdg.configFile."Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/settings.json"; 
}
