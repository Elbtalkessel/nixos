{...}: {
  services.ollama = {
    enable = true;
    home = "/media/ollama";
    acceleration = "cuda";
    writablePaths = ["/media/ollama"];
  };
}
