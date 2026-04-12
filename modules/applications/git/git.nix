{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/git";
in {
  programs.git = {
    enable = true;

    # default configuration (setting to hide nixos evaluation warnings)
    signing.format = null;
  };

  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/.gitconfig";
}
