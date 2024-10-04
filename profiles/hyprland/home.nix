{ config, pkgs, ... }:

{
  
  home.username = "koala";
  home.homeDirectory = "/home/koala";


  # packages

  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.fira-code-nerdfont
    pkgs.google-chrome
    pkgs.unzip

    pkgs.waybar
    pkgs.hyprpaper
    pkgs.wofi

    pkgs.libnotify
    pkgs.mako
    pkgs.polkit-kde-agent
  ];
  imports = [
    ../../modules/applications/git/git.nix
    ../../modules/applications/kitty/kitty.nix 
    ../../modules/applications/vscode/vscode.nix
    ../../modules/applications/starship/starship.nix
  ];


  # package configurations

  programs = {

    home-manager.enable = true;

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = true;
      };
    };

    bash = {
      enable = true;
      shellAliases = {
        la = "ls -A";
        ll = "ls -lAFh";

        chrome = "google-chrome-stable";
      };
    };

    waybar.enable = true;
    wofi.enable = true;
  };

  services = {
    mako.enable = true;
    hyprpaper.enable = true;
  };


  # other configurations

  home.file = {
    ".config/home-manager/home.nix".source = config.lib.file.mkOutOfStoreSymlink ./home.nix;
 
    ".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink ./hyprland.conf;
  };
  xdg.configFile."hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink ./hyprpaper.conf;

  home.sessionVariables = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.stateVersion = "24.05";

}
