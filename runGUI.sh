#!/bin/bash
cd /chia-blockchain
. ./activate
chia init
if [ "$KEYS" == "generate" ]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  chia keys generate
else
  chia keys add -f $KEYS
fi

if [ ! "$(ls -A /plots)" ]; then
  echo "Plots directory appears to be empty and you have not specified another, try mounting a plot directory with the docker -v command "
fi

chia plots add -d $PLOTS_DIR

sed -i 's/localhost/127.0.0.1/g' $HOME/.chia/mainnet/config/config.yaml
cd chia-blockchain-gui
npm run electron

