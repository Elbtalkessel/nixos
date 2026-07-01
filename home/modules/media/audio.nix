{
  pkgs,
  lib,
  config,
  ...
}:
let
  enable = true;
  frontend = "ncmpcpp";
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
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire Audio Output"
      }
    '';
  };

  services.mpd-mpris = {
    inherit enable;
  };

  programs.inori = {
    enable = enable && frontend == "inori";
    settings = {
      qwerty_keybindings = true;
      keybindings = {
        up = "k";
        down = "j";
        left = "h";
        right = "l";
        top = "g";
        bottom = "G";
        screenful_up = "C-u";
        screenful_down = "C-d";
        select = "<enter>";
        select_and_next = "C-j";
        quit = "q";
        toggle_screen = "<tab>";
        clear_queue = "<space>";
        local_search = "/";
        global_search = "?";
      };
      theme = {
        block_active = {
          fg = "White";
          bg = "#5e5e5e";
        };

        item_highlight_active = {
          fg = "#f4f4f4";
          bg = "#5e5e5e";
          addmodifier = [ "BOLD" ];
        };

        item_highlight_inactive = {
          fg = "#d0d0d0";
        };

        search_query_active = {
          fg = "#f4f4f4";
        };

        search_query_inactive = {
          fg = "#b0b0b0";
        };

        slash_span = {
          fg = "#d787d7";
        };

        status_album = {
          fg = "#d7af87";
        };

        status_artist = {
          fg = "#d78787";
        };

        status_paused = {
          fg = "#d7af5f";
        };

        status_playing = {
          fg = "#87d7af";
        };

        status_stopped = {
          fg = "#808080";
        };

        status_title = {
          fg = "#f2f2f2";
        };
      };
    };
  };

  programs.ncmpcpp = {
    enable = enable && frontend == "ncmpcpp";
    settings = {
      ncmpcpp_directory = "${config.home.sessionVariables.XDG_DATA_HOME}/ncmpcpp";
      lyrics_directory = "${config.home.sessionVariables.XDG_CACHE_HOME}/ncmpcpp-lyrics";
    };
    mpdMusicDir = config.home.sessionVariables.XDG_MUSIC_DIR;
    bindings = [
      {
        key = "+";
        command = "show_clock";
      }
      {
        key = "=";
        command = "volume_up";
      }
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "u";
        command = "page_up";
      }
      {
        key = "d";
        command = "page_down";
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
        key = ".";
        command = "show_lyrics";
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
    # Stolen from https://github.com/owl4ce/dotfiles/blob/ng/.config/ncmpcpp/main.config
    settings = {
      # MPD
      # ---
      mpd_crossfade_time = "2";

      # VISUALIZER
      # ---
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer";
      visualizer_in_stereo = "no";
      visualizer_fps = "60";
      visualizer_type = "wave";
      visualizer_look = "∗▐";
      visualizer_color = "199,200,201,202,166,130,94,58,22";
      visualizer_spectrum_smooth_look = "yes";

      # GENERAL
      # ---
      connected_message_on_startup = "yes";
      cyclic_scrolling = "yes";
      mouse_support = "yes";
      mouse_list_scroll_whole_page = "yes";
      lines_scrolled = "1";
      message_delay_time = "1";
      playlist_shorten_total_times = "yes";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";
      autocenter_mode = "yes";
      centered_cursor = "yes";
      user_interface = "classic";
      follow_now_playing_lyrics = "yes";
      locked_screen_width_part = "50";
      ask_for_locked_screen_width_part = "yes";
      display_bitrate = "no";
      external_editor = "nano";
      main_window_color = "default";
      startup_screen = "playlist";

      # PROGRESS BAR
      # ---
      progressbar_look = "━━━";
      #progressbar_look = "▃▃▃";
      progressbar_elapsed_color = "5";
      progressbar_color = "black";

      # UI VISIBILITY
      # ---
      header_visibility = "no";
      statusbar_visibility = "yes";
      titles_visibility = "yes";
      enable_window_title = "yes";

      # COLORS
      # ---
      statusbar_color = "white";
      color1 = "white";
      color2 = "blue";

      # UI APPEARANCE
      # ---
      now_playing_prefix = "$b$2$7 ";
      now_playing_suffix = "  $/b$8";
      current_item_prefix = "$b$7$/b$3 ";
      current_item_suffix = "  $8";

      song_columns_list_format = "(50)[]{t|fr:Title} (0)[magenta]{a}";

      song_list_format = " {%t $R   $8%a$8}|{%f $R   $8%l$8} $8";

      song_status_format = "$b$6$7[$8      $7]$6 $2 $7{$8 %b }|{$8 %t }|{$8 %f }$7 $8";

      song_window_title_format = "Now Playing ..";
    };
  };
}
