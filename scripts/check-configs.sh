#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Checking NixOS configurations..."

# Check NixOS configurations
for host in qemu t500 t15 ms7e57; do
  echo -n "Checking $host... "
  if nix build .#nixosConfigurations.$host.config.system.build.toplevel --dry-run &>/dev/null; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${RED}FAILED${NC}"
    exit 1
  fi
done

# Check Darwin configurations
echo -n "Checking Darwin VM configuration... "
if nix build .#darwinConfigurations.vm.config.system.build.toplevel --dry-run &>/dev/null; then
  echo -e "${GREEN}OK${NC}"
else
  echo -e "${RED}FAILED${NC}"
  exit 1
fi

# # Check Home Manager configurations
# echo -n "Checking Home Manager configuration... "
# if nix build .#homeManagerConfigurations.loeffel.activationPackage --dry-run &>/dev/null; then
#   echo -e "${GREEN}OK${NC}"
# else
#   echo -e "${RED}FAILED${NC}"
#   exit 1
# fi

echo -e "\n${GREEN}All configurations validated successfully!${NC}"
