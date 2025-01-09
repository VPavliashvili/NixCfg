{
  config,
  pkgs,
  inputs,
  ...
} : {
  users.users.stranger = {
    isNormalUser = true;
    description = "strager";
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
