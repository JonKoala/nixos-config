{ pkgs, ... }:

{
  home.packages = [
    (pkgs.unityhub.override {
      extraLibs = pkgs: [
        # hack for Unity 6000.6+
        # UnityShaderCompiler needs libncursesw.so.6, but named as libtinfo.so.6
        (pkgs.runCommand "libtinfo-compat" { nativeBuildInputs = [ pkgs.patchelf ]; } ''
          mkdir -p $out/lib
          cp ${pkgs.ncurses}/lib/libncursesw.so.6 $out/lib/libtinfo.so.6
          chmod +w $out/lib/libtinfo.so.6
          patchelf --set-soname libtinfo.so.6 $out/lib/libtinfo.so.6
        '')
      ];
    })
  ];
  
  home.sessionVariables = {
    ASSETINVENTORY_CONFIG_PATH = "${(import ../../../settings.nix).directories.home}/.unity";
  };
}
