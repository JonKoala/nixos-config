{ stdenvNoCC, stdenv, fetchurl, autoPatchelfHook }:

# Unity CLI, packaged from Unity's prebuilt binary.
# Run ./update.sh to bump version and sha256 to the latest stable release.
stdenvNoCC.mkDerivation rec {
  pname = "unity-cli";
  version = "1.0.1";

  src = fetchurl {
    url = "https://public-cdn.cloud.unity3d.com/hub/prod/cli/${version}/unity-linux-x64";
    sha256 = "a38e75631edde5b96df8e0a37e2eb8c8d1eb1a6ba30fd41c34f2baac793b5b31";
  };

  dontUnpack = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ]; # libgcc_s

  installPhase = ''
    install -Dm755 $src $out/bin/unity
  '';
}
