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

      mkDarwinSystem = { hostname, username, isMacMini ? false }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit isMacMini username; };
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              networking.hostName = hostname;
              users.users.${username}.home = "/Users/${username}";
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        "private-m1-macbookpro" = mkDarwinSystem {
          hostname = "Hiragas-MacBook-Pro";
          username = "hiragayuria";
          isMacMini = false;
        };
        "private-m4-macmini" = mkDarwinSystem {
          hostname = "Yurias-Mac-mini";
          username = "yuyu-hf";
          isMacMini = true;
        };
      };
    };
}
