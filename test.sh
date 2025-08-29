#!/usr/bin/env nix-shell
#!nix-shell --impure -i bash -p nixpkgs-fmt jq

# Get packages from your flake

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
export NIXPKGS_ALLOW_BROKEN=1

packages=$(nix eval --impure .#darwinConfigurations.vm.config.home-manager.users.loeffel.home.packages --json | jq -r '.[] | .pname // .name' | sort -u)

echo "Testing flake packages for Darwin availability..."

for pkg in $packages; do
  result=$(nix-instantiate --eval --expr "with import <nixpkgs> { system = \"x86_64-darwin\"; }; builtins.hasAttr \"$pkg\" pkgs" 2>/dev/null)

  if [[ "$result" == "false" ]]; then
    echo "NOT AVAILABLE: $pkg"
  elif [[ "$result" == "true" ]]; then
    echo "Available: $pkg"
  else
    echo "UNKNOWN: $pkg"
  fi
done
unset NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM
