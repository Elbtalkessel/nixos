{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = true;
  frontend = "ncmpcpp";
  visualizer_data_source = "/tmp/mpd.fifo";
  visualizer_output_name = "Audio Visualizer";
  visualizer_output_format = "44100:16:2";
  # Doesn't work for some reason.
  # Disabled, but config is kept for future.
  visualizer_enable = false;
in
{
  home.packages = lib.mkIf enable [
    pkgs.mpc
  ];

  home.shellAliases = lib.mkIf enable {
    music = frontend;
  };

  services.mpd = {
    inherit enable;
    musicDirectory = config.home.sessionVariables.XDG_MUSIC_DIR;
    extraConfig =
      [
        ''
          audio_output {
            type "pipewire"
            name "Pipewire Audio Output"
          }
        ''
      ]
      ++ (lib.optionals visualizer_enable ''
        audio_output {
          type "fifo"
          name "${visualizer_output_name}"
          path "${visualizer_data_source}"
          format "${visualizer_output_format}"
        }
      '')
      |> lib.strings.join "\n";
  };

  services.mpd-mpris = {
    inherit enable;
  };

  programs.ncmpcpp = {
    enable = enable && frontend == "ncmpcpp";
    mpdMusicDir = config.home.sessionVariables.XDG_MUSIC_DIR;
    # https://wiki.archlinux.org/title/Ncmpcpp
    # https://github.com/ncmpcpp/ncmpcpp/blob/master/doc/config
    settings = {
      ## Directory for storing downloaded lyrics. It defaults to ~/.lyrics since other
      ## MPD clients (eg. ncmpc) also use that location.
      lyrics_directory = "${config.home.sessionVariables.XDG_CACHE_HOME}/ncmpcpp-lyrics";
      mpd_crossfade_time = 2;

      message_delay_time = 1;
      playlist_disable_highlight_delay = 2;
      ignore_leading_the = "yes";
      allow_for_physical_item_deletion = "no";
      follow_now_playing_lyrics = "yes";
      user_interface = "alternative";
      statusbar_visibility = "no";
      header_visibility = "no";
      titles_visibility = "no";

      ##### song format #####
      ##
      ## For a song format you can use:
      ##
      ## %l - length
      ## %f - filename
      ## %F - full filepath
      ## %D - directory
      ## %a - artist
      ## %A - album artist
      ## %t - title
      ## %b - album
      ## %y - date
      ## %n - track number (01/12 -> 01)
      ## %N - full track info (01/12 -> 01/12)
      ## %g - genre
      ## %c - composer
      ## %p - performer
      ## %d - disc
      ## %C - comment
      ## %P - priority
      ## $R - begin right alignment
      ##
      ## If you want to make sure that a part of the format is displayed only when
      ## certain tags are present, you can archieve it by grouping them with brackets,
      ## e.g. '{%a - %t}' will be evaluated to 'ARTIST - TITLE' if both tags are
      ## present or '' otherwise.  It is also possible to define a list of
      ## alternatives by providing several groups and separating them with '|',
      ## e.g. '{%t}|{%f}' will be evaluated to 'TITLE' or 'FILENAME' if the former is
      ## not present.
      ##
      ## Note: If you want to set limit on maximal length of a tag, just put the
      ## appropriate number between % and character that defines tag type, e.g. to
      ## make album take max. 20 terminal cells, use '%20b'.
      ##
      ## In addition, formats support markers used for text attributes.  They are
      ## followed by character '$'. After that you can put:
      ##
      ## - 0 - default window color (discards all other colors)
      ## - 1 - black
      ## - 2 - red
      ## - 3 - green
      ## - 4 - yellow
      ## - 5 - blue
      ## - 6 - magenta
      ## - 7 - cyan
      ## - 8 - white
      ## - 9 - end of current color
      ## - b - bold text
      ## - u - underline text
      ## - i - italic text
      ## - r - reverse colors
      ## - a - use alternative character set
      ##
      ## If you don't want to use a non-color attribute anymore, just put it again,
      ## but this time insert character '/' between '$' and attribute character,
      ## e.g. {$b%t$/b}|{$r%f$/r} will display bolded title tag or filename with
      ## reversed colors.
      ##
      ## If you want to use 256 colors and/or background colors in formats (the naming
      ## scheme is described below in section about color definitions), it can be done
      ## with the syntax $(COLOR), e.g. to set the artist tag to one of the
      ## non-standard colors and make it have yellow background, you need to write
      ## $(197_yellow)%a$(end). Note that for standard colors this is interchangable
      ## with attributes listed above.
      ##
      ## Note: colors can be nested.

      progressbar_look = "▂▂▂";
      alternative_header_first_line_format = "$(225){%t}|{%f}$(end)";
      alternative_header_second_line_format = "$(219){%D}$(end)";
      song_status_format = "$7%t";
      song_list_format = " %b $R%t %l ";
      song_library_format = "{{%a - %t} (%b)}|{%f}";
      browser_playlist_prefix = "$6[p] $9 ";

      current_item_prefix = "$b$r";
      current_item_suffix = "$/r$/b";
      current_item_inactive_column_prefix = "$(242)$r";
      current_item_inactive_column_suffix = "$/r$(end)";
      # (width of the column)[color of the column]{displayed tag}
      song_columns_list_format = "(20)[242]{a} (6f)[242]{NE} (50)[225]{t|f:Title} (20)[219]{b} (7f)[219]{l}";

      colors_enabled = "yes";
      empty_tag_color = "242";
      empty_tag_marker = "...";
      header_window_color = "default";
      volume_color = "default";
      state_line_color = "default";
      state_flags_color = "default:b";
      main_window_color = "250_transparent";
      color1 = "225";
      color2 = "219";
      progressbar_color = "black:b";
      progressbar_elapsed_color = "225:b";
      statusbar_color = "default";
      statusbar_time_color = "default:b";
      player_state_color = "default:b";
      alternative_ui_separator_color = "black:b";
      window_border_color = "black";
      active_window_border = "black";
    }
    // lib.attrsets.optionalAttrs visualizer_enable {
      inherit visualizer_data_source;
      inherit visualizer_output_name;
      visualizer_in_stereo = if visualizer_output_format == "44100:16:2" then "yes" else "no";
      visualizer_type = "wave";
      visualizer_look = "▗";
      visualizer_color = "47, 83, 119, 155, 191, 227, 221, 215, 209, 203, 197, 161";
    };
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "ctrl-b";
        command = "page_up";
      }
      {
        key = "ctrl-u";
        command = "page_up";
      }
      {
        key = "ctrl-f";
        command = "page_down";
      }
      {
        key = "ctrl-d";
        command = "page_down";
      }
      {
        key = "g";
        command = "move_home";
      }
      {
        key = "G";
        command = "move_end";
      }
      {
        key = "n";
        command = "next_found_item";
      }
      {
        key = "N";
        command = "previous_found_item";
      }
    ];
  };
}
