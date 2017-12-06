### Blockchain weekends is an event for enhancing IBM HyperLedger Fabric Blockchain framework skills.  ###
##                                                                                                      ##
##                                                                                                      ##    
##  This repository contains an initial network setup to demonstrate Blockchain Fabric concepts on:     ##
##              1- Blockchain Network Design, for Organizations, and Peers.                             ##
##              2- Shared Ledgers, through the concept of Channels.                                     ##
##              3- Smart Contracts, installed, and instantiated on these channels.                      ##
##              4- Scalling Dynamically, adding more Organizations to the network.                      ##

##							DISCLAIMER																	##

This lab has been fairly due to the help of many other useful material by:
Ivan Vankov,
Nick Gaski,
Jae Duk Seo,
Joshua Rippon,
Jeff Garratt.

##							Source Code																	##
Please clone the following repository in order to continue with the lab.
Via Git, you can issue the following in your terminal in your exercise directory (of your own choice)

	git clone https://github.com/muhammadsalah/Blockchain-weekends.git


##							Pulling Fabric Version 1.1-preview												##
The source code was built on the duration between version 1.1-preview.
Please navigate to the scripts folder, and run the “pull_fabric.sh” script.

	./pull_fabric.sh

This script will make sure you have the correct version; and you can set the version inside the script variable.

##							Case Scenario																##
We are going to build a basic network that has the following components:

		1- Two orderer services in the blockchain network. 

		2- Two organizations namely "mailbox1", and "mailbox2". 

		3- Each organization has two peers (Peer0,Peer1), where Peer0 is an anchor Peer in each organization. ##
	
		4- Each peer has a CouchDB, that keeps track of the world state. 

		5- Each Organization has its own Membership service provider.	

Please, notice that we are not dealing with MSP in this lab, but for a complete network overview we included it in our network.
Please, also notice that the naming of "mailbox1", and "mailbox2" is completely arbitrary and can be replaced with any organization name depending on the use case.

We will create a channel between these two organizations "mailbox1", and "mailbox2" and deploy a chaincode over this channel.
We will be using a CLI development container, in order to achieve that target.

<img src="https://github.com/muhammadsalah/Blockchain-weekends/blob/master/pics/blkchnwknd1.jpg" width="100" height="100"/>

Then, we will configure another network of one organization with 2 peers each are supported by CouchDB as well, and connect it to the current network, and connect it to the channel.
In order to demonstrate the process of scalling dynamically in Hyperledger Fabric.

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
We dive into our CLI container
	docker exec -ti cli bash

	peer channel join -b channel.block

	peer channel update -o orderer1.network.com:7050 -c channel -f ./channel-artifacts/mailbox1MSPanchors.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

and same applies for the 2nd peer from the other organization but we need to switch identity so we do these simple exports, since the container was preconfigured for peer0 on mailbox1.

	export CORE_PEER_ADDRESS=peer0.mailbox2.network.com:7051

	export CORE_PEER_LOCALMSPID=mailbox2MSP

	export CORE_PEER_TLS_ENABLED=true

	export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.crt

	export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.key

	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/ca.crt

	export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/users/Admin@mailbox2.network.com/msp

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

Please, notice that this sample chaincode just simply stores the invoking CA identity referenced to that key, and that's to demonstrate the GetCreator() function of the shim interface.


## 						Adding an Organization to Our Current Setup									##

Before hand, we have to define our new organization, so we need to create our new crytpo config file for our new organization from scratch.
We need to create a new file named "neworgcrypto.yaml", all under a new folder namely "neworg".

Fill the new yaml file with the following params

	PeerOrgs:
  		- Name: mailbox3
    	Domain: mailbox3.network.com
    	Template:
     		Count: 2
    	Users:
    		Count: 5

just as the other organizations, a 3rd replica exactly.

Now we need to define the transaction yaml file, in order to set MSP details for this new organization.
We create a new file named "configtx.yaml"

	Organizations:
		- &mailbox3
			Name: mailbox3MSP
			ID: mailbox3MSP
			MSPDir: crypto-new/peerOrganizations/mailbox3.network.com/msp

			AnchorPeers:
				- Host: peer0.mailbox3.network.com
				Port: 7051

Now we are ready to start writing our dockerfile yaml file, so we now create a new file again "neworg.yaml"

	version: '2'
	networks:
		network:
	services:
	mailbox3-ca:
		container_name: mailbox3-ca.network.com
		image: hyperledger/fabric-ca:x86_64-1.1.0-preview
		environment:
			- FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
			- FABRIC_CA_SERVER_TLS_ENABLED=true
			- FABRIC_CA_SERVER_CA_NAME=mailbox-ca3
			- FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server-config/ca.mailbox3.network.com-cert.pem
			- FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server-config/CA3_PRIVATE_KEY
		ports:
			- "9054:7054"
		command: sh -c 'fabric-ca-server start --ca.certfile /etc/hyperledger/fabric-ca-server-config/ca.mailbox3.network.com-cert.pem --ca.keyfile /etc/hyperledger/fabric-ca-server-config/CA3_PRIVATE_KEY -b admin:adminpw -d'
		volumes:
			- ./crypto-new/peerOrganizations/mailbox3.network.com/ca/:/etc/hyperledger/fabric-ca-server-config
		networks:
			- network
	couchdbpeer0mailbox3:
		container_name: couchdbpeer0mailbox3
		image: hyperledger/fabric-couchdb:x86_64-1.1.0-preview
		environment:
			- COUCHDB_USER=
			- COUCHDB_PASSWORD=
		ports:
			- "9984:5984"
		networks:
			- network
	peer0.mailbox3.network.com:
		container_name: peer0.mailbox3.network.com
		extends:
			file:  base/peer-base.yaml
			service: peer-base
		environment:
			- CORE_PEER_ID=peer0.mailbox3.network.com
			- CORE_PEER_ADDRESS=peer0.mailbox3.network.com:7051
			- CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.mailbox3.network.com:7051
			- CORE_PEER_LOCALMSPID=mailbox3MSP
			- CORE_LEDGER_STATE_STATEDATABASE=CouchDB
			- CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdbpeer0mailbox3:5984
			- CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=
			- CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=
		depends_on:
			- couchdbpeer0mailbox3
		volumes:
			- /var/run/:/host/var/run/
			- ./crypto-new/peerOrganizations/mailbox3.network.com/peers/peer0.mailbox3.network.com/msp:/etc/hyperledger/fabric/msp
			- ./crypto-new/peerOrganizations/mailbox3.network.com/peers/peer0.mailbox3.network.com/tls:/etc/hyperledger/fabric/tls
		ports:
			- 11051:7051
			- 11053:7053
		networks:
			- network
	couchdbpeer1mailbox3:
		container_name: couchdbpeer1mailbox3
		image: hyperledger/fabric-couchdb:x86_64-1.1.0-preview
		environment:
			- COUCHDB_USER=
			- COUCHDB_PASSWORD=
		ports:
			- "10984:5984"
		networks:
			- network
	peer1.mailbox3.network.com:
		container_name: peer1.mailbox3.network.com
		extends:
			file:  base/peer-base.yaml
			service: peer-base
		environment:
			- CORE_PEER_ID=peer1.mailbox3.network.com
			- CORE_PEER_ADDRESS=peer1.mailbox3.network.com:7051
			- CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.mailbox3.network.com:7051
			- CORE_PEER_LOCALMSPID=mailbox3MSP
			- CORE_LEDGER_STATE_STATEDATABASE=CouchDB
			- CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdbpeer1mailbox3:5984
			- CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=
			- CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=
		depends_on:
			- couchdbpeer1mailbox3
		volumes:
			- /var/run/:/host/var/run/
			- ./crypto-new/peerOrganizations/mailbox1.network.com/peers/peer1.mailbox3.network.com/msp:/etc/hyperledger/fabric/msp
			- ./crypto-new/peerOrganizations/mailbox1.network.com/peers/peer1.mailbox3.network.com/tls:/etc/hyperledger/fabric/tls
		ports:
			- 12051:7051
			- 12053:7053
		networks:
			- network
	cli:
		container_name: climailbox3
		image: hyperledger/fabric-tools:x86_64-1.1.0-preview
		tty: true
		environment:
			- GOPATH=/opt/gopath
			- CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
			- CORE_LOGGING_LEVEL=DEBUG
			- CORE_PEER_ID=cli
			- CORE_PEER_ADDRESS=peer0.mailbox3.network.com:7051
			- CORE_PEER_LOCALMSPID=mailbox3MSP
			- CORE_PEER_TLS_ENABLED=true
			- CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox3.network.com/peers/peer0.mailbox3.network.com/tls/server.crt
			- CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox3.network.com/peers/peer0.mailbox3.network.com/tls/server.key
			- CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox3.network.com/peers/peer0.mailbox3.network.com/tls/ca.crt
			- CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox3.network.com/users/Admin@mailbox3.network.com/msp
		working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
		command: /bin/bash -c 'sleep 10000000'
		volumes:
			- /var/run/:/host/var/run/
			- ../chaincode/:/opt/gopath/src/github.com/chaincode
			- ./crypto-new:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/
			- ../scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/
			- ../channel-artifacts:/opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts
		depends_on:
			- peer0.mailbox3.network.com
			- peer1.mailbox3.network.com
		networks:
			- network

Now, we can up this docker file later, when we export the crypto material, and create the required transaction.

Following the same path of generating the artifacts, we do the drill and we dump the material into the CLI shared space as well.

	FABRIC_CFG_PATH=$PWD

	configtxgen -printOrg mailbox3MSP > ../channel-artifacts/mailbox3MSP.json
	
	cp -r ../crypto-config/ordererOrganizations crypto-new


notice we fetched the orderer certs into our crypto-new folder.


We have to leverage some new tools inside of our CLI dev container; hence we start running updates for the mirrors through aptitude; and install a JSON parser, and optionally a text editor of our choice; nano is good for kickstarters.

We run the following command

	apt update && apt install jq nano

Now we start the configtxlator tool inside the CLI container.

	configtxlator start &

we can export the URL for our tool for simplicity

	export CONFIGTXLATOR_URL=http://127.0.0.1:7059

Now, we fetch the most recent configuration block from the network

	peer channel fetch config config_block.pb -o orderer1.network.com:7050 -c channel --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

Now we leverage our configtxlator rest server to decode the binaries for us and parse into JSON with JQ parser.

	curl -X POST --data-binary @config_block.pb "$CONFIGTXLATOR_URL/protolator/decode/common.Block" | jq . > config_block.json

Now we inspect the block

	nano config_block.json

Please notice the structure of the JSON object, and you will find all the current network configuration we built in our yaml files.
We simply need to detach the configuration section only, so we can put our magic on it.

	jq .data.data[0].payload.data.config config_block.json > config.json

We now want to append the mailbox3MSP json we generated earlier to this config json to create an updated config json.

	jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups":{"mailbox3MSP":.[1]}}}}}' config.json ./channel-artifacts/mailbox3MSP.json >& updated_config.json

Now we inspect the updated JSON object via nano
	
	nano updated_config.json

Now we have the two configuration JSONs, but what we are interested in is the change; however Blockchain doesn't understand JSON, it speaks protobuffers; so we have encode both JSONS
into protobuffers
	
	curl -X POST --data-binary @config.json "$CONFIGTXLATOR_URL/protolator/encode/common.Config" > config.pb

	curl -X POST --data-binary @updated_config.json "$CONFIGTXLATOR_URL/protolator/encode/common.Config" > updated_config.pb

This command now brings us the delta between the two JSONs

	curl -X POST -F channel=channel -F "original=@config.pb" -F "updated=@updated_config.pb" "${CONFIGTXLATOR_URL}/configtxlator/compute/update-from-configs" > config_update.pb

Now we have a config update protobuffer, a delta update that is ready to go through the network.
However, we need to wrap it with some headers yet so, we will turn it back again into a JSON

	curl -X POST --data-binary @config_update.pb "$CONFIGTXLATOR_URL/protolator/decode/common.ConfigUpdate" | jq . > config_update.json

Now we have to wrap some headers

	echo '{"payload":{"header":{"channel_header":{"channel_id":"channel","type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json

We encode this back again into protobuffer

	curl -X POST --data-binary @config_update_in_envelope.json "$CONFIGTXLATOR_URL/protolator/encode/common.Envelope" > config_update_in_envelope.pb

Now, we need to sign this with both organizations identities
We make sure we have the first identity

	export CORE_PEER_ADDRESS=peer0.mailbox1.network.com:7051

	export CORE_PEER_LOCALMSPID=mailbox1MSP

	export CORE_PEER_TLS_ENABLED=true

	export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/peers/peer0.mailbox1.network.com/tls/server.crt

	export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/peers/peer0.mailbox1.network.com/tls/server.key
	
	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/peers/peer0.mailbox1.network.com/tls/ca.crt

	export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox1.network.com/users/Admin@mailbox1.network.com/msp


	peer channel signconfigtx -f config_update_in_envelope.pb

Now we switch back to the second identity

	export CORE_PEER_ADDRESS=peer0.mailbox2.network.com:7051

	export CORE_PEER_LOCALMSPID=mailbox2MSP

	export CORE_PEER_TLS_ENABLED=true

	export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.crt

	export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/server.key

	export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/peers/peer0.mailbox2.network.com/tls/ca.crt

	export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mailbox2.network.com/users/Admin@mailbox2.network.com/msp

However, here we won't need to sign, hence mailbox2 will sign it when we try to update.

	peer channel update -f config_update_in_envelope.pb -o orderer1.network.com:7050 -c channel --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

Now, we are ready to up the new containers, in a new terminal window

	export COMPOSE_PROJECT_NAME=blockchainweeekends
	
	docker-compose -f neworg.yaml up

Now, we move to our new CLI that is tied to mailbox3 peer0 In a new terminal window as well

	docker exec -ti climailbox3 bash

Now we try to join channel, and deploy chaincode as well.

	export CHANNEL_NAME=channel
	
	export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/network.com/orderers/orderer1.network.com/msp/tlscacerts/tlsca.network.com-cert.pem

In order to join the channel, we need the channel first block

	peer channel fetch 0 mychannel.block -o orderer1.network.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

	peer channel join -b mychannel.block

Verify your accomplishment through

	peer channel list

Now, the organization has joined the channel successfuly, we can reset the steps to restart the chaincode; or deploy chaincode on the 3 organizations.
Or do whatever we simply want.

Congratulations on finishing the lab.




