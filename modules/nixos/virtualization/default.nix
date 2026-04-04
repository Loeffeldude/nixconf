{ config, pkgs, ... }: {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
      verbatimConfig = ''
        user = "root"
        group = "root"
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm",
          "/dev/dri/renderD128"
        ]
      '';
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  users.users.${config.primaryUser}.extraGroups = [ "libvirtd" "qemu-libvirtd" "render" ];
  environment.systemPackages = with pkgs; [
    OVMF
    mesa
    virglrenderer
  ];
  boot.kernel.sysctl."net.ipv4.ip_forward" =
    1; # 1. Enable IP forwarding (required for NAT)
  networking.firewall.trustedInterfaces =
    [ "virbr0" ]; # 2. Tell firewall to trust the libvirt bridge
  
  # Enable graphics for VirtIO-GPU
  hardware.graphics.enable = true;
}
