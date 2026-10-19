# Baseline security services and sudo configuration.
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    # ****** when typing password, insecure, but looks better :)
    sudo.extraConfig = ''
      Defaults pwfeedback
    '';
  };
}
