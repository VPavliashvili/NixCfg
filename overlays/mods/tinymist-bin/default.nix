# this is temporary overlay, after nixos
# 26.11 release i will updating the flake
# and this overlays will become obsolete
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "tinymist";
  version = "0.15.2";
  src = fetchurl {
    url = "https://github.com/Myriad-Dreamin/tinymist/releases/download/v${version}/tinymist-linux-x64";
    hash = "sha256-9eJ1xiiaXEtFyiEaveMp3WYrA/LErKIpnWwVS4ETVoQ=";
  };
  dontUnpack = true;
  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.lib];
  installPhase = ''
    install -Dm755 $src $out/bin/tinymist
  '';
}
