{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/rofi";
in {
  home.packages = [ pkgs.rofi-wayland ];
  
  xdg.configFile."rofi/config.rasi".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/config.rasi";
  xdg.configFile."rofi/theme.rasi".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/theme.rasi";
}

