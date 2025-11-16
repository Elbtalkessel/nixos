{ config, ... }:
let
  HOME = "/home/${config.my.username}";
  sessionVariables = rec {
    # https://wiki.archlinux.org/title/XDG_Base_Directory
    XDG_DATA_HOME = "${HOME}/.local/share";
    XDG_CONFIG_HOME = "${HOME}/.config";
    XDG_CACHE_HOME = "${HOME}/.cache";
    XDG_STATE_HOME = "${HOME}/.state";

    # https://wiki.archlinux.org/title/XDG_user_directories
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
    # TODO: shouldn't it work automagically?
    XDG_DATA_DIRS = "${HOME}/.local/share/flatpak/exports/share:/run/current-system/sw/share:${HOME}/.local/state/nix/profiles/home-manager/home-path/share:${HOME}/.local/share";

    # Configuration variables
    EDITOR = config.my.editor;
    TERMINAL = config.my.terminal.exe;
    VAGRANT_DEFAULT_PROVIDER = "libvirt";
    VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
    DOCKER_BUILDKIT = "1";
    PASSWORD_STORE_DIR = "${HOME}/.local/share/pwdstr";
    OLLAMA_HOST = "http://127.0.0.1:11434";

    # ~ cleaning
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    MIX_XDG = "true";
    KUBECONFIG = "${XDG_CONFIG_HOME}/kube";
    KUBECACHEDIR = "${XDG_CACHE_HOME}/kube";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
    ANSIBLE_HOME = "${XDG_CONFIG_HOME}/ansible";
    ANSIBLE_CONFIG = "${XDG_CONFIG_HOME}/ansible.cfg";
    ANSIBLE_GALAXY_CACHE_DIR = "${XDG_CACHE_HOME}/ansible/galaxy_cache";
    VAGRANT_HOME = "${XDG_DATA_HOME}/vagrant";
    VAGRANT_ALIAS_FILE = "${XDG_DATA_HOME}/vagrant/aliases";
    NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
    # TODO(conf): ensure state home and .config/pg directories exist.
    PSQLRC = "${XDG_CONFIG_HOME}/pg/psqlrc";
    PSQL_HISTORY = "${XDG_STATE_HOME}/psql_history";
    PGPASSFILE = "${XDG_CONFIG_HOME}/pg/pgpass";
    PGSERVICEFILE = "${XDG_CONFIG_HOME}/pg/pg_service.conf";
    PYTHON_HISTORY = "${XDG_STATE_HOME}/python_history";
    # ensure these directories exist.
    PYTHONPYCACHEPREFIX = "${XDG_CACHE_HOME}/python";
    PYTHONUSERBASE = "${XDG_DATA_HOME}/python";
    # ensure directory exists.
    HISTFILE = "${XDG_STATE_HOME}/bash/history";
    GOPATH = "${XDG_DATA_HOME}/go";
    GOMODCACHE = "${XDG_CACHE_HOME}/go/mod";
  };
in
{
  home = {
    inherit sessionVariables;
  };
  programs.nushell.environmentVariables = sessionVariables;
}
