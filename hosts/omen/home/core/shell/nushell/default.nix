{ config, lib, ... }:
{
  programs = rec {
    nushell = {
      enable = true;
      shellAliases = config.home.shellAliases;
      loadSessionVariables = true;
      extraConfig =
        [
          # nu
          ''
            source ${./conf.d/config.nu}
            source ${./conf.d/comp/sshp.nu}
            use ${./conf.d/functions.nu} *
          ''
        ]
        ++
          lib.optional config.programs.zoxide.enable # nu
            ''
              source ${./conf.d/comp/zoxide.nu}
            ''
        ++
          lib.optional config.programs.notmuch.enable # nu
            ''
              source ${./conf.d/comp/notmuch.nu}
              use ${./conf.d/lib/equery.mod.nu} *
            ''
        ++
          lib.optional config.programs.devenv.enable # nu
            ''
              source ${./conf.d/comp/devenv.nu}
            ''
        |> lib.strings.join "\n";
    };
    # Nushell autocomplete
    carapace = {
      inherit (nushell) enable;
    };
  };
}
