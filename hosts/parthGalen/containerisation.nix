{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../common/modules/containerisation/docker
  ];

  containerisation = {
    docker = true;
  };
}
