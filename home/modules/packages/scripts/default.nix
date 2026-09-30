{ pkgs, ... }:
# Scripts I don't want put into nixpkgs-custom yet.
{
  home.packages = with pkgs; [
    # Shell scripts
    (nuenv.writeShellApplication {
      name = "lsd";
      text = builtins.readFile ./lsd.nu;
    })
    (nuenv.writeShellApplication {
      name = "hyprswitch";
      text = builtins.readFile ./hyprswitch.nu;
    })
    (nuenv.writeShellApplication {
      name = "hhget";
      text = builtins.readFile ./hhget.nu;
    })
    (nuenv.writeShellApplication {
      name = "youtrack-cli";
      text = builtins.readFile ./youtrack-cli.nu;
    })
    (nuenv.writeShellApplication {
      name = "sc";
      text = builtins.readFile ./sc.nu;
      runtimeInputs = [
        pkgs.scrcpy
        pkgs.android-tools
        pkgs.fzf
      ];
    })
    (writers.writePython3Bin "cctl" {
      flakeIgnore = [ "E501" ];
    } (builtins.readFile ./cctl.py))
    (nuenv.writeShellApplication {
      name = "yt-mm";
      text = builtins.readFile ./yt-mm.nu;
      runtimeInputs = [
        pkgs.yt-dlp
        pkgs.opustags
        pkgs.mpc
        pkgs.rsync
      ];
    })
    # nixpkgs ships vllm without CUDA (and marks the CUDA build broken),
    # so `vllm serve` runs the official CUDA image through the NVIDIA
    # container toolkit instead. See ./vllm.nu.
    (nuenv.writeShellApplication {
      name = "vllm";
      text = builtins.readFile ./vllm.nu;
      runtimeInputs = [
        pkgs.docker
      ];
    })
    # nixpkgs has no CUDA-enabled llama.cpp server build, so the script runs
    # the official server-cuda13 image and picks up the host NVIDIA driver
    # through the container toolkit CDI spec. See ./llamacpp.nu.
    (nuenv.writeShellApplication {
      name = "llamacpp";
      text = builtins.readFile ./llamacpp.nu;
      runtimeInputs = [
        pkgs.docker
        pkgs.fzf
      ];
    })
  ];
}
