{ config, pkgs, inputs, ... }:

{

  imports = [
    ../hardware-configuration.nix
    ../modules/hardware/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/run/media/koala/DATA" = {
    device = "dev/disk/by-uuid/ced7785d-9cf5-4a40-8f65-f156dc7b1a1e";
    options = ["nofail"];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # define user account
  users.users.koala = {
    isNormalUser = true;
    description = "Jon Koala";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # enable sound with pipewire
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # packages & package configurations
  nixpkgs.config.allowUnfree = true;
  services.printing.enable = true;
  programs.firefox.enable = true;
  environment.systemPackages = [
    pkgs.vim
    pkgs.home-manager
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  system.stateVersion = "24.05";

}
