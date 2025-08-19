<<<<<<< HEAD
# My NixOS Configurations

My personal NixOS and home-manager configurations.

## Getting Started

Use the `Makefile` to simplify common operations. The `HOST` variable is automatically set to your system's hostname, but you can override it if needed.

### Applying the Configuration

To apply the configuration to the current machine, run:

```bash
make switch
```

This is equivalent to running `sudo nixos-rebuild switch --flake .#$(hostname)`.

### Updating Flake Inputs

To update the flake's inputs, run:

```bash
make update
```

### Other Useful Commands

- `make build`: Builds the NixOS configuration.
- `make test`: Tests the NixOS configuration.
- `make dump-hardware-config`: Dumps the hardware configuration to the appropriate host directory.

To use a specific host configuration, you can pass the `HOST` variable to the make command:

```bash
make switch HOST=t15
```
=======
# My nix config
>>>>>>> feature/qemu-setup
