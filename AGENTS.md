# Dotfiles

NixOS flake + home-manager config for a single machine (hyprland profile).

## Layout
- settings.nix — active profile, paths
- profiles/<name>/ — system (configuration.nix) + user (home.nix) per desktop
- modules/applications/<app>/ — per-app modules, only for apps that need raw config
  files or some configuration of their own: <app>.nix + config files
- Apps that just need installing go directly in profiles/hyprland/home.nix
  (home.packages, or programs.<app>.enable) — no module needed

## Commands
 - Never run nix-related commands (nix, nixos-rebuild, nix-shell, home-manager,
etc.). Suggest them; the user runs them.

## Conventions
- Config files are linked via mkOutOfStoreSymlink → edits apply without rebuild;
  adding or changing links needs a rebuild
- Commit messages: lowercase, short, clauses separated by ";"
- Gruvbox theme everywhere

## Gotchas
- hyprland.lua window rules for Unity/Steam/Aseprite menus; startup hack for chrome/vesktop

