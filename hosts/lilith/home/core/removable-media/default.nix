# Removable media: automount USB devices and surface them as desktop
# notifications.
{
  services.udiskie = {
    enable = true;
    notify = true;
    automount = true;
  };
}
