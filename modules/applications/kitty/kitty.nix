{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/kitty";
in {
  home.packages = [ pkgs.kitty ];
  programs.kitty.enable = true;
  xdg.configFile = {
    "kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/kitty.conf";
    "kitty/current-theme.conf".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/current-theme.conf";
  };
}
