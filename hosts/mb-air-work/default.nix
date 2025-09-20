{ inputs, pkgs, ...}
let
  inherit (inputs) nixpkgs;
in
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  imports = [
    ../common/common.nix
    ../common/darwin-common.nix
  ]
}
