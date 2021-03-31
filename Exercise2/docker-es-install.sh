#!/bin/bash

#1. Checks for docker software and install if it is not present
#2. If docker is installed it will start the elasticsearch container and check elasticsearch health status

# Usage: ./docker-es-install.sh


docker info > /dev/null 2>&1

if [ $? -ne 0 ] && [ ! -x /var/lib/docker  ]; then

        echo    "Docker is not installed, Installation Prcoess started"

        read -sn1 -p "Press y key to continue with installation process (or) any other key to cancel the installation :"

        if [ $REPLY == "y" ]; then

        echo    #installing docker  and docker dependencies Please give yes to proceed further
        sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

        echo   #add docker’s official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        #set up the stable repository.
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        #update the packages
        apt-get update -y

        #installing dcoker through docker-ce
        apt-get install docker-ce docker-ce-cli containerd.io -y

        #installing docker-compose
        apt-get install docker-compose -y

        echo "docker successfully installed"

else

echo

echo -e "You have cancel the installation, Please again start the script and press "y" to start installation process\n"

fi

else
        echo "Docker Already Installed"

fi


pgrep docker > /dev/null 2>&1

if [ $? -eq 0  ]; then

        echo    "Docker is running, Starting elasticsearch container"

        docker-compose  -f docker-compose.yml up -d


sleep 40s
#Checking the Cluster Health using Curl

curl http://127.0.0.1:9200/_cat/health

if [ $? -eq 0 ]; then

        echo "Elasticsearch Container is running"

else
        echo "Container is Dead"

fi

else

echo "Docker is not running, please check"

fi