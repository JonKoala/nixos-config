{ config, pkgs, ... }:

{
  home.packages = [ pkgs.kitty ];
  programs.kitty.enable = true;
  xdg.configFile."kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink ./kitty.conf;
  home.file.".config/kitty/current-theme.conf".source = config.lib.file.mkOutOfStoreSymlink ./current-theme.conf; 
}
