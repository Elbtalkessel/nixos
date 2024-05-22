{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  #env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ pkgs.git ];

  # https://devenv.sh/scripts/
  #scripts.hello.exec = "echo hello from $GREET";

  #enterShell = ''
  #'';

  # https://devenv.sh/tests/
  #enterTest = ''
  #'';

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/languages/
  # languages.nix.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
  pre-commit.hooks = {
    switchHome = {
      enable = true;
      name = "Apply home configuration";
      entry = "bash ./switch.sh --home";
      stages = ["pre-push"];
      types = ["nix"];
      files = "^home/";
      pass_filenames = false;
      fail_fast = true;
    };
    switchSystem = {
      enable = true;
      name = "Apply system configuration";
      entry = "bash ./switch.sh --system";
      stages = ["pre-push"];
      types = ["nix"];
      files = "^system/";
      pass_filenames = false;
      fail_fast = true;
    };
  };
}
