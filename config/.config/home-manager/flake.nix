{
  description = "nix-darwin and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
      username = "hiragayuria";
    in
    {
      darwinConfigurations."Hiragas-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            users.users.${username}.home = "/Users/${username}";
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
}
