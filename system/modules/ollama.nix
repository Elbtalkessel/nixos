_: {
  services.ollama = {
    enable = true;
    home = "/media/ollama";
    models = "/media/ollama/models";
    acceleration = "cuda";
  };
}
