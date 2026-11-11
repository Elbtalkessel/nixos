{
  my.core.microvm = {
    atlas = {
      ip = "192.168.122.10";
      mac = "02:00:00:00:00:01";
      itype = "bridge";
    };
  };
  # Part host, part vm configuration.
  # VM opens port for services that has matching IP address,
  # host create vhost for all records that request proxy.
  # Unless subdomain is set, address will be "<attrname>.<domain>"
  my.srv = {
    domain = "s3.home.arpa";
    opencode = {
      enable = true;
      proxy = true;
      ip = "192.168.122.10";
      port = 4096;
      subdomain = "oc";
    };
    localsrv = {
      enable = true;
      proxy = true;
      ip = "192.168.122.10";
      port = 8080;
      subdomain = "srv";
    };
    comfyui = {
      enable = false;
      proxy = true;
      ip = "127.0.0.1";
      port = 8188;
    };
    nsrv = {
      enable = true;
      proxy = true;
      ip = "127.0.0.1";
      port = 9998;
    };
  };
}
