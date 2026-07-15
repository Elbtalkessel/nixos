{ pkgs, config, ... }:
let
  MAILDIR = "${config.xdg.dataHome}/mail/${config.my.mail.address}";
in
{
  home.packages = with pkgs; [
    notmuch-mailmover
  ];

  xdg.configFile."notmuch-mailmover/config.yaml".text = # yaml
    ''
      maildir: ${MAILDIR}
      # if omitted (or nujl), it will use the same as notmuch would, see notmuch-config(1)
      notmuch_config: null

      # only rename if you use mbsync
      rename: true

      # rule_match_mode can be one of `unique`, `first`, `all` and determines how rules are applied;
      # rule_match_mode is optional and defaults to `unique`; the following modes are available:
      #   - first: the first rule that matches will be applied
      #   - all: all rules that match will be applied (in order), i.e. a single mail can be moved multiple times
      #   - unique: like first, but ensure that a mail is only moved once
      rule_match_mode: unique

      # NOTE: rule_match_mode `unique` means that queries must NOT overlap (hence the `and not tag:trash` clause in the second query).
      # This is to avoid moving files more than once and checked by notmuch-mailmover *before* any files are moved.
      # So, don't worry about it, notmuch-mailmover will complain if your rules are ambiguous.
      rules:
        # move mails tagged as `trash` to folder `Trash`
        - folder: Trash
          query: tag:trash

        # move mails tagged as `sent` to folder `Sent`
        - folder: Sent
          query: tag:sent and not tag:trash

        # move mails tagged as `archive` to folder `Archive`
        - folder: Archive
          query: tag:archive and not tag:sent and not tag:trash
    '';
}
