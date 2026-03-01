{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/waybar";
in {
  home.packages = [
    pkgs.lm_sensors
  ];
  programs.waybar.enable = true;
  xdg.configFile = {
    "waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/config.jsonc";
    "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/style.css";
    "waybar/cpu-temp.sh".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/cpu-temp.sh";
  };
}

