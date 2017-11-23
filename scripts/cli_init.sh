#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# Modified by Muhammad Salah <muhammad.salah@eg.ibm.com>
# Blockchain Weekends Program: Lab 1 "Blockchain Network Design"
#

# This script conducts initial setup for the network through the CLI.
echo "---------Blockchain Weekends-----------------"
echo "Sample Project Initiation Script"
echo "##############################################"
echo "##############################################"




echo "Creating Channel Through Peer0/Mailbox1 name channel"
peer channel create -o orderer1.network.com:7050 -c channel -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

echo "Peer0/Mailbox1 joining the channel, and configuring the anchor transactions"
peer channel join -b channel.block
peer channel update -o orderer1.network.com:7050 -c channel -f ./channel-artifacts/mailbox1MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

echo "Switching to act as Peer0/mailbox2"
export CORE_PEER_ADDRESS=peer0.mailbox2.network.com:7051
export CORE_PEER_LOCALMSPID=mailbox2MSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/users/Admin@mailbox2.network.com/msp

echo "Peer0/mailbox2 joining the channel, and configuring the anchor transactions"
peer channel join -b channel.block
peer channel update -o orderer1.network.com:7050 -c channel -f ./channel-artifacts/mailbox2MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem