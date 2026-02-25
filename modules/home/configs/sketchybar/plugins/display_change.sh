#!/usr/bin/env bash

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

# Reinitialize workspaces when displays change
"$CONFIG_DIR/plugins/init_workspaces.sh" --no-delay
