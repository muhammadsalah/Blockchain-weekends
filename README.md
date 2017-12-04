### Blockchain weekends is an event for enhancing IBM HyperLedger Fabric Blockchain framework skills.  ###
##                                                                                                      ##
##                                                                                                      ##    
##  This repository contains an initial network setup to demonstrate Blockchain Fabric concepts on:     ##
##              1- Blockchain Network Design, for Organizations, and Peers.                             ##
##              2- Shared Ledgers, through the concept of Channels.                                     ##
##              3- Smart Contracts, installed, and instantiated on these channels.                      ##
##              4- Scalling Dynamically, adding more Organizations to the network.                      ##

##							Source Code																	##
Please clone the following repository in order to continue with the lab.
Via Git, you can issue the following in your terminal in your exercise directory (of your own choice)

	git clone https://github.com/muhammadsalah/Blockchain-weekends.git


##							Pulling Fabric Version 1.0.4												##
The source code was built on the duration between version 1.0.3 – 1.0.4, both of any those versions should work fine as they have been tested.
Please navigate to the scripts folder, and run the “pull_fabric.sh” script.

	./pull_fabric.sh

This script will make sure you have the correct version; and you can set the version inside the script variable.




##							Set up the environment														##
This part most of us might have done many times, through creating the crypto material, and generating the artifacts part.
There is not much to be walked through here on this stage, as it has been covered earlier in an early stage of blockchain lab, however, you can follow the same trail as in “generate.sh” shell script, under the script folder.

However, notice that your binaries “cryptogen”, and “configtxgen” should be accessible via your environment directly, in other words they have to be appended to the path.


##							Running the environment														##
The “start_env.sh” script, is a simple script that simply kills all the running docker containers, and clears all docker networks that are not used; if you choose to use this script to initialize the environment; it will tail the logs in a text file “log.txt”.

Please make sure you inspect the script, and ask a question whenever any command is not clear.
Also, all scripts are plain simple for demonstration purposes so make sure you understand them clearly.
Another, alternative is making sure the environment variable is set

	COMPOSE_PROJECT_NAME=blockchainweeekends

This can be achieved whether you can export that in the terminal
	
	export COMPOSE_PROJECT_NAME=blockchainweeekends

or create a .env file with the sole attribute
	
	COMPOSE_PROJECT_NAME=blockchainweeekends

Then run the command that consumes the “network.yaml” file via docker-compose.
Docker-compose is a tool that consumes yaml configuration files, and start executing them in a manner to create ready made containers, a very common practice is you initialize your container parameterized in yaml configuration file, and each container is pointing to one, ore more shell scripts that start executing to make sure everything is up and running; which is the case with our CLI container, that sets up our environment pulling the channel transactions, and connecting the the anchor peers; to get ready to deploy our first chaincode through it; and opt for testing it out.

However, we can go manual mode; and that is simply achieved via changing the “network.yaml” file, find the CLI container section, and opt for commenting the command line.
This can be found at line 257. simply add “#” for comment before command.


##							Behind the scenes														##
What we are about to leverage is; our CLI container -which is a tool that is meant for development process, can act on behalf of any peer/user (endpoint) as long as it has access to the right certificates, and it has all basic blockchain binaries inside of it; saving the hussle of configuring these binaries on your local machine.
One binary, that we are very interested is: Peer
The binary is configured through parametrization in environment variables, most of these variable are self explanatory by nature however, lets take a look at them.

CORE_PEER_ADDRESS ===> Maps to the peer url.

CORE_PEER_LOCALMSPID=====> The MSPID used in signing, and identification.

CORE_PEER_TLS_ENABLED====> Boolean for TLS. 

CORE_PEER_TLS_CERT_FILE=====> Maps for the TLS Certification File.

CORE_PEER_TLS_KEY_FILE======> Maps for the private key used to sign transactions.

CORE_PEER_TLS_ROOTCERT_FILE====> Root certificate for TLS.

CORE_PEER_MSPCONFIGPATH====> Configuration folder which contains standard folder structure that all the certs, and keys that allows dealing of this peer with the MSP.

Once, “peer” binary has access to all these stuff, you can create channels instantiate deploy chaincodes, and act on behalf of the peer; and we will leverage that later to add a third organization to our current network.
However the CLI does those two operations on behalf of the two anchor peers, that has been configured previously in the generate of artifacts sections.

	peer channel join -b channel.block

	peer channel update -o orderer1.network.com:7050 -c channel -f ./channel-artifacts/mailbox1MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

and same applies for the 2nd peer from the other organization

	peer channel join -b channel.block

	peer channel update -o orderer1.network.com:7050 -c channel -f ./channel-artifacts/mailbox2MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

Please visit the “cli_init.sh” to have a better grasp, and careful that the peer is preconfigured to act on behalf of the first anchor peer.


##						Deploying Sample Chaincode													##
First we make sure that our identity is set to PEER 0 in Org mailbox 1

	export CORE_PEER_ADDRESS=peer0.mailbox1.network.com:7051

	export CORE_PEER_LOCALMSPID=mailbox1MSP

	export CORE_PEER_TLS_ENABLED=true

	export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/peers/peer0.mailbox1.network.com/tls/server.crt

	export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/peers/peer0.mailbox1.network.com/tls/server.key
	
	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/peers/peer0.mailbox1.network.com/tls/ca.crt

	export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/users/Admin@mailbox1.network.com/msp

Then we install the chaincode:

	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go

and we do same thing for peer 0 in org Mailbox 2
	
	export CORE_PEER_ADDRESS=peer0.mailbox2.network.com:7051

	export CORE_PEER_LOCALMSPID=mailbox2MSP

	export CORE_PEER_TLS_ENABLED=true

	export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.crt

	export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.key

	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/ca.crt

	export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/users/Admin@mailbox2.network.com/msp

	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go

Then we can instantiate the chaincode once on any peer; sepecify our endorsement policy

	peer chaincode instantiate -o orderer1.network.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem -C channel -n mycc -v 1.0 -c '{"Args":["init"]}' -P "OR ('mailbox1MSP.member','mailbox2MSP.member')"

and we could invoke the chaincode

	peer chaincode invoke -o orderer1.network.com:7050  --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem  -C channel -n mycc -c '{"Args":["invoke","somekey"]}'


and we can query our chaincode to see the reflection of our code

	peer chaincode query -C channel -n mycc -c '{"Args":["query","somekey"]}'

