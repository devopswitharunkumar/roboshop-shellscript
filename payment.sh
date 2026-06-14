#!/bin/bash

ID=$(id -u)

$R="\e[31m"
$G="\e[32m"
$Y="\e[33m"
$N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

if [ $ID -ne 0 ]
then 
    echo -e "$R You are not a root userpls take access $N"
else 
    echo -e "$G You are a root user $N"
fi

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R Failed $N"
    else
        echo -e "$2 ... $G Success $N"
    fi
}


dnf install python36 gcc python3-devel -y

validate $? "Installing python 3.6 version"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop &>> $LOG_FILE
    validate $? "Creating new user"
else
    echo -e "$Y ERROR :: User already exists .. Skipping $N"
fi

mkdir -p /app

validate $? "Creating directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

validate $? "Downloading PAyment module"

cd /app

pip3.6 install -r requirements.txt

validate $? "Installing python dependencies"

systemctl daemon-reload

validate $? "Daemon-reload"

systemctl enable payment 

validate $? "Enabling payment module"

systemctl start payment 

validate $? "Starting Payment module"       
