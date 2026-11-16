{ config, pkgs, ... }:

{
  services.udiskie = {
    enable = true;

    # the tray option requires tray.target, and I don't care for it
    tray = "never";
  };
}
