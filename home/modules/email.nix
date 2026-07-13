{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.protonmail-bridge = {
    enable = true;
    extraPackages = with pkgs; [ gnome-keyring ];
  };
  home.packages = with pkgs; [
    aerc
    libnotify
  ];
  systemd.user.services.goimapnotify = {
    Unit = {
      Description = "Protonmail Bridge Notifier";
      After = [ "graphical-session.target" ];
    };

    Service =
      let
        secret = config.sops.secrets."protonmail/bridge".path;
      in
      {
        RuntimeDirectory = "goimapnotify";

        ExecStartPre = pkgs.writeShellScript "generate-goimapnotify-config" ''
          set -euo pipefail

          USERNAME="$(${lib.getExe pkgs.yq-go} '.username' ${secret})"
          PASSWORD="$(${lib.getExe pkgs.yq-go} '.password' ${secret})"

          cat > "$RUNTIME_DIRECTORY/config.yaml" <<EOF
          ---
          configurations:
            - host: 127.0.0.1
              port: 1143
              tls: true
              tlsOptions:
                starttls: true
              username: $USERNAME
              password: $PASSWORD
              boxes:
                - mailbox: INBOX
                  onNewMail: "notify-send '%s' 'You've got mail!'"
          EOF
        '';

        ExecStart = "${lib.getExe pkgs.goimapnotify} -conf %t/goimapnotify/config.yaml";

        Restart = "always";
        RestartSec = 5;
      };

    Install.WantedBy = [ "default.target" ];
  };
}
