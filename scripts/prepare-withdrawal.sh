#!/usr/bin/env bash

NET_ID=39010
SCRIPTS_VERSION="0.1.0"
NODE_DATA_DIR="$HOME/.drlnet"
NODE_BASE_DIR="$HOME/dorol"
NODE_BIN_DIR="$NODE_BASE_DIR/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_VALIDATOR_KEYS_DIR="$NODE_BASE_DIR/validator_keys"
NODE_VALIDATOR_BLS_TO_EXECUTION_DIR="$NODE_BASE_DIR/bls_to_execution_changes"
NODE_VALIDATOR_WALLET_DIR="$NODE_BASE_DIR/validator_wallet"
NODE_VALIDATOR_DATA="$NODE_DATA_DIR/validator"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"

NODE_LOGS_DIR="$NODE_BASE_DIR/logs"
BEACON_CONFIG=$NODE_DATA_DIR/node/config.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

rm -rf $NODE_VALIDATOR_BLS_TO_EXECUTION_DIR

echo "*******************************************************************************************************************"
echo "Current withdtraawal credentials:"
echo "*******************************************************************************************************************"

%NODE_BIN_DIR/balances-view \
    --keys-dir $NODE_VALIDATOR_KEYS_DIR \
    --with-withdrawal-credentials

echo "*******************************************************************************************************************"

$NODE_BIN_DIR/deposit generate-bls-to-execution-change \
    --bls_to_execution_changes_folder $NODE_BASE_DIR \
    --chain dorol

$NODE_BIN_DIR/prysmctl validator withdraw \
       --accept-terms-of-use --confirm \
       --path $NODE_VALIDATOR_BLS_TO_EXECUTION_DIR/bls_to_execution_change-*.json