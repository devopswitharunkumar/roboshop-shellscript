#!/bin/bash

ID=$(id -u)
MONGODB_HOST=mongodb.devopswitharun.online

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

if [ $ID -ne 0 ]
then
    echo "ERROR :: You are not a root user pls take access"
    exit 1
else
    echo "You are a root user pls proceed"
fi

validate(){
    if [ $1 -ne 0 ]
    then
        echo "ERROR :: $2 ... Failed"
        exit 1
    else
        echo "$2 ... Success"
    fi
}

dnf module dilesab nodejs -y

validate $1 "Nodejs module disabling default version"

dnf module enable nodejs:18 -y

validate $? "Nodejs Required version enabling"

dnf install nodejs -y

validate $? "Installation of Nodejs"

useradd roboshop

validate $? "Creating new user"

mkdir /app

validate $? "Creating new directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

validate $? "Downloading a catalogue zip file from browser"

cd /app

validate $? "Changing loc to new directory"

unzip /tmp/catalogue.zip

validate $? "Unzipping catalogue application"

npm install

validate $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service

validate $? "Copying the service file to systemd path"

systemctl daemon-reload

validate $? "Loading service"

systemctl enable catalogue

validate $? "Enable catalogue"

systemctl start catalogue 

validate $? "Starting catalogue service"

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo

validate $? "Copying mongodb repo"

systemctl install mongodb-org-shell -y 

validate $? "Installing mongodb client"

mong --host $MONGODB_HOST </app/schema/catalogue.js