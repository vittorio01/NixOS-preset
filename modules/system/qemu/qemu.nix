{config, lib, pkgs, inputs, ...}:
let 
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  config = lib.mkIf (config.virtualisation.libvirtd.enable) {
    programs.dconf.enable = lib.mkDefault true;
    #users.users.gcis.extraGroups = [ "libvirtd" ];
    users.extraGroups.libvirtd.members = [ "gcis" ];
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice 
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
      looking-glass-client
    ];

    virtualisation = {
      libvirtd = {
        qemu = {
          swtpm.enable = lib.mkDefault true;
          ovmf.enable = lib.mkDefault true;
          ovmf.packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
          runAsRoot=true;
        };
        hooks.qemu = {
          qemu = ./hooks;
        };
      };
      
      spiceUSBRedirection.enable = lib.mkDefault true;
    };
    services.spice-vdagentd.enable = lib.mkDefault true;

    system.activationScripts.installLibvirtHooks.text = ''
      rm -rf /var/lib/libvirt/hooks
      mkdir -p /var/lib/libvirt/hooks
      cp -r /etc/nixos/modules/system/qemu/hooks/* /var/lib/libvirt/hooks/
      chmod +x /var/lib/libvirt/hooks/qemu
      find /var/lib/libvirt/hooks/qemu.d -type f -exec chmod +x {} +
    '';

  };
  
}
