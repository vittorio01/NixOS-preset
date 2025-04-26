{
  description = "personal configuration for my NixOS systems";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, nixos-hardware, cachix}: {
    nixosConfigurations.skywalker-vm = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./modules/hardware/hardware.nix
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
          hardware.hardware-profile="QEMU";
          services.openssh.enable=true;
          services.flatpak.enable=true;
          services.xserver.desktopManager.gnome.enable=true;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=false;
            applications.misc=true;
            applications.videoEditing=false;
            applications.programming=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
          };
        }
        )
      ];
    };
    nixosConfigurations.skywalker-tuf = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        nixos-hardware.nixosModules.asus-fa507nv
        ./modules/hardware/hardware.nix
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
          hardware.hardware-profile="FA507NU";
          virtualisation.virtualbox.host.enable=true;
          services.openssh.enable=true;
          virtualisation.libvirtd.enable=true;
          ollama.enable = true;
          services.flatpak.enable=true;
          virtualisation.docker.enable=true;
          programs.steam.enable=true;
          hardware.asus.battery.enableChargeUptoScript = true;
          hardware.asus.battery.chargeUpto = 80;
          users.users.vittorio.extraGroups = [ "audio" "realtime"];
          launchpad.enable=true;

          services.xserver.desktopManager.gnome.enable=true;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=true;
            applications.misc=true;
            applications.videoEditing=true;
            applications.programming=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
          };
        }
        )
      ];
    };
nixosConfigurations.skywalker-r3 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      system = "x86_64-linux";
      modules = [ 
        nix-flatpak.nixosModules.nix-flatpak
        ./modules/hardware/hardware.nix
        ./configuration.nix
        ./modules/system/modules.nix
        home-manager.nixosModules.home-manager
        (
        {config,lib,...}:
        {
          hardware.hardware-profile="R3";
          virtualisation.virtualbox.host.enable=true;
          services.openssh.enable=true;
          virtualisation.libvirtd.enable=true;
          services.flatpak.enable=true;
          virtualisation.docker.enable=true;
          programs.steam.enable=true;
          services.samba.enable=true;
          launchpad.enable=true;
          services.xserver.desktopManager.gnome.enable=true;
          users.users.vittorio.extraGroups = [ "audio" "realtime"];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vittorio = {
            imports = [./modules/home/home.nix];
            home.username = "vittorio";
            home.homeDirectory = "/home/vittorio";

            applications.CADs=true;
            applications.gaming=true;
            applications.misc=true;
            applications.videoEditing=true;
            applications.programming=true;

            home.stateVersion = "24.11";
            programs.home-manager.enable = true;
          };
          home-manager.extraSpecialArgs = {
            flake-inputs = inputs;
            systemConfig = config;
          };
        })
      ];
    };
  };
}
