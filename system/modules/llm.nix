{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    home = "/media/ollama";
    models = "/media/ollama/models";
    acceleration = "cuda";
  };
  # https://github.com/Janrupf/stable-diffusion-webui-nix?tab=readme-ov-file#using-this-flake
  environment.systemPackages = [
    # stable-diffusion-webui command
    pkgs.stable-diffusion-webui.forge.cuda
    # pkgs.stable-diffusion-webui.comfy.cuda
  ];
}
