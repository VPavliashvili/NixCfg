# just in case bleeding edge looking glass version
{prev}:
prev.stdenv.mkDerivation {
  pname = "looking-glass-client";
  version = "7f31ecf";

  src = prev.fetchgit {
    url = "https://github.com/gnif/LookingGlass";
    rev = "7f31ecf5e572ecdfa64306be76e49ee537f5fdbf";
    hash = "sha256-l4TtW1g1bxCCEmgxBDikysV2c3NoXSBGV7FiWMz3ojg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    prev.cmake
    prev.pkg-config
    prev.wayland-scanner
  ];

  buildInputs = [
    prev.libx11
    prev.libGL
    prev.freefont_ttf
    prev.spice-protocol
    prev.expat
    prev.libbfd
    prev.nettle
    prev.fontconfig
    prev.libffi
    prev.libxkbcommon
    prev.libxi
    prev.libxscrnsaver
    prev.libxinerama
    prev.libxcursor
    prev.libxpresent
    prev.libxext
    prev.libxrandr
    prev.libxdmcp
    prev.wayland
    prev.wayland-protocols
    prev.pipewire
    prev.pulseaudio
    prev.libsamplerate
    prev.xorg.libxcb
  ];

  cmakeFlags = [
    "-DOPTIMIZE_FOR_NATIVE=OFF"
  ];

  postUnpack = ''
    echo "7f31ecf5e572ecdfa64306be76e49ee537f5fdbf" > LookingGlass-7f31ecf/VERSION
    sourceRoot="LookingGlass-7f31ecf/client"
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp $src/resources/lg-logo.png $out/share/pixmaps
  '';

  meta = prev.looking-glass-client.meta;
}
