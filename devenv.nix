_: {
  scripts = {
    chsecret.exec = ''
      nix-shell -p sops --run "sops system/secrets/secrets.yaml"
    '';
    switch.exec = ''
      if [ $(whoami) = "root" ]
      then 
        nixos-rebuild ''${1:-switch} --flake ./
      else
        home-manager switch --flake ./
      fi
    '';
    cleanup.exec = ''
      nix-collect-garbage -d
    '';
    nixos-generations.exec = ''
      nix profile history --profile /nix/var/nix/profiles/system
    '';
  };
}
