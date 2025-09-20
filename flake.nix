{
  description = "Ahnaf Rafi's nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
  };

  outputs = inputs@{
    self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, neovim-nightly, 
    nix-homebrew, homebrew-core, homebrew-cask,
  }:

  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mb-air-work
    darwinConfigurations."mb-air-work" = nix-darwin.lib.darwinSystem {
      specialArgs = inputs;
      modules = [ 
        ./hosts/mb-air-work
      ];
    };
  };
}
