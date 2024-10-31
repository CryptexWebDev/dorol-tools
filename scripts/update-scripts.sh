#!/usr/bin/env bash

NODE_TOOLS_VERSION=0.0.1d

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"

SCRIPTS="https://github.com/CryptexWebDev/dorol-tools/releases/download/0.1/scripts.tar.gz"

echo "
$(tput setaf 3)$(tput bold)
Dorol Node Tools Update v0.0.1 $(tput sgr0)
$(tput setaf 5)Download updates...$(tput sgr0)

"
TMP_DIR=$(mktemp -d)
cd $TMP_DIR

curl -L -o scripts.tar.gz $SCRIPTS
tar -xzf scripts.tar.gz
mv scripts/*sh $NODE_SCRIPTS_DIR/
chmod +x  $NODE_SCRIPTS_DIR/*sh

echo "Node tools updated to version $NODE_TOOLS_VERSION"