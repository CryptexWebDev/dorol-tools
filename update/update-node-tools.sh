#!/usr/bin/env bash

NODE_TOOLS_VERSION=0.0.1f

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"

SCRIPTS="https://github.com/CryptexWebDev/dorol-tools/releases/download/0.1/scripts.tar.gz"

echo "
$(tput setaf 3)$(tput bold)
Dorol Node Tools Update v0.0.1f $(tput sgr0)
$(tput setaf 5)Download updates...$(tput sgr0)

"
TMP_DIR=$(mktemp -d)
cd $TMP_DIR

curl -L -o scripts.tar.gz $SCRIPTS
tar -xzf scripts.tar.gz
mv scripts/*sh $NODE_SCRIPTS_DIR/
chmod +x  $NODE_SCRIPTS_DIR/*sh

rm -rf $NODE_BIN_DIR/balances-view

NODE_OS="unknown"
NODE_ARCH="unknown"
OSTYPE=$(uname -s)
ARCH=$(uname -m)

if [[ "$OSTYPE" == "Linux"* ]]; then
        NODE_OS="linux"
elif [[ "$OSTYPE" == "Darwin"* ]]; then
        NODE_OS="darwin"
else
        echo "Unsupported OS: $OSTYPE"
        exit 1
fi

echo "Downloading balances-view tool for $NODE_OS/$NODE_ARCH"
curl -L -o  balances-view.tar.gz https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/balances-view-$NODE_OS-$NODE_ARCH.tar.gz
tar -xzf balances-view.tar.gz
ls -laR
mv balances-view $NODE_BIN_DIR
chmod +x $NODE_BIN_DIR/balances-view

echo "Node tools updated to version $NODE_TOOLS_VERSION"