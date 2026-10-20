# MicroVM guest: the hypervisor module plus Home Manager integration.
#
# A guest's system tree owns its user tree so a single rebuild -- whether
# `nixos-rebuild switch` or `microvm -u` -- activates both at boot. Home
# Manager is therefore wired as a NixOS module here rather than as the
# standalone `homeFor` build.
{
  config,
  lib,
  self,
  hostName,
  hostDescriptor,
  homeSpecialArgs,
  sopsConfig,
  microvm,
  home-manager,
  sops-nix,
  ...
}:
{
  imports = [
    microvm.nixosModules.microvm
    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = homeSpecialArgs;

    users.${config.my.username} = {
      imports = [
        (self + "/options")
        { my.username = hostDescriptor.user; }
      ]
      ++ (lib.optional hostDescriptor.sops {
        imports = [ sops-nix.homeManagerModules.sops ];
        sops = sopsConfig;
        home.sessionVariables.SOPS_AGE_KEY_FILE = "/etc/sops-nix/key.txt";
      })
      ++ [ (self + "/hosts/${hostName}/home.nix") ];
    };
  };
}
