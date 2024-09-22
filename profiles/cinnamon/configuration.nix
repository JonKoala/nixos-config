{ config, pkgs, ... }:

{

  imports = [
    ../configuration.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    xkb = {
      layout = "us";
      variant = "intl";
    };
  };

  environment.systemPackages = [
    pkgs.papirus-icon-theme 
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      lockAll = true;
      settings = {
        "org/x/apps/portal" = { color-scheme = "prefer-dark"; };
        "org/cinnamon/theme" = { name = "Mint-Y-Dark-Sand"; };
        "org/cinnamon/desktop/interface" = {
          icon-theme = "Papirus-Dark";
          gtk-theme = "Mint-Y-Dark-Sand";
        };

        "org/cinnamon/desktop/applications/terminal" = { exec = "kitty"; };
      };
    }];
  };
}
