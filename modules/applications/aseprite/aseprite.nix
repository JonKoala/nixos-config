{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/aseprite";
in {
  home.packages = [ pkgs.aseprite ];

  xdg.configFile."aseprite/scripts/claude-bridge.lua".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/claude-bridge.lua";
}
