{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    prezto = {
      enable = true;
      editor = {
        dotExpansion = true;
        keymap = "vi";
      };
      prompt = {
        theme = "pure";
      };
    };
  };
}
