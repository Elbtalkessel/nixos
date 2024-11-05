_: {
  scripts = {
    chsecret.exec = ''
      nix-shell -p sops --run "sops system/secrets/secrets.yaml"
    '';
  };
}
