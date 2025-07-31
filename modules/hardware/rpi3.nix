{ config, pkgs, lib, inputs, ... }: 
{
  config = lib.mkIf (config.hardware.hardware-profile == "RPI3") {
    boot.loader.generic-extlinux-compatible.enable = true;
    swapDevices = [ { device = "/swap"; size = 4096; } ];

    environment.systemPackages = with pkgs; [
      libraspberrypi
    ];
    boot= {
      kernelParams = [
        "console=ttyS1,115200n8"
      ];
    };
    networking.interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.254";
          prefixLength = 24;
        }
      ];
    };
    hardware.enableRedistributableFirmware = true;
    networking.defaultGateway = "192.168.1.1";
    networking.nameservers = [ "192.168.1.1" "8.8.8.8" ];
  };
}
