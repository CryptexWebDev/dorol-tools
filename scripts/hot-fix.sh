#!/usr/bin/env bash

NODE_TOOLS_VERSION=0.0.1b

NODE_OS="unknown"
NODE_ARCH="unknown"
NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"

ARCH=$(uname -m)

TMP_DIR=$(mktemp -d)
cd $TMP_DIR

SCRIPTS="https://github.com/CryptexWebDev/dorol-tools/releases/download/0.1/scripts.tar.gz"
DEPOSIT_SEND="https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/deposit-send-linux-amd64.tar.gz"

echo "
$(tput setaf 3)$(tput bold)
Dorol Node HotFix $(tput sgr0)
$(tput setaf 5)Download updates...$(tput sgr0)

"

curl -L -o scripts.tar.gz $SCRIPTS
tar -xzf scripts.tar.gz
mv scripts/*sh $NODE_SCRIPTS_DIR/
chmod +x  $NODE_SCRIPTS_DIR/*sh

curl -L -o deposit-send.tar.gz $DEPOSIT_SEND
tar -xzf deposit-send.tar.gz

mv deposit-send $NODE_BIN_DIR/deposit-send
chmod +x $NODE_BIN_DIR/deposit-send

echo "Hot Fix Complete: $NODE_TOOLS_VERSION"