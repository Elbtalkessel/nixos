{ pkgs, ... }:
# Scripts I don't want put into nixpkgs-custom yet.
{
  home.packages = with pkgs; [
    kitty
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
  ];
}
