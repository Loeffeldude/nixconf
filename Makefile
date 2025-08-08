HOST ?= $(shell hostname)

switch:
	sudo nixos-rebuild switch --flake .#${HOST}

update:
	nix flake update

build:
	nixos-rebuild build --flake .#${HOST}

test:
	nixos-rebuild test --flake .#${HOST}
