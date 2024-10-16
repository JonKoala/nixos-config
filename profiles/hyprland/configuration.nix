{ config, pkgs, ... }:

{

  imports = [
    ../configuration.nix
  ];

  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.thunar.enable = true;
  services.udisks2.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --time-format '%d/%m/%Y %H:%M:%S' --cmd hyprland";
  }; 

  # activates numlock on bootup
  boot.initrd.preLVMCommands = ''
    ${pkgs.kbd}/bin/setleds +num
  '';

}

