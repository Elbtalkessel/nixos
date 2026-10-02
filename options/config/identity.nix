# Values for my.identity -- see ../options/identity.nix for the declarations.
{ pkgs, ... }:
let
  inherit (import ./common.nix) username userhome;
in
{
  config.my = {
    inherit username;

    avatar = "${userhome}/.cache/avatar";

    shell = {
      name = "nu";
      package = pkgs.nushell;
    };

    editor = "nvim";
  };
}
