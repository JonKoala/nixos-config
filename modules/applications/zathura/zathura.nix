{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/zathura";
in {
  programs.zathura.enable = true;

  xdg.configFile."zathura/zathurarc".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/zathurarc";
}

