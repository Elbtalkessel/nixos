{
  services = {
    # The documented install flow configures machine access over SSH.
    # Admin access lands on root; `atlas` is an unprivileged runtime user
    # with no SSH login and no sudo. Drop in as root, then `su - atlas`.
    # Defaults for host key types, relocated onto the persistent volume --
    # /etc/ssh is tmpfs here.
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      hostKeys = [
        {
          path = "/var/lib/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
    # Accessable at atlas.local
    avahi.enable = true;
  };
}
