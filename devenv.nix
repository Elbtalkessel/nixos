_: {
  scripts = {
    chsecret.exec = ''
      nix-shell -p sops --run "sops system/secrets/secrets.yaml"
    '';
    switch.exec = ''
      if [ $(whoami) = "root" ]
      then 
        nixos-rebuild ''${1:-switch} --flake ./ --accept-flake-config
      else
        home-manager switch --flake ./
      fi
    '';
    cleanup.exec = ''
      nix-collect-garbage -d
    '';
    generations.exec = ''
      nix profile history --profile /nix/var/nix/profiles/system
    '';
    news.exec = ''
      home-manager news --flake ./
    '';
  };
  enterShell = ''
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
    🗑️ $(info 'cleanup') Delete garbage.
    📰 $(info 'news') Home Manager news.
    EOF
    )"
  '';
}
