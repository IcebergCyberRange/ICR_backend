#!/bin/bash
#
# starts docker containers 

#ip=$(ip addr show enp1s0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
#echo "HOST_IP=$ip" > .env
#uncomment if interface for cyber range is known to retrieve ip address automatically

# stop docker containers and remove legacy containers and volumes
docker-compose stop 
echo " removed docker container:"
sudo docker container rm elasticsearch 
echo " removed docker volume:"
sudo docker volume rm docker_es-data 
rm ./logs/*.log

# restart docker containers
docker-compose up -d

#rm logs/docker_compose-screen.log
#screen -dmS docker_compose -L -Logfile logs/docker_compose-screen.log docker-compose up

# restart docker containers and force build when changes have occured 
#docker-compose up -d --build

# note on the start process:
# docker-compose up automatically runs /build/digital_twin/start.sh as this is the start command (CMD) in the Dockerfile of the digital_twin container


# imports the kibana-based dashboard
echo 'Stopping legacy kibana-dashboard import screen session'
screen -X -S kbndashboard-import quit
screen -dmS kbndashboard-import -L -Logfile logs/kbndashboard-import-screen.log bash ./kbndashboard-import.sh localhost ./../kibana/dashboard-siem.json


# reverts the dsiem correlation directives .json to .txt
## TODO: uncomment if necessary
#screen -dmS run_deactivate_directives -L -Logfile ./logs/deactivate_directives-screen.log bash ./../../src/deactivate_directives.sh 

# stop and restart the API
echo 'Stopping legacy api screen session'
screen -X -S api quit
ip_vm=$(cat .env | grep HOST_IP= | cut -d '=' -f2)
screen -dmS api -L -Logfile ./logs/api-screen.log python ./../../src/pyrest/api.py $ip_vm


# stop and restart the frontend
cd ./../../../DTCRforIR_frontend
rm frontend-screen.log
echo 'Stopping legacy frontend screen session'
screen -X -S frontend quit
screen -dmS frontend -L -Logfile frontend-screen.log npm run serve 
