{ config, pkgs, ... }:

let
  settings = import ../../settings.nix;
  currentDir = "${settings.directories.dotfiles}/profiles/hyprland";

  cursorName = "Bibata-Modern-Classic";
in {

  home.username = "koala";
  home.homeDirectory = settings.directories.home;


  # applications

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.google-fonts
    pkgs.corefonts

    pkgs.papirus-icon-theme
    pkgs.bibata-cursors

    pkgs.hyprpaper
    pkgs.hyprcursor

    pkgs.libnotify
    pkgs.kdePackages.polkit-kde-agent-1
    pkgs.wl-clipboard

    pkgs.udiskie

    pkgs.zip
    pkgs.unzip
    pkgs.gzip
    pkgs.gnutar

    pkgs.aseprite
    pkgs.blender
  ];
  programs = {
    home-manager.enable = true;

    obsidian.enable = true;

    google-chrome.enable = true;
    imv.enable = true;
  };

  imports = [
    ../../modules/applications/ghostty/ghostty.nix
    ../../modules/applications/git/git.nix
    ../../modules/applications/godot/godot.nix
    ../../modules/applications/kitty/kitty.nix
    ../../modules/applications/mako/mako.nix
    ../../modules/applications/neovim/neovim.nix
    ../../modules/applications/rofi/rofi.nix
    ../../modules/applications/starship/starship.nix
    ../../modules/applications/unityhub/unityhub.nix
    ../../modules/applications/vesktop/vesktop.nix
    ../../modules/applications/vscode/vscode.nix
    ../../modules/applications/waybar/waybar.nix
    ../../modules/applications/yazi/yazi.nix
    ../../modules/applications/wezterm/wezterm.nix
    ../../modules/applications/zathura/zathura.nix
  ];

  programs = {
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
  };

  services = {
    hyprpaper.enable = true;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/plain" = "code.desktop";
    "text/html" = "code.desktop";
    "text/markdown" = "code.desktop";
    "application/x-shellscript" = "code.desktop";

    "x-scheme-handler/http" = "google-chrome.desktop";
    "x-scheme-handler/https" = "google-chrome.desktop";
    "x-scheme-handler/about" = "google-chrome.desktop";
    "x-scheme-handler/unknown" = "google-chrome.desktop";

    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
    "image/avif" = "imv.desktop";
    "image/x-icon" = "imv.desktop";

    "application/pdf" = "org.pwmt.zathura.desktop";
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
