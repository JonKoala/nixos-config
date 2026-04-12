{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/wezterm";
in {
  programs.wezterm.enable = true;

  xdg.configFile = {
    "wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/wezterm.lua";
    "wezterm/colorschemes.lua".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/colorschemes.lua";
  };
}
