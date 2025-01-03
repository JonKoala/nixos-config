{ config, pkgs, ... }:

let
  settings = import ../../settings.nix;
  currentDir = "${settings.directories.dotfiles}/profiles/hyprland";

  cursorName = "Bibata-Modern-Classic";
in {

  home.username = "koala";
  home.homeDirectory = settings.directories.home;


  # packages

  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.fira-code-nerdfont
    pkgs.unzip
    pkgs.udiskie
    pkgs.papirus-icon-theme
    pkgs.bibata-cursors

    pkgs.waybar
    pkgs.hyprpaper
    pkgs.hyprcursor
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
    ../../modules/applications/google-chrome/google-chrome.nix
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
      };
    };

    waybar.enable = true;
    wofi.enable = true;
  };

  services = {
    mako.enable = true;
    hyprpaper.enable = true;
  };


  # theming

  home.pointerCursor = {
    name = cursorName;
    package = pkgs.bibata-cursors;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = cursorName;
    };
    gtk.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
      cursor-theme = cursorName;
    };
  };


  # other configurations

  xdg.configFile = {
    "home-manager/home.nix".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/home.nix";

    "hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/hyprland.conf";
    "hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/hyprpaper.conf";
  };

  home.sessionVariables = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.stateVersion = "24.05";

}
