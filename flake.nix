{
  description = "NixOS";

  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # the cendre colour scheme's extras (bat theme for delta's syntax highlighting)
    cendre = {
      url = "github:Aejkatappaja/cendre";
      flake = false;
    };
    # arkenfox's hardened user.js; home/firefox.nix appends our overrides
    arkenfox = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
    amane = {
      url = "github:MystiaFin/amane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    strata = {
      url = "github:lgse/strata";
      # needs a newer rustc than 26.05 ships
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # the aoide music player (home/aoide.nix). no follows on purpose: with its own
    # locked nixpkgs and crane it is the build its checks ran against, and a
    # nixpkgs update here doesn't rebuild it (about 40 minutes on this machine).
    # over ssh while the repository is private; github:mhogeveen/aoide once public
    aoide.url = "git+ssh://git@github.com/mhogeveen/aoide";
    # secrets kept encrypted in this repository and decrypted at login (home/sops.nix)
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
        "1password"
        "1password-cli"
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
