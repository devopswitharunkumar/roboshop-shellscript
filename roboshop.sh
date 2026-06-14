#!/bin/bash

AMI_ID=
SG_ID=

INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payment" "dispatch" "web")

for i in  "{[ INSTANCES[@]}"
do
    echo "Instance is : $i"
    if [ i == "mongodb" ] || [ i == "mysql" ] || [ i == "shipping" ]
then
    INSTANCE_TYPE="t3.small"
else
    INSTANCE_TYPE="t2.micro"
    fi
done

aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID