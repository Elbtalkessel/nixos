# The `my.*` namespace, shared by the NixOS system and the home-manager
# configuration. Both trees import this one module, so a setting added here is
# available to both.
#
#   options/  mkOption declarations -- the reference for what a setting is
#   config/   config.my.* values    -- the profile of this machine
#
# The two halves are split by role and then by domain, so the same filename
# appears on both sides: my.mail is declared in options/options/mail.nix and
# set in options/config/mail.nix.
_: {
  imports = [
    ./options
    ./config
  ];
}
