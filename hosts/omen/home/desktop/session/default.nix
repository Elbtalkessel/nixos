# Session modules. This file is a barrel and must contain only `imports`.
{
  imports = [
    ./hyprland-session.nix
    ./hyprland.nix
    ./polkit-agent.nix
  ];
}
