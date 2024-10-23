#!/usr/bin/env bash
cat <<EOS
Start dorol full node...

EOS
mkdir -p $HOME/dorol/logs || echo "logs directory already exists, skip"
cd $HOME/dorol
cat <<EOS

Start dorol execution layer client (geth)...

EOS
$HOME/bin/geth  >> $HOME/dorol/logs/geth.log &
tail -f $HOME/dorol/logs/geth.log &
cat <<EOS

Wait...

EOS
sleep 10

