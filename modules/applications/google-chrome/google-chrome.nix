{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/google-chrome";
in {
  home.packages = [ pkgs.google-chrome ];
  home.file.".local/share/applications/google-chrome.desktop".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/google-chrome.desktop";
  programs.bash.shellAliases.chrome = "google-chrome-stable";
}
