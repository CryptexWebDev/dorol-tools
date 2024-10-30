#!/bin/bash

echo "
**********************************************************
*   Prepare validator keys and withdrawal credentials    *
**********************************************************

ATTENTION! This script can overwrite the existing validator keys!
Please make sure you have a backup of the existing keys before proceeding.

"
SCRIPTS_VERSION="0.1.0"

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BASE_DIR="$HOME/dorol"
NODE_BIN_DIR="$NODE_BASE_DIR/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_VALIDATOR_KEYS_DIR="$NODE_BASE_DIR/validator_keys"
NODE_VALIDATOR_DATA="$NODE_DATA_DIR/validator"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"
NODE_LOGS_DIR="$HOME/dorol/logs"

BEACON_CONFIG=$NODE_DATA_DIR/node/config.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

NODE_UPDATE_URL="https://github.com/CryptexWebDev/dorol-tools/releases/download/0.1/updates.tar.gz"

BOOT_NODE=""

trap 'echo "Error on line $LINENO"; exit 1' ERR
# Function to handle the cleanup
cleanup() {
    echo "
Caught Ctrl+C. Exiting."
    exit
}

restartMe() {
    echo "Restarting script..."
    exec $0
    exit 0
}

ask_for_confirmation() {
    while true
    do
        read -p "Do you want to continue? (y/n) " yn
        case $yn in
            [Yy] ) return;;
            [Nn] ) exit 0;;
            * ) echo "\nPlease answer y(es) or n(o).";;
        esac
    done
}

# Trap the SIGINT signal and call the cleanup function when it's caught
trap 'cleanup' SIGINT

cd $NODE_BASE_DIR
echo "Validator keys directory found.
This script can overwrite the existing validator keys!
Do you wish to overwrite the existing keys?"
if test -d "$NODE_VALIDATOR_KEYS_DIR"; then
    ask_for_confirmation
fi

echo "Check scripts updates..."

mkdir $UPDATES_DIR || echo "updates directory already exists, skip"

cd $UPDATES_DIR

TMP_DIR=$(mktemp -d)

cd $TMP_DIR

UPDATES_DIR=$TMP_DIR/updates/$SCRIPTS_VERSION

curl -L -o update.tar.gz $NODE_UPDATE_URL
tar -xvf update.tar.gz
rm -rf update.tar.gz
pwd
ls -laR
# if [[ -d "$UPDATES_DIR" ]]; then
#     echo "Updates downloaded successfully."
#     echo "Applying updates..."
#     cp -r $UPDATES_DIR/scripts/* $NODE_SCRIPTS_DIR/
#     chmod +x $NODE_SCRIPTS_DIR/*
#     echo "Updates applied successfully."
#     if [[ "$OSTYPE" == "darwin"* ]]; then
#         echo "Please enter your sudo password to update the scripts."
#         sudo xattr -d com.apple.quarantine $NODE_SCRIPTS_DIR/*
#     fi
#     echo "Scripts updated successfully."
# fi

echo "Preparing validator keys..."

cd $NODE_BASE_DIR

MNEMONIC_MODE="new-mnemonic"

read -p "Do you already have validator keys mnemonic?" yn
case $yn in
    [Yy] ) MNEMONIC_MODE="existing-mnemonic";
esac

mkdir -p $NODE_VALIDATOR_KEYS_DIR || echo "Validator keys directory exists, skip..."

$NODE_BIN_DIR/deposit $MNEMONIC_MODE \
   --folder $NODE_VALIDATOR_KEYS_DIR \
   --chain dorol

echo "
$(tput setaf 3)$(tput bold)
******************************************************************
Validator keys created successfully.
Import Validator keys to your validator client and prepare for run
******************************************************************
$(tput sgr0)
"

mkdir -p $NODE_DIR/validator || echo "Validator directory exist, skip..."; exit

$NODE_BIN_DIR/validator \
    --datadir $NODE_VALIDATOR_DATA \
    --accept-terms-of-use \
    --chain-config-file $BEACON_CONFIG \
    accounts import --keys-dir $NODE_VALIDATOR_KEYS_DIR

echo "

******************************************************************
Validator prepared successfully.
Now you need make validator deposit.
******************************************************************

"

DEPOSIT_ADDRESS_PRIVATE_KEY=$0

$NODE_BIN_DIR/deposit-send --validator-dir $NODE_VALIDATOR_KEYS_DIR \
    --private-key $DEPOSIT_ADDRESS_PRIVATE_KEY \
    --geth-endpoint http://localhost:8545 \
    --geth-use-socket
