{
  lib,
  config,
  pkgs,
  ...
}:
{
  services = {
    greetd = {
      enable = lib.mkDefault true;
      settings =
        let
          cmd = if config.my.wm.uwsm.enable then "uwsm start hyprland-uwsm.desktop" else "start-hyprland";
        in
        {
          initial_session = {
            command = cmd;
            user = config.my.username;
          };
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --asterisks --remember --time --cmd '${cmd}'";
          };
        };
    };
  };

}
