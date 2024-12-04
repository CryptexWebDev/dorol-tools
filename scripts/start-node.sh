#!/usr/bin/env bash

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"
NODE_LOGS_DIR="$HOME/dorol/logs"

BEACON_CONFIG=$NODE_DATA_DIR/node/config.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

BOOT_NODE=""

# trap 'echo "Error on line $LINENO"; exit 1' ERR
# Function to handle the cleanup
# cleanup() {
#     echo "Caught Ctrl+C. Killing active loger processes."
#     exit
# }
# Trap the SIGINT signal and call the cleanup function when it's caught
# trap 'cleanup' SIGINT

cat <<EOS
Start dorol full node...

EOS
mkdir -p $HOME/dorol/logs || echo "logs directory already exists, skip"
cd $HOME/dorol
cat <<EOS

Start dorol execution layer client (geth)...

EOS
$NODE_BIN_DIR/geth --datadir=$NODE_EXECUTION_DIR \
    --authrpc.jwtsecret $NODE_EXECUTION_DIR/jwtsecret > $NODE_LOGS_DIR/geth.log 2>&1 &

tail -f $HOME/dorol/logs/geth.log &

cat <<EOS

Wait little time before start beacon-chain client...

EOS
sleep 10

$NODE_BIN_DIR/beacon-chain --datadir $NODE_CONSENSUS_DIR/beacondata \
    --min-sync-peers 1 \
    --genesis-state $BEACON_GENESIS_SSZ \
    --chain-config-file $BEACON_CONFIG \
    --contract-deployment-block 0 \
    --bootstrap-node /ip4/57.129.75.190/tcp/13000/p2p/16Uiu2HAmTPNx1UQVNNSV4tYaw8aUk6KTHmV28xhpWFcFSGxaxJQk \
    --bootstrap-node /ip4/57.129.75.192/tcp/13000/p2p/16Uiu2HAmUzJ7Rk2SdnygJ7jKg5z6pG1oFxLdSXUn5pM9vv3dyXRJ \
    --bootstrap-node /ip4/57.129.75.191/tcp/13000/p2p/16Uiu2HAkxhy1FSEH3QUCYUmtz22jvqXr4QJWats1XuUbFG3B3hR4 \
    --bootstrap-node enr:-MK4QKFAGXNU6fnctFcKHy3SIniFIMwYVEubU5A_S57tXJ_6Vrk5Hu2_LpRBcD99-6QRZaQprHlU-ZjIxT4BN_sKxPKGAZOISxIuh2F0dG5ldHOIAADAAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDmBS76Jc2VjcDI1NmsxoQPa35AyvEEvXU2vq7yQM4GU2qSW9DQfVCEM-YuXZFOIDYhzeW5jbmV0cw-DdGNwgjLIg3VkcIIu4A \
    --bootstrap-node enr:-MK4QCoTqxv9lvKmMMDKBFepvhHoF52ryDCmLaaoIxmXgAZ6UAzH9kX041ur40SuAZSvxMatkrmXuDi9kC4zlpwEyFmGAZOIY-clh2F0dG5ldHOIAAAAAAADAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDmBS8CJc2VjcDI1NmsxoQPyrRvN9nyc_EPfkMSAd9PI-wgpDWXpj5sVaQrRM0A9uYhzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --bootstrap-node enr:-MK4QP9LXocFWcxPy6ToNw9tglwRZ_VsK8Oi9cifxk6QPb5adN95R6Sd6LiohzeMtPSIDQ1cwUzNMeXwLRfUGk7hM3qGAZOIdxkTh2F0dG5ldHOIAAAAAABgAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDmBS7-Jc2VjcDI1NmsxoQIwv5qkkNimBbyMCBmPm4dbc1pXW1stcJ7z22NRAe6GA4hzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --accept-terms-of-use \
    --suggested-fee-recipient 0xcCa7fD5a2D7DF4D9ad717a14E871C012F85F437c \
    --jwt-secret $NODE_EXECUTION_DIR/jwtsecret \
    --minimum-peers-per-subnet 0 \
    --chain-id 39010 \
    --execution-endpoint $NODE_EXECUTION_DIR/geth.ipc > "$NODE_LOGS_DIR/beacon.log" 2>&1 &

tail -f -n40 $NODE_LOGS_DIR/beacon.log &
