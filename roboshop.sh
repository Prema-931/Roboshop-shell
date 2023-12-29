#!/bin/bash

AMI=AKIA3D5BLUYVS5NBEGN2 
SG_ID= ixEYC+bce47GQmOYAEN15LDBOfRt7CmEsvjrXaRQ
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if[ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then 
         INSTANCE_TYPE="t3.small"
    else
         INSTANCES_TYPE="t2.micro"
    fi   
     aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE t2.micro --security-group-ids sg-0221f74584c684f30
       
done 