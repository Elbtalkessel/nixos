{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting     # Disable greeting
      fish_vi_key_bindings  # Enable vi mode

      direnv hook fish | source

      # trigger direnv at prompt, and on every arrow-based directory change (default)
      # set -g direnv_fish_mode eval_on_arrow

      # trigger direnv at prompt, and only after arrow-based directory changes before executing command
      # set -g direnv_fish_mode eval_after_arrow

      # trigger direnv at prompt only, this is similar functionality to the original behavior
      # set -g direnv_fish_mode disable_arrow

      # This function allows you to switch to a different task
      # when an interactive command takes too long
      # by notifying you when it is finished.
      #
      # It is invoked by the fish shell automatically using its event system.
      # src: https://github.com/kovidgoyal/kitty/issues/1892#issuecomment-1127515620
      function __postexec_notify_on_long_running_commands --on-event fish_postexec
         set --function interactive_commands 'nvim' 'mpv' 'man' 'less'
         set --function command (string split ' ' $argv[1])
         if contains $command $interactive_commands
             # We quit interactive commands manually,
             # no need for a notification.
             return
         end
      
         if test $CMD_DURATION -gt 5000
             notify-send "Took $(math -s 0 $CMD_DURATION / 1000)s" "$argv"
         end
      end
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
