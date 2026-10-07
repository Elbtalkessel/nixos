# The user: who they are, and the tools that identify them.
#
# Sibling of mail, theme, desktop, fonts and system -- see ./my.nix for how these
# slices combine into the single `my.*` namespace.
{ lib, ... }:
{
  options.my = {
    # The default user identity. Per host — rule #4 of the README: a login
    # shell differs per machine, so the username and shell that go with it
    # belong to the host entrypoint, not to a shared profile.
    username = lib.mkOption {
      type = lib.types.str;
      description = "Default user's username.";
    };

    avatar = lib.mkOption {
      type = lib.types.str;
      description = "User's avatar.";
    };
  };
}
