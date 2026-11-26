{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/claude-code";

  # extra tools available only inside claude-code
  extra-tools = pkgs.symlinkJoin {
    inherit (pkgs.claude-code) pname version meta;
    paths = [ pkgs.claude-code ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --suffix PATH : ${pkgs.lib.makeBinPath [ pkgs.python3 ]}
    '';
  };
in {
  programs.claude-code.enable = true;
  programs.claude-code.package = extra-tools;

  home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/settings.json";
  home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/CLAUDE.md";
  home.file.".claude/themes".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/themes";
  home.file.".claude/skills/aseprite".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/skills/aseprite";
}
