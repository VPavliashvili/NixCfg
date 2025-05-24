{prev}:
prev.looking-glass-client.overrideAttrs(oldAttrs: rec {
  pname = oldAttrs.pname;
  version = "B7";

  src = prev.fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "sha256-I84oVLeS63mnR19vTalgvLvA5RzCPTXV+tSsw+ImDwQ=";
    fetchSubmodules = true;
  };
})
