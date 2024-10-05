{ config, pkgs, ... }:

{
  home.packages = [ pkgs.google-chrome ];
  home.file.".local/share/applications/google-chrome.desktop".source = config.lib.file.mkOutOfStoreSymlink ./google-chrome.desktop;
  programs.bash.shellAliases.chrome = "google-chrome-stable --use-angle=vulkan --use-cmd-decoder=passthrough --ozone-platform=wayland";
}
