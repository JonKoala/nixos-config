{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/claude-code";
in {
  programs.claude-code.enable = true;

  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/settings.json";
}
