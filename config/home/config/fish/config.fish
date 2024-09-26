set fish_greeting     # Disable greeting
fish_vi_key_bindings  # Enable vi mode

direnv hook fish | source

# trigger direnv at prompt, and on every arrow-based directory change (default)
# set -g direnv_fish_mode eval_on_arrow

# trigger direnv at prompt, and only after arrow-based directory changes before executing command
# set -g direnv_fish_mode eval_after_arrow

# trigger direnv at prompt only, this is similar functionality to the original behavior
# set -g direnv_fish_mode disable_arrow

# Pretty prints milliseconds.
# Example:
#  __duration 60001
#  "1m"
# __duration 8.63e+8
#  "9d 23h 45m 20s"
function __duration
  set MINUTE 60000
  set HOUR 3600000
  set DAY 86400000

  set out ""
  set rem $argv[1]

  # Fish doesn't support closures
  if test $rem -gt $DAY
    set whole $(math -s 0 "$rem / $DAY")
    set out "$(string join '' $out $whole 'd') "
    set rem $(math "$rem % $DAY")
  end
  if test $rem -gt $HOUR
    set whole $(math -s 0 "$rem / $HOUR")
    set out "$(string join '' $out $whole 'h') "
    set rem $(math "$rem % $HOUR")
  end
  if test $rem -gt $MINUTE
    set whole $(math -s 0 "$rem / $MINUTE")
    set out "$(string join '' $out $whole 'm') "
    set rem $(math "$rem % $MINUTE")
  end
  set whole $(math -s 0 "$rem / 1000")
  set out "$(string join '' $out $whole 's' ) "

  echo (string join ', ' $out)
end

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
    notify-send "Took $(__duration $CMD_DURATION)" "$argv"
  end
end
