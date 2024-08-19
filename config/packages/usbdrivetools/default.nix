{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  pname = "usbdrivetools";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "satk0";
    repo = "usbdrivetools";
    rev = "main";
    sha256 = "sha256-fB1ma2WvAV+y41VicHxLKzeLIWDAaRFPsacAJgwDUvs=";
  };

  buildInputs = [pkgs.bash pkgs.rsync];

  installPhase = ''
    mkdir -p $out/bin
    cp -r scripts/* $out/bin/
    chmod +x $out/bin/*
  '';

  meta = with pkgs.lib; {
    description = "Simple bash tools that aim to help transfer files to USB Drive and monitor their syncing progress.";
    homepage = "https://github.com/satk0/usbdrivetools";
    license = licenses.gpl3;
  };
}
