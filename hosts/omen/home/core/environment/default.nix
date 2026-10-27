{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    sessionVariables = {
      # Configuration variables
      EDITOR = config.my.apps.editor;
      TERMINAL = config.my.apps.terminal.exe;

      # Defaults
      VAGRANT_DEFAULT_PROVIDER = "libvirt";
      VIRSH_DEFAULT_CONNECT_URI = "qemu:///system";
      DOCKER_BUILDKIT = "1";

      # ~ cleaning
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pwdstr";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      MIX_XDG = "true";
      KUBECONFIG = "${config.xdg.configHome}/kube";
      KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
      ANSIBLE_HOME = "${config.xdg.configHome}/ansible";
      ANSIBLE_CONFIG = "${config.xdg.configHome}/ansible.cfg";
      ANSIBLE_GALAXY_CACHE_DIR = "${config.xdg.cacheHome}/ansible/galaxy_cache";
      VAGRANT_HOME = "${config.xdg.dataHome}/vagrant";
      VAGRANT_ALIAS_FILE = "${config.xdg.dataHome}/vagrant/aliases";
      NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
      # TODO(conf): ensure state home and .config/pg directories exist.
      PSQLRC = "${config.xdg.configHome}/pg/psqlrc";
      PSQL_HISTORY = "${config.xdg.stateHome}/psql_history";
      PGPASSFILE = "${config.xdg.configHome}/pg/pgpass";
      PGSERVICEFILE = "${config.xdg.configHome}/pg/pg_service.conf";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
      # ensure these directories exist.
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
      # ensure directory exists.
      HISTFILE = "${config.xdg.stateHome}/bash/history";
      GOPATH = "${config.xdg.dataHome}/go";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";

      # Colored man pages
      MANPAGER = "sh -c 'col -bx | ${lib.getExe pkgs.bat} -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
