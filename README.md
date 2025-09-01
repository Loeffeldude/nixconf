# My NixOS Configurations

My personal Nix configurations.
For MacOS, NixOS and WSL.

<img src="./media/screenshot.png" width="100%" alt="NixOS Screenshot" >

## Getting Started

Use the `Makefile` to simplify common operations. The `HOST` variable is automatically set to your system's hostname, but you can override it if needed.

### Applying the Configuration

#### NixOS

```sh
make switch
```

#### MacOS

```sh
make darwin-switch
```

#### WSL

You can build your own WSL file.
You need an existing Nix installation.

Run to build the WSL Image:

```sh
make build-wsl
```

Your build file is under dist/nixos.wsl

For an existing NixOS WSL installation:

```sh
make switch
```

### Updating Flake Inputs

To update the flake's inputs, run:

```sh
make update
```

### Other Useful Commands

- `make dump-hardware-config`: Dumps the hardware configuration to the appropriate host directory.
