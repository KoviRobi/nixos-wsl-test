{
  inputs.nixpkgs.url = "nixpkgs";

  inputs.NixOS-WSL.url = "github:nix-community/NixOS-WSL";
  inputs.NixOS-WSL.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager, NixOS-WSL }: {

    nixosConfigurations.wsl-test = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        NixOS-WSL.nixosModules.wsl
        ({ pkgs, lib, ... }: {
          wsl = {
            enable = true;
            automountPath = "/mnt";
            defaultUser = "test";
            startMenuLaunchers = true;

            # Enable native Docker support
            # docker-native.enable = true;

            # Enable integration with Docker Desktop (needs to be installed)
            # docker-desktop.enable = true;

          };

          # Enable nix flakes
          nix.package = pkgs.nixFlakes;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
        })
      ];
    };
  };
}
