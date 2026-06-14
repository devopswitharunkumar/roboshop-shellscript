#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]
then 
    echo -e "$R Error :: You are not a root user.. pls take access $N"
else
    echo -e "$G You are a root user.. pls proceed $N"
fi

$R="\e[31m"
$G="\e[32m"
$Y="\e[33m"
$N="\e[0m"

Timestamp=$(date +%F-%H-%M-%S)
LOG_FILE="/tmp/$0-$Timestamp.log"

exec &>> $LOG_FILE

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 ... $R Failed $N"
    else
        wcho -e "$2 ... $G Success $N"
    fi
}

dnf module disable nodejs -y

validate $? "Disable default nodejs version"

dnf module enable nodejs:18 -y

validate $? "Enable our project requirement nodejs version"

dnf install nodejs -y

validate $? "Installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    echo -e "$R User not exists.. pls Create $N"
    useradd roboshop
    validate $? "Creating user"
else
    echo -e "User already exists ... $Y Skipping $N"
fi

mkdir -p /app

validate $? "Creating Directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

validate $? "Downloading cart module from web"

cd /app

unzip -o /tmp/cart.zip

validate $? "Unzipping cart zip file"

npm install

validate $? "Installing nodejs dependencies"

cp /home/centos/roboshop-shellscript/cart.service /etc/systemd/system/cart.service

validate $? "Copying Service file into Systemd"

systemctl daemon-reload

validate $? "Daemon-reload"

systemctl enable cart

validate $? "Enable cart module"

systemctl start cart

validate $? "Starting cart module"
