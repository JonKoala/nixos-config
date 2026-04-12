{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/godot";
in {
  home.packages = [
    pkgs.godot_4_4
    pkgs.godot_4_4-mono
  ];

  programs.bash.shellAliases.godot = "godot4.4-mono --display-driver wayland";

  home.file.".local/share/applications/org.godotengine.Godot4.desktop".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/godot.desktop";
  home.file.".local/share/applications/org.godotengine.Godot4.4-mono.desktop".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/godot4.4-mono.desktop";
  home.file.".local/share/applications/org.godotengine.Godot4.4.desktop".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/godot4.4.desktop";
}
