{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../common/modules/containerisation/docker
    ../common/modules/containerisation/kubernetes
  ];

  containerisation = {
    docker = true;
    minikube = true;
  };
}
