{ config, pkgs, ... }:

{
  #source: https://nixos.wiki/wiki/Nvidia

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  # load the driver in the initrd (early KMS) so the greeter starts on the nvidia framebuffer
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
