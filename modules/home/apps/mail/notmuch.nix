{ config, pkgs, ... }:
let
  MAILDIR = "${config.xdg.dataHome}/mail/${config.my.mail.address}";
in
{
  programs.notmuch = {
    enable = true;
    new = {
      tags = [
        "unread"
        "inbox"
      ];
      ignore = [
        ".mbsyncstate"
        ".uidvalidity"
        ".mbsyncstate.journal"
      ];
    };
    hooks = {
      preNew = "";
      # Tags all standard directories plus based
      # on Folders|Labels subdirectories creates additional tags
      # and tags these directories with it.
      # Note for the consistency sake all tags are lowercased,
      # commans replaces with whitespace, multiple whitespaces squezed into
      # single plus sign and result is trimmed.
      postNew =
        # bash
        ''
          notmuch tag +archive -- folder:Archive
          notmuch tag +draft -- folder:Drafts
          notmuch tag +sent -- folder:Sent
          notmuch tag +spam -- folder:Spam
          notmuch tag +starred -- folder:Starred
          notmuch tag +trash -- folder:Trash
          # Remove inbox tag from everything outside INBOX
          notmuch tag -inbox -- not folder:INBOX

          # Dynamic tags based on directory structure,
          # each level is a tag, e.g. emails in work/hh/* will be have
          # tags "work", "hh".
          # /Labels intentionally ignored, IMAP has only directories,
          # adding labels will create duplicates.
          while read -r dir; do
            printf 'Checking %s\n' "$dir"

            base="''${dir%/*}"
            path="''${base##${MAILDIR}/}"

            # Strip "Folders/" prefix,
            # lowercase, normalize commas/spaces, split by /
            IFS='/' read -r -a tags <<< "$(
              printf '%s' "''${path##Folders/}" \
              | tr '[:upper:]' '[:lower:]' \
              | tr ',' ' ' \
              | tr -s ' ' '+' \
              | xargs
            )"

            # Prefix each tag with +
            tags=("''${tags[@]/#/+}")

            printf "Tagging %s -- %s\n" "''${tags[*]}" "$path"
            notmuch tag "''${tags[@]}" -- folder:"$path"
          done < <(find "${MAILDIR}/Folders" -type d -name "cur")
        '';
    };
    maildir = {
      synchronizeFlags = true;
    };
    extraConfig = {
      database = {
        path = MAILDIR;
      };
      user = {
        name = config.my.username;
        primary_email = config.my.mail.address;
      };
      new = {
        tags = "unread;inbox";
        ignore = ".mbsyncstate;.uidvalidity";
      };
      search = {
        exclude_tags = "deleted;spam;trash;";
      };
    };
  };

  systemd.user = {
    services = {
      notmuch-new = {
        Unit.Description = "Update notmuch database";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.notmuch}/bin/notmuch new";
        };
      };
    };
    timers = {
      notmuch-new = {
        Unit.Description = "Update notmuch database";
        Timer = {
          OnBootSec = "2min";
          OnUnitActiveSec = "5min";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
