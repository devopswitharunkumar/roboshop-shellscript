#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[33m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR :: you are not a rooT user. Pls get the access $N"
    exit 1
else
    echo -e "$G You are a root user, please proceed $N"
fi

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R ERROR :: $2 ... Failed $N"
    else
        echo -e "$G $2 ... Successful $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

validate $? "Copying mongo repo" 

dnf install mongodb-org -y &>> $LOG_FILE

validate $? "Installing mongodb"

systemctl enable mongod &>> $LOG_FILE

validate $? "Enabling mongodb"

systemctl start mongod &>> $LOG_FILE

validate $? "Starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

validate $? "Remote access to mongodb"

systemctl restart momgod 

validate $? "Mongodb Restart"