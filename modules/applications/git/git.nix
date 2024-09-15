{ config, pkgs, ... }:

{
  home.packages = [ pkgs.git ];
  programs.git.enable = true;
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink ./.gitconfig;
}
