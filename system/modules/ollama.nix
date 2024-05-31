{...}: {
  services.ollama = {
    enable = true;
    home = "/media/ollama";
    writablePaths = ["/media/ollama"];
    models = "/media/ollama/models";
  };
}
