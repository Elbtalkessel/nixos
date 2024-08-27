{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # Vimium
      {id = "ghmbeldphafepmbegfdlkpapadhbakde";} # Proton Pass
      {id = "fonaoompfjljjllgccccgjnhnoghohgc";} # JetBrains Grazie
    ];
  };
}
