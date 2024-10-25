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

trap 'echo "Error on line $LINENO"; exit 1' ERR
# Function to handle the cleanup
cleanup() {
    echo "Caught Ctrl+C. Killing active background processes and exiting."
    kill $(jobs -p)  # Kills all background processes started in this script
    exit
}
# Trap the SIGINT signal and call the cleanup function when it's caught
trap 'cleanup' SIGINT

cat <<EOS
Start dorol full node...

EOS
mkdir -p $HOME/dorol/logs || echo "logs directory already exists, skip"
cd $HOME/dorol
cat <<EOS

Start dorol execution layer client (geth)...

EOS
$NODE_BIN_DIR/geth --datadir=$NODE_EXECUTION_DIR \
    --authrpc.jwtsecret $NODE_EXECUTION_DIR/jwtsecret >> $NODE_LOGS_DIR/geth.log &
tail -f $HOME/dorol/logs/geth.log &

cat <<EOS

Wait little time before start beacon-chain client...

EOS
sleep 10

$NODE_BIN_DIR/beacon-chain --datadir $NODE_CONSENSUS_DIR/beacondata \
    --min-sync-peers 1 \
    --genesis-state $BEACON_GENESIS_SSZ \
    --chain-config-file $BEACON_CONFIG \
    --bootstrap-node /ip4/51.195.4.133/tcp/13000/p2p/16Uiu2HAmR9d7cK1Vk9tTiPozN3EXUEtYSMHQFoyg1ufTbcpdhDBD \
    --bootstrap-node /ip4/152.228.221.170/tcp/13500/p2p/16Uiu2HAm6WU5qwi9H1Ab1HrvXQCTH6P46muzWzD3A7LLKYz1teL6 \
    --bootstrap-node /ip4/92.222.100.216/tcp/13000/p2p/16Uiu2HAm9yiEt1PuNBVrgHEXdx1FMMMEEabDrCvvxBi9NY28PtM6 \
    --bootstrap-node enr:-MK4QKmKrWzxIGfN7JB0nQMc0iPay5nHkZhc6pfxVCd3SdzfUs91nDeX70VvE6_sRNBwR6yBx0_WYPuKBRERFWsIOXiGAZJ4obMrh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhFzeZNiJc2VjcDI1NmsxoQLYOMIlO4_ghJKH8X1AqQSd0URYMjuPLNKfb0Ajv4LzeYhzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --bootstrap-node enr:-MK4QKYfQ4xP0ikHUVvY_TmSQeT3bWVMi5W4T1U_gJ6O6c5QLAWqWHrbvDdCY1fgNibuVXMPKwpfsmfbRqRaGchbYPaGAZJ4Trhsh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDPDBIWJc2VjcDI1NmsxoQO5ohM6UOrMWuy48C0zdZQUByCVy-RA5k0XXAPzyfB6oIhzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --bootstrap-node enr:-MK4QOezoK5ka-6queKbCE3IAgnPbJ-uYwjagRl4Hdl-FfF1ZJEQaq60YZ0_LQYsfiv0rhgA19nD5SFXNM9MGcZiIvKGAZJ4iK0Xh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhJjk3aqJc2VjcDI1NmsxoQKkqwJ_h__E7v2h2X4sXYrbNWx9lPCC-LDDvh03JBvw34hzeW5jbmV0cwCDdGNwgjS8g3VkcIIw1A \
    --accept-terms-of-use \
    --suggested-fee-recipient 0xcCa7fD5a2D7DF4D9ad717a14E871C012F85F437c \
    --jwt-secret $NODE_EXECUTION_DIR/jwtsecret \
    --minimum-peers-per-subnet 0 \
    --chain-id 39010 \
    --execution-endpoint $NODE_EXECUTION_DIR/geth.ipc > "$NODE_LOGS_DIR/beacon.log" 2>&1 &

tail -f -n40 $NODE_LOGS_DIR/beacon.log
