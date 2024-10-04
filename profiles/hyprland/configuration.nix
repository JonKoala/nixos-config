{ config, pkgs, ... }:

{

  imports = [
    ../configuration.nix
  ];

  environment.systemPackages = [
    pkgs.papirus-icon-theme
  ];


  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.thunar.enable = true;

  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          icon-theme = "Papirus-Dark";
          color-scheme = "prefer-dark";
        };
      };
    }];
  };

}

