# Plain attribute set, NOT a module: shared values for the sibling files in
# this directory.
#
# Import it in a `let` rather than destructuring it in a module's parameter
# list -- `username` and `userhome` are not module arguments, so a module
# written as `{ username, ... }: { ... }` would fail with an unexpected
# argument.
#
# `userhome` is deliberately a plain string rather than a store path: the
# modules reading these settings usually do not need them in the store.
let
  username = "risus";
in
{
  inherit username;
  userhome = "/home/${username}";
}
