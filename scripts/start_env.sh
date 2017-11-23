#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# Modified by Muhammad Salah <muhammad.salah@eg.ibm.com>
# Blockchain Weekends Program: Lab 1 "Blockchain Network Design"
#

# Kililng all running containers.
CONTAINER_IDS=$(docker ps -aq)
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "---- No containers available for deletion ----"
  else
    echo "---- Killing running containers -----"
    docker rm -f $CONTAINER_IDS
fi


COMPOSE_PROJECT_NAME=Blkchnwknd # Setting the compose project name for network name

docker-compose -f ../network.yaml up -d >& ../log.txt # starting the composer project with our sample network, and trailling logs in log file.

# Wait for docker containers to initialize
sleep 10

# List running containers
echo "---- Running Containers -----"
docker ps -a