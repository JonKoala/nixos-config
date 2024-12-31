{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/git";
in {
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/.gitconfig";
}
