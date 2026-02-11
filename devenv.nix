{ pkgs, ... }:
{

  packages = [
    pkgs.nixfmt
    # TODO(pipe): use https://github.com/molybdenumsoftware/statix to support pipes.
    #pkgs.statix
    pkgs.deadnix
  ];

  languages.nix.enable = true;

  scripts = {
    chsecret.exec = # sh
      ''
        nix-shell -p sops --run "sops system/secrets/secrets.yaml"
      '';
    switch.exec = # sh
      ''
        if [ $(whoami) = "root" ]
        then
          nixos-rebuild ''${1:-switch} --flake ./ --accept-flake-config
        else
          home-manager switch --flake ./
        fi
      '';
    rollback.exec = # sh
      ''
        home-manager switch --rollback --flake ./
      '';
    cleanup.exec = # sh
      ''
        nix-collect-garbage -d
      '';
    generations.exec = # sh
      ''
        nix profile history --profile /nix/var/nix/profiles/system
      '';
    news.exec = # sh
      ''
        home-manager news --flake ./
      '';
    fix-nix = {
      exec = # sh
        ''
          echo "Running statix fix..."
          statix fix .
          echo "Running deadnix..."
          deadnix --edit .
          echo "Running nixfmt..."
          find . -type f -name '*.nix' | xargs -I{} nixfmt {}
          echo "Nix files fixed!"
        '';
      description = "Automatically fix linting, dead code, and formatting in .nix files.";
    };
  };

  enterShell = # sh
    ''
      _w=$(tput cols)
      hr() {
        printf '%*s\n' "$_w"  | tr ' ' '-'
      }
      info() {
        printf "\e[0;36;1m$1\e[0m"
      }
      bold() {
        printf "\e[0;240;1m$1\e[0m"
      }

      hr
      info '🏠 Home generations\n'
      home-manager generations
      hr
      info '🌍 System generations\n'
      nix profile history --profile /nix/var/nix/profiles/system
      hr

      echo -e "$(cat <<-EOF
      🤫 $(info 'chsecret') Edit secrets using sops.
      🏠 $(info 'switch') Switch to the new home configuration.
      🌍 $(info 'sudo switch') $(bold '[switch|boot|test|...]') Reconfigure NixOS.
      ♻️ $(info 'rollback') Rollback to a previous HM generation.
      🗑️ $(info 'cleanup') Delete garbage, will remove inactive HM configurations.
      📰 $(info 'news') Home Manager news.
      🔧 $(info 'fix-nix') *.nix files auto-formatting.
      EOF
      )"
    '';

  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    # Nix linting
    deadnix.enable = true;
    # TODO(pipe): use https://github.com/molybdenumsoftware/statix to support pipes.
    # statix.enable = true;
    # General hygiene
    shellcheck.enable = true;
    check-yaml.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}
