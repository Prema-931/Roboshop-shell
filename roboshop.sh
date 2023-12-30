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
         INSTANCE_TYPE="t2.micro"
    fi   
     IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-0221f74584c684f30  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
     echo "$i: $IP_ADDRESS"  
done 

   #create R53 record, make sure you delete existing record
aws route53 change-resource-record-sets \
    --hosted-zone-id "$HOSTED_ZONE_ID" \
    --change-batch "{
        \"Changes\": [{
            \"Action\": \"UPSERT\",
            \"ResourceRecordSet\": {
                \"Name\": \"$i.$DOMAIN_PATH\",
                \"Type\": \"A\",
                \"TTL\": 1,
                \"ResourceRecords\": [{\"Value\": \"$PRIVATE_IPADDRESS\"}]
            }
        }]
    }"
    echo "record created successfully for $i : $i.$DOMAIN_PATH"