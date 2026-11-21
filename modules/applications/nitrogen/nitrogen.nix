{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/nitrogen";
in {
  home.packages = [ pkgs.nitrogen ];
  xdg.configFile."nitrogen/nitrogen.cfg" = {
    source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/nitrogen.cfg";
    force = true;
  };
  xdg.configFile."autostart/nitrogen.desktop" = {
    source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/nitrogen.desktop";
    force = true;
  };
}
