{pkgs, ...}: {
  # https://devenv.sh/basics/
  #env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [pkgs.git];

  # https://devenv.sh/scripts/
  scripts = {
    gc.exec = ''
      sudo nix-collect-garbage -d
    '';
    update-input.exec = ''
      nix flake lock --update-input nixvim
    '';
    build.exec = ''
      home-manager switch --flake ./config/
      sudo nixos-rebuild switch --flake ./config/
    '';
    home.exec = ''
      home-manager switch --flake ./config/
    '';
  };

  enterShell = ''
    echo "gc - Collect garbage"
    echo "build - Build home and system"
    echo "home - Build home"
    echo "update-input - ..."
  '';

  # https://devenv.sh/tests/
  #enterTest = ''
  #'';

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
