{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/neovim";
in {
  programs.neovim = {
    enable = true;

    plugins = [
      pkgs.vimPlugins.gruvbox-nvim
    ];
  };
  xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/init.lua";
}

