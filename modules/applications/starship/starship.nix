{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/starship";
in {
  home.packages = [ pkgs.starship ];
  programs.starship.enable = true;
  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/starship.toml";
}
