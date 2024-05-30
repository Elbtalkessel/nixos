{pkgs, ...}: {
  # https://devenv.sh/basics/
  #env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [pkgs.git];

  # https://devenv.sh/scripts/
  scripts.collect-garbadge.exec = ''
    sudo nix-collect-garbage -d
    sudo nixos-rebuild switch --flake ./
  '';

  scripts.build-home.exec = ''
    nix flake lock --update-input nixvim
    home-manager switch --flake ./
  '';

  #enterShell = ''
  #'';

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
