_: {
  services.nfs = {
    # required for vagrant with libvirt provider.
    server.enable = true;
  };
}
