{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/zathura";
in {
  programs.zathura.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications."application/pdf" = [ "org.pwmt.zathura.desktop" ];

  xdg.configFile."zathura/zathurarc".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/zathurarc";
}

