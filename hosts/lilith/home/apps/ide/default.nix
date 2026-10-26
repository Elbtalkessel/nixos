{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (zed-editor.fhsWithPackages (
        pkgs: with pkgs; [
          php
          nil
          nixd
          go
        ]
      ))
    ];
  };
}
