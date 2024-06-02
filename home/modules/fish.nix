{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting     # Disable greeting
      fish_vi_key_bindings  # Enable vi mode

      direnv hook fish | source

      # trigger direnv at prompt, and on every arrow-based directory change (default)
      set -g direnv_fish_mode eval_on_arrow

      # trigger direnv at prompt, and only after arrow-based directory changes before executing command
      #set -g direnv_fish_mode eval_after_arrow

      # trigger direnv at prompt only, this is similar functionality to the original behavior
      #set -g direnv_fish_mode disable_arrow
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "v6.1.1";
          hash = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
    ];
  };
}
