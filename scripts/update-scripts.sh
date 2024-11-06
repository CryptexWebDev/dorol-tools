#!/usr/bin/env bash

NODE_TOOLS_VERSION=0.0.1f

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/CryptexWebDev/dorol-tools/refs/heads/main/update/update-node-tools.sh)"