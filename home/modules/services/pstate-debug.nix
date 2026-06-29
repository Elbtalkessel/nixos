{ lib, pkgs, ... }:
let
  enable = false;
in
{
  systemd = {
    user.services = lib.mkIf enable {
      nvidia-pstate-logger = {
        Unit = {
          Description = "NVIDIA P-State Logger";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = pkgs.writeShellScript "nvidia-pstate-logger" ''
            #!/usr/bin/env bash

            command -v nvidia-smi >/dev/null || exit

            log_file="$HOME/npstate_$(date +'%s').csv"
            if [ ! -f "$log_file" ]; then
              echo "timestamp,power_w,temp_c,pstate,link_speed,link_width,status" >> "$log_file"
            fi

            while true; do
              stamp=$(date +'%s')
              state=$(nvidia-smi --query-gpu=power.draw,temperature.gpu,pstate --format=csv,noheader,nounits 2>/dev/null)
              speed=$(</sys/bus/pci/devices/0000:01:00.0/current_link_speed)
              width=$(</sys/bus/pci/devices/0000:01:00.0/current_link_width)
              status=$(</sys/bus/pci/devices/0000:01:00.0/power/runtime_status)

              printf "%s, %s, %s, %s, %s\n" "$stamp" "$state" "$speed" "$width" "$status" >> "$log_file"
              sleep 1
            done
          '';
        };
      };
    };
  };
}
