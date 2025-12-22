{ pkgs, config, ... }:
{
  # https://github.com/Jas-SinghFSU/HyprPanel?tab=readme-ov-file#optional
  home.packages = with pkgs; [
    brightnessctl
    pywal
    grimblast
    wf-recorder
    hyprpicker
    hyprsunset
    btop
    mutagen
    swww
  ];
  # TODO:
  #   - Use config.my.
  #   - Split into modules.
  #   - Automate unblocking config.json
  #     Maybe a wrapper script that will change ~/.config/hyprpanel/config.json from
  #     a symlink to a regualar file. After script exit translate
  #     updated config file into nix and prompt user to rebuild system
  #     removing current config.json.
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    settings = import ./settings { inherit config; };
  };
}
