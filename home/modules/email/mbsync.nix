{
  config,
  lib,
  pkgs,
  ...
}:
let
  MAILDIR = "${config.xdg.dataHome}/mail/${config.my.mail.address}";
  INBOX = "${MAILDIR}/INBOX";
in
{
  programs.mbsync = {
    enable = true;
    extraConfig = ''
      IMAPAccount default
      Host ${config.my.mail.host}
      Port ${config.my.mail.port}
      User "${config.my.mail.address}"
      PassCmd "${lib.getExe pkgs.libsecret} lookup ${config.my.mail.password}"
      TLSType ${config.my.mail.sslType}

      IMAPStore default-remote
      Account default

      MaildirStore default-local
      # trailing slash is required
      Path ${MAILDIR}/
      Inbox ${INBOX}
      Subfolders Verbatim
      MaxSize 100M

      Channel default
      Far :default-remote:
      Near :default-local:
      # Don't sync virtual all mail directory
      # https://github.com/ProtonMail/gluon/issues/426
      Patterns * !"All Mail" !"Starred" !"Labels"
      Sync Full
      # Preserve original arrival timestamps across syncs
      CopyArrivalDate yes
      # Create and remove mailboxes on server only,
      # propagate change from server to client.
      Create Near
      Remove Near
      Expunge Both
      SyncState *
    '';
  };

  services = {
    mbsync = {
      enable = true;
      frequency = "*:0/5";
      # https://mynixos.com/home-manager/option/services.mbsync.configFile
      # Says it defaults to ~/.mbsyncrc
      # However mbsync man page state that it checks .config/isyncrc
      # programs.mbsync write config to .config/isyncrc
      configFile = "${config.xdg.configHome}/isyncrc";
      preExec = "${lib.getExe' pkgs.coreutils "mkdir"} -p ${MAILDIR}";
    };
  };
}
