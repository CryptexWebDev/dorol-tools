#!/usr/bin/env bash
cat <<EOS
${tty_bold}Dorol Node Tools Installer v.0.1${tty_reset}

EOS
# apple intel/amd64 deposit cli
DEPOSIT_CLI_MAC="https://github.com/CryptexWebDev/staking-deposit-cli/releases/download/2.7.0/deposit-cli-amd64-darwin.tgz"
# linux intel/amd64 deposit cli
DEPOSIT_CLI_LINUX="https://github.com/CryptexWebDev/staking-deposit-cli/releases/download/2.7.0/deposit-cli-amd64-linux.tgz"
# TODO apple arm64 deposit cli
# apple/mac geth amd64
GETH_MAC_AMD64="https://github.com/CryptexWebDev/Dorol-Chain/releases/download/0.1.0/geth-darwin-amd64.tar.gz"
# apple/mac geth arm64
GETH_MAC_ARM64="https://github.com/CryptexWebDev/Dorol-Chain/releases/download/0.1.0/geth-darwin-arm64.tar.gz"
# linux geth amd64
GETH_LINUX_AMD64="https://github.com/CryptexWebDev/Dorol-Chain/releases/download/0.1.0/geth-linux-amd64.tar.gz"
# linux geth arm64
GETH_LINUX_ARM64="https://github.com/CryptexWebDev/Dorol-Chain/releases/download/0.1.0/geth-linux-arm64.tar.gz"
# Prysm beacon chain mac amd64/arm64
PRYSM_BEACON_CHAIN_MAC_AMD64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/beacon-chain-v5.0.3-darwin-amd64"
PRYSM_BEACON_CHAIN_MAC_ARM64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/beacon-chain-v5.0.3-darwin-arm64"
# Prysm beacon chain linux amd64/arm64
PRYSM_BEACON_CHAIN_LINUX_AMD64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/beacon-chain-v5.0.3-linux-amd64"
PRYSM_BEACON_CHAIN_LINUX_ARM64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/beacon-chain-v5.0.3-linux-arm64"
# Prysm prysmctl mac amd64/arm64
PRYSM_PRYSMCTL_MAC_AMD64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/prysmctl-v5.0.3-darwin-amd64"
PRYSM_PRYSMCTL_MAC_ARM64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/prysmctl-v5.0.3-darwin-arm64"
# Prysm prysmctl linux amd64/arm64
PRYSM_PRYSMCTL_LINUX_AMD64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/prysmctl-v5.0.3-linux-amd64"
PRYSM_PRYSMCTL_LINUX_ARM64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/prysmctl-v5.0.3-linux-arm64"
# Prysm validator mac amd64/arm64
PRYSM_VALIDATOR_MAC_AMD64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/validator-v5.0.3-darwin-amd64"
PRYSM_VALIDATOR_MAC_ARM64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/validator-v5.0.3-darwin-arm64"
# Prysm validator linux amd64/arm64
PRYSM_VALIDATOR_LINUX_AMD64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/validator-v5.0.3-linux-amd64"
PRYSM_VALIDATOR_LINUX_ARM64="https://github.com/prysmaticlabs/prysm/releases/download/v5.0.3/validator-v5.0.3-linux-arm64"
# Deposit send utility
DEPOSIT_SEND_DARWIN_AMD64="https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/deposit-send-darwin-amd64.tar.gz"
DEPOSIT_SEND_MAC_ARM64="https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/deposit-send-darwin-arm64.tar.gz"
DEPOSIT_SEND_LINUX_AMD64="https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/deposit-send-linux-amd64.tar.gz"
DEPOSIT_SEND_LINUX_ARM64="https://github.com/CryptexWebDev/Deposit-Send/releases/download/0.0.1/deposit-send-linux-arm64.tar.gz"
# full node boot data
BOOT_DATA="https://github.com/CryptexWebDev/dorol-tools/releases/download/0.1/bootdata.tar.gz"
SCRIPTS="https://github.com/CryptexWebDev/dorol-tools/releases/download/0.1/scripts.tar.gz"

NODE_OS="unknown"
NODE_ARCH="unknown"
NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"

ARCH=$(uname -m)

TMP_DIR=$(mktemp -d)
cd $TMP_DIR

if test -d "$NODE_BIN_DIR"; then
    read -p "Node bin dir found. Do you wish to reinstall node software? " yn
    case $yn in
        [Yy]* ) rm -rf $NODE_BIN_DIR;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
fi

if test -d "$NODE_SCRIPTS_DIR"; then
    read -p "Node bin dir found. Do you wish to reinstall node management scripts? " yn
    case $yn in
        [Yy]* ) rm -rf $NODE_SCRIPTS_DIR;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
    esac
fi

mkdir -p $NODE_BIN_DIR || echo "Failed to create node bin dir"
mkdir -p $NODE_SCRIPTS_DIR || echo "Failed to create node scripts dir"


if [[ "$OSTYPE" == "linux"* ]]; then
        NODE_OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        NODE_OS="darwin"
else
        echo "Unsupported OS: $OSTYPE/"
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

echo "Downloading node software..."
GETH_DIST=""
PRYSM_PRYSMCTL_DIST=""
PRYSM_BEACON_CHAIN_DIST=""
PRYSM_VALIDATOR_DIST=""
DEPOSIT_CLI=""
DEPOSIT_SEND_TOOL=""

if [[ "$NODE_OS" == "linux" ]]; then
        if [[ "$NODE_ARCH" == "amd64" ]]; then
                GETH_DIST=$GETH_LINUX_AMD64
                PRYSM_PRYSMCTL_DIST=$PRYSM_PRYSMCTL_LINUX_AMD64
                PRYSM_BEACON_CHAIN_DIST=$PRYSM_BEACON_CHAIN_LINUX_AMD64
                PRYSM_VALIDATOR_DIST=$PRYSM_VALIDATOR_LINUX_AMD64
                DEPOSIT_SEND_TOOL=$DEPOSIT_SEND_LINUX_AMD64
        elif [[ "$NODE_ARCH" == "arm64" ]]; then
                GETH_DIST=$GETH_LINUX_ARM64
                PRYSM_PRYSMCTL_DIST=$PRYSM_PRYSMCTL_LINUX_ARM64
                PRYSM_BEACON_CHAIN_DIST=$PRYSM_BEACON_CHAIN_LINUX_ARM64
                PRYSM_VALIDATOR_DIST=$PRYSM_VALIDATOR_LINUX_ARM64
                DEPOSIT_SEND_TOOL=$DEPOSIT_SEND_LINUX_ARM64
        fi
elif [[ "$NODE_OS" == "darwin" ]]; then
        if [[ "$NODE_ARCH" == "amd64" ]]; then
                GETH_DIST=$GETH_MAC_AMD64
                PRYSM_PRYSMCTL_DIST=$PRYSM_PRYSMCTL_MAC_AMD64
                PRYSM_BEACON_CHAIN_DIST=$PRYSM_BEACON_CHAIN_MAC_AMD64
                PRYSM_VALIDATOR_DIST=$PRYSM_VALIDATOR_MAC_AMD64
                DEPOSIT_SEND_TOOL=$DEPOSIT_SEND_DARWIN_AMD64
        elif [[ "$NODE_ARCH" == "arm64" ]]; then
                GETH_DIST=$GETH_MAC_ARM64
                PRYSM_PRYSMCTL_DIST=$PRYSM_PRYSMCTL_MAC_ARM64
                PRYSM_BEACON_CHAIN_DIST=$PRYSM_BEACON_CHAIN_MAC_ARM64
                PRYSM_VALIDATOR_DIST=$PRYSM_VALIDATOR_MAC_ARM64
                DEPOSIT_SEND_TOOL=$DEPOSIT_SEND_MAC_ARM64
        fi
fi

if [[ "$NODE_OS" == "linux" ]]; then
        DEPOSIT_CLI=$DEPOSIT_CLI_LINUX
elif [[ "$NODE_OS" == "darwin" ]]; then
        DEPOSIT_CLI=$DEPOSIT_CLI_MAC
fi

if [[ -z "$GETH_DIST" ]]; then
        echo "Failed to determine Geth distribution"
        exit 1
fi

if [[ -z "$DEPOSIT_CLI" ]]; then
        echo "Failed to determine deposit CLI distribution"
        exit 1
fi

echo "Downloading Geth from $GETH_DIST"
curl -L -o geth.tar.gz $GETH_DIST

echo "Downloading deposit CLI from $DEPOSIT_CLI"

curl -L -o deposit-cli.tar.gz $DEPOSIT_CLI

echo "Downloading Geth from $GETH_DIST"

echo "Extracting Geth..."

tar -xzf geth.tar.gz

echo "Extracting deposit CLI..."

tar -xzf deposit-cli.tar.gz

echo "Download deposit send utility..."

curl -L -o deposit-send.tar.gz $DEPOSIT_SEND_TOOL

tar -xzf deposit-send.tar.gz

echo "Download Prysm beacon-chain client..."

curl -L -o beacon-chain $PRYSM_BEACON_CHAIN_DIST

echo "Download Prysm prysmctl..."

curl -L -o prysmctl $PRYSM_PRYSMCTL_DIST

echo "Download Prysm validator client..."

curl -L -o validator $PRYSM_VALIDATOR_DIST

chmod 0644 *
chmod +x *

echo "Install  binaries to $NODE_BIN_DIR..."

mv geth $NODE_BIN_DIR
mv deposit $NODE_BIN_DIR
mv beacon-chain $NODE_BIN_DIR
mv prysmctl $NODE_BIN_DIR
mv validator $NODE_BIN_DIR

echo "Software and scripts installed, prepare node for start..."

mkdir -p $NODE_DATA_DIR/node/execution || echo "Node data dir exists, skip..."
mkdir -p $NODE_DATA_DIR/node/consensus/beacondata || echo "Node data dir exists, skip..."
mkdir -p $NODE_DATA_DIR/node/consensus/validator || echo "Node data dir exists, skip..."

echo "Downloading and prepare node management scripts..."
curl -L -o scripts.tar.gz $SCRIPTS

tar -xzf scripts.tar.gz

mv scripts/*sh $NODE_SCRIPTS_DIR/
chmod +x  $NODE_SCRIPTS_DIR/*sh



curl -L -o bootdata.tar.gz $BOOT_DATA

tar -xzf bootdata.tar.gz

mv data-prepared/config.main.yaml $NODE_DATA_DIR/node/config.yaml
mv data-prepared/genesis.ssz $NODE_DATA_DIR/node/genesis.ssz

touch $NODE_DATA_DIR/node/consensus/beacondata/tosaccepted
if [[ "$OSTYPE" == "darwin"* ]]; then

    curl -L -o $HOME/Desktop/StartNode.command https://raw.githubusercontent.com/CryptexWebDev/dorol-tools/refs/heads/main/scripts/darwin/startnode.command
    chmod +x $HOME/Desktop/StartNode.command
    echo "Removing quarantine attribute from binaries. You may be prompted for your password."
    sudo -s xattr -d com.apple.quarantine $NODE_BIN_DIR/* || echo "Some executable  files not need to be removed from quarantine"
    sudo -s xattr -d com.apple.quarantine $HOME/Desktop/StartNode.command
    echo "Removing quarantine attribute from scripts..."
    sudo -s xattr -d com.apple.quarantine $NODE_SCRIPTS_DIR/* || echo "Some script files not need to be removed from quarantine"

    echo "Removing quarantine attribute from scripts..."
    sudo -s xattr -d com.apple.quarantine $NODE_SCRIPTS_DIR/*sh || echo "Some script files not need to be removed from quarantine"

    mv script/darwin/startnode.command $HOME/Desktop/StartNode.command
    chmod +x $HOME/Desktop/StartNode.command
    sudo -s xattr -d com.apple.quarantine $HOME/Desktop/StartNode.command

fi
echo "Node software and data prepared. Now you can run dorol node with $NODE_SCRIPTS_DIR/start-node.sh"