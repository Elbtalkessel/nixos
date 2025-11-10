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
    _r="\e[0m"
    _i="\e[0;36;1m"
    _s="\e[0;240;1m"

    echo -e "$(cat <<-EOF
    🤫 ''${_i}chsecret''${_r} Edit secrets using sops
    🏠 ''${_i}switch''${_r} Switch to new home configuration
    🌍 ''${_i}sudo switch''${_r} ''${_s}[switch|boot|test|...]''${_r} Reconfigure NixOS
    🗑️ ''${_i}cleanup''${_r} Delete garbage
    📰 ''${_i}news''${_r} home manager news
    EOF
    )"
  '';
}
