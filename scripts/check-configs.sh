#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Create temporary file
ERROR_LOG=$(mktemp)
trap 'rm -f "$ERROR_LOG"' EXIT

echo "Checking NixOS configurations..."

# Check NixOS configurations
for host in qemu t500 t15 ms7e57; do
  echo -n "Checking $host... "
  if nix build .#nixosConfigurations.$host.config.system.build.toplevel --dry-run 2>"$ERROR_LOG"; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${RED}FAILED${NC}"
    echo -e "\nError output for $host:"
    cat "$ERROR_LOG"
    exit 1
  fi
done

# Check Darwin configurations
echo -n "Checking Darwin VM configuration... "
if nix build .#darwinConfigurations.vm.config.system.build.toplevel --dry-run 2>"$ERROR_LOG"; then
  echo -e "${GREEN}OK${NC}"
else
  echo -e "${RED}FAILED${NC}"
  echo -e "\nError output for Darwin VM:"
  cat "$ERROR_LOG"
  exit 1
fi

# # Check Home Manager configurations
# echo -n "Checking Home Manager configuration... "
# if nix build .#homeManagerConfigurations.loeffel.activationPackage --dry-run 2>"$ERROR_LOG"; then
#   echo -e "${GREEN}OK${NC}"
# else
#   echo -e "${RED}FAILED${NC}"
#   echo -e "\nError output for Home Manager:"
#   cat "$ERROR_LOG"
#   exit 1
# fi

echo -e "\n${GREEN}All configurations validated successfully!${NC}"
