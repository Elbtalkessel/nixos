{ config, ... }:
let
  HOME = "/home/${config.user}";
  sessionVariables = {
    XDG_DATA_HOME = "${HOME}/.local/share";
    XDG_CONFIG_HOME = "${HOME}/.config";
    XDG_CACHE_HOME = "${HOME}/.cache";
    XDG_DOWNLOAD_DIR = "${HOME}/Downloads";
    XDG_RUNTIME_DIR = "/run/${config.user}/1000";
    XDG_DESKTOP_DIR = "${HOME}/Desktop";
    XDG_DOCUMENTS_DIR = "${HOME}/Documents";
    XDG_MUSIC_DIR = "${HOME}/Music";
    XDG_PICTURES_DIR = "${HOME}/Pictures";
    XDG_PUBLICSHARE_DIR = "${HOME}/Public";
    XDG_TEMPLATES_DIR = "${HOME}/Templates";
    XDG_VIDEOS_DIR = "${HOME}/Videos";
    XDG_DATA_DIRS = "${HOME}/.local/share/flatpak/exports/share";
    EDITOR = config.editor;
    TERMINAL = config.terminal;
    BROWSER = config.browser;
    VAGRANT_DEFAULT_PROVIDER = "kvm";
    VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
    DOCKER_BUILDKIT = "1";
    PASSWORD_STORE_DIR = "${HOME}/.local/share/pwdstr";
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };
in
{
  home = {
    inherit sessionVariables;
  };
  programs.nushell.environmentVariables = sessionVariables;
}
