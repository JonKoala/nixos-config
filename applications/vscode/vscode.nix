{ config, pkgs, ... }:

{
  home.packages = [ pkgs.vscode ];
  programs.vscode.enable = true;
  home.file.".config/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink ./settings.json; 
}
