{ lib, ... }:
{
  programs = {
    starship = {
      enable = true;
      # output of `starship preset pure-preset` converted to nix
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$python"
          "$git_state"
          "$git_branch"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$shell$character"
        ];
        directory = {
          style = "white";
        };
        git_state = {
          format = ''(\([$state( $progress_current/$progress_total)]($style)\) )'';
          style = "white";
        };
        git_branch = {
          format = "([$branch]($style))";
          style = "bright-black";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style)";
          style = "white";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = " ↨";
        };
        cmd_duration = {
          format = "( [$duration]($style))";
          style = "yellow";
        };
        # ---
        python = {
          format = "([$virtualenv]($style) )";
          style = "bright-black";
        };
        shell = {
          disabled = false;
          format = "[$indicator]($style)";
          zsh_indicator = "%";
          nu_indicator = "λ";
          unknown_indicator = "$";
          style = "white";
        };
        character = {
          success_symbol = "[_](white)";
          error_symbol = "[_](red)";
          vimcmd_symbol = "[_ >](cyan)";
        };
      };
    };
  };
}
