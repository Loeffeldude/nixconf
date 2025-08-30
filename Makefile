HOST ?= $(shell hostname)

switch:
	sudo nixos-rebuild switch --flake .#${HOST}

switch-darwin:
	sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#${HOST}

dump-hardware-config:
	nixos-generate-config --show-hardware-config > ./hosts/${HOST}/hardware-configuration.nix

update:
	nix flake update

build:
	nixos-rebuild build --flake .#${HOST}

test:
	nixos-rebuild test --flake .#${HOST}
