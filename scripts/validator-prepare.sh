#!/bin/bash

trap 'echo "Error on line $LINENO"; exit 1' ERR

echo "
**********************************************************
*   Prepare validator keys and withdrawal credentials    *
**********************************************************

ATTENTION! This script can overwrite the existing validator keys!
Please make sure you have a backup of the existing keys before proceeding.

"
SCRIPTS_VERSION="0.1.0c"

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BASE_DIR="$HOME/dorol"
NODE_BIN_DIR="$NODE_BASE_DIR/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_VALIDATOR_KEYS_DIR="$NODE_BASE_DIR/validator_keys"
NODE_VALIDATOR_WALLET_DIR="$NODE_BASE_DIR/validator_wallet"
NODE_VALIDATOR_DATA="$NODE_DATA_DIR/validator"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"
NODE_LOGS_DIR="$HOME/dorol/logs"

BEACON_CONFIG=$NODE_DATA_DIR/node/config.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

BOOT_NODE=""

trap 'echo "Error while validator prepare"; exit 1' ERR

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

cd $NODE_BASE_DIR

echo "Check validator keys at:NODE_VALIDATOR_KEYS_DIR"

if test -d "$NODE_VALIDATOR_KEYS_DIR"; then
    echo "Validator keys directory found.
This script can overwrite the existing validator keys!
Do you wish to overwrite the existing keys?"
    ask_for_confirmation
fi

echo "Preparing validator keys..."

cd $NODE_BASE_DIR

MNEMONIC_MODE="new-mnemonic"

read -p "Do you already have validator keys mnemonic?" yn
case $yn in
    [Yy] ) MNEMONIC_MODE="existing-mnemonic";
esac

mkdir -p $NODE_VALIDATOR_KEYS_DIR || echo "Validator keys directory exists, skip..."

$NODE_BIN_DIR/deposit $MNEMONIC_MODE \
   --folder $NODE_BASE_DIR \
   --chain dorol

echo "
$(tput setaf 3)$(tput bold)
******************************************************************
Validator keys created successfully.
Keys stored in $NODE_VALIDATOR_KEYS_DIR
Import Validator keys to your validator client and prepare for run
******************************************************************
$(tput sgr0)
"

mkdir -p $NODE_VALIDATOR_DATA || echo "Validator directory exist, skip..."

$NODE_BIN_DIR/validator \
    --datadir $NODE_VALIDATOR_DATA \
    --chain-config-file $BEACON_CONFIG \
    accounts import \
    --accept-terms-of-use \
    --wallet-dir $NODE_VALIDATOR_WALLET_DIR \
    --keys-dir $NODE_VALIDATOR_KEYS_DIR

echo "
$(tput setaf 3)$(tput bold)
******************************************************************
Validator prepared successfully.
Now you already to make validator deposit.
******************************************************************
$(tput sgr0)
"

read -p "Do you want to make a deposit right now?" yn
case $yn in
    [Nn] ) exit 0;;
esac

echo "Validator keys path: $NODE_VALIDATOR_KEYS_DIR "
echo "Execution endpoint: $NODE_EXECUTION_DIR/geth.ipc "

$NODE_BIN_DIR/deposit-send --deposit-data-path $NODE_VALIDATOR_KEYS_DIR/deposit_data-*.json \
    --node-endpoint $NODE_EXECUTION_DIR/geth.ipc \
    --node-use-socket
