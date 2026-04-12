{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/google-chrome";
in {
  programs.google-chrome.enable = true;

  home.file.".local/share/applications/google-chrome.desktop" = {
    source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/google-chrome.desktop";
    force = true;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "google-chrome.desktop" ];
    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/about" = "google-chrome.desktop";
    "x-scheme-handler/unknown" = "google-chrome.desktop";
  };

  programs.bash.shellAliases.chrome = "google-chrome-stable";
}
