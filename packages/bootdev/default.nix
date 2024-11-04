{ pkgs }:
let
  version = "1.10.1";
in
pkgs.buildGoModule {
  pname = "bootdev";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "bootdotdev";
    repo = "bootdev";
    rev = "v${version}";
    sha256 = "sha256-mgicbuN/CrqqEcORMmFLHYtxYPxHvLVt9UnP1ksDdkE=";
  };

  vendorHash = "sha256-jhRoPXgfntDauInD+F7koCaJlX4XDj+jQSe/uEEYIMM=";

  meta = with pkgs.lib; {
    description = "Boot.dev cli tool";
    homepage = "https://github.com/bootdotdev/bootdev";
    license = licenses.mit;
  };
}