#!/bin/bash

trap 'echo "Error on line $LINENO"; exit 1' ERR

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

trap 'echo "Error while make deposit"; exit 1' ERR
# Function to handle the cleanup

read -p "Do you want to make a deposit right now?" yn
case $yn in
    [Nn] ) exit 0;;
esac

echo "Validator keys path: $NODE_VALIDATOR_KEYS_DIR "
echo "Execution endpoint: $NODE_EXECUTION_DIR/geth.ipc "

$NODE_BIN_DIR/deposit-send --deposit-data-path $NODE_VALIDATOR_KEYS_DIR/deposit_data-*.json \
    --node-endpoint $NODE_EXECUTION_DIR/geth.ipc \
    --node-use-socket
