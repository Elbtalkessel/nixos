_:
let
  # TODO(conf):
  #   - username is hardcoded.
  #   - can't be set anywhere else.
  sessionVariables = {
    XDG_DATA_HOME = "/home/risus/.local/share";
    XDG_CONFIG_HOME = "/home/risus/.config";
    XDG_CACHE_HOME = "/home/risus/.cache";
    XDG_DOWNLOAD_DIR = "/media/downloads";
    XDG_RUNTIME_DIR = "/run/user/1000";
    XDG_DESKTOP_DIR = "/media/desktop";
    XDG_DOCUMENTS_DIR = "/media/docs";
    XDG_MUSIC_DIR = "/media/music";
    XDG_PICTURES_DIR = "/media/pictures";
    XDG_PUBLICSHARE_DIR = "/media/public";
    XDG_TEMPLATES_DIR = "/media/templates";
    XDG_VIDEOS_DIR = "/media/videos";
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "vivaldi";
    VAGRANT_DEFAULT_PROVIDER = "kvm";
    VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
    DOCKER_BUILDKIT = "1";
    PASSWORD_STORE_DIR = "/home/risus/.local/share/pwdstr";
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };
in
{
  home = {
    inherit sessionVariables;
  };
  programs.nushell.environmentVariables = sessionVariables;
}
