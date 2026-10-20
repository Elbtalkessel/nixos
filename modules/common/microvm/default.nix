# MicroVM wiring for hosts built from the `microvm` flake input.
#
# A host descriptor (passed by flake.nix through `specialArgs.hostDescriptor`)
# decides the role: `microvm = true` makes the host a guest running inside a
# hypervisor on another machine, `microvmHost = [ ... ]` makes it the host
# running the named guests. A host is never both.
{ hostDescriptor, lib, ... }:
{
  imports =
    (lib.optional (hostDescriptor.microvm or false) ./guest.nix)
    ++ (lib.optional (hostDescriptor ? microvmHost) ./host.nix);
}
