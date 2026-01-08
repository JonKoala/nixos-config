{ config, pkgs, ... }:

{

  imports = [
    ../configuration.nix

    ../../modules/applications/podman/podman.nix
  ];

  home-manager.users.koala = import ./home.nix;
  home-manager.backupFileExtension = "backup";

  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.thunar.enable = true;
  services.udisks2.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time --time-format '%d/%m/%Y %H:%M:%S' --cmd start-hyprland";
  };

  programs.steam.enable = true;

  # activates numlock on bootup
  boot.initrd.preLVMCommands = ''
    ${pkgs.kbd}/bin/setleds +num
  '';

}

