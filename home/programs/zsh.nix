{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };
}
