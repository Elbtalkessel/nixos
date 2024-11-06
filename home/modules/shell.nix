{lib, ...}:

{
  programs = {
    zsh = {
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
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
      	add_newline = false;
        format = lib.concatStrings [
          "$username"
	  "$hostname"
	  "$directory"
	  "$git_branch"
	  "$git_state"
	  "$git_status"
	  "$cmd_duration"
	  "$line_break"
	  "$python"
	  "$character"
        ];
	directory = {
          style = "blue";
	};
	character = {
		success_symbol = "[λ](purple)";
		error_symbol = "[λ](red)";
		vimcmd_symbol = "[❮](green)";
	};
	git_branch = {
		format = "[$branch]($style)";
		style = "bright-black";
	};
	git_status = {
		format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
		style = "cyan";
		conflicted = "​";
		untracked = "​";
		modified = "​";
		staged = "​";
		renamed = "​";
		deleted = "​";
		stashed = "≡";
	};
	git_state = {
		format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
		style = "bright-black";
	};
	cmd_duration = {
		format = "[$duration]($style) ";
		style = "yellow";
	};
	python = {
		format = "[$virtualenv]($style) ";
		style = "bright-black";
	};
      };
    };
  };
}
