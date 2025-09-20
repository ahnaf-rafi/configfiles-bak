{ config, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  # Host-specific system packages
  environment.systemPackages = [
    # Add packages specific to this machine
    # Example: docker-desktop, specific development tools
    pkgs.google-chrome
  ];

  # Host-specific settings
  # networking.hostName = "Ahnafs-MacBook-Pro";
  # networking.localHostName = "Ahnafs-MacBook-Pro";
}
