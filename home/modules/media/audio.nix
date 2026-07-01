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
  };
}
