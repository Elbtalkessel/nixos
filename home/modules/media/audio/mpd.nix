{ lib, config, ... }:
let
  enable = true;
  visualizer_data_source = "/tmp/mpd.fifo";
  visualizer_output_name = "Audio Visualizer";
  visualizer_output_format = "44100:16:2";
  visualizerSupport = true;
in
{
  services.mpd = {
    inherit enable;
    musicDirectory = config.home.sessionVariables.XDG_MUSIC_DIR;
    extraConfig =
      [
        ''
          audio_output {
            type "pipewire"
            name "Pipewire Audio Output"
          }
        ''
      ]
      ++ (lib.optional visualizerSupport ''
        audio_output {
          type "fifo"
          name "${visualizer_output_name}"
          path "${visualizer_data_source}"
          format "${visualizer_output_format}"
        }
      '')
      |> lib.strings.join "\n";
  };

  services.mpd-mpris = {
    inherit enable;
  };
}
