#!/usr/bin/env bash
trap 'echo "Error on line $LINENO"; exit 1' ERR
NET_ID=39010
SCRIPTS_VERSION="0.1.0"
NODE_DATA_DIR="$HOME/.drlnet"
NODE_BASE_DIR="$HOME/dorol"
NODE_BIN_DIR="$NODE_BASE_DIR/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_VALIDATOR_KEYS_DIR="$NODE_BASE_DIR/validator_keys"
NODE_VALIDATOR_WALLET_DIR="$NODE_BASE_DIR/validator_wallet"
NODE_VALIDATOR_DATA="$NODE_DATA_DIR/validator"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"

NODE_LOGS_DIR="$NODE_BASE_DIR/logs"
BEACON_CONFIG=$NODE_DATA_DIR/node/config.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

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


if [[ "$ARCH" == "x86_64" ]]; then
       NODE_ARCH="amd64"
elif [[ "$ARCH" == "arm64" ]]; then
       NODE_ARCH="arm64"
else
        echo "Unsupported architecture: $ARCH"
        exit 1
fi

installBalanceViewTool() {
    TMP_DIR=$(mktemp -d)
    cd $TMP_DIR
    echo "Downloading balances-view tool for $NODE_OS/$NODE_ARCH"
    curl -L -o  balances-view.tar.gz https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/balances-view-$NODE_OS-$NODE_ARCH.tar.gz
    tar -xzf balances-view.tar.gz
    ls -laR
    mv balances-view $NODE_BIN_DIR
    chmod +x $NODE_BIN_DIR/balances-view
    rm -rf $TMP_DIR
    cd $NODE_BASE_DIR
}

if [[ ! -f $NODE_BIN_DIR/balances-view ]]; then
    installBalanceViewTool
fi

cd $NODE_BASE_DIR

$NODE_BIN_DIR/balances-view -keys-dir $NODE_VALIDATOR_KEYS_DIR