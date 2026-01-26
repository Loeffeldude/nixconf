HOST := `hostname`
UNAME := `uname`

# Switch system configuration (auto-detects Darwin/NixOS)
switch:
    @if [ "{{UNAME}}" = "Darwin" ]; then just switch-darwin; else just switch-nixos; fi

# Switch Darwin (macOS) configuration
switch-darwin:
    sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#{{HOST}}

# Switch NixOS configuration
switch-nixos:
    sudo nixos-rebuild switch --flake .#{{HOST}}

# Build WSL tarball
build-wsl:
    sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
    mkdir -p dist/
    mv nixos.wsl dist/

# Generate hardware configuration for current host
dump-hardware-config:
    nixos-generate-config --show-hardware-config > ./hosts/{{HOST}}/hardware-configuration.nix

# Update flake inputs
update:
    nix flake update

# Build system configuration without switching
build:
    nixos-rebuild build --flake .#{{HOST}}

# Test system configuration (temporary activation)
test:
    nixos-rebuild test --flake .#{{HOST}}
