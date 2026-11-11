{
  description = "NixOS";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    amane.url = "github:MystiaFin/amane";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      mangowm,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # A separate nixpkgs instantiation does not inherit the system-level
      # nixpkgs.config, so the unfree allowlist is repeated here.
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "claude-code"
          ];
      };
    in
    {
      nixosConfigurations.prometheus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./hosts/prometheus
          mangowm.nixosModules.mango
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs pkgs-unstable; };
              users.maarten = import ./home;
              backupFileExtension = "backup";
            };
          }
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
