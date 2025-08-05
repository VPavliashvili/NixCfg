{
  config,
  lib,
  mainUser,
  ...
}: 
let
  userFiles = {
    stranger = [ ./stranger.nix ];
    vpavliashvili = [ ./vpavliashvili.nix ];
  };
in {
  imports = userFiles.${mainUser} 
    or (throw "mainUser argument was not set properly from flake.nix. got '${mainUser}' instead.");
}
