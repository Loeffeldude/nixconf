HOST ?= $(shell hostname)

switch:
	sudo nixos-rebuild switch --flake .#${HOST}

switch-darwin:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#${HOST}

build-wsl:
	sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
	mkdir -p dist/
	mv nixos.wsl dist/

dump-hardware-config:
	nixos-generate-config --show-hardware-config > ./hosts/${HOST}/hardware-configuration.nix

update:
	nix flake update

build:
	nixos-rebuild build --flake .#${HOST}

test:
	nixos-rebuild test --flake .#${HOST}
