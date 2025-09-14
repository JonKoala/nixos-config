{ config, pkgs, ... }:

{
  home.packages = [ pkgs.unityhub ];
  
  home.sessionVariables = {
    ASSETINVENTORY_CONFIG_PATH = "${(import ../../../settings.nix).directories.home}/.unity";
  };
}
