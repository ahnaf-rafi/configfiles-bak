{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
    ../darwin-common.nix
  ];

  # Host-specific system packages
  environment.systemPackages = with pkgs; [
    # Add packages specific to this machine
    # Example: docker-desktop, specific development tools
  ];

  # Host-specific settings
  # networking.hostName = "Ahnafs-MacBook-Pro";
  # networking.localHostName = "Ahnafs-MacBook-Pro";
}
