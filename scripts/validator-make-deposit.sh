#!/bin/bash

trap 'echo "Error on line $LINENO"; exit 1' ERR

echo "
**********************************************************
*                   Send validator deposit               *
**********************************************************

ATTENTION! Once you send the deposit, you will not be able
cancel it. Make sure you have the correct validator keys
and withdrawal credentials before proceeding.

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

BOOT_NODE=""

trap 'echo "Error on line $LINENO"; exit 1' ERR
# Function to handle the cleanup
cleanup() {
    echo "
Caught Ctrl+C. Exiting."
    exit
}

cd $NODE_BASE_DIR

$NODE_BIN_DIR/deposit-send --deposit-data-path $NODE_VALIDATOR_KEYS_DIR \
    --node-endpoint $NODE_EXECUTION_DIR/geth.ipc \
    --node-use-socket
