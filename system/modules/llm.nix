_: {
  services.ollama = {
    enable = false;
    home = "/media/ollama";
    models = "/media/ollama/models";
    acceleration = "cuda";
  };
}
