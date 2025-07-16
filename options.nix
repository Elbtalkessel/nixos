{ lib, ... }:
{
  options = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "risus";
      description = "The username for the home directory.";
    };
    shell = lib.mkOption {
      type = lib.types.str;
      default = "nu";
      description = "The default shell for the user.";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "The default editor for the user.";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "alacritty";
      description = "The default terminal emulator for the user.";
    };
    browser = lib.mkOption {
      type = lib.types.str;
      default = "vivaldi";
      description = "The default web browser for the user.";
    };
  };
}
