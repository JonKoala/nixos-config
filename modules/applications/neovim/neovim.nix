{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/neovim";
in {
  programs.neovim = {
    enable = true;

    plugins = [
      pkgs.vimPlugins.snacks-nvim
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.yazi-nvim
      pkgs.vimPlugins.mini-icons
    ];
  };
  xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/init.lua";
}

