#!/bin/bash

NET_ID=39010
SCRIPTS_VERSION="0.1.0"
NODE_DATA_DIR="$HOME/.drlnet"
NODE_BASE_DIR="$HOME/dorol"
NODE_BIN_DIR="$NODE_BASE_DIR/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_VALIDATOR_KEYS_DIR="$NODE_BASE_DIR/validator_keys"
NODE_VALIDATOR_WALLET_DIR="$NODE_BASE_DIR/validator_wallet"
NODE_VALIDATOR_DATA="$NODE_DATA_DIR/validator"
NODE_VALIDATOR_WALLET="$NODE_DATA_DIR/validator_wallet"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"

NODE_LOGS_DIR="$HOME/dorol/logs"
BEACON_CONFIG=$NODE_DATA_DIR/node/config.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

$NODE_BIN_DIR/validator \
    --datadir $NODE_VALIDATOR_DATA \
    --accept-terms-of-use \
    --suggested-fee-recipient 0xcCa7fD5a2D7DF4D9ad717a14E871C012F85F437c \
    --wallet-dir $NODE_VALIDATOR_WALLET_DIR \
    --chain-config-file $BEACON_CONFIG &