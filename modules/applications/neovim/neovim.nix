{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/neovim";
in {
  home.packages = [
    pkgs.lua
    pkgs.lua-language-server
  ];
  programs.neovim = {
    enable = true;

    plugins = [
      pkgs.vimPlugins.snacks-nvim
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.yazi-nvim
      pkgs.vimPlugins.mini-icons
      pkgs.vimPlugins.lazydev-nvim
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };
  xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/init.lua";
  xdg.configFile."nvim/lsp/".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/lsp/";
}

