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
    echo -e "$R ERROR :: You are not a root user pls take access $N"
    exit 1
else
    echo -e "$G You are a root user pls proceed $N"
fi

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R ERROR :: $2 ... Failed $N"
        exit 1
    else
        echo -e "$G $2 ... Success $N"
    fi
}

dnf module disable nodejs -y &>> $LOG_FILE

validate $? "Nodejs module disabling default version"

dnf module enable nodejs:18 -y &>> $LOG_FILE

validate $? "Nodejs Required version enabling"

dnf install nodejs -y &>> $LOG_FILE

validate $? "Installation of Nodejs"

id roboshop
if [ $? -ne 0]
then 
    useradd roboshop &>> $LOG_FILE
    validate $? "Creating new user"
else
    echo -e "$Y ERROR :: User already exists .. Skipping $N"
fi
s if already exist it wi

#-p means if already folder exists it will not throw error..it will skip

mkdir -p /app &>> $LOG_FILE

validate $? "Creating new directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOG_FILE

validate $? "Downloading a catalogue zip file from browser"

cd /app &>> $LOG_FILE

validate $? "Changing loc to new directory"

unzip /tmp/catalogue.zip &>> $LOG_FILE

validate $? "Unzipping catalogue application"

npm install &>> $LOG_FILE

validate $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE

validate $? "Copying the service file to systemd path"

systemctl daemon-reload &>> $LOG_FILE

validate $? "Loading service"

systemctl enable catalogue &>> $LOG_FILE

validate $? "Enable catalogue"

systemctl start catalogue  &>> $LOG_FILE

validate $? "Starting catalogue service"

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

validate $? "Copying mongodb repo"

systemctl install mongodb-org-shell -y  &>> $LOG_FILE

validate $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js &>> $LOG_FILE

validate $? "data loaded to catalogue service through mongo client"