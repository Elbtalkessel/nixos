{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Shell scripts
    (nuenv.writeShellApplication {
      name = "lsd";
      text = builtins.readFile ../../bin/lsd.nu;
    })
    (nuenv.writeShellApplication {
      name = "hyprswitch";
      text = builtins.readFile ../../bin/hyprswitch.nu;
    })
  ];
}
