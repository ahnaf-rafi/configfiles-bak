{
  description = "Ahnaf Rafi's dotfiles with nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self, nixpkgs, nix-darwin, home-manager,
    nix-homebrew, homebrew-core, homebrew-cask,
    neovim-nightly-overlay, ...
  }@inputs: {
    # macOS configurations
    darwinConfigurations = {

      # "macbook-pro" = darwin.lib.darwinSystem {
      #   system = "aarch64-darwin"; # or x86_64-darwin
      #   modules = [
      #     ./hosts/darwin-common.nix
      #     ./hosts/macbook-pro
      #     home-manager.darwinModules.home-manager
      #     {
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #       home-manager.users.yourusername = import ./home/darwin.nix;
      #     }
      #   ];
      #   specialArgs = { inherit inputs; };
      # };

      "mb-air-work" = darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # or x86_64-darwin
        modules = [
          ./hosts/darwin-common.nix
          ./hosts/work-macbook-air
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yourusername = import ./home/darwin.nix;
            # Work-specific home manager settings
            home-manager.extraSpecialArgs = {
              inherit inputs;
              isWorkMachine = true;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };

    # # Future NixOS configuration
    # nixosConfigurations = {
    #   "nixos-workstation" = nixpkgs.lib.nixosSystem {
    #     system = "x86_64-linux";
    #     modules = [
    #       ./hosts/nixos-workstation
    #       home-manager.nixosModules.home-manager
    #       {
    #         home-manager.useGlobalPkgs = true;
    #         home-manager.useUserPackages = true;
    #         home-manager.users.ahnafrafi = import ./home/linux.nix;
    #       }
    #     ];
    #     specialArgs = { inherit inputs; };
    #   };
    # };

  };
}
