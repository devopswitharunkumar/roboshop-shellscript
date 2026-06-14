#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGODB_HOST=mongodb.devopswitharun.online

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

if [ $ID -ne 0 ]
then 
    echo -e "$R ERROR : You are not a root user pls get access $N"
else
    echo -e "$G You are a root user... Pls proceed $N"
fi


exec &>> $LOG_FILE

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "ERROR : $2 ... $R Failed $N"
    else
        echo -e "$2 ... $G Success $N"
    fi
}


dnf module disable nodejs -y

validate $? "Disabling Default nodejs version"

dnf module enable nodejs:18 -y

validate $? "Enabling our proj requirement version"

dnf install nodejs -y

validate $? "Installing nodejs 18 package"

id roboshop
if [ $? -ne 0 ]
then 
    echo -e "$Y User not exists...pls Create $N"
    useradd roboshop
    validate $? "Creating new user"
else
    echo -e "User already exists... $Y Skipping $N"
fi

mkdir -p /app

validate $? "Creating directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

validate $? "Downloading the zip file"

cd /app

unzip -o /tmp/user.zip

validate $? "Unzipping user module"

npm install

validate $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shellscript/user.service /etc/systemd/system/user.service

validate $? "Copying the service file"

systemctl daemon-reload

validate $? "Daemon reload"

systemctl enable user

validate $? "Enable user module to start at boot time"

systemctl start user

validate $? "Starting user module"

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo

validate $? "Copying mongo repo file"

dnf install mongodb-org-shell -y

validate $? "Installing mongo client to load user data"

mongo --host $MONGODB_HOST </app/schema/user.js