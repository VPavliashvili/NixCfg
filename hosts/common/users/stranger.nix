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
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };
  home-manager.users.stranger = import stranger/${config.networking.hostName}.nix;
}
