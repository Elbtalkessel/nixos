{ pkgs, ... }:
rec {

  packages = [
    pkgs.nixfmt
    # TODO(pipe): use https://github.com/molybdenumsoftware/statix to support pipes.
    #pkgs.statix
    pkgs.deadnix
  ];

  languages.nix.enable = true;

  scripts = {
    chsecret = {
      exec = # sh
        ''
          nix-shell -p sops --run "sops system/secrets/secrets.yaml"
        '';
      description = "Edit secrets using sops.";
    };
    switch = {
      exec = # sh
        ''
          if [ $(whoami) = "root" ]
          then
            nixos-rebuild ''${1:-switch} --flake ./ --accept-flake-config
          else
            home-manager switch --flake ./
          fi
        '';
    };
    rollback = {
      exec = # sh
        ''
          home-manager switch --rollback --flake ./
        '';
      description = "Rollback to a previous HM generation.";
    };
    cleanup = {
      exec = # sh
        ''
          nix-collect-garbage -d
        '';
      description = "Delete garbage, will remove inactive HM configurations.";
    };
    generations = {
      exec = # sh
        ''
          nix profile history --profile /nix/var/nix/profiles/system
        '';
      description = "System generations.";
    };
    news = {
      exec = # sh
        ''
          home-manager news --flake ./
        '';
      description = "Home Manager news.";
    };
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
    hm-squash = {
      exec = # nu
        ''
          home-manager generations
          | lines
          | parse '{date} {time} : id {id} -> {path}'
          | group-by date --to-table
          | get items
          | each {|g| $g | slice 1..}
          | flatten
          | each {|it| home-manager remove-generations $it.id}
        '';
      package = pkgs.nushell;
      binary = "nu";
      description = "Removes generations leaving 1 per day.";
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
      🤫 $(info 'chsecret') ${scripts.chsecret.description}
      🏠 $(info 'switch') Switch to the new home configuration.
      🌍 $(info 'sudo switch') $(bold '[switch|boot|test|...]') Reconfigure NixOS.
      ♻️ $(info 'rollback') ${scripts.rollback.description}
      🗑️ $(info 'cleanup') ${scripts.cleanup.description}
      🔥 $(info 'hm-squash') ${scripts.hm-squash.description}
      📰 $(info 'news') ${scripts.news.description}
      🔧 $(info 'fix-nix') ${scripts.fix-nix.description}
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
