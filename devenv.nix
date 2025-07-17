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
    echo "Available commands:"
    echo " - chsecret: Edit secrets using sops"
    echo " - switch: Switch to new home configuration"
    echo " - sudo switch [switch|boot|test|...]: Reconfigure NixOS"
    echo " - cleanup: Delete garbage"
    echo " - generations: Availabel NixOS generations."
  '';
}
