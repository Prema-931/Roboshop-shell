#!/bin/bash

AMI="ami-03265a0778a880afb"
SG_ID="sg-0221f74584c684f30"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    echo "instances is: $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]

    then 
         INSTANCE_TYPE="t3.small"
    else
         INSTANCES_TYPE="t2.micro"
    fi   
     aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE t2.micro --security-group-ids sg-0221f74584c684f30  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text
       
done 