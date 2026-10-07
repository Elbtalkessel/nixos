# The single declaration of the `my.*` namespace.
#
# Each domain file in this directory adds its own slice with the nested
# shorthand -- `options.my.<name> = lib.mkOption { ... };` -- and the module
# system merges those into this option.
#
# The `submodule` type is deliberately left empty. A populated
# `submodule { options = ...; }` here would be closed: it would reject the
# shorthand children declared by the domain files, and two files declaring the
# same option with their own `submodule` type is a hard "already declared"
# error. Leaving it empty keeps `my` a closed submodule (unknown keys under
# `my.*` are still rejected) while letting the domain files extend it.
{ lib, ... }:
{
  options.my = lib.mkOption {
    description = "Frequently changed / shared settings.";
    type = lib.types.submodule { };
  };
}
