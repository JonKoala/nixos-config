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
    pkgs.nerd-fonts.fira-code
    pkgs.google-fonts
    pkgs.corefonts

    pkgs.udiskie
    pkgs.papirus-icon-theme
    pkgs.bibata-cursors

    pkgs.zip
    pkgs.unzip
    pkgs.gzip
    pkgs.gnutar

    pkgs.hyprpaper
    pkgs.hyprcursor

    pkgs.libnotify
    pkgs.kdePackages.polkit-kde-agent-1
    pkgs.wl-clipboard

    pkgs.aseprite
    pkgs.blender
  ];
  imports = [
    ../../modules/applications/git/git.nix
    ../../modules/applications/ghostty/ghostty.nix
    ../../modules/applications/godot/godot.nix
    ../../modules/applications/google-chrome/google-chrome.nix
    ../../modules/applications/kitty/kitty.nix
    ../../modules/applications/mako/mako.nix
    ../../modules/applications/neovim/neovim.nix
    ../../modules/applications/rofi/rofi.nix
    ../../modules/applications/starship/starship.nix
    ../../modules/applications/unityhub/unityhub.nix
    ../../modules/applications/vscode/vscode.nix
    ../../modules/applications/vesktop/vesktop.nix
    ../../modules/applications/waybar/waybar.nix
    ../../modules/applications/yazi/yazi.nix
    ../../modules/applications/zathura/zathura.nix
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
  };

  services = {
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

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.stateVersion = "24.05";

}
