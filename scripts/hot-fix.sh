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
VALIDATOR_PREPARE="https://raw.githubusercontent.com/CryptexWebDev/dorol-tools/refs/heads/main/scripts/validator-prepare.sh"
DEPOSIT_SEND="https://raw.githubusercontent.com/CryptexWebDev/dorol-tools/refs/heads/main/scripts/validator-make-deposit.sh"
echo "
$(tput setaf 3)$(tput bold)
Dorol Node HotFix $(tput sgr0)
$(tput setaf 5)Download updates...$(tput sgr0)

"

cd $NODE_SCRIPTS_DIR

curl -L -o validator-prepare.sh $VALIDATOR_PREPARE
chmod +x validator-prepare.sh

curl -L -o validator-make-deposit.sh $DEPOSIT_SEND
chmod +x validator-make-deposit.sh

echo "Hot Fix Complete: $NODE_TOOLS_VERSION"