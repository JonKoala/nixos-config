{ config, pkgs, ... }:

{
  home.packages = [ pkgs.starship ];
  programs.starship.enable = true;
  home.file.".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink ./starship.toml; 
}
