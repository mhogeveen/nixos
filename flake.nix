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
    amane = {
      url = "github:MystiaFin/amane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

      # The one unfree allowlist, applied to both the system nixpkgs and
      # pkgs-unstable (a separate instantiation doesn't inherit nixpkgs.config).
      unfreePackages = [
        "claude-code"
      ];
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfreePackages;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = { inherit allowUnfreePredicate; };
      };
    in
    {
      nixosConfigurations.prometheus = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [
          ./modules/user.nix
          ./hosts/prometheus
          mangowm.nixosModules.mango
          home-manager.nixosModules.home-manager
          (
            { config, ... }:
            {
              nixpkgs.config = { inherit allowUnfreePredicate; };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs pkgs-unstable; };
                users.${config.user.name} = import ./home;
                backupFileExtension = "backup";
              };
            }
          )
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
