{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/godot";
in {
  home.packages = [ pkgs.godot_4 ];
  home.file.".local/share/applications/org.godotengine.Godot4.desktop".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/godot.desktop";
  programs.bash.shellAliases.godot = "godot4 --display-driver wayland";
}
