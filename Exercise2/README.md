Docker Installtion Script:

Script will check whether docker is installed or not in the localhost. 


Case 1:
1. If docker is installed it will run the docker compose file and bring up the elasticsearch container defined in the docker-compose.yml file.

2. Check the elasticserach container status and display the output.


case 2:
1. If docker is not installed, It will ask user prompt to enter y, to install docker. 

2. If you give y it will install the docker package and using docker-compose.yml it will run the elasticsearch container and display the container status as output. 

3. If you press any other key the installation process will be stopped and script will exit.



docker-es-install.sh  -> Bash script to install docker package and start elasticsearch container

docker-compose.yml  -> Docker compose use the yml file information to start the elasticsearch container.
