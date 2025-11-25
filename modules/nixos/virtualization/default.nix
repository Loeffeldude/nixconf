{ config, pkgs, ... }: {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.${config.primaryUser}.extraGroups = [ "libvirtd" "qemu-libvirtd" ];

  boot.kernel.sysctl."net.ipv4.ip_forward" =
    1; # 1. Enable IP forwarding (required for NAT)
  networking.firewall.trustedInterfaces =
    [ "virbr0" ]; # 2. Tell firewall to trust the libvirt bridge
}
