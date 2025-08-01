{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/mako";
in {
  services.mako.enable = true;
  
  xdg.configFile."mako/config".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/config";
}

