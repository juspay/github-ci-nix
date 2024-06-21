{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    github-ci-nix = { };
  };
  outputs = inputs: {
    nixosConfigurations.example = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.github-ci-nix.nixosModules.default
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          fileSystems."/" = { device = "/dev/sda"; fsType = "ext"; };
          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };
          system.stateVersion = "24.05";
        }
      ];
    };

    darwinConfigurations.example = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        inputs.github-ci-nix.darwinModules.default
        {
          nixpkgs.hostPlatform = "aarch64-darwin";
          services.nix-daemon.enable = true;
        }
      ];
    };
  };
}
