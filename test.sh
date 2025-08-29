#!/usr/bin/env nix-shell
#!nix-shell --impure -i bash -p nixpkgs-fmt jq

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
export NIXPKGS_ALLOW_BROKEN=1

echo "Getting package names from your config..."

# Try to get just the attribute names from your packages list
package_attrs=$(nix eval --impure .#darwinConfigurations.vm.config.home-manager.users.loeffel.home.packages --apply 'pkgs: map (p: p.pname or p.name or "unknown") pkgs' --json 2>/dev/null)

if [[ $? -eq 0 ]]; then
  packages=$(echo "$package_attrs" | jq -r '.[]' | sort -u)
else
  echo "Evaluation failed, trying to extract from source files..."
  # Look for common patterns in nix files
  packages=$(find . -name "*.nix" -exec grep -E '\b[a-zA-Z0-9_-]+\b' {} \; | grep -v '^#' | tr ' ' '\n' | grep -E '^[a-z][a-zA-Z0-9_-]*$' | sort -u | head -100)
fi

echo "Testing packages for Darwin availability..."

for pkg in $packages; do
  if [[ -z "$pkg" || "$pkg" == "null" || "$pkg" == "unknown" ]]; then
    continue
  fi

  # Test both x86_64-darwin and aarch64-darwin
  result_x86=$(nix-instantiate --eval --expr "with import <nixpkgs> { system = \"x86_64-darwin\"; }; builtins.hasAttr \"$pkg\" pkgs" 2>/dev/null)
  result_aarch64=$(nix-instantiate --eval --expr "with import <nixpkgs> { system = \"aarch64-darwin\"; }; builtins.hasAttr \"$pkg\" pkgs" 2>/dev/null)

  if [[ "$result_x86" == "false" && "$result_aarch64" == "false" ]]; then
    echo "NOT AVAILABLE: $pkg (neither x86_64 nor aarch64)"
  elif [[ "$result_x86" == "true" && "$result_aarch64" == "false" ]]; then
    echo "PARTIAL: $pkg (only x86_64-darwin)"
  elif [[ "$result_x86" == "true" && "$result_aarch64" == "true" ]]; then
    echo "Available: $pkg (both architectures)"
  else
    echo "UNKNOWN: $pkg"
  fi
done

unset NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM
