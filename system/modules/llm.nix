_: {
  services.ollama = {
    enable = false;
    home = "/srv/nfs/personal/ollama";
    models = "/srv/nfs/personal/ollama/models";
    acceleration = "cuda";
  };
}
