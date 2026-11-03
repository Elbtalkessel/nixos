{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellApplication {
      name = "gidged";
      runtimeInputs = with pkgs; [
        coreutils
        git
        gnused
        inetutils
      ];
      text = builtins.readFile ./gidged.bash;
    })
  ];
}
