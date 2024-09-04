_:
let
  BLUE = "#282c34";
  GRAY = "#7a8395";
  GRAY_100 = "#353b45";
  GRAY_200 = "#565c64";
  WHITE = "#c8ccd4";
  RED = "#e06c75";
  RED_100 = "#be5046";
  YELLOW = "#e5c07b";
  TEAL = "#56b6c2";
  PURPLE_100 = "#b6bdca";

  bg_default = BLUE;
  bg_lighter = GRAY_100;
  bg_selection = GRAY;
  fg_disabled = GRAY_200;
  fg_default = WHITE;
  bg_lightest = WHITE;
  fg_error = RED;
  bg_hint = YELLOW;
  fg_matched_text = WHITE;
  bg_passthrough_mode = TEAL;
  bg_insert_mode = RED_100;
  bg_warning = PURPLE_100;
in
{
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors = {
        webpage.darkmode.enabled = true;
        completion = {
          # Text color of the completion widget. May be a single color to use for
          # all columns or a list of three  one for each column.
          fg = fg_default;
          # Background color of the completion widget for odd rows.
          odd.bg = bg_lighter;
          # Background color of the completion widget for even rows.
          even.bg = bg_default;

          category = {
            # Foreground color of completion widget category headers.
            fg = bg_hint;
            # Background color of the completion widget category headers.
            bg = bg_default;
            # Top border color of the completion widget category headers.
            border.top = bg_default;
            # Bottom border color of the completion widget category headers.
            border.bottom = bg_default;
          };

          item.selected = {
            # Foreground color of the selected completion
            fg = fg_default;
            # Background color of the selected completion
            bg = bg_selection;
            # Top border color of the selected completion
            border.top = bg_selection;
            # Bottom border color of the selected completion
            border.bottom = bg_selection;
            # Foreground color of the matched text in the selected completion
            match.fg = fg_matched_text;
          };

          # Foreground color of the matched text in the
          match.fg = fg_matched_text;
          # Color of the scrollbar handle in the completion view.
          scrollbar.fg = fg_default;
          # Color of the scrollbar in the completion view.
          scrollbar.bg = bg_default;
        };

        contextmenu = {
          # Background color of disabled items in the context menu.
          disabled.bg = bg_lighter;
          # Foreground color of disabled items in the context menu.
          disabled.fg = fg_disabled;
          # Background color of the context menu. If set to null, the Qt default is used.
          menu.bg = bg_default;
          # Foreground color of the context menu. If set to null, the Qt default is used.
          menu.fg = fg_default;
          # Background color of the context menu’s selected  If set to null, the Qt default is used.
          selected.bg = bg_selection;
          #Foreground color of the context menu’s selected  If set to null, the Qt default is used.
          selected.fg = fg_default;
        };

        downloads = {
          # Background color for the download bar.
          bar.bg = bg_default;
          # Color gradient start for download text.
          start.fg = bg_default;
          # Color gradient start for download backgrounds.
          start.bg = bg_insert_mode;
          # Color gradient end for download text.
          stop.fg = bg_default;
          # Color gradient stop for download backgrounds.
          stop.bg = bg_passthrough_mode;
          # Foreground color for downloads with errors.
          error.fg = fg_error;
        };

        hints = {
          # Font color for hints.
          fg = bg_default;
          # Background color for hints. Note that you can use a `rgba(...)` value
          # for transparency.
          bg = bg_hint;
          # Font color for the matched part of hints.
          match.fg = fg_default;
        };

        keyhint = {
          # Text color for the keyhint widget.
          fg = fg_default;
          # Highlight color for keys to complete the current keychain.
          suffix.fg = fg_default;
          # Background color of the keyhint widget.
          bg = bg_default;
        };

        messages = {
          # Foreground color of an error message.
          error = {
            fg = bg_default;
            # Background color of an error message.
            bg = fg_error;
            # Border color of an error message.
            border = fg_error;
          };

          warning = {
            # Foreground color of a warning message.
            fg = bg_default;
            # Background color of a warning message.
            bg = bg_warning;
            # Border color of a warning message.
            border = bg_warning;
          };

          info = {
            # Foreground color of an info message.
            fg = fg_default;
            # Background color of an info message.
            bg = bg_default;
            # Border color of an info message.
            border = bg_default;
          };
        };

        prompts = {
          # Foreground color for prompts.
          fg = fg_default;
          # Border used around UI elements in prompts.
          border = bg_default;
          # Background color for prompts.
          bg = bg_default;
          # Background color for the selected item in filename prompts.
          selected.bg = bg_selection;
          # Foreground color for the selected item in filename prompts.
          selected.fg = fg_default;
        };

        statusbar = {
          # Foreground color of the statusbar.
          normal.fg = fg_matched_text;
          # Background color of the statusbar.
          normal.bg = bg_default;
          # Foreground color of the statusbar in insert mode.
          insert.fg = bg_default;
          # Background color of the statusbar in insert mode.
          insert.bg = bg_insert_mode;
          # Foreground color of the statusbar in passthrough mode.
          passthrough.fg = bg_default;
          # Background color of the statusbar in passthrough mode.
          passthrough.bg = bg_passthrough_mode;
          # Foreground color of the statusbar in private browsing mode.
          private.fg = bg_default;
          # Background color of the statusbar in private browsing mode.
          private.bg = bg_lighter;

          command = {
            # Foreground color of the statusbar in command mode.
            fg = fg_default;
            # Background color of the statusbar in command mode.
            bg = bg_default;
            # Foreground color of the statusbar in private browsing + command mode.
            private.fg = fg_default;
            # Background color of the statusbar in private browsing + command mode.
            private.bg = bg_default;
          };

          caret = {
            # Foreground color of the statusbar in caret mode.
            fg = bg_default;
            # Background color of the statusbar in caret mode.
            bg = bg_warning;
            # Foreground color of the statusbar in caret mode with a selection.
            selection.fg = bg_default;
            # Background color of the statusbar in caret mode with a selection.
            selection.bg = bg_insert_mode;
          };

          # Background color of the progress bar.
          progress.bg = bg_insert_mode;

          url = {
            # Default foreground color of the URL in the statusbar.
            fg = fg_default;
            # Foreground color of the URL in the statusbar on error.
            error.fg = fg_error;
            # Foreground color of the URL in the statusbar for hovered links.
            hover.fg = fg_default;
            # Foreground color of the URL in the statusbar on successful load
            # (http).
            success.http.fg = bg_passthrough_mode;
            # Foreground color of the URL in the statusbar on successful load
            # (https).
            success.https.fg = fg_matched_text;
            # Foreground color of the URL in the statusbar when there's a warning.
            warn.fg = bg_warning;
          };
        };

        tabs = {
          # Background color of the tab bar.
          bar.bg = bg_default;

          indicator = {
            # Color gradient start for the tab indicator.
            start = bg_insert_mode;
            # Color gradient end for the tab indicator.
            stop = bg_passthrough_mode;
            # Color for the tab indicator on errors.
            error = fg_error;
          };

          # Foreground color of unselected odd tabs.
          odd.fg = fg_default;
          # Background color of unselected odd tabs.
          odd.bg = bg_lighter;
          # Foreground color of unselected even tabs.
          even.fg = fg_default;
          # Background color of unselected even tabs.
          even.bg = bg_default;

          pinned = {
            # Background color of pinned unselected even tabs.
            even.bg = bg_passthrough_mode;
            # Foreground color of pinned unselected even tabs.
            even.fg = bg_lightest;
            # Background color of pinned unselected odd tabs.
            odd.bg = fg_matched_text;
            # Foreground color of pinned unselected odd tabs.
            odd.fg = bg_lightest;

            # Background color of pinned selected even tabs.
            selected = {
              even.bg = bg_selection;
              # Foreground color of pinned selected even tabs.
              even.fg = fg_default;
              # Background color of pinned selected odd tabs.
              odd.bg = bg_selection;
              # Foreground color of pinned selected odd tabs.
              odd.fg = fg_default;
            };
          };

          selected = {
            # Foreground color of selected odd tabs.
            odd.fg = fg_default;
            # Background color of selected odd tabs.
            odd.bg = bg_selection;
            # Foreground color of selected even tabs.
            even.fg = fg_default;
            # Background color of selected even tabs.
            even.bg = bg_selection;
          };
        };
      };

      zoom.mouse_divider = 100000000;
      zoom.default = 125;
      scrolling.smooth = false;

      qt.highdpi = true;

      content = {
        geolocation = false;
        mouse_lock = false;
        notifications.enabled = false;
        register_protocol_handler = false;
      };

      downloads.position = "bottom";
      downloads.remove_finished = 10000;

      tabs.position = "top";
      editor.command = [ "nvim" "-f" "{file}" "-c" "normal {line}G{column0}l" ];
      spellcheck.languages = [ "en-US" "ru-RU" ];
    };

    keyBindings = {
      normal = {
        ",p" = "spawn --userscript qute-pass --dmenu-invocation dmenu";
        ",P" = "spawn --userscript qute-pass --dmenu-invocation dmenu --password-only";
        "D" = "tab-close";
        "r" = "nop";
        "d" = "nop";
      };
    };
  };
}
