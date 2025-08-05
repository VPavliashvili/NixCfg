{
  config,
  pkgs,
  inputs,
  ...
} : {
  users.users.vpavliashvili = {
    isNormalUser = true;
    description = "vpavliashvili";
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
