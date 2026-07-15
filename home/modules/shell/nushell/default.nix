{ config, lib, ... }:
{
  programs = rec {
    nushell = {
      enable = true;
      shellAliases = config.home.shellAliases;
      extraConfig =
        [
          # nu
          ''
            source ${./conf.d/config.nu}
            source ${./conf.d/comp/sshp.nu}
            use ${./conf.d/functions.nu} *
            # Workaround for https://github.com/nix-community/home-manager/issues/4313
            if (("__HM_SESS_VARS_SOURCED" in $env) and ($env.__HM_SESS_VARS_SOURCED != "1")) {
              open ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh | capture-foreign-env | load-env
            }
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
              use ${./conf.d/lib/equery.nu} *
            ''
        |> lib.strings.join "\n";
    };
    # Nushell autocomplete
    carapace = {
      inherit (nushell) enable;
    };
  };
}
