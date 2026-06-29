{
  hosts = {
    dorthonion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg420Po/NOUvn4zWJBCZ2qsy7Kkai+lRlqnBQ8n9I++ root@dorthonion";
    rivendell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICMkIcZXUOMZ5P7QyXV0F+goMum/ALMX0GtwXX8dVntB root@rivendell";
    parthgalen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8+oqruLUHAXG/AYTpIN6XkcwAw6YQIRGLixdIZ30/w root@parthGalen";
    moria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQlX/vyRZ2VFB7YhE+33F2AUfTGd/E5jl6C49Pei5h1 root@moria";
  };

  users = {
    stranger = {
      parthGalen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTpUGhWJtqnQ6xgdgIdVrm++gFlwrtCIORH4PvZ7gD8 stranger-key-parthGalen";
      dorthonion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4ZfV5TFJndan43XMw2J0VWimaWSIt2+GMAtRdq+cml stranger-key-dorthonion";
    };
  };
}
