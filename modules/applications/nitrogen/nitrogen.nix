{ config, pkgs, ... }:

{
  home.packages = [ pkgs.nitrogen ];
  home.file.".config/nitrogen/nitrogen.cfg" = {
    source = config.lib.file.mkOutOfStoreSymlink ./nitrogen.cfg;
    force = true;
  };
  home.file.".config/autostart/nitrogen.desktop" = {
    source = config.lib.file.mkOutOfStoreSymlink ./nitrogen.desktop;
    force = true;
  };
}
