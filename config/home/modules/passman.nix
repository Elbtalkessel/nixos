{pkgs, ...}: {
  home.packages = with pkgs; [
    gopass
    pass
    passExtensions.pass-import
  ];
}
