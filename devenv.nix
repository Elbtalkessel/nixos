_: {
  scripts = {
    chsecret.exec = ''
      nix-shell -p sops --run "sops system/secrets/secrets.yaml"
    '';
    switch.exec = ''
      if [ $(whoami) = "root" ]
      then 
        nixos-rebuild switch --flake ./
      else
        home-manager switch --flake ./
      fi
    '';
    cleanup.exec = ''
      nix-collect-garbage -d
    '';
  };
}
