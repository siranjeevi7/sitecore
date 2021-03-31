#!/bin/bash

chmod 400 private_key.pem

#for line in `more /opt/siran/az-vm-creation/ou.txt`


while read -r line;
do

ping -c 3 $line > /dev/null 2>&1


if [ $? -eq 0 ]; then

echo "Server $line is rechable"
echo "---------------------------------------------------------------"
echo "Server_Name               CPU(%)   DISK(%)"
echo "---------------------------------------------------------------"

scpu=$(ssh -n -o StrictHostKeyChecking=no -o LogLevel=ERROR -o UserKnownHostsFile=/dev/null  -i private_key.pem azureuser@$line sudo cat /proc/stat | awk '/cpu/{printf("%.2f%\n"), ($2+$4)*100/($2+$4+$5)}' |  awk '{print $0}' | head -1 )
sdisk=$(ssh -n -o StrictHostKeyChecking=no -o LogLevel=ERROR -o UserKnownHostsFile=/dev/null -i private_key.pem azureuser@$line sudo df -hT | grep /$ | awk '{ print $4}')
snetl=$(ssh -n -o StrictHostKeyChecking=no -o LogLevel=ERROR -o UserKnownHostsFile=/dev/null -i private_key.pem azureuser@$line sudo netstat -plunt | awk 'NR>1')



#ocpu=$(echo $scpu | xargs)
#odisk=$(echo $sdisk | xargs)
#onetl=$(echo $snetl | xargs)
echo "$line             $scpu    $sdisk  "
echo "---------------------------------------------------------------"
echo "Listening Ports"
echo "---------------------------------------------------------------"
echo "$snetl"
echo "---------------------------------------------------------------"
echo "---------------------------------------------------------------"
else

        echo "Server $line Not reachable"
fi

done  < public_ip.txt