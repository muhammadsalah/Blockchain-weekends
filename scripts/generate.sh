#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# Modified by Muhammad Salah <muhammad.salah@eg.ibm.com>
# Blockchain Weekends Program: Lab 1 "Blockchain Network Design"
#

### Before running this script make sure the Hyperledger fabric binaries are accessible in your PATH. Run it directly, because it is dependent on your path.
cd ..
rm -r crypto-config

cryptogen generate --config=./crypto-config.yaml

rm -r channel-artifacts

mkdir channel-artifacts



FABRIC_CFG_PATH=$PWD configtxgen -profile OrdererGenesis -outputBlock ./../channel-artifacts/genesis.block
FABRIC_CFG_PATH=$PWD configtxgen -profile Channel -outputAnchorPeersUpdate ./../channel-artifacts/mailbox1MSPanchors.tx -channelID channel -asOrg mailbox1MSP
FABRIC_CFG_PATH=$PWD configtxgen -profile Channel -outputAnchorPeersUpdate ./../channel-artifacts/mailbox2MSPanchors.tx -channelID channel -asOrg mailbox2MSP

cd ./scripts
