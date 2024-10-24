#!/usr/bin/env bash

NODE_DATA_DIR="$HOME/.drlnet"
NODE_BIN_DIR="$HOME/dorol/bin"
NODE_SCRIPTS_DIR="$HOME/dorol/scripts"
NODE_EXECUTION_DIR="$NODE_DATA_DIR/node/execution"
NODE_CONSENSUS_DIR="$NODE_DATA_DIR/node/consensus"
NODE_LOGS_DIR="$HOME/dorol/logs"

BEACON_CONFIG=$NODE_DATA_DIR/node/config.main.yaml
BEACON_GENESIS_SSZ=$NODE_DATA_DIR/node/genesis.ssz

BOOT_NODE=""

cat <<EOS
Start dorol full node...

EOS
mkdir -p $HOME/dorol/logs || echo "logs directory already exists, skip"
cd $HOME/dorol
cat <<EOS

Start dorol execution layer client (geth)...

EOS
$NODE_BIN_DIR/geth --data-dir=$NODE_EXECUTION_DIR >> $NODE_LOGS_DIR/geth.log &
tail -f $HOME/dorol/logs/geth.log &

cat <<EOS

Wait little time before start beacon-chain client...

EOS
sleep 10

$NODE_BIN_DIR/beacon-chain --datadir $NODE_CONSENSUS_DIR/beacondata \
    --chain-id 39010 \
    --min-sync-peers 0 \
    --genesis-state $BEACON_GENESIS_SSZ \
    --chain-config-file $BEACON_CONFIG \
    --bootstrap-node /ip4/51.195.4.133/tcp/13000/p2p/16Uiu2HAmR9d7cK1Vk9tTiPozN3EXUEtYSMHQFoyg1ufTbcpdhDBD \
    --bootstrap-node enr:-MK4QKYfQ4xP0ikHUVvY_TmSQeT3bWVMi5W4T1U_gJ6O6c5QLAWqWHrbvDdCY1fgNibuVXMPKwpfsmfbRqRaGchbYPaGAZJ4Trhsh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDPDBIWJc2VjcDI1NmsxoQO5ohM6UOrMWuy48C0zdZQUByCVy-RA5k0XXAPzyfB6oIhzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --bootstrap-node /ip4/51.195.4.133/tcp/13000/p2p/16Uiu2HAmR9d7cK1Vk9tTiPozN3EXUEtYSMHQFoyg1ufTbcpdhDBD \
    --bootstrap-node enr:-MK4QOezoK5ka-6queKbCE3IAgnPbJ-uYwjagRl4Hdl-FfF1ZJEQaq60YZ0_LQYsfiv0rhgA19nD5SFXNM9MGcZiIvKGAZJ4iK0Xh2F0dG5ldHOIAAAAAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhJjk3aqJc2VjcDI1NmsxoQKkqwJ_h__E7v2h2X4sXYrbNWx9lPCC-LDDvh03JBvw34hzeW5jbmV0cwCDdGNwgjS8g3VkcIIw1A \
    --contract-deployment-block 0 \
    --accept-terms-of-use \
    --jwt-secret $NODE_EXECUTION_DIR/jwtsecret \
    --minimum-peers-per-subnet 0 \
    --enable-debug-rpc-endpoints \
    --execution-endpoint $NODE_EXECUTION_DIR/geth.ipc > "$NODE_LOGS_DIR/beacon.log" 2>&1 &

tail -f -n40 $NODE_LOGS_DIR/beacon.log &