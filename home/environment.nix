{ config, pkgs, ... }:
let
  HOME = "/home/${config.username}";
  sessionVariables = {
    # TODO(conf): system modules need to access to those variables as well,
    #   for example system/modules/sops.nix. Home Manager has config.xdg.configHome,
    #   but I don't think it is available for host configuration.
    XDG_DATA_HOME = "${HOME}/.local/share";
    XDG_CONFIG_HOME = "${HOME}/.config";
    XDG_CACHE_HOME = "${HOME}/.cache";
    XDG_DOWNLOAD_DIR = "${HOME}/Downloads";
    # TODO(conf): how can I replace hard-coded 1000?
    XDG_RUNTIME_DIR = "/run/user/1000";
    XDG_DESKTOP_DIR = "${HOME}/Desktop";
    XDG_DOCUMENTS_DIR = "${HOME}/Documents";
    XDG_MUSIC_DIR = "${HOME}/Music";
    XDG_PICTURES_DIR = "${HOME}/Pictures";
    XDG_PUBLICSHARE_DIR = "${HOME}/Public";
    XDG_TEMPLATES_DIR = "${HOME}/Templates";
    XDG_VIDEOS_DIR = "${HOME}/Videos";
    # TODO(conf): only if flatpak is installed.
    # TODO: shouldn't it work automagically?
    XDG_DATA_DIRS = "${HOME}/.local/share/flatpak/exports/share:/run/current-system/sw/share:${HOME}/.local/state/nix/profiles/home-manager/home-path/share:${HOME}/.local/share";
    EDITOR = config.editor;
    TERMINAL = pkgs.lib.getName config.terminal;
    # TODO(conf): only if vagrant + qemu is installed.
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
    # TODO(conf): only if qemu is installed.
    VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
    DOCKER_BUILDKIT = "1";
    PASSWORD_STORE_DIR = "${HOME}/.local/share/pwdstr";
    # TODO(conf): only if ollama is installed
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };
in
{
  home = {
    inherit sessionVariables;
  };
  programs.nushell.environmentVariables = sessionVariables;
}
