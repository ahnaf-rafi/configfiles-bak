{ config, pkgs, inputs, ...}:
{
  # macOS system settings
  system.defaults = {
    dock.autohide = true;
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.AppleShowAllExtensions = true;
  };
}
