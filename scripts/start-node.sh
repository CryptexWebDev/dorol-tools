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
    --bootstrap-node enr:-KC4QFgw_PBTQ0AzBEms_cjtPgWV7UWdYgEWtfVazKLTtNmSErGh5Wiw0czr_xhuXivN28D-PYnpbiJIvMhVlaY16gqGAZOISr2Ug2V0aMvKhAJMDnKEaHYOgYJpZIJ2NIJpcIQ5gUu-iXNlY3AyNTZrMaECfV8amfH86UABJzJ6pL3WxHLIPn8ZVB-dafSmQChmVXyEc25hcMCDdGNwgnZf \
    --bootstrap-node enr:-KC4QNOpbbdhslmwghcAlgaM9r2WnY8KB4K0XlvWQjybO91sAS5v8nXCRFs3pzMntVmm1cI5udm07bL1n2lemjaxuMSGAZOIY6DHg2V0aMvKhAJMDnKEaHYOgYJpZIJ2NIJpcIQ5gUvAiXNlY3AyNTZrMaECH-kFpmsSLq4GTENMRVzgp1pMDl-B7thWHgYDl4zkZ9uEc25hcMCDdGNwgnZf \
    --bootstrap-node enr:-KC4QAPkP_Zq3DQskChLZuEmgBgSY3Y5PQ0yqG66ghIaGHypAKhtgaG27tlLNvmAS4jKYfJeaKGhFThthyNgGHlLhfiGAZOIdscPg2V0aMvKhAJMDnKEaHYOgYJpZIJ2NIJpcIQ5gUu_iXNlY3AyNTZrMaEDCjvqKC5BNx-mxtg9NjkZEHDKN9_aBLrlDcPLFbt_-0KEc25hcMCDdGNwgnZf \
    --accept-terms-of-use \
    --suggested-fee-recipient 0xcCa7fD5a2D7DF4D9ad717a14E871C012F85F437c \
    --jwt-secret $NODE_EXECUTION_DIR/jwtsecret \
    --minimum-peers-per-subnet 0 \
    --chain-id 39010 \
    --execution-endpoint $NODE_EXECUTION_DIR/geth.ipc > "$NODE_LOGS_DIR/beacon.log" 2>&1 &

tail -f -n40 $NODE_LOGS_DIR/beacon.log &
