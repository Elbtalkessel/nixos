{ config, ... }:
{
  programs = rec {
    nushell = {
      enable = true;
      shellAliases = config.home.shellAliases;
      extraConfig = # nu
        ''
          # Stolen from https://github.com/Lykos153/nixos/commit/b7f94990ab609a5bd2c2f609871c54d4d0bfbd27#diff-42b53d787a6bf3b5085510148bb366a388802be980474f607845ff3d6671bbfc
          source ${./conf.d/config.nu}
          source ${./conf.d/comp/sshp.nu}
          ${if config.programs.zoxide.enable then "source ${./conf.d/comp/zoxide.nu}" else ""}
          use ${./conf.d/functions.nu} *

          # Workaround for https://github.com/nix-community/home-manager/issues/4313
          if (("__HM_SESS_VARS_SOURCED" in $env) and ($env.__HM_SESS_VARS_SOURCED != "1")) {
            open ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh | capture-foreign-env | load-env
          }
        '';
    };
    # Nushell autocomplete
    carapace = {
      inherit (nushell) enable;
    };
  };
}
