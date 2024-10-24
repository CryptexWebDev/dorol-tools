#!/bin/bash
echo "Stopping node..."
echo " - stop validator..."
pkill validator || echo "No existing validator processes"
sleep 3
echo " - stop beacon-chain..."
pkill beacon-chain || echo "No existing beacon-chain processes"
sleep 3
echo " - stop execution layer..."
pkill geth || echo "No existing geth processes"
sleep 3
