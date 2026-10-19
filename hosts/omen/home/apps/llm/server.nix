{ pkgs, ... }:
{
  # The CUDA build of ollama below pulls in an unfree CUDA runtime whose exact
  # attribute set moves with the nixpkgs pin, so the prefix rule stays a
  # predicate -- `allowUnfreePackages` matches whole names only.
  nixpkgs.config = {
    allowUnfreePackages = [ "libcublas" ];
  };

  services.ollama = {
    enable = false;
    package = pkgs.ollama-cuda;
  };
}
