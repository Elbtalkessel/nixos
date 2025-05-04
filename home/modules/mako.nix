_: {
  # Requires libnotify
  services.mako = {
    enable = true;
    settings = {
      backgroundColor = "#282828CC";
      textColor = "#ebdbb2";
      borderColor = "#32302f";
      progressColor = "over #414559";
      borderRadius = "10";
      defaultTimeout = "5000";
      font = "OverpassM Nerd Font 14";
    };
    criterias = {
      "urgency=low" = {
        defaultTimeout = "2500";
      };
      "urgency=high" = {
        textColor = "#fb4934";
        defaultTimeout = "0";
      };
    };
  };
}
