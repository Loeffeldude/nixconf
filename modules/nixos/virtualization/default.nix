{ config, pkgs, ... }: {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

<<<<<<< HEAD
  users.users.nicokratschmer.extraGroups = [ "libvirtd" "qemu-libvirtd" ];
=======
  users.users.${config.primaryUser}.extraGroups = [ "libvirtd" "qemu-libvirtd" ];
>>>>>>> f276465ad57f25e9173ccaa7aabd411376527756

  boot.kernel.sysctl."net.ipv4.ip_forward" =
    1; # 1. Enable IP forwarding (required for NAT)
  networking.firewall.trustedInterfaces =
    [ "virbr0" ]; # 2. Tell firewall to trust the libvirt bridge
}
