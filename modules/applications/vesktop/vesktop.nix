{ config, pkgs, ... }:

let
  currentDir = "${import ../pwd.nix}/vesktop";
in {
  programs.vesktop.enable = true;
  programs.vesktop.settings.spellCheckLanguages = [ "en-US" "pt-BR" ];
  programs.vesktop.vencord.settings.enabledThemes = [ "theme.css" ];

  # temporary solution, until https://github.com/NixOS/nixpkgs/pull/476347 is merged into nixpkgs-unstable
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.overrideAttrs (old: {
        preBuild = ''
          cp -r ${prev.electron.dist} electron-dist
          chmod -R u+w electron-dist
        '';
        buildPhase = ''
          runHook preBuild

          pnpm build
          pnpm exec electron-builder \
            --dir \
            -c.asarUnpack="**/*.node" \
            -c.electronDist="electron-dist" \
            -c.electronVersion=${prev.electron.version}

          runHook postBuild
        '';
      });
    })
  ];
  
  xdg.configFile."vesktop/themes/theme.css".source = config.lib.file.mkOutOfStoreSymlink "${currentDir}/theme.css";
}

