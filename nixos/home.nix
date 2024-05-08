{ ... }: {
  imports = [ <home-manager/nixos> ];
  
  home-manager.users.risus = { pkgs, ... }: { 
    # https://mynixos.com/home-manager/options/programs

    programs.git = {
      enable = true;
      userName = "Elbtalkessel";
      userEmail = "rtfsc@pm.me";
      aliases = {
        m = "merge --no-ff";
      };
    };
    
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting     # Disable greeting
        fish_vi_key_bindings  # Enable vi mode
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

    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    programs.fzf = {
      enable = true;
    };

    programs.eza = {
      enable = true;
    };

    programs.bat = {
      enable = true;
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "JetBrainsMono NF";
            style = "Regular";
          };
          offset = {
            x = 0;
            y = 10;
          };
          cursor = {
            style = {
              shape = "Beam";
              blinking = "always";
            };
            vi_mode_style = {
              shape = "Beam";
            };
          };
          keyboard = {
            bindings = [
              {
                key = "V";
                mods = "Control";
                action = "Paste";
              }
              {
                key = "C";
                mods = "Control";
                action = "Copy";
              }
              {
                key = "C";
                mods = "Control|Shift";
                action = "\u0003";
              }
            ];
          };
          window = {
            decorations = "full";
            opacity = "0.96";
            padding = {
              x = 0;
              y = 0;
            };
          };
        };
      };
    };

    xdg.configFile."tofi/config".source = ./config/tofi/config;
    xdg.configFile."lvim/config.lua".source = ./config/lvim/config.lua;

    home.shellAliases = {
      cat = "bat";
      cp = "cp -iv";
      dc = "docker compose";
      ln = "ln -v";
      ls = "exa";
      mv = "mv -iv";
      n = "lvim .";
      rm = "rm -v";
      S = "sudo systemctl";
      s = "sudo";
      Ss = "sudo systemctl status";
      g = "lazygit";
    };
    
    # https://discourse.nixos.org/t/virt-manager-cannot-create-vm/38894/2
    # virt-manager doesn't work without it
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };

    home.sessionVariables = {
      XDG_DATA_HOME = "/home/risus/.local/share";
      XDG_CONFIG_HOME = "/home/risus/.config";
      XDG_CACHE_HOME = "/home/risus/.cache";
      XDG_DOWNLOAD_DIR = "/home/risus/Download";
      XDG_RUNTIME_DIR = "/run/user/1000";
      BIN_HOME = "/home/risus/.local/bin";
      SOURCE_HOME = "/home/risus/.local/src";
      PROJECTS_DIR = "/home/risus/Projects";
      # Default apps
      EDITOR = "lvim";
      TERMINAL = "alacritty";
      BROWSER = "brave";
      # ~/ Clean-up:
      GTK2_RC_FILES = "/home/risus/.config/gtk-2.0/gtkrc-2.0";
      LESSHISTFILE = "-";
      WGETRC = "/home/risus/.config/wget/wgetrc";
      INPUTRC = "/home/risus/.config/inputrc";
      PASSWORD_STORE_DIR = "/home/risus/.local/share/password-store";
      NVM_DIR = "/home/risus/.config/nvm";
      WORKON_HOME = "/home/risus/.local/share/virtualenvs";
      # fixes only user prefrences, directories .java/fonts and something else will remain
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot='/home/risus/.config/java'";
      IPYTHONDIR = "/home/risus/.config/jupyter";
      JUPYTER_CONFIG_DIR = "/home/risus/.config/jupyter";
      CUDA_CACHE_PATH = "/home/risus/.cache/nv";
      # pg dirs should be created before hand
      PSQLRC = "/home/risus/.config/pg/psqlrc";
      PSQL_HISTORY = "/home/risus/.cache/pg/psql_history";
      PGPASSFILE = "/home/risus/.config/pg/pgpass";
      PGSERVICEFILE = "/home/risus/.config/pg/pg_service.conf";
      MYSQL_HISTFILE = "/home/risus/.local/share/mysql_history";
      # should be created
      PYTHONSTARTUP = "/home/risus/.local/share/python_history";
      AWS_CONFIG_FILE = "/home/risus/.config/aws/credentials";
      ANDROID_SDK_HOME = "/home/risus/.config/android";
      GNUPGHOME = "/home/risus/.local/share/gnupg";
      POETRY_HOME = "/home/risus/.local/share/poetry";
      VAGRANT_HOME = "/home/risus/.local/share/vagrant";
      VAGRANT_ALIAS_FILE = "/home/risus/.local/share/vagrant/aliases";
      HISTFILE = "/home/risus/.local/share/bash/history";
      NODE_REPL_HISTORY = "/home/risus/.local/share/node_repl_history";
      # https://github.com/npm/npm/issues/6675#issuecomment-251049832
      NPM_CONFIG_USERCONFIG = "/home/risus/.config/npm/config";
      NPM_CONFIG_CACHE = "/home/risus/.cache/npm";
      NPM_CONFIG_TMP = "/run/user/1000/npm";
      GOPATH = "/home/risus/.local/src/go";
      GOBIN = "/home/risus/.local/bin/go";
      CARGO_HOME = "~/.local";
      RUSTUP_HOME = "/home/risus/.cache/rustup";
      # Settings
      VAGRANT_DEFAULT_PROVIDER = "kvm";
      VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
      DOCKER_BUILDKIT = "1";
      # appearance
      # https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications
      # style qt apps as gtk, requires qt5-styleplugins
      QT_QPA_PLATFORMTHEME = "gtk2";
      # I didn't install xdg-desktop-portal-kde (it's for kde, to much to only make kde dialogs look ok)
      GTK_USE_PORTAL = "1";

      # TEMPORARY FOR RUNNING IN WITHOUT HW RENDERING
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      HYPRLAND_LOG_WLR = "1";
    };

    home.stateVersion = "23.11";
  };
  
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
