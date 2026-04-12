{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/yazi";
in {
  programs.yazi = {
    enable = true;

    # default configuration (setting to hide nixos evaluation warnings)
    shellWrapperName = "y";
  };

  xdg.configFile."yazi/yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/yazi.toml";
  xdg.configFile."yazi/theme.toml".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/theme.toml";
  xdg.configFile."yazi/flavors/".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/flavors/";
}

