# creating this overlay because nixpkgs does not
# offer last stable version of looking glass(.i.e B6)
{prev}:
prev.looking-glass-client.overrideAttrs(oldAttrs: rec {
  pname = oldAttrs.pname;
  version = "B6";

  src = prev.fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "sha256-6vYbNmNJBCoU23nVculac24tHqH7F4AZVftIjL93WJU=";
    fetchSubmodules = true;
  };
  
  patches = [];
})
