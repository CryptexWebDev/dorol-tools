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
    --bootstrap-node /ip4/57.128.216.187/tcp/13000/p2p/16Uiu2HAm3wVP5vXpWdKDHbJCSSs8Uqw7Nqdezvey4ZVHBZ98Ja75 \
    --bootstrap-node /ip4/57.129.76.41/tcp/13000/p2p/16Uiu2HAmSsv1Frk28znHxAzzYF3jRWoFGvoztMExMtxzYaQCaET6 \
    --bootstrap-node /ip4/91.134.44.218/tcp/13000/p2p/16Uiu2HAkvCMUNhdXrkrT6sRdJRn9b5Jf4ks3KVs58nXQxyXv3Tf8 \
    --bootstrap-node enr:-MK4QOtiOEBTrAnmPKnCAx1Y35tQEvFTkhrTBXPTWJMncTR7ANaHkc4rI11s0NF33y4-Aq6ng2VgShDvobzPskow_s6GAZOi0yGZh2F0dG5ldHOIAAAwAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDmA2LuJc2VjcDI1NmsxoQJ-gO-fIOQ_uAJE41M4fTe3eTBUnDIzqIAKLa6gaE3pHIhzeW5jbmV0cw-DdGNwgjLIg3VkcIIu4A \
    --bootstrap-node enr:-MK4QHqaUPnUwedhwsvcUX_yJcC9jM6DbYhTFmf5Sd8BHypcOiNnepZWuSSWSg3u8UdJ0HMmCYdN0ZNomd6kjNYWTmSGAZOi4uZBh2F0dG5ldHOIAAAAAAAAAAyEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhDmBTCmJc2VjcDI1NmsxoQPTU0EO43_n0ItslE0nysQEitwmuclweqNq8HTgwr-vtYhzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --bootstrap-node enr:-MK4QOCW5t2R7IyIM8O3RDCBuM5gN14OFkAb2NfrPGNvGZoYKecqnYCmxai8D1OPoJ2DxVFkDozGz0YxX0mgwIhAa0uGAZOm3dVYh2F0dG5ldHOIAIABAAAAAACEZXRoMpDZiKItIAAAkwAdBAAAAAAAgmlkgnY0gmlwhFuGLNqJc2VjcDI1NmsxoQILcjXRxCc2OOM6IaA0wrMUjM4_uYTMBvb-WQxZA5SeK4hzeW5jbmV0cwCDdGNwgjLIg3VkcIIu4A \
    --accept-terms-of-use \
    --suggested-fee-recipient 0x76DEe791acb14705c7cEB1536877867eaE6ea1D0 \
    --jwt-secret $NODE_EXECUTION_DIR/jwtsecret \
    --minimum-peers-per-subnet 0 \
    --chain-id 39010 \
    --execution-endpoint $NODE_EXECUTION_DIR/geth.ipc > "$NODE_LOGS_DIR/beacon.log" 2>&1 &

tail -f -n40 $NODE_LOGS_DIR/beacon.log &
