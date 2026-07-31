{ config, ... }: {
  languages.nix.enable = true;

  enterShell = # sh
    ''
      export PATH="${config.devenv.root}/bin:''${PATH}"
    '';

  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    # Nix linting
    deadnix.enable = true;
    statix.enable = true;
    # General hygiene
    shellcheck.enable = true;
    check-yaml.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}
