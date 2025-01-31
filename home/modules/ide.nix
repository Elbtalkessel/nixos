{ pkgs, lib, ... }:
{
  home = {
    packages = with pkgs; [
      jetbrains-toolbox
      # Patched JetBrains fsnotifier
      # reason: https://github.com/cachix/devenv/issues/1258
      # fix: https://github.com/NixOS/nixpkgs/pull/318358
      # related: https://github.com/JetBrains/intellij-community/pull/2171
      # fsnotifier
    ];

    sessionVariables = {
      # Custom path to the proerties file, see xdg.configFile below.
      # https://intellij-support.jetbrains.com/hc/en-us/articles/207240985-Changing-IDE-default-directories-used-for-config-plugins-and-caches-storage?page=3
      #PYCHARM_PROPERTIES = "/home/risus/.config/idea/pycharm.properties";
    };
  };

  xdg.configFile = {
    "ideavim/ideavimrc".source = ../config/ideavim/ideavimrc;
    # Sets filewatcher to patched one
    #"idea/pycharm.properties".text = "idea.filewatcher.executable.path = ${pkgs.fsnotifier}/bin/fsnotifier";
  };

  programs.zed-editor = {
    enable = false;

    extensions = [
      "nix"
      "toml"
      "make"
    ];

    ## everything inside of these brackets are Zed options.
    userSettings = {
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;
        default_model = {
          provider = "ollama";
          model = "deepseek-r1:1.5b";
        };
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      hour_format = "hour24";
      auto_update = false;
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "alacritty";
        };
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        program = "zsh";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      lsp = {
        nix = {
          binary = {
            # path = lib.getExe pkgs.<?>;
            path_lookup = true;
          };
        };
      };

      vim_mode = true;
      ## tell zed to use direnv and direnv can use a flake.nix enviroment.
      load_direnv = "shell_hook";
      theme = {
        mode = "system";
        light = "JetBrains New Dark";
        dark = "One Dark";
      };
      show_whitespaces = "all";
      ui_font_size = 25;
      buffer_font_size = 22;
      buffer_line_height = {
        custom = 2;
      };
      show_inline_completions = true;
    };
  };
}
