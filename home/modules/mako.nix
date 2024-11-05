_: {
  # Requires libnotify
  services.mako = {
    enable = true;
    backgroundColor = "#282828CC";
    textColor = "#ebdbb2";
    borderColor = "#32302f";
    progressColor = "over #414559";
    borderRadius = 10;
    defaultTimeout = 5000;
    font = "OverpassM Nerd Font 14";
    extraConfig = "
[urgency=low]
default-timeout=2500
[urgency=high]
text-color=#fb4934
default-timeout=0
";
  };
}
