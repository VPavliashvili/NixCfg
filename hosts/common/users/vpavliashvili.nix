{
  config,
  pkgs,
  inputs,
  lib,
  ...
} : {
  users.users.vpavliashvili = {
    isNormalUser = true;
    description = "vpavliashvili";

    # just avoidiong warnings after nixos rebuild
    # by settings uid to this value since its a third user created
    # on this host (first was automatically created named nixos with uid 1000)
    uid = lib.mkForce 1002; 
    extraGroups = [
      "networkmanager" 
      "wheel"
      "libvirtd"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
  };
}
