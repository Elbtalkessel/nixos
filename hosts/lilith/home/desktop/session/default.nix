# Session modules. This file is a barrel and must contain only `imports`.
_: {
  imports = [
    ./hyprland-session.nix
    ./hyprland.nix
    ./polkit-agent.nix
  ];
}
